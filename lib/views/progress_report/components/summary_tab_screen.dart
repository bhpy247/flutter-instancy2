import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/view/common/components/common_loader.dart';
import 'package:flutter_chat_bot/view/common/components/modal_progress_hud.dart';
import 'package:flutter_instancy_2/models/progress_report/data_model/consolidated_group_dto.dart';
import 'package:flutter_instancy_2/models/progress_report/data_model/overall_score_dto.dart';
import 'package:flutter_instancy_2/models/progress_report/data_model/parent_data_dto.dart';
import 'package:flutter_instancy_2/models/progress_report/request_model/my_progress_report_request_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../backend/progress_report/progress_report_controller.dart';
import '../../../backend/progress_report/progress_report_provider.dart';
import '../../../configs/app_configurations.dart';
import '../../../configs/ui_configurations.dart';
import '../../../models/progress_report/data_model/credit_dto.dart';
import '../../../models/progress_report/data_model/status_count_dto.dart';

class SummaryTabScreen extends StatefulWidget {
  final int componentId;
  final int componentInsId;

  const SummaryTabScreen({super.key, required this.componentId, required this.componentInsId});

  @override
  State<SummaryTabScreen> createState() => _SummaryTabScreenState();
}

class _SummaryTabScreenState extends State<SummaryTabScreen> {
  late ThemeData themeData;
  late ProgressReportController progressReportController;
  late ProgressReportProvider progressReportProvider;

  void getData() async {
    await progressReportController.getMyProgressReportData(
      requestModel: MyProgressReportRequestModel(
        aintComponentID: widget.componentId,
        aintCompInsID: widget.componentInsId,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    progressReportProvider = context.read<ProgressReportProvider>();
    progressReportController = ProgressReportController(progressReportProvider: progressReportProvider);
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return RefreshIndicator(
      onRefresh: () async {
        getData();
      },
      child: Consumer(builder: (context, ProgressReportProvider progressReportProvider, _) {
        ConsolidatedGroupDTO? consolidatedGroupDTO = progressReportProvider.consolidatedGroupDTO.get();
        if (progressReportProvider.isLoadingMyProgressReportData.get()) {
          return const CommonLoader();
        }
        if (consolidatedGroupDTO == null) {
          return Center(
            child: AppConfigurations.commonNoDataView(),
          );
        }
        List<StatusCountDTO> statusCountDTOs = consolidatedGroupDTO.statusCountData;
        List<ScoreMaxDTO> scoreMaxDTOs = consolidatedGroupDTO.scoreMaxCount;
        List<ContentCountDTO> contentCountDTOs = consolidatedGroupDTO.contentCountData;
        List<ParentDataDto> parentDTOs = consolidatedGroupDTO.parentData;
        return ModalProgressHUD(
          inAsyncCall: progressReportProvider.isLoadingMyProgressReportData.get(),
          child: Scaffold(
              body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (contentCountDTOs.checkNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 15),
                    child: RichText(
                      text: TextSpan(
                        text: "${parentDTOs.length} ",
                        style: TextStyle(fontSize: 20, color: Color(0xff3A3A3A), fontWeight: FontWeight.bold),
                        children: const [
                          TextSpan(
                            text: "Content",
                            style: TextStyle(fontSize: 16, color: Color(0xff3A3A3A), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                _buildDefaultDoughnutChart(
                  title: "Content Types",
                  seriesList: _getContentTypeDoughnutSeries(contentCountDto: contentCountDTOs),
                ),
                getStatisticsScoreWidget(
                  scoreMaxCount: scoreMaxDTOs.firstElement,
                  score: ParsingHelper.parseDoubleMethod(
                    scoreMaxDTOs.firstElement?.ScoreMax,
                  ),
                ),
                _buildDefaultDoughnutChart(
                  title: "Status",
                  seriesList: _getStatusDoughnutSeries(statusCountDto: statusCountDTOs),
                ),
              ],
            ),
          )),
        );
      }),
    );
  }

  /// Return the circular chart with default doughnut series.
  Widget _buildDefaultDoughnutChart({String title = "", required List<DoughnutSeries<ChartSampleData, String>> seriesList}) {
    return Container(
      height: MediaQuery.of(context).size.height * .6,
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(color: Colors.black12, offset: Offset(0, 1), spreadRadius: 2, blurRadius: 2),
        ],
      ),
      child: SfCircularChart(
        title: ChartTitle(text: title, alignment: ChartAlignment.near),

        legend: const Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
          position: LegendPosition.bottom,
          iconWidth: 10,
          isResponsive: false,
          // height: "5%",
          // width: "r%",
        ),
        series: seriesList,
        // margin: EdgeInsets.all(10),
      ),
    );
  }

  List<DoughnutSeries<ChartSampleData, String>> _getStatusDoughnutSeries({required List<StatusCountDTO> statusCountDto}) {
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
          explode: true,
          explodeOffset: '10%',
          legendIconType: LegendIconType.circle,
          dataSource: statusCountDto.map((e) => ChartSampleData(x: e.status, y: ParsingHelper.parseDoubleMethod(e.ContentCount), text: "${e.ContentCount}%")).toList(),
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          dataLabelSettings: const DataLabelSettings(isVisible: true))
    ];
  }

  List<DoughnutSeries<ChartSampleData, String>> _getContentTypeDoughnutSeries({required List<ContentCountDTO> contentCountDto}) {
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
        // radius: '50%',
          explode: true,
          explodeOffset: '10%',
          legendIconType: LegendIconType.circle,
          dataSource: contentCountDto.map((e) => ChartSampleData(x: e.ContentType, y: ParsingHelper.parseDoubleMethod(e.ContentCount), text: "${e.ContentCount}%")).toList(),
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          dataLabelSettings: const DataLabelSettings(isVisible: true))
    ];
  }

  Widget getStatisticsScoreWidget({required double score, required ScoreMaxDTO? scoreMaxCount}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(color: Colors.black12, offset: Offset(0, 1), spreadRadius: 2, blurRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Average Score",
            style: themeData.textTheme.titleLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox.square(
                dimension: 150,
                child: CircularStepProgressIndicator(
                  totalSteps: 10,
                  currentStep: (score / 10).round(),
                  selectedStepSize: 20.0,
                  unselectedStepSize: 20.0,
                  selectedColor: InstancyColors.green,
                  unselectedColor: InstancyColors.grey.withAlpha(150),
                  padding: 0.04,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${score.round()}%",
                        style: themeData.textTheme.titleLarge?.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      // Text(
                      //   appProvider.localStr.myprogressreportLabelScorelabel,
                      //   style: themeData.textTheme.labelSmall,
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChartSampleData {
  String x = "";
  String text = "";
  double y = 0.0;

  ChartSampleData({this.x = "", this.text = "", this.y = 0.0});
}
