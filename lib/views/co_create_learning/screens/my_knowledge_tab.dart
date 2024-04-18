import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/my_print.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_controller.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../../../backend/co_create_knowledge/co_create_knowledge_provider.dart';
import '../component/add_content_dialog.dart';
import '../component/custom_search_view.dart';
import '../component/item_widget.dart';
import '../component/size_utils.dart';

class MyKnowledgeTab extends StatefulWidget {
  @override
  State<MyKnowledgeTab> createState() => _MyKnowledgeTabState();
}

class _MyKnowledgeTabState extends State<MyKnowledgeTab> with MySafeState {
  late CoCreateKnowledgeController _controller;
  late CoCreateKnowledgeProvider _provider;

  late Future future;

  // void showPopupMenu(BuildContext context) async {
  //   final RenderObject? sliver = Scrollable.of(context);
  //   if (sliver == null) return; // Handle null case (e.g., no scrollable parent)
  //
  //   final offset = sliver.localToGlobal(Offset.zero);
  //   final size = ListItemWidget.buttonSize;
  //
  //   // final RenderBox button = context.findRenderObject() as RenderBox;
  //   // final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  //   // final RelativeRect position = RelativeRect.fromRect(
  //   //   Rect.fromPoints(
  //   //     button.localToGlobal(Offset.zero, ancestor: overlay),
  //   //     button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
  //   //   ),
  //   //   Offset.zero & overlay.size,
  //   // );
  //   await showMenu(
  //     context: context,
  //     position: RelativeRect.fromSize(
  //       Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height), // Position below button
  //       Size(300, 200.0), // Set desired menu width and height
  //     ),
  //     items: [
  //       const PopupMenuItem(
  //         value: 'Edit',
  //         child: Text('Edit'),
  //       ),
  //       const PopupMenuItem(
  //         value: 'Share',
  //         child: Text('Share'),
  //       ),
  //       const PopupMenuItem(
  //         value: 'Delete',
  //         child: Text('Delete'),
  //       ),
  //     ],
  //     elevation: 8.0,
  //   );
  // }

  // void showKnowledgeContentDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AddContentDialog();
  //     },
  //   );
  // }

  Future<void> getFutureData() async {
    await _controller.getMyKnowledgeList();
  }

  void onCardTapCallBack({required int objectType}) {
    if (objectType == InstancyObjectTypes.flashCard) {
    } else if (objectType == InstancyObjectTypes.rolePlay) {
    } else if (objectType == InstancyObjectTypes.podcastEpisode) {
    } else if (objectType == InstancyObjectTypes.referenceUrl) {
    } else if (objectType == InstancyObjectTypes.document) {
    } else if (objectType == InstancyObjectTypes.videos) {
    } else if (objectType == InstancyObjectTypes.quiz) {
    } else if (objectType == InstancyObjectTypes.article) {}
  }

  @override
  void initState() {
    super.initState();
    _provider = context.read<CoCreateKnowledgeProvider>();
    _controller = CoCreateKnowledgeController(coCreateKnowledgeProvider: _provider);
    future = getFutureData();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Sizer(builder: (context, orientation, deviceType) {
      return RefreshIndicator(
        onRefresh: () async {
          future = getFutureData();
          mySetState();
        },
        child: Scaffold(
          body: mainWidget(),
          floatingActionButton: PopUpDialog(
            provider: _provider,
          ),
        ),
      );
    });
  }

  Widget mainWidget() {
    return FutureBuilder(
      future: future,
      builder: (context, AsyncSnapshot asyncSnapshot) {
        if (asyncSnapshot.connectionState != ConnectionState.done) return const Center(child: CommonLoader());

        return MultiProvider(
          providers: [
            ChangeNotifierProvider<CoCreateKnowledgeProvider>.value(value: _provider),
          ],
          child: Consumer<CoCreateKnowledgeProvider>(builder: (context, CoCreateKnowledgeProvider provider, _) {
            if (provider.isLoading.get()) return const CommonLoader();
            List<CourseDTOModel> list = provider.myKnowledgeList.getList();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0).copyWith(top: 15, bottom: 10),
                  child: CustomSearchView(),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: list.length,
                      padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 10),
                      itemBuilder: (BuildContext listContext, int index) {
                        return myKnowledgeItemWidget(
                          model: list[index],
                          // onMoreTap: (){
                          //   showPopupMenu(listContext);
                          // },
                        );
                      }),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}

class PopUpDialog extends StatefulWidget {
  final CoCreateKnowledgeProvider provider;

  const PopUpDialog({super.key, required this.provider});

  @override
  State<PopUpDialog> createState() => _PopUpDialogState();
}

class _PopUpDialogState extends State<PopUpDialog> with MySafeState {
  final List<KnowledgeTypeModel> knowledgeTypeList = [
    KnowledgeTypeModel(name: "Flashcard", iconUrl: "assets/cocreate/Card.png", objectTypeId: InstancyObjectTypes.flashCard),
    KnowledgeTypeModel(name: "Quiz", iconUrl: "assets/cocreate/Chat Question.png", objectTypeId: InstancyObjectTypes.quiz),
    KnowledgeTypeModel(name: "Podcast Episode", iconUrl: "assets/cocreate/Vector-4.png", objectTypeId: InstancyObjectTypes.podcastEpisode),
    KnowledgeTypeModel(name: "Article", iconUrl: "assets/cocreate/Vector-2.png", objectTypeId: InstancyObjectTypes.article),
    KnowledgeTypeModel(name: "Video", iconUrl: "assets/cocreate/video.png", objectTypeId: InstancyObjectTypes.videos),
    KnowledgeTypeModel(name: "Reference Link", iconUrl: "assets/cocreate/Vector-1.png", objectTypeId: InstancyObjectTypes.referenceUrl),
    KnowledgeTypeModel(name: "Documents", iconUrl: "assets/cocreate/Vector.png", objectTypeId: InstancyObjectTypes.document),
    KnowledgeTypeModel(name: "Event", iconUrl: "assets/cocreate/Vector-3.png", objectTypeId: InstancyObjectTypes.events),
    KnowledgeTypeModel(name: "Roleplay", iconUrl: "assets/cocreate/video.png", objectTypeId: InstancyObjectTypes.rolePlay),
    KnowledgeTypeModel(name: "Learning Maps", iconUrl: "assets/cocreate/Business Hierarchy.png", objectTypeId: InstancyObjectTypes.learningMaps),
    KnowledgeTypeModel(name: "AI Agents", iconUrl: "assets/cocreate/Ai.png", objectTypeId: InstancyObjectTypes.aiAgent),
  ];
  ValueNotifier<bool> isDialOpen = ValueNotifier<bool>(false);

  void onCardTapCallBack({required int objectType}) {
    if (objectType == InstancyObjectTypes.flashCard) {
      MyPrint.printOnConsole("in flsh Card");
      widget.provider.addToMyKnowledgeList(CourseDTOModel(
        ContentTypeId: InstancyObjectTypes.flashCard,
        Title: "Flash Card Title",
      ));
    } else if (objectType == InstancyObjectTypes.rolePlay) {
    } else if (objectType == InstancyObjectTypes.podcastEpisode) {
    } else if (objectType == InstancyObjectTypes.referenceUrl) {
    } else if (objectType == InstancyObjectTypes.document) {
    } else if (objectType == InstancyObjectTypes.videos) {
    } else if (objectType == InstancyObjectTypes.quiz) {
    } else if (objectType == InstancyObjectTypes.article) {}
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      spacing: 3,
      overlayColor: Colors.black,
      overlayOpacity: .5,
      mini: false,
      openCloseDial: isDialOpen,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 2,
      buttonSize: const Size(56.0, 56.0),
      // it's the SpeedDial size which defaults to 56 itself
      /// The below button size defaults to 56 itself, its the SpeedDial childrens size
      childrenButtonSize: const Size(50, 50),
      visible: true,
      direction: SpeedDialDirection.up,
      switchLabelPosition: false,

      /// If true user is forced to close dial manually
      closeManually: true,

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
      children: List.generate(
        knowledgeTypeList.length,
        (index) => SpeedDialChild(
          onTap: () {
            // Navigator.pop(context);
            isDialOpen.value = false;
            mySetState();
            MyPrint.printOnConsole("Index: ${knowledgeTypeList[index].objectTypeId}");
            onCardTapCallBack(objectType: knowledgeTypeList[index].objectTypeId);
          },
          label: knowledgeTypeList[index].name,
          labelStyle: const TextStyle(color: Colors.white),
          labelBackgroundColor: const Color(0xff2BA700),
          elevation: 0,
          labelShadow: [],
          child: Image.asset(
            knowledgeTypeList[index].iconUrl,
            height: 20,
            width: 20,
          ),
        ),
      ),
    );

    //   knowledgeTypeList
    //       .map(
    //         (e) => SpeedDialChild(
    //           onTap: () {},
    //           label: e.name,
    //           labelStyle: const TextStyle(color: Colors.white),
    //           labelBackgroundColor: const Color(0xff2BA700),
    //           elevation: 0,
    //           labelShadow: [],
    //           child: Image.asset(
    //             e.iconUrl,
    //             height: 20,
    //             width: 20,
    //           ),
    //         ),
    //       )
    //       .toList(),
    // );
  }
}
