import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/main_screen/main_screen_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/backend/wiki_component/wiki_controller.dart';
import 'package:flutter_instancy_2/backend/wiki_component/wiki_provider.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/wiki_component/response_model/fileUploadControlModel.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

class AddWikiButtonComponent extends StatefulWidget {
  final int componentId;
  final int componentInstanceId;
  final WikiProvider? wikiProvider;
  final bool isHandleChatBotSpaceMargin;

  const AddWikiButtonComponent({
    super.key,
    required this.componentId,
    required this.componentInstanceId,
    this.wikiProvider,
    this.isHandleChatBotSpaceMargin = false,
  });

  @override
  State<AddWikiButtonComponent> createState() => _AddWikiButtonComponentState();
}

class _AddWikiButtonComponentState extends State<AddWikiButtonComponent> with MySafeState {
  late WikiProvider wikiProvider;
  late WikiController wikiController;

  int componentId = 0, componentInstanceId = 0;

  late Future getFileUploadControlFuture;

  ValueNotifier<bool> isDialOpen = ValueNotifier<bool>(false);

  Future<void> getInitialWikiComponentData({bool isRefresh = true}) async {
    if (!isRefresh && wikiProvider.fileUploadControlsModelList.isNotEmpty) {
      if (wikiProvider.wikiCategoriesList.isEmpty) {
        wikiController.getWikiCategoriesFromApi(
          componentId: componentId,
          componentInstanceId: componentInstanceId,
        );
      }

      return;
    }

    await wikiController.getFileUploadControlsFromApi(
      componentId: componentId,
      componentInstanceId: componentInstanceId,
    );

    if (wikiProvider.fileUploadControlsModelList.isNotEmpty && (wikiProvider.wikiCategoriesList.isEmpty || isRefresh)) {
      wikiController.getWikiCategoriesFromApi(
        componentId: componentId,
        componentInstanceId: componentInstanceId,
      );
    }
  }

  WikiContentIconModel? getWikiContentIconModelFromObjectAndMediaType({
    required int objectTypeId,
    required int mediaTypeId,
  }) {
    WikiContentIconModel? wikiContentIconModel;

    switch (mediaTypeId) {
      case InstancyMediaTypes.image:
        {
          wikiContentIconModel = const WikiContentIconModel(
            assetPath: "assets/catalog/wiki_image.png",
          );
          break;
        }
      case InstancyMediaTypes.video:
        {
          wikiContentIconModel = const WikiContentIconModel(
            assetPath: "assets/catalog/wiki_video.png",
          );
          break;
        }
      case InstancyMediaTypes.audio:
        {
          wikiContentIconModel = const WikiContentIconModel(
            assetPath: "assets/catalog/wiki_audio.png",
          );
          break;
        }
      case InstancyMediaTypes.pDF:
        {
          wikiContentIconModel = const WikiContentIconModel(
            assetPath: "assets/catalog/imageDescription.png",
          );
          break;
        }
      case InstancyMediaTypes.url:
        {
          wikiContentIconModel = const WikiContentIconModel(
            assetPath: "assets/catalog/website_url.png",
          );
          break;
        }
    }

    return wikiContentIconModel;
  }

  Future<void> clickOnWikiUploadAction({required String title, required int objectTypeId, required int mediaTypeId}) async {
    dynamic value = await NavigationController.navigateToAddWikiContentScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: AddWikiContentScreenNavigationArguments(
        title: title,
        objectTypeId: objectTypeId,
        mediaTypeId: mediaTypeId,
      ),
    );

    if (value == true) {
      //TODO: Refresh Catalog Data
    }
  }

  @override
  void initState() {
    super.initState();

    wikiProvider = widget.wikiProvider ?? WikiProvider();
    wikiController = WikiController(wikiProvider: wikiProvider);

    componentId = widget.componentId;
    componentInstanceId = widget.componentInstanceId;

    getFileUploadControlFuture = getInitialWikiComponentData(isRefresh: false);
  }

  @override
  void didUpdateWidget(covariant AddWikiButtonComponent oldWidget) {
    bool isModified = false;

    if (wikiProvider != oldWidget.wikiProvider) {
      wikiProvider = widget.wikiProvider ?? WikiProvider();
      wikiController = WikiController(wikiProvider: wikiProvider);
      isModified = true;
    }

    if (componentId != oldWidget.componentId) {
      componentId = widget.componentId;
      isModified = true;
    }

    if (componentInstanceId != oldWidget.componentInstanceId) {
      componentInstanceId = widget.componentInstanceId;
      isModified = true;
    }

    if (isModified) {
      getFileUploadControlFuture = getInitialWikiComponentData(isRefresh: true);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WikiProvider>.value(value: wikiProvider),
      ],
      child: Consumer2<WikiProvider, MainScreenProvider>(
        builder: (context, WikiProvider wikiProvider, MainScreenProvider mainScreenProvider, _) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: mainScreenProvider.isChatBotButtonEnabled.get() && widget.isHandleChatBotSpaceMargin && !mainScreenProvider.isChatBotButtonCenterDocked.get() ? 70 : 0.0,
            ),
            child: FutureBuilder(
              future: getFileUploadControlFuture,
              builder: (BuildContext context, AsyncSnapshot snapShot) {
                if (snapShot.connectionState != ConnectionState.done) {
                  return const SizedBox();
                }

                return SpeedDial(
                  icon: Icons.add,
                  activeIcon: Icons.close,
                  spacing: 3,
                  mini: false,
                  openCloseDial: isDialOpen,
                  childPadding: const EdgeInsets.all(5),
                  spaceBetweenChildren: 4,
                  buttonSize: const Size(56.0, 56.0),
                  // it's the SpeedDial size which defaults to 56 itself
                  /// The below button size defaults to 56 itself, its the SpeedDial childrens size
                  childrenButtonSize: const Size(70, 70),
                  visible: true,
                  direction: SpeedDialDirection.up,
                  switchLabelPosition: false,

                  /// If true user is forced to close dial manually
                  closeManually: false,

                  /// If false, backgroundOverlay will not be rendered.
                  renderOverlay: false,
                  onOpen: () {
                    debugPrint('OPENING DIAL');
                    // setState(() {});
                  },
                  onClose: () {
                    debugPrint('DIAL CLOSED');
                    // isDialOpen.value = false;
                  },
                  useRotationAnimation: true,
                  tooltip: 'Open Speed Dial',
                  // heroTag: 'speed-dial-hero-tag',
                  elevation: 1.0,
                  animationCurve: Curves.easeIn,
                  isOpenOnStart: false,
                  // shape: customDialRoot ? const RoundedRectangleBorder() : const StadiumBorder(),
                  // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  children: _getWikiOption(),
                );
              },
            ),
          );
        },
      ),
    );
  }

  List<SpeedDialChild> _getWikiOption() {
    List<SpeedDialChild> children = [];
    Iterable<FileUploadControlsModel> controls = wikiProvider.fileUploadControlsModelList.where((element) => element.status == true);
    for (FileUploadControlsModel element in controls) {
      WikiContentIconModel? wikiContentIconModel = getWikiContentIconModelFromObjectAndMediaType(
        objectTypeId: element.objectTypeID,
        mediaTypeId: element.mediaTypeID,
      );

      if (wikiContentIconModel != null) {
        children.add(_wikiOption(
          assetIconPath: wikiContentIconModel.assetPath,
          iconData: wikiContentIconModel.iconData,
          title: element.mediaTypeIdisplayName,
          objectTypeID: element.objectTypeID,
          mediaTypeID: element.mediaTypeID,
        ));
      }
    }

    return children;
  }

  SpeedDialChild _wikiOption({
    IconData? iconData,
    required String assetIconPath,
    required String title,
    required int objectTypeID,
    required int mediaTypeID,
  }) {
    return SpeedDialChild(
      child: iconData == null
          ? Image.asset(
              assetIconPath,
              height: 18,
              width: 18,
              color: themeData.primaryColor,
            )
          : const Icon(Icons.accessibility),
      foregroundColor: themeData.primaryColor,
      backgroundColor: themeData.colorScheme.background.withOpacity(0.8),
      label: null,
      elevation: 2,
      onTap: () {
        MyPrint.printOnConsole(mediaTypeID);

        clickOnWikiUploadAction(
          title: title,
          objectTypeId: objectTypeID,
          mediaTypeId: mediaTypeID,
        );
      },
      onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
    );
  }
}

class WikiContentIconModel {
  final String assetPath;
  final IconData? iconData;

  const WikiContentIconModel({
    this.assetPath = "",
    this.iconData,
  });
}
