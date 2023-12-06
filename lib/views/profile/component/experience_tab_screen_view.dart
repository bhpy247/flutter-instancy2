import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/app_theme/style.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/models/profile/data_model/user_experience_data_model.dart';
import 'package:provider/provider.dart';

import '../../common/components/common_button.dart';

class ExperienceTabScreenView extends StatefulWidget {
  final List<UserExperienceDataModel> experienceData;
  final bool showAdd;
  final bool showEdit;
  final void Function() onAddEditData;

  const ExperienceTabScreenView({
    Key? key,
    required this.experienceData,
    required this.showAdd,
    required this.showEdit,
    required this.onAddEditData,
  }) : super(key: key);

  @override
  State<ExperienceTabScreenView> createState() => _ExperienceTabScreenViewState();
}

class _ExperienceTabScreenViewState extends State<ExperienceTabScreenView> {
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

    return SingleChildScrollView(
      child: Column(
        children: [
          addExperienceButton(),
          getExperienceListWidget(experienceData: widget.experienceData),
          getAddExperienceButton(),
        ],
      ),
    );
  }

  Widget addExperienceButton() {
    if (!widget.showAdd || widget.experienceData.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.fromLTRB(17, 24, 17, 0),
      child: InkWell(
        onTap: () async {
          dynamic value = await NavigationController.navigateToAddEditExperienceScreen(
            navigationOperationParameters: NavigationOperationParameters(
              context: context,
              navigationType: NavigationType.pushNamed,
            ),
            arguments: const AddEditExperienceScreenNavigationArguments(),
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
              "Add Experience",
              style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
            )
          ],
        ),
      ),
    );
  }

  Widget getExperienceListWidget({required List<UserExperienceDataModel> experienceData}) {
    if(experienceData.isEmpty) {
      return SizedBox(
        height: 70,
        child: Center(
          // child: Text("No Education Data Available"),
          child: Text(appProvider.localStr.profileLabelExperienceNotAvailable),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(17, 24, 17, 17),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: experienceData.length,
      itemBuilder: (BuildContext context, int index) {
        return getExperienceCard(userExperienceDataModel: experienceData[index]);
      },
    );
  }

  Widget getExperienceCard({required UserExperienceDataModel userExperienceDataModel}) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 17),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(4), boxShadow: [BoxShadow(color: Colors.black26.withOpacity(0.2), blurRadius: 4)]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // "Front - End Developer",
                  userExperienceDataModel.title,
                  style: themeData.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 5),
                Text(
                  // "IBM",
                  userExperienceDataModel.companyname,
                  style: themeData.textTheme.labelLarge?.copyWith(
                    color: Styles.lightTextColor2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "${userExperienceDataModel.fromdate} - ${userExperienceDataModel.todate.isNotEmpty ? userExperienceDataModel.todate : "Present"}",
                  style: themeData.textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          if (widget.showEdit)
            InkWell(
              onTap: () async {
                dynamic value = await NavigationController.navigateToAddEditExperienceScreen(
                  navigationOperationParameters: NavigationOperationParameters(
                    context: context,
                    navigationType: NavigationType.pushNamed,
                  ),
                  arguments: AddEditExperienceScreenNavigationArguments(
                    userExperienceDataModel: userExperienceDataModel,
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

  Widget getAddExperienceButton() {
    if (!widget.showEdit || widget.experienceData.isNotEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0).copyWith(bottom: 17),
      child: CommonButton(
        onPressed: () async {
          dynamic value = await NavigationController.navigateToAddEditExperienceScreen(
            navigationOperationParameters: NavigationOperationParameters(
              context: context,
              navigationType: NavigationType.pushNamed,
            ),
            arguments: const AddEditExperienceScreenNavigationArguments(),
          );

          if (value == true) {
            widget.onAddEditData();
          }
        },
        backGroundColor: themeData.primaryColor,
        minWidth: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        text: "Add Experience",
        fontColor: themeData.colorScheme.onPrimary,
      ),
    );
  }
}
