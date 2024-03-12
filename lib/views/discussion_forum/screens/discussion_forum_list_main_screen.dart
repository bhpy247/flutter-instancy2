import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/backend/discussion/discussion_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/discussion/discussion_controller.dart';
import '../../../configs/app_constants.dart';
import 'discussion_list_screen.dart';
import 'my_discussion_forum_list_screen.dart';

class DiscussionForumMainScreen extends StatefulWidget {
  static const String routeName = "/DiscussionForumMainScreen";

  final DiscussionForumScreenNavigationArguments arguments;

  const DiscussionForumMainScreen({super.key, required this.arguments});

  @override
  State<DiscussionForumMainScreen> createState() => _DiscussionForumMainScreenState();
}

class _DiscussionForumMainScreenState extends State<DiscussionForumMainScreen> with MySafeState, SingleTickerProviderStateMixin {
  late ThemeData themeData;

  TabController? tabController;
  late DiscussionController discussionController;
  late DiscussionProvider discussionProvider;
  late AppProvider appProvider;
  String? appBarTitle;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    discussionProvider = widget.arguments.discussionProvider ?? DiscussionProvider();
    if (widget.arguments.searchString.checkNotEmpty) {
      discussionProvider.forumListSearchString.set(value: widget.arguments.searchString);
      discussionProvider.myDiscussionForumListSearchString.set(value: widget.arguments.searchString);
    }
    appProvider = context.read<AppProvider>();
    if (widget.arguments.isShowAppbar) {
      appBarTitle = appProvider.getMenuModelFromComponentId(componentId: InstancyComponents.discussionForumComponent)?.displayname;
    }
    discussionController = DiscussionController(discussionProvider: discussionProvider, apiController: widget.arguments.apiController);
    discussionController.getCategoriesList(componentId: widget.arguments.componentId, componentInstanceId: widget.arguments.componentInsId);
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Consumer<DiscussionProvider>(
      builder: (BuildContext context, DiscussionProvider discussionProvider, Widget? child) {
        return ModalProgressHUD(
          inAsyncCall: discussionProvider.isLoading.get(),
          child: Scaffold(
            appBar: widget.arguments.isShowAppbar ? getAppBarFromGlobalSearch() : getAppBar(),
            body: getMainBody(),
          ),
        );
      },
    );
  }

  AppBar? getAppBarFromGlobalSearch() {
    if (appBarTitle == null) return null;
    return AppBar(
      title: Text(
        appBarTitle ?? "",
      ),
    );
  }

  PreferredSize? getAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.5), width: 0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(child: SizedBox()),
              TabBar(
                controller: tabController,
                padding: const EdgeInsets.symmetric(vertical: 0),
                labelPadding: const EdgeInsets.all(0),
                indicatorPadding: const EdgeInsets.only(top: 20),
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: themeData.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
                tabs: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("All Discussion"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("My Discussion"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getMainBody() {
    return TabBarView(
      controller: tabController,
      children: <Widget>[
        allDiscussionTab(),
        myDiscussionTab(),
      ],
    );
  }

  Widget allDiscussionTab() {
    return DiscussionListScreen(
      componentId: widget.arguments.componentId,
      componentInstanceId: widget.arguments.componentInsId,
      apiController: widget.arguments.apiController,
    );
  }

  Widget myDiscussionTab() {
    return MyDiscussionListScreen(
      componentId: widget.arguments.componentId,
      componentInstanceId: widget.arguments.componentInsId,
      apiController: widget.arguments.apiController,
    );
  }
}
