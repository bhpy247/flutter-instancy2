import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/backend/ask_the_expert/ask_the_expert_controller.dart';
import 'package:flutter_instancy_2/backend/ask_the_expert/ask_the_expert_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/views/ask_the_expert/screen/all_question_tab.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class AskTheExpertMainScreen extends StatefulWidget {
  final AskTheExpertScreenNavigationArguments arguments;

  const AskTheExpertMainScreen({super.key, required this.arguments});

  @override
  State<AskTheExpertMainScreen> createState() => _AskTheExpertMainScreenState();
}

class _AskTheExpertMainScreenState extends State<AskTheExpertMainScreen> with MySafeState, SingleTickerProviderStateMixin {
  late ThemeData themeData;

  TabController? tabController;
  late AskTheExpertController askTheExpertController;
  late AskTheExpertProvider askTheExpertProvider;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    askTheExpertProvider = context.read<AskTheExpertProvider>();
    askTheExpertController = AskTheExpertController(discussionProvider: askTheExpertProvider);
    askTheExpertController.getFilterSkills(componentId: widget.arguments.componentId, componentInstanceId: widget.arguments.componentInsId);
    askTheExpertController.getUserFilterSkills(componentId: widget.arguments.componentId, componentInstanceId: widget.arguments.componentInsId);
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Consumer<AskTheExpertProvider>(
      builder: (BuildContext context, AskTheExpertProvider discussionProvider, Widget? child) {
        return ModalProgressHUD(
          inAsyncCall: discussionProvider.isLoading.get(),
          child: Scaffold(
            // appBar: getAppBar(),
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
                    child: Text("All Questions"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("My Questions"),
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
    return allQuestionTab();

    /*return TabBarView(
      controller: tabController,
      children: <Widget>[
        allQuestionTab(),
        myQuestionTab(),
      ],
    );*/
  }

  Widget allQuestionTab() {
    return AllQuestionsTab(
      componentId: widget.arguments.componentId,
      componentInstanceId: widget.arguments.componentInsId,
    );
  }

  Widget myQuestionTab() {
    return AllQuestionsTab(
      componentId: widget.arguments.componentId,
      componentInstanceId: widget.arguments.componentInsId,
    );
  }
}
