import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_controller.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_provider.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/currency_model.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/request_model/currency_data_request_model.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/response_model/currency_data_response_model.dart';
import 'package:flutter_instancy_2/models/common/instancy_picked_file_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/common/components/app_ui_components.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../api/api_controller.dart';
import '../../models/common/data_response_model.dart';
import '../../views/common/components/platform_alert_dialog.dart';
import '../navigation/navigation_controller.dart';
import 'app_repository.dart';

class AppController {
  late AppProvider _appProvider;
  late AppRepository _appRepository;

  AppController({required AppProvider? provider, AppRepository? repository, ApiController? apiController}) {
    _appProvider = provider ?? AppProvider();
    _appRepository = repository ?? AppRepository(apiController: apiController ?? ApiController());
  }

  AppProvider get appProvider => _appProvider;

  AppRepository get appRepository => _appRepository;

  Future<void> sessionTimeOut() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("AppController().sessionTimeOut() called", tag: tag);
    MyPrint.printOnConsole(StackTrace.current, tag: tag);

    await AppUIComponents.showMyPlatformDialog(
      context: NavigationController.mainNavigatorKey.currentContext!,
      dialog: const PlatformAlertDialog(
        defaultActionText: 'OK',
        title: 'Alert',
        content: "Parallel session detected,this session will logout",
        cancelActionText: '',
      ),
      barrierDismissible: false,
    );

    // if (didiRequestSignOut == true) {
    if (true) {
      MyPrint.printOnConsole("Logout", tag: tag);

      AuthenticationProvider authenticationProvider = Provider.of<AuthenticationProvider>(NavigationController.mainNavigatorKey.currentContext!, listen: false);
      AuthenticationController authenticationController = AuthenticationController(provider: authenticationProvider);
      authenticationController.logout();
    }
  }

  static Future<List<InstancyPickedFileModel>> pickImages({required InstancyImagePickSource imageSource, bool pickMultiple = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("AppController.pickImages() called with imageSource:$imageSource, pickMultiple:$pickMultiple", tag: tag);

    List<InstancyPickedFileModel> images = <InstancyPickedFileModel>[];

    ImageSource? source;
    if (imageSource == InstancyImagePickSource.camera) {
      source = ImageSource.camera;
    } else if (imageSource == InstancyImagePickSource.gallery) {
      source = ImageSource.gallery;
    }
    MyPrint.printOnConsole("source:$source", tag: tag);

    if (source == null) {
      MyPrint.printOnConsole("Returning from AppController.pickImages() because ImageSource is Null", tag: tag);
      return images;
    }

    List<XFile> files = [];

    try {
      if (pickMultiple) {
        files = await ImagePicker().pickMultiImage();
      } else {
        XFile? xfile = await ImagePicker().pickImage(source: source);
        if (xfile != null) {
          files.add(xfile);
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Picking Image in AppController.pickImages():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return images;
    }

    MyPrint.printOnConsole("files length:${files.length}", tag: tag);

    for (XFile file in files) {
      Uint8List? bytes;
      try {
        bytes = await file.readAsBytes();
      } catch (e, s) {
        MyPrint.printOnConsole("Error in Getting Bytes from Image in AppController.pickImages():$e", tag: tag);
        MyPrint.printOnConsole(s, tag: tag);
      }
      images.add(InstancyPickedFileModel(
        fileName: file.name,
        bytes: bytes,
      ));
    }

    MyPrint.printOnConsole("Final images length:${images.length}", tag: tag);

    return images;
  }

  static Future<List<InstancyPickedFileModel>> pickFiles({required InstancyFilePickType filePickType, List<String>? customExtensions, bool pickMultiple = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("AppController.pickFiles() called with filePickType:$filePickType, pickMultiple:$pickMultiple", tag: tag);

    List<InstancyPickedFileModel> images = <InstancyPickedFileModel>[];

    FileType fileType = FileType.any;
    if (filePickType == InstancyFilePickType.image) {
      fileType = FileType.image;
    } else if (filePickType == InstancyFilePickType.audio) {
      fileType = FileType.audio;
    } else if (filePickType == InstancyFilePickType.video) {
      fileType = FileType.video;
    } else if (filePickType == InstancyFilePickType.media) {
      fileType = FileType.media;
    } else if (filePickType == InstancyFilePickType.custom) {
      fileType = FileType.custom;
    }
    MyPrint.printOnConsole("fileType:$fileType", tag: tag);

    List<PlatformFile> files = [];

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: fileType,
        allowCompression: true,
        allowedExtensions: customExtensions,
        allowMultiple: pickMultiple,
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        MyPrint.printOnConsole("Returning from ProfileController().updateProfileImage() because picked file or bytes are Null", tag: tag);
        return images;
      }

      files = result.files;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Picking Image in AppController.pickImages():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return images;
    }

    MyPrint.printOnConsole("files length:${files.length}", tag: tag);

    for (PlatformFile file in files) {
      MyPrint.printOnConsole("File Name:${file.name}");
      MyPrint.printOnConsole("File Bytes:${file.bytes?.lengthInBytes}");

      Uint8List? bytes = file.bytes;
      if (bytes != null) {
        int index = file.name.indexOf(".");
        if (index >= 0) {
          String extension = file.name.substring(index);
          images.add(InstancyPickedFileModel(
            fileName: "${DateTime.now().millisecondsSinceEpoch}$extension",
            bytes: bytes,
          ));
        }
      }

      // Stream<List<int>>? stream = file.readStream;
      // if(stream != null) {
      //   Uint8List bytes = await _getBytesFromStream(stream: stream);
      //   images.add(InstancyPickedFileModel(
      //     fileName: file.name,
      //     bytes: bytes,
      //   ));
      // }
    }

    MyPrint.printOnConsole("Final images length:${images.length}", tag: tag);

    return images;
  }

  /*static Future<Uint8List> _getBytesFromStream({required Stream<List<int>> stream}) async {
    MyPrint.printOnConsole('Conversion Started');
    DateTime startTime = DateTime.now();

    Uint8List uint8list = await compute<Stream<List<int>>, Uint8List>((Stream<List<int>> stream) async {
        MyPrint.printOnConsole("Got stream in Isolate:$stream");

        List<int> mainList = <int>[];

        List<List<int>> list = await stream.toList();
        // MyPrint.printOnConsole("list length:${list.length}");

        mainList = list.fold(mainList, (previousValue, element) {
          // MyPrint.printOnConsole("Got element reduce:${Uint8List.fromList(element).lengthInBytes / pow(1000, 2)} MB");
          // MyPrint.printOnConsole("Got Value reduce:${Uint8List.fromList(previousValue).lengthInBytes / pow(1000, 2)} MB");
          return previousValue..addAll(element);
        });

        return Uint8List.fromList(mainList);
      },
      stream,
    );
    DateTime endTime = DateTime.now();

    MyPrint.printOnConsole('Conversion Finished in ${endTime.difference(startTime).inMilliseconds} Milliseconds');
    MyPrint.printOnConsole('Bytes Length:${uint8list.lengthInBytes / pow(1000, 2)} MB');

    return uint8list;
  }*/

  static Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
        return true;
      case ConnectivityResult.none:
      default:
        return false;
    }
  }

  static Future<String> getDocumentsDirectory() async {
    if (kIsWeb) {
      return "";
    }
    final directory = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
    return directory?.path ?? "";
  }

  static String? getPathSeparator() {
    if (kIsWeb) {
      return null;
    }
    return Platform.pathSeparator;
  }

  Future<CurrencyModel?> getCurrencyModel({
    String country = "",
    bool isRefresh = true,
    bool isGetFromCache = true,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("AppController().getCurrencyModel() called with country:'$country', isRefresh:$isRefresh, isGetFromCache:$isGetFromCache, isNotify:$isNotify", tag: tag);

    AppProvider provider = appProvider;

    CurrencyModel? currencyModel = provider.currencyModel.get();
    MyPrint.printOnConsole("currencyModel in Provider:$currencyModel", tag: tag);

    if (isGetFromCache) {
      DataResponseModel<CurrencyDataResponseModel> response = await appRepository.GetCurrencyData(
        requestModel: CurrencyDataRequestModel(
          strUserCountry: country,
        ),
        isGetDataFromHive: true,
        isStoreDataInHive: false,
      );
      MyPrint.logOnConsole("GetCurrencyData Hive response:$response", tag: tag);

      currencyModel = response.data?.Table.firstOrNull;
      MyPrint.printOnConsole("currencyModel in Hive:$currencyModel", tag: tag);
      provider.currencyModel.set(value: currencyModel, isNotify: isNotify);
    }

    if (isRefresh || currencyModel == null) {
      DataResponseModel<CurrencyDataResponseModel> response = await appRepository.GetCurrencyData(
        requestModel: CurrencyDataRequestModel(
          strUserCountry: country,
        ),
        isStoreDataInHive: true,
        isGetDataFromHive: false,
      );
      MyPrint.logOnConsole("GetCurrencyData response:$response", tag: tag);

      if (response.appErrorModel != null) {
        MyPrint.printOnConsole("Returning from AppController().getCurrencyModel() because GetCurrencyData had some error", tag: tag);
        return currencyModel;
      }

      currencyModel = response.data?.Table.firstOrNull;
      MyPrint.printOnConsole("currencyModel from Api:$currencyModel", tag: tag);
    }

    MyPrint.logOnConsole("final currencyModel:$currencyModel", tag: tag);
    provider.currencyModel.set(value: currencyModel, isNotify: true);

    return currencyModel;
  }
}
