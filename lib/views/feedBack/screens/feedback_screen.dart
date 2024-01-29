import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/view/common/components/common_loader.dart';
import 'package:flutter_instancy_2/backend/feedback/feedback_controller.dart';
import 'package:flutter_instancy_2/backend/feedback/feedback_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/models/feedback/data_model/feedback_dto_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../backend/main_screen/main_screen_provider.dart';
import '../../../utils/date_representation.dart';
import '../../../utils/my_safe_state.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/common_cached_network_image.dart';
import '../../common/components/modal_progress_hud.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> with MySafeState {
  bool isLoading = false;
  late FeedbackProvider feedbackProvider;
  late FeedbackController feedbackController;

  Future<void> getFeedbackData() async {
    await feedbackController.getFeedbackList(viewAll: true);
  }

  @override
  void initState() {
    super.initState();
    feedbackProvider = context.read<FeedbackProvider>();
    feedbackController = FeedbackController(feedbackProvider: feedbackProvider);
    getFeedbackData();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FeedbackProvider>.value(value: feedbackProvider),
      ],
      child: Consumer2<FeedbackProvider, MainScreenProvider>(
        builder: (context, FeedbackProvider discussionProvider, MainScreenProvider mainScreenProvider, _) {
          return RefreshIndicator(
            onRefresh: () async {
              getFeedbackData();
            },
            child: Scaffold(
              floatingActionButton: Padding(
                padding: EdgeInsets.only(
                  bottom: mainScreenProvider.isChatBotButtonEnabled.get() && !mainScreenProvider.isChatBotButtonCenterDocked.get() ? 70 : 0,
                ),
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  child: const Icon(Icons.add),
                  onPressed: () async {
                    bool? value = await NavigationController.navigateToAddFeedbackScreen(
                      navigationOperationParameters: NavigationOperationParameters(
                        context: context,
                        navigationType: NavigationType.pushNamed,
                      ),
                    );
                    if (value == null || !value) return;

                    getFeedbackData();
                  },
                ),
              ),
              body: ModalProgressHUD(
                  inAsyncCall: isLoading,
                  child: getMainWidget(
                    feedbackList: feedbackProvider.feedbackList.getList(),
                  )),
            ),
          );
        },
      ),
    );
  }

  Widget getMainWidget({List<FeedbackDtoModel> feedbackList = const []}) {
    if (feedbackProvider.isLoadingFeedbacks.get()) {
      return const CommonLoader();
    }

    if (feedbackProvider.feedbackList.getList().checkEmpty) {
      return Center(child: AppConfigurations.commonNoDataView());
    }

    return ListView.builder(
      itemCount: feedbackList.length,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        FeedbackDtoModel model = feedbackList[index];
        return getFeedbackSingleItem(model: model);
      },
    );
  }

  Widget getFeedbackSingleItem({required FeedbackDtoModel model}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileView(model: model),
              const SizedBox(
                height: 9,
              ),
              Text(
                model.titlename,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 9,
              ),
              if (model.imagepath.checkNotEmpty) ...[
                imageWidget(
                  url: model.imagepath,
                  isProfile: false,
                  height: 50,
                  width: 80,
                ),
                const SizedBox(
                  height: 9,
                ),
              ],
              Text(model.desc),
            ],
          ),
        ),
        const Divider(
          height: 1,
          thickness: .5,
        )
        // Text(model.titlename),
      ],
    );
  }

  Widget profileView({required FeedbackDtoModel model}) {
    // MyPrint.printOnConsole('profileImageUrl:$profileImageUrl');

    return Row(
      children: [
        imageWidget(url: model.UserProfilePathdata),
        // Container(
        //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(color: Colors.black)),
        //   child: ClipRRect(
        //     borderRadius: BorderRadius.circular(50),
        //     child: CommonCachedNetworkImage(
        //       // imageUrl: "https://picsum.photos/200/300",
        //       imageUrl: profileImageUrl,
        //       // imageUrl: imageUrl,
        //       height: 30,
        //       width: 30,
        //       fit: BoxFit.cover,
        //       errorIconSize: 30,
        //     ),
        //   ),
        // ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.UserDisplayName,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      DatePresentation.getFormattedDate(dateFormat: "dd/MM/yy", dateTime: DateFormat("MM/dd/yyyy hh:mm:ss a").parse(model.date)) ?? "",
                      style: const TextStyle(color: Color(0xff858585), fontSize: 10),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),

        InkWell(
            onTap: () async {
              await feedbackController.deleteFeedback(id: model.ID, context: context);
              getFeedbackData();
            },
            child: const Icon(
              FontAwesomeIcons.trash,
              size: 15,
            ))
      ],
    );
  }

  Widget imageWidget({required String url, bool isProfile = true, double height = 30, double width = 30}) {
    String profileImageUrl = MyUtils.getSecureUrl(
      AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(
        imagePath: url,
      ),
    );
    return InkWell(
      onTap: () {
        NavigationController.navigateToCommonViewImageScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: CommonViewImageScreenNavigationArguments(
            imageUrl: profileImageUrl,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: isProfile ? BorderRadius.circular(50) : BorderRadius.zero,
          border: isProfile ? Border.all(color: Colors.black) : null,
        ),
        child: ClipRRect(
          borderRadius: isProfile ? BorderRadius.circular(50) : BorderRadius.zero,
          child: CommonCachedNetworkImage(
            // imageUrl: "https://picsum.photos/200/300",
            imageUrl: profileImageUrl,
            // imageUrl: imageUrl,
            height: height,
            width: width,
            fit: BoxFit.cover,
            errorIconSize: 30,
          ),
        ),
      ),
    );
  }
}
