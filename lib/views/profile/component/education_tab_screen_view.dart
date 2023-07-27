import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/profile/profile_provider.dart';
import 'package:flutter_instancy_2/models/profile/data_model/user_education_data_model.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/navigation/navigation.dart';
import '../../common/components/common_button.dart';

class EducationTabScreenView extends StatefulWidget {
  final List<UserEducationDataModel> educationData;
  final bool showAdd;
  final bool showEdit;
  final void Function() onAddEditData;
  final ProfileProvider profileProvider;

  const EducationTabScreenView({
    Key? key,
    required this.educationData,
    required this.showAdd,
    required this.showEdit,
    required this.onAddEditData,
    required this.profileProvider,
  }) : super(key: key);

  @override
  State<EducationTabScreenView> createState() => _EducationTabScreenViewState();
}

class _EducationTabScreenViewState extends State<EducationTabScreenView> {
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
    return getMainWidget();
  }

  //region getMainWidget
  Widget getMainWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          addEducationButton(),
          getEducationListWidget(educationData: widget.educationData),
          getAddEducationButton(),
        ],
      ),
    );
  }

  //endregion

  Widget addEducationButton() {
  if(!widget.showAdd || widget.educationData.isEmpty)return const SizedBox();

    return Padding(
      padding: const EdgeInsets.fromLTRB(17, 24, 17, 0),
      child: InkWell(
        onTap: () async {
          dynamic value = await NavigationController.navigateToAddEducationScreen(
            navigationOperationParameters: NavigationOperationParameters(
              context: context,
              navigationType: NavigationType.pushNamed,
            ),
            arguments: AddEducationScreenNavigationArguments(
              profileProvider: widget.profileProvider,
            ),
          );

          if (value == true) {
            widget.onAddEditData();
          }
          // widget.onEditing(widget.isEditingEnabled);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(
              Icons.edit,
              size: 18,
            ),
            const SizedBox(
              width: 2,
            ),
            Text(
              "Add Education",
              style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
            )
          ],
        ),
      ),
    );
  }

  //region getEducationListWidget
  Widget getEducationListWidget({required List<UserEducationDataModel> educationData}) {
    if(educationData.isEmpty) {
      return SizedBox(
        height: 70,
        child: Center(
          // child: Text("No Education Data Available"),
          child: Text(appProvider.localStr.profileLabelEducationNotAvailable),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(17, 24, 17, 17),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: educationData.length,
      itemBuilder: (BuildContext context, int index) {
        return getEducationData(educationDataModel: educationData[index]);
      },
    );
  }

  Widget getEducationData({required UserEducationDataModel educationDataModel}) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 17),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), boxShadow: [BoxShadow(color: Colors.black26.withOpacity(0.2), blurRadius: 4)]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  educationDataModel.school,
                  style: themeData.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  educationDataModel.titleeducation,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  educationDataModel.totalperiod,
                  style: themeData.textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          if(widget.showEdit) InkWell(
            onTap: () async {
              dynamic value = await NavigationController.navigateToAddEducationScreen(
                navigationOperationParameters: NavigationOperationParameters(
                  context: context,
                  navigationType: NavigationType.pushNamed,
                ),
                arguments: AddEducationScreenNavigationArguments(
                  userEducationDataModel: educationDataModel,
                  profileProvider: widget.profileProvider,
                ),
              );

              if (value == true) {
                widget.onAddEditData();
              }
            },
            child: const Icon(
              Icons.edit,
              size: 20,
            ),
          )
        ],
      ),
    );
  }

  //endregion

  //region saveChangesButton
  Widget getAddEducationButton() {
    if(!widget.showEdit||widget.educationData.isNotEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0).copyWith(bottom: 17),
      child: CommonButton(
        onPressed: () async {
          dynamic value = await NavigationController.navigateToAddEducationScreen(
            navigationOperationParameters: NavigationOperationParameters(
              context: context,
              navigationType: NavigationType.pushNamed,
            ),
            arguments: AddEducationScreenNavigationArguments(
              profileProvider: widget.profileProvider,
            ),
          );

          if (value == true) {
            widget.onAddEditData();
          }
        },
        backGroundColor: themeData.primaryColor,
        minWidth: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Text(
          "Add Education",
          style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
//endregion
}
