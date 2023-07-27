import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/extensions.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/event_track/event_track_controller.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../configs/app_configurations.dart';
import '../../../models/event_track/data_model/event_track_reference_item_model.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_safe_state.dart';
import '../../../utils/my_toast.dart';
import '../../../utils/my_utils.dart';

class ResourceTabWidget extends StatefulWidget {
  final List<EventTrackReferenceItemModel> resourceData;


  const ResourceTabWidget({
    Key? key,
    required this.resourceData,

  }) : super(key: key);

  @override
  State<ResourceTabWidget> createState() => _ResourceTabWidgetState();
}

class _ResourceTabWidgetState extends State<ResourceTabWidget> with MySafeState {
  late AppProvider appProvider;
  late ApiUrlConfigurationProvider apiUrlConfigurationProvider;


  void navigateUrl(EventTrackReferenceItemModel refItem) {
    print('urlpathh ${refItem.path}');

    String urlpath = "";

    if (refItem.type == 'url') {
      urlpath = refItem.path;
    } else {
      if (refItem.path.contains('jwplatform')) {
        urlpath = refItem.path.replaceAll('//', '');
      } else {
        urlpath = apiUrlConfigurationProvider.getCurrentSiteUrl() + refItem.path;
      }

      if (urlpath.toLowerCase().contains(".ppt") ||
          urlpath.toLowerCase().contains(".pptx") ||
          urlpath.toLowerCase().contains(".pdf") ||
          urlpath.toLowerCase().contains(".doc") ||
          urlpath.toLowerCase().contains(".docx") ||
          urlpath.toLowerCase().contains(".xls") ||
          urlpath.toLowerCase().contains(".xlsx")) {
        urlpath = urlpath.replaceAll("file://", "");
        if (appProvider.appSystemConfigurationModel.isCloudStorageEnabled) {
          urlpath = "https://docs.google.com/gview?embedded=true&url=$urlpath?fromnativeapp=true";
        }
        else {
          urlpath = "https://docs.google.com/gview?embedded=true&url=$urlpath?fromNativeapp=true";
        }
      } else if (urlpath.toLowerCase().contains(".jwplatform")) {
        urlpath = 'http://$urlpath';
      }
//      else if (urlpath.toLowerCase().contains(".pdf")) {
//        if (appBloc.uiSettingModel.isCloudStorageEnabled.toLowerCase() ==
//            'true') {
//          urlpath = "http://docs.google.com/gview?embedded=true&url="+ urlpath + "?fromnativeapp=true";
//        } else {
//          urlpath = "http://docs.google.com/gview?embedded=true&url=" +urlpath + "?fromNativeapp=true";
//        }
//      }
      else {
        urlpath = urlpath;
      }
    }

//     Navigator.of(context).push(MaterialPageRoute(
//        builder: (context) => InAppWebCourseLaunch('https://flutter.instancy.com//Content/Instancy V2 Folders/734/en-us/856acec4-56ff-4dec-aa24-652cb34f892a.pdf?fromNativeapp=true', table2)));

    urlpath = MyUtils.getSecureUrl(urlpath);
    print('finalurlpath $urlpath');

    NavigationController.navigateToWebViewScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: WebViewScreenNavigationArguments(
        title: refItem.title,
        url: urlpath,
      ),
    );
  }

  Future<void> downloadRes(EventTrackReferenceItemModel refItem) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventTrackList().downloadRes() called", tag: tag);

    if (kIsWeb) return;

    if (!["Media resource", "Document"].contains(refItem.type)) {
      MyPrint.printOnConsole("Invalid Resource Type For Download", tag: tag);
      // MyToast.showToast(context, "Invalid Resource Type For Download");
      return;
    }

    String filePath = refItem.path;
    if (filePath.isEmpty) {
      MyPrint.printOnConsole("filePath is empty to download resource", tag: tag);
      // MyToast.showToast(context, "Download Url Not Available");
      return;
    }

    //region File Name Initialization
    String fileName = "";
    MyPrint.printOnConsole("File Path: ${filePath}");
    if (filePath.isNotEmpty && filePath.contains("/")) {
      fileName = filePath.split("/").lastElement ?? "";
    } else {
      fileName = filePath.trim();
    }

    if (fileName.isEmpty) {
      fileName = DateTime.now().millisecondsSinceEpoch.toString();
    }
    //endregion

    //region File Url Initialization
    ApiUrlConfigurationProvider provider = ApiController().apiDataProvider;
    String fileUrl = "${provider.getCurrentSiteUrl()}${filePath.trim()}?fromnativeapp=true";
    //endregion

    MyPrint.printOnConsole("Download File Name:$fileName", tag: tag);
    MyPrint.printOnConsole("Download File Url:$fileUrl", tag: tag);

    refItem.isDownloading = true;
    mySetState();

    bool isDownloaded = await EventTrackController(learningPathProvider: null).simpleDownloadFileAndSave(downloadUrl: fileUrl, downloadFileName: fileName);
    MyPrint.printOnConsole("isDownloaded:$isDownloaded", tag: tag);

    refItem.isDownloading = false;
    mySetState();

    if (isDownloaded) {
      if(context.mounted) {
        MyToast.showSuccess(context: context, msg: "Successfully Downloaded");
      }
    } else {
      if (context.mounted) {
        MyToast.showError(msg: "Download Failed", context: context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();
    apiUrlConfigurationProvider = ApiController().apiDataProvider;
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return ListView.builder(
      itemCount: widget.resourceData.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        EventTrackReferenceItemModel model = widget.resourceData[index];

        return resourceListItem(model: model);
      },
    );
  }

  Widget resourceListItem({required EventTrackReferenceItemModel model}) {
    return InkWell(
      onTap: () {
        navigateUrl(model);
      },
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black26)),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: Row(
          children: [
            /*Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.transparent), color: const Color(0xffF8F7FA)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const CommonCachedNetworkImage(
                  imageUrl: "https://picsum.photos/200/300",
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),*/
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      coursesIcon(resourceType: model.type),
                      const SizedBox(width: 10),
                      Text(
                        model.type,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Color(0xff757575),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    model.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xff757575),
                    ),
                  )
                ],
              ),
            ),
            if ([TrackResourceType.document, TrackResourceType.mediaResource].contains(model.type))
              InkWell(
                onTap: () {

                  if (!model.isDownloading) downloadRes(model);
                },
                child: model.isDownloading
                    ? SpinKitCircle(color: themeData.primaryColor, size: 30)
                    : const Icon(
                  Icons.download_for_offline,
                  color: Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget coursesIcon({String resourceType = ""}) {
    String assetName = AppConfigurations.getContentIconFromObjectAndMediaType(mediaTypeId: 1, objectTypeId: 2);
    if(resourceType == TrackResourceType.document) {
      assetName = AppConfigurations.getContentIconFromObjectAndMediaType(mediaTypeId: InstancyMediaTypes.document, objectTypeId: InstancyObjectTypes.document);
    }
    else if(resourceType == TrackResourceType.url) {
      assetName = AppConfigurations.getContentIconFromObjectAndMediaType(mediaTypeId: InstancyMediaTypes.url, objectTypeId: InstancyObjectTypes.reference);
    }
    else if(resourceType == TrackResourceType.mediaResource) {
      assetName = AppConfigurations.getContentIconFromObjectAndMediaType(mediaTypeId: InstancyMediaTypes.audio, objectTypeId: InstancyObjectTypes.mediaResource);
    }

    return Image.asset(
      assetName,
      height: 13,
      width: 13,
      fit: BoxFit.cover,
    );
  }
}
