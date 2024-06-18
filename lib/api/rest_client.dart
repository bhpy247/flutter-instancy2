import 'dart:io';

import 'package:flutter_instancy_2/configs/app_strings.dart';
import 'package:flutter_instancy_2/models/common/Instancy_multipart_file_upload_model.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:http/http.dart';

import '../utils/curl_generator.dart';
import '../utils/my_utils.dart';
import 'api_call_model.dart';

typedef RestCallTypeDef = Future<Response?> Function({required ApiCallModel apiCallModel});

enum RestCallType {
  simpleGetCall,
  simplePostCall,
  multipartRequestCall,
  saveGenericFilesCall,
  xxxUrlEncodedFormDataRequestCall,
}

class RestClient {
  static Map<RestCallType, RestCallTypeDef> callsMap = <RestCallType, RestCallTypeDef>{
    RestCallType.simpleGetCall: getCall,
    RestCallType.simplePostCall: postCall,
    RestCallType.multipartRequestCall: multipartRequestCall,
    RestCallType.saveGenericFilesCall: saveGenericFilesCall,
    RestCallType.xxxUrlEncodedFormDataRequestCall: xxxUrlEncodedFormDataRequestCall,
  };

  static Future<Response?> callApi({required ApiCallModel apiCallModel}) async {
    RestCallTypeDef? type = callsMap[apiCallModel.restCallType];

    if(type != null) {
      return type(apiCallModel: apiCallModel);
    }
    else {
      return null;
    }
  }

  static Future<Response?> getCall({required ApiCallModel apiCallModel}) async {
    Map<String, String> headers = _getRequiredHeadersFromApiCallModel(apiCallModel: apiCallModel);
    headers.addAll(apiCallModel.headers ?? <String, String>{});

    String newId = MyUtils.getNewId(isFromUUuid: true);

    try {
      String url = _getFinalApiUrl(url: apiCallModel.url, queryParameters: apiCallModel.queryParameters);

      MyPrint.printOnConsole("getCall called", tag: newId);
      MyPrint.printOnConsole("Url:'$url'", tag: newId);
      MyPrint.printOnConsole("Headers:$headers", tag: newId);

      MyPrint.logOnConsole("Curl Request:${CurlGenerator.toCurlFromRawRequest(
        method: "GET",
        url: url,
        headers: headers,
      )}", tag: newId);


      DateTime startTime = DateTime.now();
      MyPrint.printOnConsole("Api startTime:${DatePresentation.fullDateTimeFormat(startTime)} Seconds", tag: newId);

      Response response = await get(Uri.parse(url), headers: headers);

      DateTime endTime = DateTime.now();
      MyPrint.printOnConsole("Api endTime:${DatePresentation.fullDateTimeFormat(endTime)}", tag: newId);

      MyPrint.printOnConsole("Response Time:${endTime.difference(startTime).inMilliseconds / 1000} Seconds", tag: newId);
      MyPrint.printOnConsole("Response Status:${response.statusCode}", tag: newId);
      MyPrint.logOnConsole("Response Body:${response.body}", tag: newId);

      // MyLogger.i(response.body);

      return response;
    }
    catch (e, s) {
      MyPrint.printOnConsole("Error in Getting Response in RestClient.getCall():$e", tag: newId);
      MyPrint.printOnConsole(s, tag: newId);
      return null;
    }
  }

  static Future<Response?> postCall({required ApiCallModel apiCallModel}) async {
    Map<String, String> headers = _getRequiredHeadersFromApiCallModel(apiCallModel: apiCallModel);
    headers.addAll(apiCallModel.headers ?? <String, String>{});

    String newId = MyUtils.getNewId(isFromUUuid: true);

    try {
      String url = _getFinalApiUrl(url: apiCallModel.url, queryParameters: apiCallModel.queryParameters);

      MyPrint.printOnConsole("postCall called", tag: newId);
      MyPrint.printOnConsole("Url:'$url'", tag: newId);
      MyPrint.printOnConsole("Headers:$headers", tag: newId);
      MyPrint.printOnConsole("RequestBody:${apiCallModel.requestBody}", tag: newId);

      MyPrint.logOnConsole("Curl Request:${CurlGenerator.toCurlFromRawRequest(
        method: "POST",
        url: url,
        headers: headers,
        body: ParsingHelper.parseStringMethod(apiCallModel.requestBody),
      )}", tag: newId);


      DateTime startTime = DateTime.now();
      MyPrint.printOnConsole("Api startTime:${DatePresentation.fullDateTimeFormat(startTime)} Seconds", tag: newId);

      Response response = await post(Uri.parse(url), headers: headers, body: apiCallModel.requestBody);

      DateTime endTime = DateTime.now();
      MyPrint.printOnConsole("Api endTime:${DatePresentation.fullDateTimeFormat(endTime)}", tag: newId);

      MyPrint.printOnConsole("Response Time:${endTime.difference(startTime).inMilliseconds / 1000} Seconds", tag: newId);
      MyPrint.printOnConsole("Response Status:${response.statusCode}", tag: newId);
      MyPrint.logOnConsole("Response Body:${response.body}", tag: newId);

      // MyLogger.i(response.body);

      return response;
    }
    catch (e, s) {
      MyPrint.printOnConsole("Error in Getting Response in RestClient.postCall():$e", tag: newId);
      MyPrint.printOnConsole(s, tag: newId);
      return null;
    }
  }

  static Future<Response?> multipartRequestCall({required ApiCallModel apiCallModel}) async {
    String newId = MyUtils.getNewId(isFromUUuid: true);

    Map<String, String> headers = _getRequiredHeadersFromApiCallModel(apiCallModel: apiCallModel);
    headers.addAll(apiCallModel.headers ?? <String, String>{});
    headers.remove(HttpHeaders.contentTypeHeader);

    try {
      String url = _getFinalApiUrl(url: apiCallModel.url, queryParameters: apiCallModel.queryParameters);

      MyPrint.printOnConsole("multipartRequestCall called", tag: newId);
      MyPrint.printOnConsole("Url:'$url'", tag: newId);
      MyPrint.printOnConsole("Headers:$headers", tag: newId);
      MyPrint.printOnConsole("RequestBody:${apiCallModel.requestBody}", tag: newId);
      MyPrint.printOnConsole("fields:${apiCallModel.fields}", tag: newId);
      MyPrint.printOnConsole("files:${apiCallModel.files?.map((e) => "(${e.fieldName} : ${e.fileName})").toList()}", tag: newId);

      MyPrint.logOnConsole("Curl Request:${CurlGenerator.toCurlFromRawRequest(
        method: "POST",
            url: url,
            headers: Map.from(headers)..addAll({HttpHeaders.contentTypeHeader: "multipart/form-data"}),
            body: MyUtils.encodeJson(apiCallModel.fields),
          )}", tag: newId);


      MultipartRequest request = MultipartRequest("POST", Uri.parse(url));

      if (apiCallModel.fields.checkNotEmpty) request.fields.addAll(apiCallModel.fields!);

      List<MultipartFile> files = <MultipartFile>[];
      for(InstancyMultipartFileUploadModel instancyMultipartFileUploadModel in (apiCallModel.files ?? <InstancyMultipartFileUploadModel>[])) {
        if(instancyMultipartFileUploadModel.fieldName.isNotEmpty) {
          if (instancyMultipartFileUploadModel.bytes != null) {
            files.add(MultipartFile.fromBytes(
              instancyMultipartFileUploadModel.fieldName,
              instancyMultipartFileUploadModel.bytes!,
              filename: instancyMultipartFileUploadModel.fileName,
            ));
          } else if (instancyMultipartFileUploadModel.filePath.checkNotEmpty) {
            files.add(await MultipartFile.fromPath(
              instancyMultipartFileUploadModel.fieldName,
              instancyMultipartFileUploadModel.filePath!,
              filename: instancyMultipartFileUploadModel.fileName,
            ));
          }
        }
      }
      request.files.addAll(files);

      request.headers.addAll(headers);

      DateTime startTime = DateTime.now();
      MyPrint.printOnConsole("Api startTime:${DatePresentation.fullDateTimeFormat(startTime)} Seconds", tag: newId);

      StreamedResponse streamedResponse = await request.send();
      Response response = await Response.fromStream(streamedResponse);

      DateTime endTime = DateTime.now();
      MyPrint.printOnConsole("Api endTime:${DatePresentation.fullDateTimeFormat(endTime)}", tag: newId);

      MyPrint.printOnConsole("Response Time:${endTime.difference(startTime).inMilliseconds / 1000} Seconds", tag: newId);
      MyPrint.printOnConsole("Response Status:${response.statusCode}", tag: newId);
      MyPrint.logOnConsole("Response Body:'${response.body}'", tag: newId);
      MyPrint.logOnConsole("reasonPhrase:'${response.reasonPhrase}'", tag: newId);

      return response;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Getting Response in RestClient.multipartRequestCall():$e", tag: newId);
      MyPrint.printOnConsole(s, tag: newId);
      return null;
    }
  }

  static Future<Response?> saveGenericFilesCall({required ApiCallModel apiCallModel}) async {
    String newId = MyUtils.getNewId(isFromUUuid: true);

    Map<String, String> headers = _getRequiredHeadersFromApiCallModel(apiCallModel: apiCallModel);
    headers.addAll(apiCallModel.headers ?? <String, String>{});
    headers.remove(HttpHeaders.contentTypeHeader);

    try {
      String url = _getFinalApiUrl(url: apiCallModel.url, queryParameters: apiCallModel.queryParameters);

      MyPrint.printOnConsole("saveGenericFilesCall called", tag: newId);
      MyPrint.printOnConsole("Url:'$url'", tag: newId);
      MyPrint.printOnConsole("Headers:$headers", tag: newId);
      MyPrint.printOnConsole("RequestBody:${apiCallModel.requestBody}", tag: newId);
      MyPrint.printOnConsole("fields:${apiCallModel.fields}", tag: newId);
      MyPrint.printOnConsole("files:${apiCallModel.files}", tag: newId);

      MyPrint.logOnConsole(
          "Curl Request:${CurlGenerator.toCurlFromRawRequest(
            method: "POST",
            url: url,
            headers: Map.from(headers)..addAll({HttpHeaders.contentTypeHeader: "multipart/form-data"}),
            body: MyUtils.encodeJson(apiCallModel.fields),
          )}",
          tag: newId);

      MultipartRequest request = MultipartRequest("POST", Uri.parse(url));

      request.fields.addAll(apiCallModel.fields ?? <String, String>{});

      List<MultipartFile> files = <MultipartFile>[];
      for (InstancyMultipartFileUploadModel instancyMultipartFileUploadModel in (apiCallModel.files ?? <InstancyMultipartFileUploadModel>[])) {
        if (instancyMultipartFileUploadModel.fieldName.isNotEmpty) {
          if (instancyMultipartFileUploadModel.bytes != null) {
            files.add(MultipartFile.fromBytes(
              instancyMultipartFileUploadModel.fieldName,
              instancyMultipartFileUploadModel.bytes!,
              filename: instancyMultipartFileUploadModel.fileName,
            ));
          } else if (instancyMultipartFileUploadModel.filePath.checkNotEmpty) {
            files.add(await MultipartFile.fromPath(
              instancyMultipartFileUploadModel.fieldName,
              instancyMultipartFileUploadModel.filePath!,
              filename: instancyMultipartFileUploadModel.fileName,
            ));
          }
        }
      }
      request.files.addAll(files);

      request.headers.addAll(headers);

      DateTime startTime = DateTime.now();
      MyPrint.printOnConsole("Api startTime:${DatePresentation.fullDateTimeFormat(startTime)} Seconds", tag: newId);

      StreamedResponse streamedResponse = await request.send();
      Response response = await Response.fromStream(streamedResponse);

      DateTime endTime = DateTime.now();
      MyPrint.printOnConsole("Api endTime:${DatePresentation.fullDateTimeFormat(endTime)}", tag: newId);

      MyPrint.printOnConsole("Response Time:${endTime.difference(startTime).inMilliseconds / 1000} Seconds", tag: newId);
      MyPrint.printOnConsole("Response Status:${response.statusCode}", tag: newId);
      MyPrint.logOnConsole("Response Body:${response.body}", tag: newId);

      return response;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Getting Response in RestClient.saveGenericFilesCall():$e", tag: newId);
      MyPrint.printOnConsole(s, tag: newId);
      return null;
    }
  }

  static Future<Response?> xxxUrlEncodedFormDataRequestCall({required ApiCallModel apiCallModel}) async {
    Map<String, String> headers = _getRequiredHeadersFromApiCallModel(apiCallModel: apiCallModel);
    headers.addAll(apiCallModel.headers ?? <String, String>{});
    headers[HttpHeaders.contentTypeHeader] = "application/x-www-form-urlencoded";

    String newId = MyUtils.getNewId(isFromUUuid: true);

    try {
      String url = _getFinalApiUrl(url: apiCallModel.url, queryParameters: apiCallModel.queryParameters);

      MyPrint.printOnConsole("xxxUrlEncodedFormDataRequestCall called", tag: newId);
      MyPrint.printOnConsole("Url:'$url'", tag: newId);
      MyPrint.printOnConsole("Headers:$headers", tag: newId);
      MyPrint.printOnConsole("RequestBody:${apiCallModel.requestBody}", tag: newId);

      MyPrint.logOnConsole("Curl Request:${CurlGenerator.toCurlFromRawRequest(
        method: "POST",
        url: url,
        headers: headers,
        body: apiCallModel.requestBody is Map<String, String>
          ? MyUtils.encodeJson(apiCallModel.requestBody)
          : "",
      )}", tag: newId);

      DateTime startTime = DateTime.now();
      MyPrint.printOnConsole("Api startTime:${DatePresentation.fullDateTimeFormat(startTime)} Seconds", tag: newId);

      Response response = await post(Uri.parse(url), headers: headers, body: apiCallModel.requestBody);

      DateTime endTime = DateTime.now();
      MyPrint.printOnConsole("Api endTime:${DatePresentation.fullDateTimeFormat(endTime)}", tag: newId);

      MyPrint.printOnConsole("Response Time:${endTime.difference(startTime).inMilliseconds / 1000} Seconds", tag: newId);
      MyPrint.printOnConsole("Response Status:${response.statusCode}", tag: newId);
      MyPrint.logOnConsole("Response Body:${response.body}", tag: newId);

      // MyLogger.i(response.body);

      return response;
    }
    catch (e, s) {
      MyPrint.printOnConsole("Error in Getting Response in RestClient.postCall():$e", tag: newId);
      MyPrint.printOnConsole(s, tag: newId);
      return null;
    }
  }


  static String _getFinalApiUrl({required String url, Map<String, String>? queryParameters}) {
    return url + (queryParameters.checkNotEmpty ? getQueryParametersStringFromData(queryParameters: queryParameters!) : "");
  }

  static String getQueryParametersStringFromData({required Map<String, String> queryParameters}) {
    MyPrint.printOnConsole("RestClient.getQueryParametersStringFromData() called for queryParameters:'${MyUtils.encodeJson(queryParameters)}'");

    String queryParametersString = "";

    if(queryParameters.isNotEmpty) {
      queryParametersString += "?";

      queryParameters.forEach((String key, String value) {
        queryParametersString += "$key=$value&";
      });

      queryParametersString = queryParametersString.substring(0, queryParametersString.length - 1);
    }

    MyPrint.printOnConsole("Final queryParametersString:$queryParametersString");
    return queryParametersString;
  }

  static Map<String, String> _getRequiredHeadersFromApiCallModel({required ApiCallModel apiCallModel, String? contentType}) {
    Map<String, String> map = <String, String>{
      HttpHeaders.contentTypeHeader: contentType ?? ContentType.json.value,
    };

    if (apiCallModel.isInstancyCall) {
      map.addAll(<String, String>{
        "ClientURL": apiCallModel.siteUrl,
        AppStrings.allowFromExternalHostKey: 'allow',
        "SiteID": apiCallModel.siteId.toString(),
        "Locale": apiCallModel.locale,
        "UserID": apiCallModel.userId.toString(),
      });
    }
    if(apiCallModel.isAuthenticatedApiCall) {
      map.addAll(<String, String>{
        "Authorization": 'Bearer ${apiCallModel.token}',
        "UserID": apiCallModel.userId.toString(),
      });
    }

    return map;
  }
}