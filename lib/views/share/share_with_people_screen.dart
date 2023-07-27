import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/share/share_controller.dart';
import 'package:flutter_instancy_2/backend/share/share_provider.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../../backend/app/app_provider.dart';
import '../../backend/authentication/authentication_provider.dart';
import '../../backend/navigation/navigation.dart';
import '../../configs/app_constants.dart';
import '../../utils/my_toast.dart';
import '../common/components/common_button.dart';

class ShareWithPeopleScreen extends StatefulWidget {
  static const String routeName = "/ShareWithPeopleScreen";

  final ShareWithPeopleScreenNavigationArguments arguments;

  const ShareWithPeopleScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<ShareWithPeopleScreen> createState() => _ShareWithPeopleScreenState();
}

class _ShareWithPeopleScreenState extends State<ShareWithPeopleScreen> with MySafeState {
  late ThemeData themeData;

  bool isLoading = false;

  late AppProvider appProvider;
  late ShareProvider shareProvider;
  late ShareController shareController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController toEmailsController = TextEditingController();
  late TextEditingController subjectController;
  late TextEditingController messageToController;

  bool isShareWithEmailIds = true;
  List<int> userIds = <int>[];

  @override
  void initState() {
    super.initState();

    appProvider = context.read<AppProvider>();
    shareProvider = /*widget.arguments.shareProvider ?? */ShareProvider();
    shareController = ShareController(shareProvider: shareProvider);

    String contentName = widget.arguments.contentName;

    isShareWithEmailIds = !widget.arguments.isSuggestToConnections || widget.arguments.userIds.checkEmpty;
    userIds = widget.arguments.userIds ?? <int>[];

    String siteUrl = shareController.shareRepository.apiController.apiDataProvider.getCurrentSiteUrl();
    if(siteUrl.endsWith("/")) {
      siteUrl = siteUrl.substring(0, siteUrl.length - 1);
    }
    if(siteUrl.startsWith("http://")) {
      siteUrl = siteUrl.replaceFirst("http://", "https://");
    }

    String message = "";
    switch(widget.arguments.shareContentType) {
      case ShareContentType.discussionForum: {
        message = "I thought you might be interested in seeing this. Make sure you take a look at my comments and the New Video that is on your "
            "YouTube site! \n\nContent Name: $contentName. \n\n "
            "Content Link: $siteUrl/ForumID/${widget.arguments.contentId}/TopicId/$contentName";
        break;
      }
      case ShareContentType.askTheExpertQuestion: {
        message = "I thought you might be interested in seeing this. Make sure you take a look at my comments and the New Video that is on your "
            "YouTube site! \n\nContent Name: $contentName. \n\n "
            "Content Link: $siteUrl/User-Questions-List/QuestionID/${widget.arguments.contentId}";
        break;
      }
      case ShareContentType.catalogCourse: {
        message = "I thought you might be interested in seeing this. Make sure you take a look at my comments and the New Video that is on your "
            "YouTube site! \n\nContent Name: $contentName. \n\n "
            "Content Link: $siteUrl/InviteURLID/contentId/${widget.arguments.contentId}/ComponentId/1.";
        break;
      }
    }
    AuthenticationProvider authenticationProvider = Provider.of<AuthenticationProvider>(context, listen: false);

    String name = authenticationProvider.getSuccessfulUserLoginModel()?.username ?? "";

    messageToController = TextEditingController(text: message);
    subjectController = TextEditingController(text: "${name} Has Shared Content with You");
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    super.pageBuild();

    // var smallestDimension = MediaQuery.of(context).size.shortestSide;
    // final useMobileLayout = smallestDimension < 600;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: getAppbar(),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  getToEmailTextField(),
                  getSubjectTextField(),
                  getMessageTextField(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: getBottomBarButtonsRow(),
      ),
    );
  }

  PreferredSizeWidget? getAppbar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        isShareWithEmailIds ? "Share with People" : "Share with Connections",
        style: themeData.textTheme.titleLarge?.copyWith(
          color: themeData.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8
        ),
      ),
      elevation: 0,
      backgroundColor: themeData.primaryColor,
      iconTheme: themeData.iconTheme.copyWith(
        color: themeData.colorScheme.onPrimary,
      ),
    );
  }

  Widget getToEmailTextField() {
    if(!isShareWithEmailIds) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person, size: 24,),
              const SizedBox(width: 10,),
              Text(
                "Recipients",
                style: themeData.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          CommonTextFormField(
            controller: toEmailsController,
            isOutlineInputBorder: true,
            maxLines: 3,
            minLines: 2,
            hintText: "Enter email addresses separated by a comma(,) and no spaces",
            textStyle: themeData.textTheme.labelMedium,
            borderRadius: 5,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            validator: (String? text) {
              if((text?.trim()).checkEmpty) {
                return "Recipients email address cannot be empty";
              }

              List<String> emails = AppConfigurationOperations.getListFromSeparatorJoinedString(parameterString: text!.trim(), separator: ',');

              if(emails.isEmpty) {
                return "Emails has to be comma separated";
              }

              for (String value in emails) {
                bool isValid = AppConfigurationOperations.isValidEmailString(value);
                if(!isValid) {
                  return "Invalid Emails";
                }
              }

              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget getSubjectTextField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset("assets/subject.png", height: 17,width: 17,),
              // const Icon(Icons.subject, size: 24,),
              const SizedBox(width: 10,),
              Text(
                "Subject",
                style: themeData.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          CommonTextFormField(
            controller: subjectController,
            isOutlineInputBorder: true,
            hintText: "Subject",
            borderRadius: 5,
            maxLines: 3,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            textStyle: themeData.textTheme.labelMedium,
            validator: (String? text) {
              if(text.checkEmpty) {
                return "Subject cannot be empty";
              }
              else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget getMessageTextField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset("assets/message.png", height: 17,width: 17,),
              const SizedBox(width: 10,),
              Text(
                "Message",
                style: themeData.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          CommonTextFormField(
            controller: messageToController,
            isOutlineInputBorder: true,
            hintText: "Message",
            borderRadius: 5,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            textStyle: themeData.textTheme.labelMedium,
            minLines: 5,
            maxLines: null,
            // maxLines: 10,
            validator: (String? text) {
              if(text.checkEmpty) {
                return "Message cannot be empty";
              }
              else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget? getBottomBarButtonsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: CommonButton(
              onPressed: () {
                Navigator.pop(context);
              },
              backGroundColor: Colors.white,
              borderColor: themeData.primaryColor,
              fontColor: themeData.primaryColor,
              fontWeight: FontWeight.w600,
              // isPrimary: false,
              text: "Cancel",
            ),
          ),
          const SizedBox(width: 25,),
          Expanded(
            flex: 3,
            child: CommonButton(
              onPressed: () async {
                if(_formKey.currentState?.validate() ?? false) {
                  isLoading = true;
                  mySetState();

                  bool isShared;
                  if(isShareWithEmailIds) {
                    isShared = await shareController.shareWithPeople(
                      userMails: AppConfigurationOperations.getListFromSeparatorJoinedString(parameterString: toEmailsController.text.trim()),
                      subject: subjectController.text.trim(),
                      message: messageToController.text.trim(),
                      contentId: widget.arguments.contentId,
                    );
                  }
                  else {
                    isShared = await shareController.shareWithConnections(
                      userIDList: userIds,
                      subject: subjectController.text.trim(),
                      message: messageToController.text.trim(),
                      contentId: widget.arguments.contentId,
                    );
                  }

                  isLoading = false;
                  mySetState();

                  if(isShared && pageMounted && context.mounted) {
                    MyToast.showSuccess(context: context, msg: "Email successfully sent");
                    if(!isShareWithEmailIds) Navigator.pop(context);
                    Navigator.pop(context);
                  }
                }
              },
              backGroundColor: themeData.primaryColor,
              borderColor: themeData.primaryColor,
              fontColor: Colors.white,
              fontWeight: FontWeight.w600,
              // isPrimary: true,
              text: "Share",
            ),
          ),
        ],
      ),
    );
  }
}
