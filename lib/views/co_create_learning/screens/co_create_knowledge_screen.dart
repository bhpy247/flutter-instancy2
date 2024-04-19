import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/size_utils.dart';
import 'package:flutter_instancy_2/views/co_create_learning/screens/share_knowledge_tab.dart';

import '../component/theme_helper.dart';
import 'my_knowledge_tab.dart';

class CoCreateKnowledgeScreen extends StatefulWidget {
  static const String routeName = "/CoCreateKnowledgeScreen";

  const CoCreateKnowledgeScreen({super.key});

  @override
  State<CoCreateKnowledgeScreen> createState() => _CoCreateKnowledgeScreenState();
}

class _CoCreateKnowledgeScreenState extends State<CoCreateKnowledgeScreen> with MySafeState {
  @override
  void initState() {
    super.initState();
    ThemeHelper().changeTheme('primary');
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: getTabBarView(),
        );
      },
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
            tabs: const [
              Tab(
                // icon: Icon(Icons.library_books),
                text: 'My Knowledge',
              ),
              Tab(
                // icon: Icon(Icons.share),
                text: 'Share Knowledge',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const MyKnowledgeTab(
              componentId: 0,
              componentInstanceId: 0,
            ),
            ShareKnowledgeTab(),
          ],
        ),
      ),
    );
  }
}
