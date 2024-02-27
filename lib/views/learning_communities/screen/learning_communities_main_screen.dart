import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/learning_communities/learning_communities_provider.dart';
import 'package:flutter_instancy_2/views/learning_communities/screen/all_learning_communities_screen.dart';
import 'package:flutter_instancy_2/views/learning_communities/screen/my_learning_communities_screen.dart';
import 'package:provider/provider.dart';

import '../../../backend/learning_communities/learning_communities_controller.dart';
import '../../../backend/navigation/navigation_arguments.dart';
import '../../common/components/modal_progress_hud.dart';

class LearningCommunitiesMainScreen extends StatefulWidget {
  final LearningCommunitiesScreenNavigationArguments arguments;

  const LearningCommunitiesMainScreen({super.key, required this.arguments});

  @override
  State<LearningCommunitiesMainScreen> createState() => _LearningCommunitiesMainScreenState();
}

class _LearningCommunitiesMainScreenState extends State<LearningCommunitiesMainScreen> with SingleTickerProviderStateMixin {
  late ThemeData themeData;

  TabController? tabController;
  late LearningCommunitiesController learningCommunitiesController;
  late LearningCommunitiesProvider learningCommunitiesProvider;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    learningCommunitiesProvider = context.read<LearningCommunitiesProvider>();
    learningCommunitiesController = LearningCommunitiesController(learningCommunitiesProvider: learningCommunitiesProvider);
    // learningCommunitiesController.getCategoriesList(componentId: widget.arguments.componentId, componentInstanceId: widget.arguments.componentInsId);
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Consumer<LearningCommunitiesProvider>(
      builder: (BuildContext context, LearningCommunitiesProvider learningCommunitiesProvider, Widget? child) {
        return ModalProgressHUD(
          // inAsyncCall: discussionProvider.isLoading.get(),
          inAsyncCall: false,
          child: Scaffold(
            appBar: getAppBar(),
            body: getMainBody(),
          ),
        );
      },
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
                    child: Text("All Communities"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("My Communities"),
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
    return AllLearningCommunitesScreen(
      componentId: widget.arguments.componentId,
      componentInstanceId: widget.arguments.componentInsId,
    );
  }

  Widget myDiscussionTab() {
    return MyLearningCommunitiesScreen(
      componentId: widget.arguments.componentId,
      componentInstanceId: widget.arguments.componentInsId,
    );
  }
}
