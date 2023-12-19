import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/progress_report/progress_report_controller.dart';
import 'package:flutter_instancy_2/backend/progress_report/progress_report_provider.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/progress_report/components/content_tab_screen.dart';
import 'package:flutter_instancy_2/views/progress_report/components/summary_tab_screen.dart';
import 'package:provider/provider.dart';

import '../../../backend/navigation/navigation_arguments.dart';
import '../../../models/progress_report/request_model/my_progress_report_request_model.dart';

class ProgressReportMainScreen extends StatefulWidget {
  static const String routeName = "/progressReportMainScreen";
  final ProgressReportMainScreenNavigationArguments arguments;

  const ProgressReportMainScreen({super.key, required this.arguments});

  @override
  State<ProgressReportMainScreen> createState() => _ProgressReportMainScreenState();
}

class _ProgressReportMainScreenState extends State<ProgressReportMainScreen> with SingleTickerProviderStateMixin, MySafeState {
  TabController? controller;

  late ProgressReportController progressReportController;
  late ProgressReportProvider progressReportProvider;

  void getData({bool isNotify = true}) async {
    await progressReportController.getMyProgressReportData(
      requestModel: MyProgressReportRequestModel(
        aintComponentID: widget.arguments.componentId,
        aintCompInsID: widget.arguments.componentInsId,
      ),
      isNotify: isNotify,
    );
  }

  @override
  void initState() {
    super.initState();
    progressReportProvider = context.read<ProgressReportProvider>();
    progressReportController = ProgressReportController(progressReportProvider: progressReportProvider);
    controller = TabController(vsync: this, length: 2);
    // if (progressReportProvider.consolidatedGroupDTO.get() == null) {
    getData(isNotify: false);
    // }
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.5), width: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TabBar(
                    controller: controller,
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    labelPadding: const EdgeInsets.only(bottom: 1, left: 8, right: 8),
                    indicatorPadding: const EdgeInsets.only(top: 44),
                    indicator: BoxDecoration(color: themeData.primaryColor, borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
                    indicatorSize: TabBarIndicatorSize.label,
                    labelStyle: themeData.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, letterSpacing: 1.1),
                    tabs: const [
                      Tab(
                        text: "Summary",
                      ),
                      Tab(
                        text: "Content",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          SummaryTabScreen(
            componentId: widget.arguments.componentId,
            componentInsId: widget.arguments.componentInsId,
          ),
          ContentTabScreen(
            componentId: widget.arguments.componentId,
            componentInsId: widget.arguments.componentInsId,
          ),
        ],
      ),
    );
  }
}
