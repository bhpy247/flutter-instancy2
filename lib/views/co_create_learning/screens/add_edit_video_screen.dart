import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';

import '../../../configs/app_configurations.dart';

class AddEditVideoScreen extends StatefulWidget {
  static const String routeName = "/AddEditVideoScreen";
  final AddEditVideoScreenArgument arguments;

  const AddEditVideoScreen({super.key, required this.arguments});

  @override
  State<AddEditVideoScreen> createState() => _AddEditVideoScreenState();
}

class _AddEditVideoScreenState extends State<AddEditVideoScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppConfigurations().commonAppBar(
          title: "Video",
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                getCommonTextContainer(
                  text: "Record Video",
                  onTap: () {
                    NavigationController.navigateToRecordVideoScreen(
                      navigationOperationParameters: NavigationOperationParameters(
                        context: context,
                        navigationType: NavigationType.pushNamed,
                      ),
                      argument: const AddEditVideoScreenArgument(isUploadScreen: false),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                getCommonTextContainer(
                    text: "Upload Video",
                    onTap: () {
                      NavigationController.navigateToRecordVideoScreen(
                        navigationOperationParameters: NavigationOperationParameters(
                          context: context,
                          navigationType: NavigationType.pushNamed,
                        ),
                        argument: const AddEditVideoScreenArgument(isUploadScreen: true),
                      );
                    }),
                const SizedBox(
                  height: 20,
                ),
                getCommonTextContainer(
                    text: "Generate with AI",
                    onTap: () {
                      NavigationController.navigateToCreateManuallyVideoScreen(
                        navigationOperationParameters: NavigationOperationParameters(
                          context: context,
                          navigationType: NavigationType.pushNamed,
                        ),
                        argument: const AddEditVideoScreenArgument(isUploadScreen: true),
                      );
                    }),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getCommonTextContainer({
    required String text,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 50),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            const BoxShadow(
              color: Colors.black26,
              offset: Offset(1, 3),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
