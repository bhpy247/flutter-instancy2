import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_call_model.dart';
import 'package:flutter_instancy_2/api/rest_client.dart';
import 'package:flutter_instancy_2/backend/Catalog/content_launch_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_controller.dart';
import 'package:flutter_instancy_2/backend/download/flutter_download_controller.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/common/model_data_parser.dart';
import 'package:flutter_instancy_2/models/download/request_model/flutter_download_request_model.dart';
import 'package:flutter_instancy_2/models/my_learning/request_model/get_completion_certificate_params_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:http/http.dart' as http;
import 'package:open_file_plus/open_file_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../backend/my_learning/my_learning_controller.dart';
import '../../../backend/navigation/navigation.dart';

class ViewCompletionCertificateScreen extends StatefulWidget {
  static const String routeName = "/ViewCompletionCertificateScreen";

  final ViewCompletionCertificateScreenNavigationArguments arguments;

  const ViewCompletionCertificateScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<ViewCompletionCertificateScreen> createState() => _ViewCompletionCertificateScreenState();
}

class _ViewCompletionCertificateScreenState extends State<ViewCompletionCertificateScreen> with MySafeState {
  late MyLearningController myLearningController;

  late FutureOr<Uint8List> futureGetPdfData;

  String certificateUrl = "";

  /*certificateViewUrl = "", */
  String certificateDownloadUrl = "";

  FutureOr<Uint8List> getData() async {
    DataResponseModel<String> dataResponseModel = await myLearningController.myLearningRepository.getCompletionCertificatePath(
      paramsModel: GetCompletionCertificateParamsModel(
        Content_ID: widget.arguments.contentId,
        CertificateID: widget.arguments.certificateId,
        CertificatePage: widget.arguments.certificatePage,
      ),
    );

    MyPrint.printOnConsole("getCompletionCertificatePath dataResponseModel:$dataResponseModel");

    certificateUrl = ContentLaunchController().getCertificateMainUrlFromCertificatePath(
      certificatePath: (dataResponseModel.data ?? ""),
      siteUrl: myLearningController.myLearningRepository.apiController.apiDataProvider.getCurrentSiteUrl(),
    );
    /*certificateViewUrl = ContentLaunchController().getCertificateViewUrlFromCertificatePath(
      certificatePath: (dataResponseModel.data ?? ""),
      siteUrl: myLearningController.myLearningRepository.apiController.apiDataProvider.getCurrentSiteUrl(),
    );*/
    certificateDownloadUrl = ContentLaunchController().getCertificateDownloadUrlFromCertificatePath(
      certificatePath: (dataResponseModel.data ?? ""),
      siteUrl: myLearningController.myLearningRepository.apiController.apiDataProvider.getCurrentSiteUrl(),
    );
    Uint8List? certificateBytes = await getCertificateBytesData(pdfUrl: certificateUrl);
    mySetState();

    return Future<Uint8List>.value(certificateBytes);
  }

  Future<Uint8List?> getCertificateBytesData({required String pdfUrl}) async {
    try {
      http.Response? response = await RestClient.callApi(
        apiCallModel: ApiCallModel(
          restCallType: RestCallType.simpleGetCall,
          parsingType: ModelDataParsingType.dynamic,
          url: pdfUrl,
          siteUrl: "",
          isAuthenticatedApiCall: false,
        ),
      );
      return response?.bodyBytes;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Getting PDF Bytes:$e");
      MyPrint.printOnConsole(s);
      return null;
    }
  }

  Future<void> downloadPdf({required String downloadUrl}) async {
    if (kIsWeb || ![TargetPlatform.android, TargetPlatform.iOS].contains(defaultTargetPlatform)) {
      return;
    }

    MyToast.showCustomToast(context: this.context, msg: "Downloading Certificate");

    String downloadResPath = await AppController.getDocumentsDirectory();
    String fileName = "${DateTime.now().millisecondsSinceEpoch}.pdf";

    if (defaultTargetPlatform == TargetPlatform.android) {
      downloadResPath = "/storage/emulated/0/Download";
      /*try {
        downloadResPath = (await getDownloadsDirectory())?.path ?? "";
      }
      catch(e, s) {
        MyPrint.printOnConsole("Error in getting download directory:$e");
        MyPrint.printOnConsole(s);
      }
      if(downloadResPath.isEmpty) downloadResPath = (await getExternalStorageDirectories(type: StorageDirectory.downloads))!.first.path;*/
      //'/sdcard/download/'+ refItem; //for android belwo 11 version i.e 10 it's is worked
      ////(await getExternalStorageDirectories(type: StorageDirectory.downloads)).first.path + refItem; => For android 11 and above used external storage Directories.
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      // downloadResPath = (await getApplicationDocumentsDirectory()).path;
    }

    MyPrint.printOnConsole("downloadResPath:$downloadResPath");
    MyPrint.printOnConsole("fileName:$fileName");

    FlutterDownloadRequestModel requestModel = FlutterDownloadRequestModel(
      downloadUrl: downloadUrl.replaceAll("http://", "https://"),
      destinationFolderPath: downloadResPath,
      fileName: fileName,
      openFileFromNotification: true,
      showNotification: true,
    );

    bool isDownloaded = await FlutterDownloadController().downloadFile(requestModel: requestModel);

    BuildContext context = this.context;
    if (isDownloaded) {
      if (context.mounted && defaultTargetPlatform == TargetPlatform.android) MyToast.showSuccess(context: context, msg: "Downloaded Certificate");

      OpenFile.open("$downloadResPath${AppController.getPathSeparator() ?? "/"}$fileName");
    } else {
      if (context.mounted && defaultTargetPlatform == TargetPlatform.android) MyToast.showError(context: context, msg: "Download Failed");
    }
  }

  @override
  void initState() {
    super.initState();
    myLearningController = MyLearningController(provider: null);
    futureGetPdfData = getData();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    MyPrint.printOnConsole("certificateUrl:$certificateUrl");
    // MyPrint.printOnConsole("certificateViewUrl:$certificateViewUrl");
    MyPrint.printOnConsole("certificateDownloadUrl:$certificateDownloadUrl");

    return Scaffold(
      appBar: getAppBar(),
      body: SafeArea(child: getMainBody()),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppBar(
      title: const Text(
        "Certificate",
        style: TextStyle(
          fontSize: 18,
          // color: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
        ),
      ),
      actions: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                futureGetPdfData = getData();
                mySetState();
              },
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
      ],
    );
  }

  Widget getMainBody() {
    return Column(
      children: [
        Expanded(
          child: PdfPreview(
            build: (PdfPageFormat format) {
              return futureGetPdfData;
            },
            onError: (BuildContext context, Object? error) {
              return Center(
                child: Text(
                  "Error in Loading PDF:\n\n$error",
                  textAlign: TextAlign.center,
                ),
              );
            },
            onPrintError: (BuildContext context, dynamic error) {
              MyPrint.printOnConsole("Error in Printing PDF:$error");
            },
            useActions: false,
            allowPrinting: true,
            allowSharing: true,
            canChangePageFormat: false,
            canChangeOrientation: false,
            canDebug: false,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getDownloadButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget getDownloadButton() {
    if (certificateDownloadUrl.isEmpty) {
      return const SizedBox();
    }

    return CommonButton(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      onPressed: () {
        downloadPdf(downloadUrl: certificateDownloadUrl);
      },
      text: "Download",
      fontColor: themeData.colorScheme.onPrimary,
    );
  }
}
