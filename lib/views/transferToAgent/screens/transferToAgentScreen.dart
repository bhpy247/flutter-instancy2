import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/discussion_forum/screens/history_screen.dart';
import 'package:flutter_instancy_2/views/transferToAgent/screens/activeWidgetScreen.dart';

class TransferToAgent extends StatefulWidget {
  const TransferToAgent({super.key});

  @override
  State<TransferToAgent> createState() => _TransferToAgentState();
}

class _TransferToAgentState extends State<TransferToAgent> with MySafeState, SingleTickerProviderStateMixin {
  late ThemeData themeData;

  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      appBar: getAppBar(),
      body: getMainBody(),
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
                    child: Text("Active"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("History"),
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
      children: <Widget>[activeWidget(), historyWidget()],
    );
  }

  Widget activeWidget() {
    return ActiveWidgetScreen();
  }

  Widget historyWidget() {
    return AgentHistoryScreen();
  }
}
