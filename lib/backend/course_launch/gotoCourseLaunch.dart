import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_controller.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';

import '../../api/api_url_configuration_provider.dart';
import '../../models/app_configuration_models/data_models/app_ststem_configurations.dart';
import '../../models/app_configuration_models/data_models/tincan_data_model.dart';
import '../../models/authentication/data_model/successful_user_login_model.dart';
import '../../models/course_launch/data_model/course_launch_model.dart';
import '../../utils/my_print.dart';
import '../../views/common/components/common_button.dart';
import '../navigation/navigation.dart';

class GotoCourseLaunch {
  final CourseLaunchModel courseLaunchModel;
  final BuildContext context;
  final AppSystemConfigurationModel appSystemConfigurationModel;
  final TinCanDataModel tinCanDataModel;
  final ApiUrlConfigurationProvider apiUrlConfigurationProvider;
  final SuccessfulUserLoginModel successfulUserLoginModel;

  String urlForView = "";

  factory GotoCourseLaunch({
    required BuildContext context,
    required CourseLaunchModel courseLaunchModel,
    required AppSystemConfigurationModel appSystemConfigurationModel,
    required TinCanDataModel tinCanDataModel,
    required ApiUrlConfigurationProvider apiUrlConfigurationProvider,
    required SuccessfulUserLoginModel successfulUserLoginModel,
  }) {
    return GotoCourseLaunch._internal(
      context: context,
      courseLaunchModel: courseLaunchModel,
      appSystemConfigurationModel: appSystemConfigurationModel,
      tinCanDataModel: tinCanDataModel,
      apiUrlConfigurationProvider: apiUrlConfigurationProvider,
      successfulUserLoginModel: successfulUserLoginModel,
    );
  }

  GotoCourseLaunch._internal({
    required this.context,
    required this.courseLaunchModel,
    required this.appSystemConfigurationModel,
    required this.tinCanDataModel,
    required this.apiUrlConfigurationProvider,
    required this.successfulUserLoginModel,
  }) {
    MyPrint.printOnConsole("i am in it of GotoCourseLaunch");
  }

  Future<String> getCourseUrl() async {
    MyPrint.printOnConsole("GotoCourseLaunch().getCourseUrl() called");

    String retUrl = "";

    String strUserID = apiUrlConfigurationProvider.getCurrentUserId().toString();
    String userName = successfulUserLoginModel.email;
    String password = successfulUserLoginModel.password;

    int objectTypeId = courseLaunchModel.ContentTypeId;
    String mediaTypeId = courseLaunchModel.MediaTypeId.toString();
    String siteUrl = apiUrlConfigurationProvider.getCurrentSiteUrl();
    String scoId = courseLaunchModel.ScoID.toString();
    String contentId = courseLaunchModel.ContentID.toString();
    String userid = courseLaunchModel.SiteUserID.toString();
    String folderPath = courseLaunchModel.FolderPath.toString();
    String startPage = courseLaunchModel.startPage.toString();
    String courseName = courseLaunchModel.ContentName.toString();
    String jwVideoKey = courseLaunchModel.JWVideoKey.toString();
    String siteId = courseLaunchModel.SiteId.toString();
    String activityId = courseLaunchModel.ActivityId.toString();
    //String startPage = courseDTOModel.startpage.toString();
    // String endDurationDate = courseDTOModel.durationenddate.toString();

    if (objectTypeId == InstancyObjectTypes.reference) {
      return startPage;
    }

    String dir = "", downloadDestFolderPath = "", finalDownloadedFilePath = "";
    File? myFile;
    bool isDownloadFileExists = false;

    if (!kIsWeb) {
      dir = await AppController.getDocumentsDirectory();

      downloadDestFolderPath = "$dir/.Mydownloads/Contentdownloads/$contentId";

      finalDownloadedFilePath = "$downloadDestFolderPath/$startPage";
      //String finalDownloadedFilePath = downloadDestFolderPath + "/" + "hello.html";

      MyPrint.printOnConsole('downlaodedfile:$finalDownloadedFilePath');

      myFile = File(finalDownloadedFilePath);
      isDownloadFileExists = await myFile.exists();
    }
    String offlinePath = "";

    ///TIN CAN OPTIONS
    String authKey = tinCanDataModel.lrsauthorization;
    String authPassword = tinCanDataModel.lrsauthorizationpassword;
    String base64lrsAuthKey = "$authKey:$authPassword";
    String lrsEndPoint = tinCanDataModel.lrsendpoint;
    String lrsActor =
        "${"{\"name\":[\"$userName\"],\"account\":[{\"accountServiceHomePage\":\"${apiUrlConfigurationProvider.getCurrentSiteUrl()}"}\",\"accountName\":\"$password|$strUserID\"}],\"objectType\":\"Agent\"}&activity_id=$activityId&grouping=$activityId";
    String lrsAuthorizationKey = "";
    String autKey = base64lrsAuthKey;

    Uint8List encrpt = utf8.encode(autKey) as Uint8List;
    String base64 = base64Encode(encrpt);
    lrsAuthorizationKey = "Basic%20$base64";

    bool enabletincanSupportforco = tinCanDataModel.enabletincansupportforco;
    bool enabletincanSupportforao = tinCanDataModel.enabletincansupportforao;
    bool enabletincanSupportforlt = tinCanDataModel.enabletincansupportforlt;
    bool isTinCan = tinCanDataModel.istincan;

    MyPrint.printOnConsole("isTinCan:$isTinCan");
    MyPrint.printOnConsole("enabletincanSupportforco:$enabletincanSupportforco");
    MyPrint.printOnConsole("enabletincanSupportforao:$enabletincanSupportforao");
    MyPrint.printOnConsole("enabletincanSupportforlt:$enabletincanSupportforlt");

    ///End TIN CAN OPTIONS

    /// this is offline part
    if (isDownloadFileExists && objectTypeId != InstancyObjectTypes.events) {
      MyPrint.printOnConsole('if___course_launch_ogjtypr $objectTypeId');

      /// Generate Offline Path
      if ([InstancyObjectTypes.contentObject, InstancyObjectTypes.assessment, InstancyObjectTypes.track].contains(objectTypeId)) {
        /// get something from database is pending
        //databaseH.preFunctionalityBeforeNonLRSOfflineContentPathCreation(courseDTOModel, context);

        //offlinePath = databaseH.generateOfflinePathForCourseView(courseDTOModel, context);

        /// Remove this line
        offlinePath = "file://$finalDownloadedFilePath";
      } else if (objectTypeId == InstancyObjectTypes.xApi) {
        String encodedString = lrsActor;

        offlinePath = "file://$offlinePath";
        offlinePath = "$offlinePath?&endpoint=$lrsEndPoint&auth=$lrsAuthorizationKey&actor=$encodedString&cid=0&nativeappURL=true&IsInstancyContent=true";
      } else if (objectTypeId == InstancyObjectTypes.externalTraining) {
      } else if (objectTypeId == InstancyObjectTypes.scorm1_2) {
        offlinePath = "file://$dir/Mydownloads/Content/LaunchCourse.html?contentpath=file://$offlinePath";
      } else if (objectTypeId == InstancyObjectTypes.certificate) {
        String cerName = "$contentId/Certificate";

        offlinePath = "$offlinePath/$userid/$cerName.pdf";
      } else if ([
        InstancyObjectTypes.mediaResource,
        InstancyObjectTypes.document,
        InstancyObjectTypes.html,
        InstancyObjectTypes.reference,
        InstancyObjectTypes.webPage,
      ].contains(objectTypeId)) {
        offlinePath = "file://$offlinePath";

        /// CMIModel ,LearnerSessionModel

        if (courseLaunchModel.ActualStatus == "Not Started" || courseLaunchModel.ActualStatus == "") {
          // need to save CMI model

          /*CMIModel model = CMIModel(
            datecompleted: "",
            siteId: courseDTOModel.siteid.toString(),
            userId: courseDTOModel.userid,
            startdate: await getCurrentDateTimeInStr(),
            scoId: courseDTOModel.scoid,
            isupdate: "false",
            status: "incomplete",
            seqNum: "0",
            percentageCompleted: "50",
            timespent: "",
            objecttypeid: objectTypeId.toString(),
            sitrurl: courseDTOModel.siteurl,
          );*/

          ///databaseH.injectIntoCMITable(model, "false");

          /// need to find getLatestAttempt
          //int attempts = databaseH.getLatestAttempt(courseDTOModel);

          // int attempts = 0;

          /*LearnerSessionModel learnerSessionModel = LearnerSessionModel(
            siteID: courseDTOModel.siteid.toString(),
            userID: courseDTOModel.userid.toString(),
            scoID: courseDTOModel.scoid.toString(),
            attemptNumber: (attempts + 1).toString(),
            sessionDateTime: await getCurrentDateTimeInStr(),
          );*/

          ///databaseH.insertUserSession(learnerSessionModel);
        }
      } else {
        offlinePath = "file://$finalDownloadedFilePath";
      }

      String offlinePathEncode = offlinePath.replaceAll(" ", "%20");

      MyPrint.printOnConsole("final....offlinePathEncode....path.....$offlinePathEncode");
      MyPrint.printOnConsole("final....finalDownloadedFilePath....path.....$finalDownloadedFilePath");

      if (finalDownloadedFilePath.contains(".pdf")) {
        NavigationController.navigateToPDFLaunchScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: PDFLaunchScreenNavigationArguments(
            isNetworkPDF: false,
            contntName: courseLaunchModel.ContentName,
            pdfFilePath: finalDownloadedFilePath,
          ),
        );
      } else if (finalDownloadedFilePath.contains(".mp4")) {
        if (myFile != null) {
          NavigationController.navigateToVideoLaunchScreen(
            navigationOperationParameters: NavigationOperationParameters(
              context: context,
              navigationType: NavigationType.pushNamed,
            ),
            arguments: VideoLaunchScreenNavigationArguments(
              isNetworkVideo: false,
              videoFilePath: finalDownloadedFilePath,
            ),
          );
        }
      } else if (finalDownloadedFilePath.toLowerCase().contains(".xlsx") ||
          finalDownloadedFilePath.toLowerCase().contains(".xls") ||
          finalDownloadedFilePath.toLowerCase().contains(".ppt") ||
          finalDownloadedFilePath.toLowerCase().contains(".pptx") ||
          // finalDownloadedFilePath.toLowerCase().contains(".pdf") ||
          finalDownloadedFilePath.toLowerCase().contains(".doc") ||
          finalDownloadedFilePath.toLowerCase().contains(".docx")) {
        await openFile(finalDownloadedFilePath);
      } else {
        MyPrint.printOnConsole('finalDownloadedFilePath $finalDownloadedFilePath');
        return "$offlinePath?nativeappURL=true&cid=12855&stid=316&lloc=1&lstatus=incomplete&susdata=%23pgvs_start%231;2;3;4;5;6;%23pgvs_end%23&quesdata=&sname=vinoth%20instancy&IsInstancyContent=true";
        //alertDialog(context);
      }
    }

    /// this is online part
    else {
      MyPrint.printOnConsole('else___course_launch_ogjtypr GotoCourseLaunch $objectTypeId');

      if (objectTypeId == InstancyObjectTypes.track && courseLaunchModel.bit5) {
        // Need to open EventTrackListTabsActivity

        /*Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventTrackList(
                  courseDTOModel,
                  true,
                  list,
                )));*/
      } else {
        if ([
          InstancyObjectTypes.mediaResource,
          InstancyObjectTypes.document,
          InstancyObjectTypes.html,
          InstancyObjectTypes.reference,
          InstancyObjectTypes.webPage,
        ].contains(objectTypeId)) {
          // if (courseDTOModel.ActualStatus == "Not Started" || courseDTOModel.actualstatus.isEmpty) {
          if (true) {
            // need to save CMI model

            /*CMIModel model = CMIModel(
              datecompleted: "",
              siteId: courseDTOModel.siteid.toString(),
              // userId: courseDTOModel.userid, Commented or int type by Upendra
              startdate: await getCurrentDateTimeInStr(),
              scoId: courseDTOModel.scoid,
              isupdate: "false",
              status: "incomplete",
              seqNum: "0",
              percentageCompleted: "50",
              timespent: "",
              objecttypeid: objectTypeId.toString(),
              contentId: courseDTOModel.contentid,
              sitrurl: courseDTOModel.siteurl,
            );*/

            //databaseH.injectIntoCMITable(model, "false");
            // need to find getLatestAttempt
            //int attempts = databaseH.getLatestAttempt(courseDTOModel);

            // int attempts = 0;

            /*LearnerSessionModel learnerSessionModel = LearnerSessionModel(
              siteID: courseDTOModel.siteid.toString(),
              userID: courseDTOModel.userid.toString(),
              scoID: courseDTOModel.scoid.toString(),
              attemptNumber: (attempts + 1).toString(),
              sessionDateTime: await getCurrentDateTimeInStr(),
            );*/

            ///databaseH.insertUserSession(learnerSessionModel);
          }
        }

        MyPrint.printOnConsole("folderPath:'$folderPath'");
        MyPrint.printOnConsole("objectTypeId:'$objectTypeId'");
        MyPrint.printOnConsole("mediaTypeId:'$mediaTypeId'");

        // Start of 8,9,10
        if ([InstancyObjectTypes.contentObject, InstancyObjectTypes.assessment, InstancyObjectTypes.track].contains(objectTypeId)) {
          urlForView =
              "${"${siteUrl}ajaxcourse/ScoID/$scoId/ContentTypeId/$objectTypeId"}/ContentID/$contentId/AllowCourseTracking/true/trackuserid/$userid/ismobilecontentview/true/ContentPath/~Content~PublishFiles~$folderPath~$startPage?nativeappURL=true";

          if (isTinCan) {
            if (objectTypeId == InstancyObjectTypes.contentObject && enabletincanSupportforco) {
              urlForView = "$urlForView&endpoint=$lrsEndPoint&auth=$lrsAuthorizationKey&actor=$lrsActor";
            } else if (objectTypeId == InstancyObjectTypes.assessment && enabletincanSupportforao) {
              urlForView = "$urlForView&endpoint=$lrsEndPoint&auth=$lrsAuthorizationKey&actor=$lrsActor";
            } else if (objectTypeId == InstancyObjectTypes.track && enabletincanSupportforlt) {
              urlForView = "$urlForView&endpoint=$lrsEndPoint&auth=$lrsAuthorizationKey&actor=$lrsActor";
            }
          }
        } // End of 8,9,10

        // Start of 11,14,21,36
        else if ([
          InstancyObjectTypes.mediaResource,
          InstancyObjectTypes.document,
          InstancyObjectTypes.html,
          InstancyObjectTypes.webPage,
        ].contains(objectTypeId)) {
          if (objectTypeId == InstancyObjectTypes.mediaResource && isValidString(jwVideoKey)) {
            String jwstartpage = "";
            if (isValidString(courseLaunchModel.jwstartpage)) {
              jwstartpage = courseLaunchModel.jwstartpage;
            } else {
              jwstartpage = startPage;
            }

            // jwstartpage = jwstartpage.replaceAll("/", "~");

            // urlForView = "${"${siteUrl}ajaxcourse/ScoID/$scoId/ContentTypeId/$objectTypeId"}/ContentID/$contentId/AllowCourseTracking/true/trackuserid/$userid/ismobilecontentview/true/ContentPath/~Content~PublishFiles~$folderPath~$jwstartpage?JWVideoParentID/$contentId/jwvideokey/$jwVideoKey";
            urlForView = "$siteUrl/content/publishfiles/$folderPath/$jwstartpage";
          } else if (objectTypeId == InstancyObjectTypes.mediaResource && [InstancyMediaTypes.embedAudio.toString(), InstancyMediaTypes.embedVideo.toString()].contains(mediaTypeId)) {
            MyPrint.printOnConsole("In Embed Section");
            MyPrint.printOnConsole("folderPath:$folderPath");

            urlForView = "${"$siteUrl/content/publishfiles/$folderPath/${courseLaunchModel.locale}"}/$folderPath.html?v=${Random().nextInt(100000)}";
          } else {
            urlForView = "$siteUrl/content/publishfiles/${folderPath.toLowerCase()}/$startPage";
            if (appSystemConfigurationModel.isCloudStorageEnabled) {
              urlForView = "${appSystemConfigurationModel.azureRootPath}content/publishfiles/${folderPath.toLowerCase()}/$startPage";
              //urlForView = urlForView.toLowerCase();
            }
            // if (uiSettingModel.isCloudStorageEnabled == "true") {
            //   urlForView = uiSettingModel.AzureRootPath +
            //       "Content/PublishFiles/" +
            //       folderpath +
            //       "/";
            //   urlForView = urlForView.toLowerCase() + startpage;
            // } commented as per ajay only that content have that issue
          }
        }
        // End of 11,14,21,36

        else if (objectTypeId == InstancyObjectTypes.reference) {
          urlForView = startPage;
        } else if (objectTypeId == InstancyObjectTypes.scorm1_2) {
          // scorm content

          String startPage2 = startPage.replaceAll("/", "~");

          urlForView =
              "${"${siteUrl}ajaxcourse/CourseName/$courseName/ScoID/$scoId/ContentID/$contentId/ContentTypeId/$objectTypeId"}/AllowCourseTracking/true/trackuserid/$userid/eventkey//eventtype//ismobilecontentview/true/ContentPath/~Content~PublishFiles~$folderPath~$startPage2?nativeappurl=true";
        } else if (objectTypeId == InstancyObjectTypes.aICC) {
          urlForView =
              "${"$siteUrl/ajaxcourse/CourseName/$courseName/ContentID/$contentId/ContentTypeId/$objectTypeId"}/AllowCourseTracking/true/trackuserid/$userid/eventkey//eventtype//ismobilecontentview/true/ContentPath/~$startPage?nativeappurl=true";
        }

        /// need to fix after TinConfig
        else if (objectTypeId == InstancyObjectTypes.xApi) {
          String encodedString = "";

          encodedString = lrsActor.replaceAll(" ", "%20");

          if (isValidString(folderPath) && folderPath != "0") {
            urlForView =
                "${"${apiUrlConfigurationProvider.getCurrentSiteUrl()}Content/PublishFiles/$folderPath/$startPage?endpoint=$lrsEndPoint&auth=$lrsAuthorizationKey&actor=$encodedString&registration=$folderPath&ContentID=$contentId&ObjectTypeID=$objectTypeId"}&CanTrack=YES";
          } else {
            urlForView =
                "${"${apiUrlConfigurationProvider.getCurrentSiteUrl()}Content/PublishFiles/$folderPath/$startPage?endpoint=$lrsEndPoint&auth=$lrsAuthorizationKey&actor=$encodedString&ContentID=$contentId&ObjectTypeID=$objectTypeId"}&CanTrack=YES";
          }

          MyPrint.printOnConsole("isCloudStorageEnabled:${appSystemConfigurationModel.isCloudStorageEnabled}");
          if (appSystemConfigurationModel.isCloudStorageEnabled) {
            urlForView =
                "${"${appSystemConfigurationModel.azureRootPath}Content/PublishFiles/$folderPath/$startPage?endpoint=&auth=&actor=$encodedString&ContentID=$contentId&ObjectTypeID=$objectTypeId"}&CanTrack=NO&nativeappURL=true";
          }
        } else if (objectTypeId == InstancyObjectTypes.certificate) {
          String cerName = "$contentId/Certificate";
          urlForView = "$siteUrl/content/sitefiles/$siteId/UserCertificates/$userid/$cerName.pdf";
        } else if (objectTypeId == InstancyObjectTypes.externalTraining) {
        } else if (objectTypeId == InstancyObjectTypes.dictionaryGlossary) {
          urlForView = "$siteUrl/content/PublishFiles/$folderPath/glossary_english.html";

          /// uiSettingsModel
          if (appSystemConfigurationModel.isCloudStorageEnabled) {
            urlForView = "${appSystemConfigurationModel.azureRootPath}content/publishfiles/$folderPath/glossary_english.html";
          }
        } else if ([InstancyObjectTypes.arModule, InstancyObjectTypes.vrModule].contains(objectTypeId)) {
          urlForView = "${appSystemConfigurationModel.isCloudStorageEnabled ? appSystemConfigurationModel.azureRootPath : siteUrl}/content/PublishFiles/$folderPath/content/data.json";
        } else {}

        if (objectTypeId != InstancyObjectTypes.xApi && !urlForView.toLowerCase().contains("coursemedium") && !appSystemConfigurationModel.isCloudStorageEnabled) {
          urlForView = urlForView.replaceAll("\\?", "%3F");
        }

        if ([
              InstancyObjectTypes.mediaResource,
              InstancyObjectTypes.document,
              InstancyObjectTypes.dictionaryGlossary,
              InstancyObjectTypes.webPage,
            ].contains(objectTypeId) &&
            ![InstancyMediaTypes.threeDObject, InstancyMediaTypes.threeDAvatar].contains(courseLaunchModel.MediaTypeId) &&
            !appSystemConfigurationModel.isCloudStorageEnabled) {
          urlForView = "$urlForView?fromNativeapp=true";
        }

        String encodedStr = "";
        if (objectTypeId == InstancyObjectTypes.xApi || objectTypeId == InstancyObjectTypes.reference) {
          encodedStr = replace(urlForView);
        } else if ([InstancyObjectTypes.arModule, InstancyObjectTypes.vrModule].contains(objectTypeId) ||
            [InstancyMediaTypes.threeDObject, InstancyMediaTypes.threeDAvatar].contains(courseLaunchModel.MediaTypeId)) {
          encodedStr = urlForView;
        } else {
          encodedStr = replace(urlForView);
        }

        if (encodedStr.toLowerCase().contains(".xlsx") ||
            encodedStr.toLowerCase().contains(".xls") ||
            encodedStr.toLowerCase().contains(".ppt") ||
            encodedStr.toLowerCase().contains(".pptx") ||
            // encodedStr.toLowerCase().contains(".pdf") ||
            encodedStr.toLowerCase().contains(".doc") ||
            encodedStr.toLowerCase().contains(".docx")) {
          MyPrint.printOnConsole("......xxxxxxx.....");
          encodedStr = "https://docs.google.com/gview?embedded=true&url=$encodedStr";
          //encodedStr = "https://docs.google.com/gview?embedded=true&url=" + encodedStr.toLowerCase();
        }

        MyPrint.printOnConsole("..............this is final URL..........");
        MyPrint.printOnConsole("..............SAGAR..........");
        MyPrint.printOnConsole("......$objectTypeId.......................");
        MyPrint.printOnConsole("...URL...$encodedStr");

/*
          if( encodedStr.toLowerCase().contains(".pdf") )
            {


             // encodedStr = "http://africau.edu/images/default/sample.pdf";

              http.Response response = await http.get(encodedStr);
              Uint8List pdfBytes =response.bodyBytes; //Uint8List

             // MyPrint.printOnConsole(s)("......responce.statusCode..${response.statusCode}");
             // MyPrint.printOnConsole(s)("......responce...${pdfBytes}");
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => PdfCourseLaunch(url: encodedStr,pdfBytes: pdfBytes,isOffline: false,)));
            }
          else{
           Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdvancedWebCourseLaunch(encodedStr)));
          }*/

        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdvancedWebCourseLaunch(encodedStr,courseDTOModel)));
        //await Navigator.of(context).push(MaterialPageRoute(builder: (context) => InAppWebCourseLaunch(encodedStr,courseDTOModel)));
        //logger.e(".......i am back.....");

        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoCourseLaunch(myFile: myFile,)));

        ///return string value

        retUrl = encodedStr;
      }
    }

    return retUrl;
  }

  bool isValidString(String str) {
    try {
      if (str.isEmpty || str == "" || str == "null" || str == "undefined" || str == "null\n") {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  String replace(String str) {
    return str.replaceAll(" ", "%20");
  }

  Future<DateTime?> convertToDate(String dateString) async {
    DateTime? convertedDate;
    if (!isValidString(dateString)) return convertedDate;
    try {
      convertedDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateString);
    } catch (e) {
      // TODO Auto-generated catch block
      //e.printStackTrace();
    }
    return convertedDate;
  }

  Future<bool> isCourseEndDateCompleted(String endDate) async {
    bool isCompleted = true;

    DateTime? strDate = await convertToDate(endDate);

    if (strDate != null) {
      if (DateTime.now().isAfter(strDate)) {
// today is after date 2
        isCompleted = true;
      } else {
        isCompleted = false;
      }
    }

    return isCompleted;
  }

  Future<String> getCurrentDateTimeInStr() async {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat("yyyy-MM-dd hh:mm:ss");
    String formatted = formatter.format(now);

    return formatted;
  }

  Future<void> openFile(String path) async {
    final result = await OpenFile.open(path);

    MyPrint.printOnConsole(".....file...open....$result");
  }

  alertDialog(BuildContext context) {
    // This is the ok button
    Widget ok = CommonButton(
      child: const Text("Okay"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // show the alert dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Comming Soon",
            style: TextStyle(color: Colors.black),
          ),
          content: const Text("Offline HTML content will not load  "),
          actions: [
            ok,
          ],
          elevation: 5,
        );
      },
    );
  }
}
