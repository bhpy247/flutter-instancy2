import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_controller.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_arguments.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/common_save_exit_button_row.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/co_create_knowledge/co_create_knowledge_provider.dart';
import '../../../backend/navigation/navigation_controller.dart';
import '../../../backend/navigation/navigation_operation_parameters.dart';
import '../../../backend/navigation/navigation_type.dart';
import '../../../configs/app_configurations.dart';
import '../../../models/co_create_knowledge/co_create_content_authoring_model.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/modal_progress_hud.dart';

class CreateUrlScreen extends StatefulWidget {
  static const String routeName = "/CreateDocumentContentScreen";
  final CreateUrlScreenNavigationArguments argument;

  const CreateUrlScreen({super.key, required this.argument});

  @override
  State<CreateUrlScreen> createState() => _CreateUrlScreenState();
}

class _CreateUrlScreenState extends State<CreateUrlScreen> with MySafeState {
  bool isLoading = false;

  late CoCreateKnowledgeProvider coCreateKnowledgeProvider;
  late CoCreateKnowledgeController coCreateKnowledgeController;

  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  TextEditingController websiteUrlController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void initialize() {
    coCreateKnowledgeProvider = context.read<CoCreateKnowledgeProvider>();
    coCreateKnowledgeController = CoCreateKnowledgeController(coCreateKnowledgeProvider: coCreateKnowledgeProvider);

    coCreateContentAuthoringModel = widget.argument.coCreateContentAuthoringModel ??
        CoCreateContentAuthoringModel(
          coCreateAuthoringType: CoCreateAuthoringType.Create,
          contentTypeId: InstancyObjectTypes.referenceUrl,
        );

    if (coCreateContentAuthoringModel.courseDTOModel != null) {
      CourseDTOModel courseDTOModel = coCreateContentAuthoringModel.courseDTOModel!;

      coCreateKnowledgeController.initializeCoCreateContentAuthoringModelFromCourseDTOModel(courseDTOModel: courseDTOModel, coCreateContentAuthoringModel: coCreateContentAuthoringModel);

      websiteUrlController.text = coCreateContentAuthoringModel.referenceUrl ?? "";
    }
  }

  Future<void> onNextTap() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    coCreateContentAuthoringModel.referenceUrl = websiteUrlController.text;
    MyPrint.printOnConsole("Reference Url Value while navigation:${coCreateContentAuthoringModel.referenceUrl}");

    dynamic value = await NavigationController.navigateCommonCreateAuthoringToolScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      argument: CommonCreateAuthoringToolScreenArgument(
        componentId: widget.argument.componentId,
        componentInsId: widget.argument.componentInsId,
        coCreateAuthoringType: coCreateContentAuthoringModel.coCreateAuthoringType,
        objectTypeId: coCreateContentAuthoringModel.contentTypeId,
        mediaTypeId: coCreateContentAuthoringModel.mediaTypeId,
        coCreateContentAuthoringModel: coCreateContentAuthoringModel,
      ),
    );
    /*dynamic value = await NavigationController.navigateToAddEditReferenceLinkScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      argument: AddEditReferenceScreenArguments(coCreateContentAuthoringModel: coCreateContentAuthoringModel),
    );*/

    if (value == true) {
      Navigator.pop(context, true);
    }
  }

  Future<CourseDTOModel?> saveReferenceLink() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("AddEditDocumentsScreen().saveDocument() called", tag: tag);

    isLoading = true;
    mySetState();

    coCreateContentAuthoringModel.referenceUrl = websiteUrlController.text;

    String? contentId = await coCreateKnowledgeController.addEditContentItem(coCreateContentAuthoringModel: coCreateContentAuthoringModel);
    MyPrint.printOnConsole("contentId:'$contentId'", tag: tag);

    isLoading = false;
    mySetState();

    if (contentId.checkEmpty) {
      MyPrint.printOnConsole("Returning from AddEditEventScreen().saveEvent() because contentId is null or empty", tag: tag);
      return null;
    }

    CourseDTOModel? courseDTOModel = coCreateContentAuthoringModel.courseDTOModel ?? coCreateContentAuthoringModel.newCurrentCourseDTOModel;

    return courseDTOModel;
  }

  Future<void> onSaveAndExitTap() async {
    CourseDTOModel? courseDTOModel = await saveReferenceLink();

    if (courseDTOModel == null) {
      return;
    }

    Navigator.pop(context, true);
  }

  Future<void> onSaveAndViewTap() async {
    CourseDTOModel? courseDTOModel = await saveReferenceLink();

    if (courseDTOModel == null) {
      return;
    }

    await NavigationController.navigateToWebViewScreen(
      navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
      arguments: WebViewScreenNavigationArguments(
        title: coCreateContentAuthoringModel.title,
        url: coCreateContentAuthoringModel.referenceUrl ?? "",
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    websiteUrlController.text = widget.argument.coCreateContentAuthoringModel?.referenceUrl ??
        widget.argument.coCreateContentAuthoringModel?.courseDTOModel?.ViewLink ??
        "https://smartbridge.com/introduction-generative-ai-transformative-potential-enterprises/";

    initialize();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return PopScope(
      canPop: !isLoading,
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          appBar: AppConfigurations().commonAppBar(
            title: coCreateContentAuthoringModel.isEdit ? "Edit Reference Link" : "Create Reference Link",
          ),
          body: getMainBody(),
        ),
      ),
    );
  }

  Widget getMainBody() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            getWebsiteUrlTextFormField(),
            const Spacer(),
            getPrimaryButtonWidget(),
          ],
        ),
      ),
    );
  }

  //region getWebsiteUrlTextFormField
  Widget getWebsiteUrlTextFormField() {
    return getTexFormField(
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return "Please enter website url";
        }
        if (!Uri.parse(val).isAbsolute) {
          return "Please enter valid url";
        }
        return null;
      },
      isMandatory: true,
      controller: websiteUrlController,
      labelText: "Add URL",
    );
  }

  //endregion

  Widget getPrimaryButtonWidget() {
    if (coCreateContentAuthoringModel.isEdit) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: CommonSaveExitButtonRow(
          onSaveAndExitPressed: onSaveAndExitTap,
          onSaveAndViewPressed: onSaveAndViewTap,
        ),
      );
    } else {
      return CommonButton(
        minWidth: double.infinity,
        fontColor: themeData.colorScheme.onPrimary,
        fontSize: 15,
        onPressed: () {
          onNextTap();
        },
        text: "Next",
      );
    }
  }

  //region textFieldView
  Widget getTexFormField(
      {TextEditingController? controller,
      String iconUrl = "",
      String? Function(String?)? validator,
      String labelText = "Label",
      Widget? suffixWidget,
      required bool isMandatory,
      int? minLines,
      int? maxLines,
      double iconHeight = 15,
      double iconWidth = 15}) {
    return CommonTextFormFieldWithLabel(
      controller: controller,
      label: isMandatory ? labelWithStar(labelText) : null,
      labelText: isMandatory ? null : labelText,
      validator: validator,
      minLines: minLines,
      maxLines: maxLines,
      isOutlineInputBorder: true,
      prefixWidget: iconUrl.isNotEmpty
          ? getImageView(url: iconUrl, height: iconHeight, width: iconWidth)
          : const Icon(
              FontAwesomeIcons.globe,
              size: 15,
              color: Colors.grey,
            ),
      suffixWidget: suffixWidget,
    );
  }

  Widget getImageView({String url = "assets/addContentLogo.png", double height = 159, double width = 135}) {
    return Image.asset(
      url,
      height: height,
      width: width,
    );
  }

  Widget labelWithStar(String labelText, {TextStyle? style}) {
    return RichText(
      text: TextSpan(
        text: labelText,
        style: style ?? const TextStyle(color: Colors.grey),
        children: const [
          TextSpan(
              text: ' *',
              style: TextStyle(
                color: Colors.red,
              ))
        ],
      ),
    );
  }
//endregion
}
