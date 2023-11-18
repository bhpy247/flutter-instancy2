import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:provider/provider.dart';

import '../../../models/catalog/response_model/prerequisiteDetailsResponseModel.dart';
import '../../common/components/instancy_ui_actions/bottomsheet_drager.dart';

class PreRequisiteDialogueScreen extends StatefulWidget {
  final PrerequisiteDetailResponseModel prerequisiteDetailResponseModel;
  final int componentId;
  final int componentInsId;
  final String contentId;

  const PreRequisiteDialogueScreen({
    Key? key,
    required this.prerequisiteDetailResponseModel,
    this.componentId = 0,
    this.componentInsId = 0,
    required this.contentId,
  }) : super(key: key);

  @override
  State<PreRequisiteDialogueScreen> createState() => _PreRequisiteDialogueScreenState();
}

class _PreRequisiteDialogueScreenState extends State<PreRequisiteDialogueScreen> {
  late ThemeData themeData;

  late AppProvider appProvider;

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const BottomSheetDragger(),
        // const SizedBox(height: 21),
        getHeaderTextWidget(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              getContentGuidance(),
              getPrerequisiteContentList(pathsList: widget.prerequisiteDetailResponseModel.prerequisteData.table1),
            ],
          ),
        ),
      ],
    );
  }

  //region preRequisite Header Text
  Widget getHeaderTextWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      width: double.infinity,
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffDEDEDE)))),
      child: const Text(
        "Pre-requisite Content",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      ),
    );
  }

  //endregion

  //region contentView
  Widget getContentGuidance() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 18.0),
      child: Text(
        "The selected content item has the following pre-requisite content items ",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget getPrerequisiteContentList({required List<PreRequisitePathModel> pathsList}) {
    // List<PreRequisiteContentModel> table = widget.prerequisiteDetailResponseModel.prerequisteData.table;
    // List<PreRequisiteContentModel> table = widget.prerequisiteDetailResponseModel.prerequisteData.table;

    return ListView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: pathsList.length,
      itemBuilder: (BuildContext context, int index) {
        PreRequisitePathModel pathModel = pathsList[index];

        return prerequisiteComponentWidget(pathModel: pathModel, pathsList: pathsList);
      },
    );
  }

  Widget prerequisiteComponentWidget({required PreRequisitePathModel pathModel, required List<PreRequisitePathModel> pathsList}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  pathModel.pathName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: themeData.primaryColor, letterSpacing: .4),
                ),
              ),
              enrollButton(pathModel: pathModel, pathsList: pathsList)
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          ...pathModel.contents.map((PreRequisiteContentModel contentModel) {
            return Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                contentModel.name,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xff757575), fontStyle: FontStyle.italic),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget enrollButton({required PreRequisitePathModel pathModel, required List<PreRequisitePathModel> pathsList}) {
    return InkWell(
      onTap: () async {
        dynamic value = await NavigationController.navigateToPreRequisiteScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: PreRequisiteScreenNavigationArguments(
            contentId: widget.contentId,
            componentId: widget.componentId,
            componentInstanceId: widget.componentInsId,
            selectedSequencePathId: pathModel.preRequisiteSequncePathID,
            sequencePathIdsList: pathsList.map((e) => e.preRequisiteSequncePathID).toList(),
          ),
        );

        Navigator.pop(context, value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 4),
        decoration: BoxDecoration(
          color: themeData.primaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          "View Prerequisites",
          style: themeData.textTheme.labelMedium?.copyWith(
            color: themeData.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
//endregion
}
