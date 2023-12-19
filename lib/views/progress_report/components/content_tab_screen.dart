import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/backend/my_learning/my_learning_controller.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/progress_report/data_model/parent_data_dto.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:provider/provider.dart';

import '../../../backend/progress_report/progress_report_controller.dart';
import '../../../backend/progress_report/progress_report_provider.dart';
import '../../../configs/app_configurations.dart';
import '../../../models/progress_report/data_model/consolidated_group_dto.dart';
import '../../../models/progress_report/request_model/my_progress_report_request_model.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/modal_progress_hud.dart';

class ContentTabScreen extends StatefulWidget {
  final int componentId;
  final int componentInsId;

  const ContentTabScreen({super.key, required this.componentId, required this.componentInsId});

  @override
  State<ContentTabScreen> createState() => _ContentTabScreenState();
}

class _ContentTabScreenState extends State<ContentTabScreen> with MySafeState {
  late ThemeData themeData;
  late ProgressReportController progressReportController;
  late ProgressReportProvider progressReportProvider;
  List<String> dropdownItems = ['All', 'Not Started', 'Completed', 'In Progress', "Registered"];
  String selectedValue = 'All';

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
    super.pageBuild();
    themeData = Theme.of(context);
    return RefreshIndicator(
      onRefresh: () async {
        getData();
      },
      child: Consumer(
        builder: (context, ProgressReportProvider progressReportProvider, _) {
          if (progressReportProvider.isLoadingMyProgressReportData.get()) {
            return const CommonLoader();
          } else if (progressReportProvider.consolidatedGroupDTO.get() == null) {
            return Center(
              child: AppConfigurations.commonNoDataView(),
            );
          }
          ConsolidatedGroupDTO? consolidatedGroupDTO = progressReportProvider.consolidatedGroupDTO.get();
          List<ParentDataDto> parentDataDtoList = consolidatedGroupDTO?.parentData ?? [];
          if (selectedValue != "All") {
            parentDataDtoList = parentDataDtoList.where((element) => element.Status == selectedValue).toList();
          }
          return ModalProgressHUD(
            inAsyncCall: progressReportProvider.isLoadingMyProgressReportData.get(),
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    getFilterDropDown(),
                    getContentList(parentDataDtoList: parentDataDtoList),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getFilterDropDown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Set border color here
        borderRadius: BorderRadius.circular(8), // Set border radius here
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        isDense: true,
        underline: const SizedBox(),
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue!;
          });
        },
        items: dropdownItems.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: themeData.textTheme.titleSmall,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget getContentList({required List<ParentDataDto> parentDataDtoList}) {
    return ListView.builder(
        itemCount: parentDataDtoList.length,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return getSingleItem(
            parentDataDto: parentDataDtoList[index],
          );
        });
  }

  Widget getSingleItem({required ParentDataDto parentDataDto, bool isChildrenWidget = false}) {
    return Container(
      margin: EdgeInsets.all(isChildrenWidget ? 0 : 10),
      padding: EdgeInsets.all(isChildrenWidget ? 0 : 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isChildrenWidget ? 0 : 5),
        boxShadow: isChildrenWidget
            ? null
            : const [
                BoxShadow(color: Colors.black12, offset: Offset(0, 1), spreadRadius: 2, blurRadius: 2),
              ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: [InstancyObjectTypes.events, InstancyObjectTypes.track].contains(parentDataDto.ObjectTypeID)
                ? null
                : () {
                    NavigationController.navigateToProgressReportDetailScreen(
                      navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
                      arguments: MyLearningContentProgressScreenNavigationArguments(
                        contentId: parentDataDto.ObjectID,
                        userId: parentDataDto.userid,
                        contentTypeId: parentDataDto.ObjectTypeID,
                        componentId: widget.componentId,
                      ),
                    );
                  },
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isChildrenWidget)
                    Divider(
                      color: Colors.grey.withOpacity(.5),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          parentDataDto.contenttype,
                          style: themeData.textTheme.bodySmall,
                        ),
                      ),
                      if (parentDataDto.childData.checkNotEmpty)
                        InkWell(
                          onTap: () {
                            parentDataDto.isChildrenWidgetVisible = !parentDataDto.isChildrenWidgetVisible;
                            mySetState();
                          },
                          child: Icon(
                            parentDataDto.isChildrenWidgetVisible ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                            color: parentDataDto.isChildrenWidgetVisible ? themeData.primaryColor : Colors.black,
                          ),
                        )
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    parentDataDto.contenttitle,
                    style: themeData.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: getTitleAndText(title: "Started", text: parentDataDto.datestarted.checkEmpty ? "N/A" : parentDataDto.datestarted)),
                      Expanded(child: getTitleAndText(title: "Completed", text: parentDataDto.datecompleted.checkEmpty ? "N/A" : parentDataDto.datecompleted)),
                      Expanded(child: getTitleAndText(title: "Status", text: parentDataDto.Status)),
                      Expanded(child: getTitleAndText(title: "Credit", text: parentDataDto.Credit)),
                    ],
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  getCertificateWidget(parentDataDto)
                ],
              ),
            ),
          ),
          if (parentDataDto.isChildrenWidgetVisible) ...getChildrenWidget(parentDataDto: parentDataDto)
        ],
      ),
    );
  }

  Widget getCertificateWidget(ParentDataDto parentDataDto) {
    if (parentDataDto.CertificateAction.checkEmpty || parentDataDto.CertificateAction == 'notearned') return const SizedBox();
    return Row(
      children: [
        CommonButton(
          onPressed: () {
            MyLearningController(provider: null).viewCompletionCertificate(
              context: context,
              contentId: parentDataDto.ObjectID,
              certificateLink: parentDataDto.CertificateAction,
            );
          },
          text: "View Certificate",
          fontColor: Colors.white,
          minWidth: 30,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        ),
      ],
    );
  }

  Iterable<Widget> getChildrenWidget({required ParentDataDto parentDataDto}) {
    return parentDataDto.childData.map((e) {
      return getSingleItem(parentDataDto: e, isChildrenWidget: true);
    });
  }

  Widget getTitleAndText({required String title, required String text}) {
    return Column(
      children: [
        Text(
          title,
          style: themeData.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          text,
          style: themeData.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
