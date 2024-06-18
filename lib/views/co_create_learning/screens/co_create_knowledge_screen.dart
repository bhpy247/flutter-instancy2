import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/co_create_learning/screens/my_knowledge_tab.dart';
import 'package:flutter_instancy_2/views/co_create_learning/screens/shared_knowledge_tab.dart';
import 'package:flutter_instancy_2/views/common/components/app_ui_components.dart';

class CoCreateKnowledgeScreen extends StatefulWidget {
  static const String routeName = "/CoCreateKnowledgeScreen";

  final CoCreateKnowledgeScreenNavigationArguments arguments;
  final bool isHandleChatBotSpaceMargin;

  const CoCreateKnowledgeScreen({
    super.key,
    required this.arguments,
    this.isHandleChatBotSpaceMargin = false,
  });

  @override
  State<CoCreateKnowledgeScreen> createState() => _CoCreateKnowledgeScreenState();
}

class _CoCreateKnowledgeScreenState extends State<CoCreateKnowledgeScreen> with MySafeState {
  int componentId = 0, componentInstanceId = 0;

  void initialization() {
    componentId = widget.arguments.componentId;
    componentInstanceId = widget.arguments.componentInstanceId;
    MyPrint.printOnConsole("componentId: $componentId componentinstance $componentInstanceId");
  }

  @override
  void initState() {
    super.initState();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: widget.arguments.isShowAppbar ? getAppBar() : null,
        body: AppUIComponents.getBackGroundBordersRounded(
          context: context,
          child: getTabBarView(),
        ),
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppConfigurations().commonAppBar(
      title: "Co-create Knowledge",
    );
  }

  Widget getTabBarView() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 4, color: themeData.tabBarTheme.indicatorColor ?? themeData.primaryColor),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(100),
                topRight: Radius.circular(100),
              ),
            ),
            labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            tabs: const [
              Tab(
                // icon: Icon(Icons.library_books),
                text: 'Shared Knowledge',
              ),
              Tab(
                // icon: Icon(Icons.share),
                text: 'My Knowledge',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SharedKnowledgeTab(
              componentId: componentId,
              componentInstanceId: componentInstanceId,
            ),
            MyKnowledgeTab(
              componentId: componentId,
              componentInstanceId: componentInstanceId,
              isHandleChatBotSpaceMargin: widget.isHandleChatBotSpaceMargin,
            ),
          ],
        ),
      ),
    );
  }
}
