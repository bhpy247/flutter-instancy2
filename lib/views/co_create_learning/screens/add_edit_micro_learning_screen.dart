import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/configs/app_strings.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/micro_learning_model/data_model/micro_learning_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/micro_learning_model/data_model/micro_learning_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';

import '../../../backend/app_theme/style.dart';
import '../../../backend/co_create_knowledge/co_create_knowledge_provider.dart';
import '../../../backend/navigation/navigation_arguments.dart';
import '../../../backend/navigation/navigation_controller.dart';
import '../../../backend/navigation/navigation_operation_parameters.dart';
import '../../../backend/navigation/navigation_type.dart' as navigationType;
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions_constants.dart';
import '../../../configs/app_configurations.dart';
import '../../../configs/app_constants.dart';
import '../../../models/co_create_knowledge/co_create_content_authoring_model.dart';
import '../../../models/co_create_knowledge/quiz/data_models/quiz_question_model.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_border_dropdown.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../../common/components/modal_progress_hud.dart';

class AddEditMicroLearningScreen extends StatefulWidget {
  static const String routeName = "/AddEditMicroLearningScreen";

  final AddEditMicroLearningScreenNavigationArgument arguments;

  const AddEditMicroLearningScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<AddEditMicroLearningScreen> createState() => _AddEditMicroLearningScreenState();
}

class _AddEditMicroLearningScreenState extends State<AddEditMicroLearningScreen> with MySafeState {
  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;
  TextEditingController pagesController = TextEditingController();
  TextEditingController wordsPerPageController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController youtubeController = TextEditingController();
  TextEditingController internetSearchController = TextEditingController();
  TextEditingController youtubeSearchController = TextEditingController();
  bool isTextEnabled = true, isImageEnabled = true, isQuestionEnabled = true;
  PageController pageController = PageController();
  List<Widget> widgetList = [];

  bool isLoading = false;
  int selectedIndex = 0;

  String groupValue = "Large Language Model (LLM)";

  bool isForFirstTime = false;

  List<MicroLearningModel> microlearningList = [
    MicroLearningModel(
      title: "Technology in Sustainable Urban Planning",
    ),
    MicroLearningModel(title: "Components of Eco-Conscious Cities"),
    MicroLearningModel(title: "Challenges in Urban Sustainability", questionType: MicrolearningTypes.question),
    MicroLearningModel(title: "Harmonious : Sustainable Environments", questionType: MicrolearningTypes.question),
    MicroLearningModel(title: "Inspiring Action for Resilient Cities"),
  ];

  Future<void> showMoreActions({required CourseDTOModel model, int index = 0, List<InstancyUIActionModel>? actions}) async {
    InstancyUIActions().showAction(
      context: context,
      actions: actions ?? getActionsList(model: model, index: index),
    );
  }

  List<InstancyUIActionModel> getActionsList({required CourseDTOModel model, int index = 0}) {
    List<InstancyUIActionModel> actions = [
      InstancyUIActionModel(
        text: "Add Page Title",
        actionsEnum: InstancyContentActionsEnum.AddTitle,
        onTap: () {
          Navigator.pop(context);
        },
        assetIconUrl: "assets/cocreate/commonText.png",
        // iconData: InstancyIcons.,
      ),
    ];

    return actions;
  }

  List<InstancyUIActionModel> getSingleItemActionsList({required CourseDTOModel model, int index = 0}) {
    List<InstancyUIActionModel> actions = [
      InstancyUIActionModel(
        text: "Edit",
        actionsEnum: InstancyContentActionsEnum.AddTitle,
        onTap: () {
          Navigator.pop(context);
        },
        iconData: InstancyIcons.edit,
      ),
      InstancyUIActionModel(
        text: "Delete",
        actionsEnum: InstancyContentActionsEnum.Delete,
        onTap: () {
          Navigator.pop(context);
        },
        iconData: InstancyIcons.delete,
      ),
    ];

    return actions;
  }

  Future<void> onGenerateTap() async {}

  @override
  void initState() {
    super.initState();
    coCreateContentAuthoringModel = CoCreateContentAuthoringModel(
      coCreateAuthoringType: widget.arguments.coCreateContentAuthoringModel.coCreateAuthoringType,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    if (!isForFirstTime) {
      widgetList = [getPageCountAndOtherMetaDataWidget(), getSourceSelectionWidget(), getTitleListView()];
      isForFirstTime = true;
    }
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: RefreshIndicator(
          onRefresh: () async {},
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: getGenerateButton(),
            appBar: AppConfigurations().commonAppBar(
              title: coCreateContentAuthoringModel.isEdit ? "Edit Microlearning" : "Create Microlearning",
              actions: [
                if (selectedIndex + 1 == widgetList.length)
                  InkWell(
                    onTap: () {
                      showMoreActions(model: CourseDTOModel());
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Icon(Icons.more_vert),
                    ),
                  )
              ],
            ),
            body: AppUIComponents.getBackGroundBordersRounded(
              context: context,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: PageView.builder(
                  onPageChanged: (int index) {
                    selectedIndex = index;
                    mySetState();
                  },
                  controller: pageController,
                  itemCount: widgetList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return widgetList[index];
                  },
                ),
                // child: isSourceSelectionView
                //     ? isTitleList
                //         ? getTitleListView()
                //         : getSourceSelectionWidget()
                //     : getPageCountAndOtherMetaDataWidget(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getPageCountAndOtherMetaDataWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 17,
                  ),
                  getPageTextField(),

                  // getCardCountTextFormField(),
                  const SizedBox(
                    height: 17,
                  ),
                  getWordsPerPageTextField(),
                  const SizedBox(
                    height: 17,
                  ),
                  getCommonSwitchWithTextWidget(
                    text: "Text",
                    isTrue: isTextEnabled,
                    onChanged: (bool? val) => isTextEnabled = val ?? false,
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  getCommonSwitchWithTextWidget(
                    text: "Image",
                    isTrue: isImageEnabled,
                    onChanged: (bool? val) => isImageEnabled = val ?? false,
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  getCommonSwitchWithTextWidget(
                    text: "Question",
                    isTrue: isQuestionEnabled,
                    onChanged: (bool? val) => isQuestionEnabled = val ?? false,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getGenerateButton() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CommonButton(
        onPressed: () {
          onGenerateTap();
        },
        minWidth: double.infinity,
        text: AppStrings.generateWithAI,
        fontColor: themeData.colorScheme.onPrimary,
      ),
    );
  }

  Widget getPageTextField() {
    return Row(
      children: [
        Expanded(
          child: getTexFormField(
            controller: pagesController,
            keyBoardType: TextInputType.number,
            isMandatory: false,
            labelText: "#Pages",
          ),
        ),
        Expanded(
          child: Container(),
        )
      ],
    );
  }

  Widget getWordsPerPageTextField() {
    return Row(
      children: [
        Expanded(
          child: getTexFormField(
            controller: wordsPerPageController,
            keyBoardType: TextInputType.number,
            isMandatory: false,
            labelText: "#Words Per Page",
          ),
        ),
        Expanded(child: Container())
      ],
    );
  }

  Widget getCommonSwitchWithTextWidget({required String text, required bool isTrue, ValueChanged<bool?>? onChanged}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(text),
                  const SizedBox(
                    width: 30
                  ),
                  SizedBox(
                    height: 15,
                    width: 35,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: CupertinoSwitch(
                        activeColor: themeData.primaryColor,
                        value: isTrue,
                        onChanged: onChanged,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(child: Container())
      ],
    );
  }

  Widget getSourceSelectionWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: Styles.borderColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          getCommonRadioButton(
            value: "Large Language Model (LLM)",
            onChanged: (val) {
              groupValue = val ?? "";
              mySetState();
            },
          ),
          getCommonRadioButton(
              value: "YouTube",
              onChanged: (val) {
                groupValue = val ?? "";
                mySetState();
              },
              controller: youtubeController),
          getCommonRadioButton(
              value: "Website",
              onChanged: (val) {
                groupValue = val ?? "";
                mySetState();
              },
              controller: websiteController),
          getCommonRadioButton(
              value: "Internet Search",
              onChanged: (val) {
                groupValue = val ?? "";
                mySetState();
              },
              controller: internetSearchController),
          getCommonRadioButton(
            value: "YouTube Search",
            onChanged: (val) {
              groupValue = val ?? "";
              mySetState();
            },
            controller: youtubeSearchController,
          ),
        ],
      ),
    );
  }

  Widget getCommonRadioButton({required String value, ValueChanged<String?>? onChanged, bool isSubtitleTrue = false, TextEditingController? controller}) {
    return RadioListTile(
      value: value,
      groupValue: groupValue,
      onChanged: (val) {
        MyPrint.printOnConsole("value : $val");
        groupValue = val ?? "";
        mySetState();
      },
      title: Text(value),
      subtitle: value != "Large Language Model (LLM)"
          ? groupValue == value
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                  ),
                )
              : null
          : null,
    );
  }

  Widget getBottomButton() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: CommonButton(
              onPressed: () {
                pageController.jumpToPage(selectedIndex - 1);
                // isTitleList = false;
                // isTitleList == false ? isSourceSelectionView = true : isSourceSelectionView = false;
                // if (isSourceSelectionView) {
                //   isTitleList = false;
                // }
                mySetState();
              },
              text: "Previous",
              fontColor: themeData.primaryColor,
              backGroundColor: themeData.colorScheme.onPrimary,
              borderColor: themeData.primaryColor,
            ),
          ),
        ),
        // Expanded(
        //   child: isSourceSelectionView
        //       ? generatePageTitlesButton()
        //       : CommonButton(
        //           onPressed: () {
        //             isSourceSelectionView = true;
        //             mySetState();
        //           },
        //           text: "Next",
        //           fontColor: Colors.white,
        //         ),
        // ),
        Expanded(
          child: CommonButton(
            onPressed: () {
              pageController.jumpToPage(selectedIndex + 1);
              if (selectedIndex == 2) {
                microlearningList.forEach((element) {
                  MyPrint.printOnConsole("microLearningLists : ${element.questionType}");
                });
                coCreateContentAuthoringModel.microLearningContentModel = MicroLearningContentModel(microLearningModelList: microlearningList);
                NavigationController.navigateToMicrolearningTitlesScreen(
                  navigationOperationParameters: NavigationOperationParameters(
                    context: context,
                    navigationType: navigationType.NavigationType.pushNamed,
                  ),
                  argument: MicroLearningPreviewScreenNavigationArgument(
                    coCreateContentAuthoringModel: coCreateContentAuthoringModel,
                  ),
                );
              }
              mySetState();
            },
            text: selectedIndex == 1
                ? "Generate Page Titles"
                : selectedIndex == 2
                    ? "Generate with AI"
                    : "Next",
            fontColor: Colors.white,
          ),
        )
      ],
    );
  }

  Widget getTitleListView() {
    return ReorderableListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      shrinkWrap: true,
      key: GlobalKey(),
      children: List.generate(
        microlearningList.length,
        (index) {
          return ListTile(
            tileColor: Colors.grey[200],
            selectedTileColor: Colors.grey[100],
            // trailing: const Icon(
            //   FontAwesomeIcons.upDownLeftRight,
            //   size: 15,
            // ),
            key: Key("$index"),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    "${index + 1}. ${microlearningList[index].title}",
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  FontAwesomeIcons.arrowsUpDownLeftRight,
                  size: 15,
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    showMoreActions(
                      model: CourseDTOModel(),
                      actions: getSingleItemActionsList(
                        model: CourseDTOModel(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      FontAwesomeIcons.ellipsisVertical,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = microlearningList.removeAt(oldIndex);
          microlearningList.insert(newIndex, item);
        });
      },
    );
  }

  //region textFieldView
  Widget getTexFormField({
    TextEditingController? controller,
    String iconUrl = "",
    String? Function(String?)? validator,
    String labelText = "Label",
    Widget? suffixWidget,
    required bool isMandatory,
    int? minLines,
    int? maxLines,
    TextInputType? keyBoardType,
    double iconHeight = 15,
    double iconWidth = 15,
  }) {
    return CommonTextFormFieldWithLabel(
      controller: controller,
      label: isMandatory ? labelWithStar(labelText) : null,
      labelText: isMandatory ? null : labelText,
      validator: validator,
      minLines: minLines,
      maxLines: maxLines,
      isOutlineInputBorder: true,
      keyboardType: keyBoardType,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      // prefixWidget: iconUrl.isNotEmpty
      //     ? getImageView(url: iconUrl, height: iconHeight, width: iconWidth)
      //     : const Icon(
      //   FontAwesomeIcons.globe,
      //   size: 15,
      //   color: Colors.grey,
      // ),
      suffixWidget: suffixWidget,
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
            ),
          )
        ],
      ),
    );
  }
//endregion
}

class MicrolearningPreviewScreen extends StatefulWidget {
  static const String routeName = "/MicorlearningTitlesScreen";
  final MicroLearningPreviewScreenNavigationArgument arguments;

  const MicrolearningPreviewScreen({super.key, required this.arguments});

  @override
  State<MicrolearningPreviewScreen> createState() => _MicrolearningPreviewScreenState();
}

class _MicrolearningPreviewScreenState extends State<MicrolearningPreviewScreen> with MySafeState {
  double? maxHeight;

  PageController pageController = PageController();

  final HtmlEditorController controller = HtmlEditorController();

  QuizQuestionModel quizModel = QuizQuestionModel(
    question: "What is the primary goal of office ergonomics?",
    choices: [
      "A. Promote proper posture and reduce strain on the body",
      "B. Increase workload for employees",
      "C. Encourage standing desks only",
      "D. Focus on aesthetics over functionality",
    ],
    correct_choice: "A. Promote proper posture and reduce strain on the body",
    correctFeedback:
        "That's right! The main goal is to create a workspace that supports good posture and reduces physical stress. By adjusting the workspace to fit the individual needs of workers, office ergonomics promotes better health and productivity.",
    inCorrectFeedback:
        "Incorrect. Office ergonomics is about optimizing the physical setup of the workspace to reduce strain and prevent injuries, thereby improving employee comfort and performance.",
    isEditModeEnable: [false, false, false, false],
  );

  String defaultArticleScreen = """<!DOCTYPE  html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><title>138cb517-5876-4271-a989-58e64b81db22</title><meta name="author" content="sportiwe"/><style type="text/css"> * {margin:0; padding:0; text-indent:0; }
 p { color: black; font-family:"Palatino Linotype", serif; font-style: normal; font-weight: normal; text-decoration: none; font-size: 12pt; margin:0pt; }
</style></head><body><p style="padding-top: 6pt;padding-left: 6pt;text-indent: 0pt;text-align: left;">Sustainable urban planning focuses on creating cities and communities that are environmentally friendly, economically viable, and socially equitable. Technology plays a crucial role in this effort by providing tools and solutions that enhance the efficiency and effectiveness of urban development. Key technological advancements include smart grids, green buildings, intelligent transportation systems, and data analytics for urban management.</p><p style="padding-top: 10pt;text-indent: 0pt;text-align: left;"><br/></p><p style="padding-left: 6pt;text-indent: 0pt;text-align: left;"><span><table border="0" cellspacing="0" cellpadding="0"><tr><td><img width="552" height="276" src="data:image/jpg;base64,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"/></td></tr><tr><td><img width="552" height="138" src="data:image/jpg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAMCAgMCAgMDAwMEAwMEBQgFBQQEBQoHBwYIDAoMDAsKCwsNDhIQDQ4RDgsLEBYQERMUFRUVDA8XGBYUGBIUFRT/2wBDAQMEBAUEBQkFBQkUDQsNFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBT/wAARCACKAigDASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD9JzRig0Yr0j48KBRRQAdxRRSd6AFxRQa5vWfiL4d0GYw3epxecMhooQZGBHY7QcH2OK56+Jo4aPPXmorzaQ0m9jpKMVwEPxv8MyTbHe6iX/no8OR+hJ/Sup0TxVpPiNC2nX8N0RyUVsOB7qcEflXLQzPBYqXLRrRk+yeo3FrdGtXO3+lWtx4/0TUnv44r22069t4rAkb5o5JLYvIOc4QxIDwR+8GSOM9FXOah4dubjx/o2uo8f2Wy02+tHjJO8vNJashAxjAED557jjrj0iGdHjivgv8AaN+JeiaD8afElhd+FbbULiF4Q1y+zc+YIyM5Qnocde1fZuhXvjGa/C6zo+h2djtJMthqs1xKG7DY1tGMe+78K+Lv2gPi6nh74x+JdP1DwxZXE8EyDzUuN29TEhQkmLrtK5HY5AJxk7UnaW55uOjz00uVvXvY5Cy+PXhO0tEhl+Henyuucu3k5PJPeKp/+GgfB/8A0TfTv/IP/wAaplj+0np1pbRwnwPZSBc5Yzrk85/55VaX9p7Suc+ALT2/0lP/AIzXTf8AvfgeR7D/AKdP/wACKlx8ffCc1tLHH8OdPQupXcPJ446/6qsb/hcfhz/oR7P84/8A43XQXP7TGk3FvLGPAdohdSob7QuRkdf9TWF/wvjTh/zKFv8A9/l/+N00/wC8Q6L/AOfT/wDAjL1P4m6HfSq8XhS2tgFwVXy+ff7gql/wsDSP+hdg/wDHP/iav6n8XrHU50dfDMEAVdu0Sqc8/wC5VM/EuzP/ADAIv+/i/wDxFTfzNY0Xb+G//Ahn/CwNI/6F2D/xz/4mvdP2NvFdhrHxhNvbaPFZyf2dO3mptyMFOOAK8O/4WXZ/9ACL/v4v/wARXuX7HHjO31z4wG1i0pLNzp07eYrgngpx90VMn7r1OijSaqRfs2tf5j7m9aMUnrXG/EX4v+EvhQNPPinVf7LF/wCYLf8A0eWXfs27v9WrYxvXr6+1ch9Bey1Oz9K+UfF37cOoeF/FetaMnw8lvE0+9mtFuf7QZBKI5GUPjyDjOM4yevU16T/w2F8I/wDobP8AynXf/wAarj/EH7UnwzvdWmmg8Tb4mC4P2K5HQAd460hFN2Zw4mvKnDmpK7PDPjn+1Xq/xh8EDw9H4UuvDsTXKTTTRXjyiZFVv3TL5SZG4q3Xqg4q38Hv2wtV+FfgOy8N3HhK58QG0d/Lu5r9oiELZCBfKbAXPHP5cCu88X/tEeANU0cwW3iDzJd4O37JOPX1SuH/AOFx+EP+gv8A+S83/wARW/sodzxpY/Ep3VJ/j/kdj/w8Gvf+ibyf+DRv/keuu+E37ZF58TviBpHhp/A76Wl87q139vaXygqM2dvkrn7oHUda8g/4XF4Q/wCguP8AwHm/+IrufhD+0V8P/C3iC7udT1/7NBJamNW+x3DZbcpxhUPYGplTik2mb0MdiKlWMJ02k+v9I+wO9HevGf8AhsL4R/8AQ2f+U67/APjVegfD/wCJHhz4o6NLqvhnUP7SsIZ2tnl8mSLEgVWK4dVPR1OcY5rmaZ7/ADJ7M6bFcv8AErw1deL/AAdfaVZPFHczSQMrTsVT5Jkc5IB7Ke3Wuork/ilpGpa74I1Cy0hHk1CR4DGqSCMkLPGzfMSB90N3pDOQ+Jel3eoeJWmtraWeLyUXfGhIyM5FefaV4Y1iO9lZtLu1Ug4JhYA8j2r1jxZ4r/4RjV2sxafaf3Yff5mzrnjGD6VzFp8XjdXTRDSdoQE7vtOen/Aa/MFUxF8clBe8vf8A7uvTv+J9zWpYSU8vc6jTi/c0+J269jjdU8L6xJexsumXbKFAJELY6n2q1q3hnVpbUqmm3TncDgRN/hXUXvxfNrcJH/ZIkyAc/aMY5/3alvviubODzBpe7kDH2jH/ALLVKpiebA+4vd+DX4tevb8DF0MDy5j+9fvfxNPh06aa6epy2l+HNUSwiR9OulZd2QYmBHzH2qjo3hXWYZpC+l3aDHVoWHeu5tfin9rtkl/svYWz8v2jPfH92q9h8Yftrsv9kbMDP/Hxn/2Wo9pieTGrkVpP39fhd+nfUr2WB9plz9q7xX7vT4ly9e2nocffeF9Yk1WKRdLuygZSWELYHP0qxrPhnVpbNdmm3TkODhYmPY+1dTcfF9re9S3/ALKzuKjd9o9T/u1Lf/Fg2USyf2VvywXH2jHY/wCz7VrGrilVwL9mrxXua/Etd+xjOjgHh8yTqvllL947fC9Nu5ylj4b1ZdNVG025D7SNpiPWq+h+F9Xg88SaZdR5xjdCwz1rtIfit59p550zGVJ2mfOMf8BqHTfi41/5n/Eq8sJjpcZ65/2fauf2mI9hjI8itKS53/K77LvqdfssG8VgJKo+aMXyK2klyrV9tNTwP4q+ObT4ea26678NVvElIWLVryFFW5OwEhS0Zztzt6n7teY3/wAa/DV3dySx+A7KJWxhB5QA4A/551698ZP2o7Wx8STaDdeDor77AysJpbwEHfGrfdMRx1x1PSvJdQ/aB0y7u3mXwZbRhsfKJ1IHAH/PIelfpeTznLA0vaWWit6dD8zzrDwWPq+yg5Jtu/NbV7r5Mzrr4ueH7i3eNPBdpE7DAceWcf8AkOsf/hYGkf8AQuwf+Of/ABNbV58cdPu7aSIeE7eMuMbhMuR/5DrH/wCFl2Z/5gEX/fwf/EV67fmeRCi7fwn/AOBHXfCLxfp2qfETSba30WK0lfzcTKFyv7pz2Uehr6G1TS7zUfLNrbTXATIbykLbc9M4+hr58+EXjq21f4haVZppCWrS+aBKsgO3ETn+6PT9a+m7Pxd/wipf/RPtPn46ybNuM+x9a/P80qYinndGWFipzUdE9O/6H6Bl9DCzyGvTxknTpuWr3fQ5n/hGNX/6Bl3/AN+W/wAK1NP0+5062MV1BJbyFiwWVSpxxz+hrd/4W6f+gV/5Mf8A2NUrvxCfE0gujb/Ztg8vZv3dDnOcD1rmz3FZtVwTji8OoQutU769BcOYTJKOYKeBxMp1LPRxtp16HP3Ph3VJ5pJY9OuZI3YsrLESCCeDTB4Y1c8DTLv/AL8t/hXWxfFE6fGtr/ZvmeSBHv8APxnbxnG32px+LhI40r/yY/8Asa9mljM99jFRwsWrL7XSy8zwa+A4b+sTc8bJS5ndcvW7027mLf2817A8UETzSvjakaliccnj8DWR/wAIxq//AEDLv/vy3+FdFb6sdBnS+EXnmLP7vdtzkY6/jV//AIW6f+gV/wCTH/2NeDkGIzSjh5LB0FOPM7tu2p9LxNhMmrYqEsfiZU5cqslG+nR7HM6bot/p9w0t1Zz28ZUqHkjKjORxz9DXuHwgUt4buMAn/SmHA/2Ury298df8JNGLU2X2bYfM3+buzjjHQf3q9m+BjAeFLrOP+P1v/QErSlWxU87U8ZTUJ8myd9Oh3YTDYKOSezwNVzp827Vne+qOlKMoyVIH0pBXQuUZSPlNYclq4yQhC9uc19vGfNueBWoeytZ3IsZoooFaHGFc78RLrS7LwF4iuNctXvdGisJ5L22i+/LCEJdByOSuR1H1FdFXP/ECPSZPAniFdfeSLRGsJxfPFncsGw+YRgE5256DNAM6AAAcdDR2oAwOuR2opsAxRRijtSAVeoooH3hRQMQ4ozxQaKBCHGKKXNAoAM9KRmCKWJwAMkk9KbJMkRG91XPTcQM14x8UPjt4XmbUPB+j67b3XiLf5FzbQ7sxqATIA+NrNxtKg5GTnoa4sbiVgsNUxEldRTY1vYzfiR8V7nXLifTtImaDTFyrSocPP689l9u+eeuB5tnHX866/wCH3w11Dx7cyPGws9MhOJ76QfKp9FHc459B3PTPcrqfgLwncDT9D0CTxjqfQzOglVj7ZBBPuq496/CatLF5vL67jaihF7Xvr5RirtpeS+Z6tOjZLojxc4qW3upbO4SaCWSCeM5WSNirKfYjpXu03jjUvs2Lv4UFrTuhtyQB/wB+v6VlQ6L4B+KDNb6Wr+FteOcW7gBHPGQFzg9+BtPU44rN5OuZLD1rz6JxlBv0ckl+Jp7JPRP9DV+FvxPbxMRpeqMBqaqTFKBgTgdeOzAenX8K9K718ra3our/AA/8QrDcxm3vrZ1likXlXAOQynuOP8e9fTOg6tHrmjWV/GAouIVkKg52kjkfgcj8K/TeF81r4uE8Hi/4lPvu1tr5p/foebWhyMvnFfCf7RXxji8MfGbxJpjaFHeG3eEGc3AXdmCNumw+uOvavu2vhP8AaJ+Mk/hj4y+I9LXRUuhbvCBKZiN2YI26bfev0Ck7N6niY+HPTXu82vexyOnftRW9hZxwf8IdFJtz8320DOTn/nlVn/hq23/6EuL/AMDh/wDGarWH7Ul3Y2ccA8LROFz832kjOST/AHPep/8Ahq+8z/yKsf8A4FH/AOIrp5v7x43sX/z6/wDJv+CMuv2p4Lm2li/4Q2JN6ld320cZH/XGsH/hoCH/AKFmP/wKH/xut25/aou7m3liPhaIB1K5+0njI/3KxB+0JcbefDsf/gQf/iaXMv5iXRv/AMuf/Jv+CZWqfGaPU5lkHh+OMKu3AuQe/wD1zqn/AMLVj/6Aaf8AgQP/AIir2qfGqbUpkkbREi2rtx5xP/stUP8AhbEv/QJT/v8AH/4mnfzNo0nb+H/5N/wQ/wCFqx/9ANP/AAIH/wARXuX7HXjpPEPxf+xrpi2hOnTv5gl3HgpxjaK8N/4WxL/0CU/7/H/4mvcv2O/HkniL4v8A2NrBbcf2dO+8SFuhTtgVM2nF6nRRptVIvk69z7h9a8/+MXww8MfEXSLaXxFpS6k9gx+zFpZI/L8wqH+4wznavXPSvQfWsfxZ/wAgOf8A3k/9CFcsN0etiW1Qm12PlLVPhh8GtGv5bK80mKG5iIDoZLs4yMjkMR0Iql4q+Dvw2l8BXur6JosYKlBHOJrgc+Yqtwz+57VQ+J4P/Cdarwfvp/6LWuqtxj4FXJ/6af8Atda9Jpdj4v2tTT3n9580b/APt/3zPU13aeBrGVY541R2RXAxMflYZB49jXmRByeD1ra8Wg/2lBwf+PS3/wDRa1zcz7HufV/eSU3952hs/Ay2IvNi/ZjKYQ4E338Zxjr0NFpZ+B74yiBA5ijaVxiYYVeSea43BHgZOD/yEm/9FLTvCQPm6rkY/wCJdP8A+g0cz00IdF8rfO9PM6kHwC7BRgseBxPX6HfArwXo3gj4Z6PBotkLGO+hivrgCR38yd4kDP8AMTjIVeBgcdK/K6BW+1RcH7w/nX62/DXj4eeGf+wbb/8AotazqO6PRwtP2dRrmb06+p0lcl8VW1VfA2oHRPtX9pb7fy/sQYy48+Pfjbz93dn2zXW1ieNIdduPDV7H4angt9bOw28l1xHw6lgx2PjK7hnaetc56jOa8SeFofE2qNdyzSQybAmxACOP/wBdYFt8JrK2neRb2clgey+tY3xI1rxRb3cTJaWlrqbRgyWUOpSfZ0GWwVl8kFiRtPKDqRk4yeC0jxJ4pmS7eRl+3pnyrb+0pGhYZXq/l5U8njaeg9ePzONDEP67y1bW+L+9r17dPxPuK+IwsZ4BTotuT93+7pv5nqt38JLK8uEk+23KkDGFValvPhbZXkJja8nXkHhRXkVz4k8VGVzdlLWcIDDDb6lJIkh54ZjGu3nAyA39KuN4j8USW0n9ohLFQRsa01KSYk56EGNMD86r6tiP9iaqrX4Nvd1/E5njMG1mH7h+78f9/T/yXsepWnwus7W3SIXk7AZ5IHrmorL4R2Nk7Mt7O5YYwVWvmH4geP8A4r2FxpCaQlzFbyA7msHe98x9/wB12ZAV46DGDnOT29V8N69q8oBub25E/lgunnswVu4HPrWtfAYmhh8VWlWTT+JLVytK2vbuZ0cwwdXE4KjGg07e43tH3b6d9NLnpE/wlsp7xbg3txlSCAFGOKkvPhbZXkSo15OADu4A5/zmvOL7XNRXV4VXULoKWUbRM2Dz9asa3rOoR2ilL65Q7xysrDsfesY0cS6+BXtdZL3Xb4N9PM0licH9XzFuh7sJWmr/ABvTXyPQofhZZQ24g+1zkAEAlRUNl8KLKx37by4O7AOQO1cNZ63qDaUrNfXJbY3Pmtnv71X0HW9Rk88vf3TkBcbpmPr71zeyrfV8bL2nuxklJW+J3evlqdnt8N9awEXR96cW4O/wLlWnnpoVvj94ntfgnpmj3S6UNaN/NJGRJKIiu0A5zsbPXFfPmoftGQX95JMfC0UW7Hy/awcYAH/PKvQPiH+0hqPhHxTd6G+inVIrTYVnlumBbciseNpx97HXtXA3/wC0dcX128x8NxoWx8v2gnGAB/cr9LyjmjgaXPO+i6dOi+SPzHOacZ4+s4Uer+1u+r+b1M+7+PEN3bvCPDcalxjP2kHH/kOsb/hasZ/5gaf9/wD/AOwrbvPj3Pd2skJ8PogcY3Cc8f8AjtYf/C2Jf+gQn/f4/wDxNexddzyYUbbUrf8Ab3/BOw+EvxAXWviDpVkNJW383zf3ol3bcROem0enrX0/pXhKHxO0vnTyRCDGNgHOf/1V8v8Awl+IcmufELSbFtOWBZTL+8EpOMROem32r3/WL25szD9nuJIA2ciNyuenXFfn2a061fOqMMPU5Jcujttv+aPv8uqYfDZDXniqPPBS1jffa2p2P/Cp7H/n9n/IVl6n4fi8OTLbQyPKrL5m5wM5JI/pXIf25qP/AD/3X/f5v8a1tKuZru1Z55ZJnD4DSMWIGBxzXJnmDzChgnPE4r2kbrS1vxK4cx+VYjMFDB4N0p2fvc1+118zqbf4ZWV/BHcPeTK0yiQqAMAkZp7fCexAOL2f64FcFc6vfQzypHe3CIrkBVlYADPTrUX9t6j/AM/91/3+b/GvZpZdm8qMZRxtlZacq7I8CvmmRxrzUsvbfM7vm63ev3nVWGkrrt3HYyO0ay5y6jkYGf6Vs/8ACp7H/n9n/wC+RXLajPJa2kkkMjRuMYZGII5HevIPij8bb/wfH/Z+nX88uryLuJaVitup6EjPLHsPxPGAfCyLCZhXw05YbE+zipNWte77n1XEOKy6njYUsVhPaycU0+a1ld6fLU9t8UaJovw/s1v7zVorVHbyt15Kka9M8Ekc8D866T4Q/tBfDjTNKuNPvPGGmWty10zjzpSiEFVGd5G3se9fnzaad4t+KetubW11bxTqzLuYQRyXMoXI9AcKMj0Ars5f2VPi1DYfam8C6l5WM7VMbSY/3A278MV9Hh8qlTxH1vFV+epa2yWhwPMIrD/VcFh1Cne9tXqfqRoeuaZ4msEvtH1Kz1Syc4W4srhJoz9GUkVpCBjxjivx+0XXPG3wR8UCayk1TwnrUOC8E0bwsy5yFkicYdTjOGBFfor+y9+0zZfHfRZrO9SKw8W2CBruyjPySpnAmizztyQCOqkjk5BPrzhKKutUZ0KtOrLkkrM9r/syDuhJ+po/syD+4f8Avo1cpGbapPpWPM+56Xsqf8qKbaXAQcKynscmuK+Iuk6fqPgvxFp2r3o0/S57CeK6u9wXyYmQhnyeBhSTzxxXbPqsAHBJ9sVw/wAStJTxb4I8RaZPeR6bHqFjPbNdy4KQB4yu85IyBnPUdOtbU+bqebivZOKULX8jeHCj0xRSL90D04yKXtXQeeHejNH40UgFH3hRQOoooGIaMe1Bo7UCCig/Sk6UAefNp2k/EHx14m0nxHoWk63aaH9mNj9vsY5zH50W6TBcHqUXpjoPSvAfiJ+zjoHw4+IsPiPS551t715podO2KsVsx6qpAHyDedq44GOTivpvQ/E0uqeM/FGjvBHHFpX2XZKud0nmxlju+mMCua+OmhtqPhq3v4k3vYy5bHaNsBj+YX8M187xCqzyut7B62/C+v4DgouSueY6H4t1LUtKsfCMupRaZoklx+9uCoXarNkh27rkk849zjp6Zb+J00e5Phj4Z6RDezqP9I1RwHVj3Yt0PXqTjPAGCK8GrrPDPxG1Hwp4b1HStNSK3mvZNxvlGJkGAMA/y9MnHNfjGX5k6UuSrJrpzLWSSWkY30jd9T2YVLPX+vI9fk0v4uWCm5/tfTtQK/MbQKmX9v8AVr/6EK53WdY0L4h6bfrrsMPhTxhp6eYJnPliRlHA55PI6ckdieal8SfDK/8Ah74abxRY+IrptXgKPcMx+SXcwBAzyRk/xZzivMvHHjOfx1q8eo3NpBazrCsLeQDhyM/Mc9+fyAr3MwxTwcfZ1lK7SfJOXOmn1Ut4yT1Npy5dH9z1GeJ/G+q+MINPj1SZZzYoY45AuHbOMlj3J2j8vqT7t8IWz8PNK5yf3o/8ivXzbHE88ixRqXkdgqqOpJ4Ar6t8KaMPD3hzT9PwA8EIV9vTf1Yj8Sa7ODFWxGOq4mo27RSbfd2t+CPMryvua1fCf7RXxd1bw38ZfEem22jx3UEDw7ZTv+bMEbdvckV91mvhT9on4neJNB+MviSwsdCW8tYXh2TeRK27MEZPKnHUkV+z0naW54GPjzU0uVS16uxyGnftM+I7GzjhXwvDKqZw2JPUn+tWv+GpPEv/AEKcH/kX/Cq+nftAeOrSzjii8JRSRrnDG0nPfP8Aeqx/w0T4+/6E+H/wDuP/AIqum7/m/A8ZUVb+Ev8AwIhu/wBp3xLcW8kR8KwIHUqWxLkZGPSsP/hfWvf9C9EffL1u3X7Qnjya2ljfwjEiMhUkWk4wCP8AerCHxn8Yf9Cyh/7dpv8AGhS/vfgRKitnSX/gRl6p8X9Y1OdJJNFSJlXaAN/TJqn/AMLN1T/oFL/4/VzVfil4nvZ1km0JYWC7QvkSjPPuapf8LE8Q/wDQJT/v0/8AjS5vP8DWNJJfw1/4EH/CzdU/6BS/+P17l+x140vtd+L5tbixW3j/ALOnff8ANnIKeteG/wDCxPEP/QJT/v0/+Ne4/sdeLdW1r4vm3vLBbeH+zp23hGHIKcZJqZS0ep00adqkfcS17nv/AO0H8dtV+Cz6INO8LSeI01ATGV0ldBBs2YB2o33t59Pu14nqv7bniTU7J7c/DeWMMQdwuJT0Of8AnlX1V8Q+PDM3/XRP/Qq+Xte+JWp6ZrN5aQw2jRQyFFLoxJA9fmqaVNSXMVjcY6dR0bXTRyrftZeIEBZvAEoHctNJ/wDG6yPFH7Tmt+JdCudNbwXJbrPtzIJpGIwwbp5ftXrq61PrHgF9QnWNZ2ViRGCF+WTA4yfQV8wH9oHxHg/6LpvT/ni//wAXW8vd3Z5VJKvfkpLTzZIfiFqhOf8AhHJv/H//AIig/EHVD18OT/8Aj/8A8RWx41+M2t+HvEdxYW1vYPDHHEwaWJy3zRqx6MO7GkuvjRrkXhGw1Rbew+0XF1NA6mJ9u1FQggb+vzHvUq19/wADZQlJRfslr5mR/wALB1QDH/COz/m//wARSH4gaoRj/hHJvzf/AOIra8LfGTW9bj1o3FvYr9j06W7j8uNxl1KgA/OeOT6Vm6R8d/EF/qllbS2unCOeZI22xPnBYA4+f3ouu4/ZSu17JaeZX/4WDqn/AELk4/77/wDiK9s8Oftt694d8P6bpa/D5p1sreO3EpupAW2qFzjyuOleReI/jjr+keItTsobbTzDa3UsKF4nLFVcgZ+frxU2tfGrXbHSdDuY7ewL31u80gaN8AiR1GPn6YUdc1MlGW72NqUqtFp06aXN5/Pse5aZ+3N4i1K/t7ZPhu7GVwvy3UhIz1OPJ7V9gA4NfFP7I3xB1Lx18QmGoRW0X2Vfk+zoy53RS5zlj/dFfaormqRitFse1hatSom6is0/U4bX/ElloOoNa3e9ptocbEyMGsSH4maHczNHGs+9epMQ/wAaseNvC134j1s3ltJEkflqmJCQcjPoD61yVj8KNVtbqSQ3NmVYEABnz1/3a/I/Z4VvFc0/h+DXd3/H8D9QqVMapYNU4JqT/eafCraddNfU6W5+Jeh20ixuk+5uRiIH+tPufiLoltFvkSbHTiMH+tctf/CfVrm5SRLmzwoA5Z+eT/s1PqHwu1S8t/LW4tFO4H5mb/4mn7PCXwt56S/ia7a9O2na5m62YJY21P4f4enxadddde9jpLf4haLcQrKizbGzjMQB4P1qG0+JuhXbssaT5Ayd0QH9aw7H4ZapZ2scRuLRiuclWbHJ/wB2qunfCbVrORma6s2BGOGfP/oNT7PC8uK9/VP3NfiV/wAdPQr2uP58EvZq0l+80+F26a6a6aXOnf4l6FDcrAyz72IAxCO/40+6+I2iWqB5Fn2k44iHX865W5+FGrTX8c4ubMKpU4LPnj/gNT6l8LdUvLcItzaKQ+cszY6H/Z96tUsG6mFTn7sl7+vwvttp8rmTrZj7LGNU1zRf7vT4l5669d7HSQ/EXRZLcSKs+zBODEP8aZZ/ErQ73f5ST/JjdmID+vtWBb/C/U4LIQ/aLUkKVyGbHP8AwGodM+FOrWHm7rmzYPj7rP2z/s1j7PDexxMnP3ov3Nd1f8dPQ6PaY72+EXIuWUX7TT4XbRb6a9kzzz47ftIRaHew6XoGjT6je28n+km4gZYgrIrLtZc5PPP0rxC//aB8QXt3JO/hyKNnxlR5mOAB3r2j4ya747+Ez2stppml6xp11IY4VgSeSdSFBYyAAADJOME8CvGNQ+N/jS7vJJZfCyI7YyotZwBwB61+oZL7OOApqnLpr69fxPyvPYVJ5hVdWkr37206P5oz7z4465d20kT6DHGrjBI31i/8LO1Q9NKX8N9bd58YPFlzbSRy+HEiRhgt9nmGPzNYn/CxPEP/AECE/wC/T/417Tf978Dw4UktPZL/AMCOu+E3ju/1n4g6TZz6esMchlzIN2RiJz3+lfUuieJLHw6ZjeByZtu0Im7pnP8AMV8ufCPxnrOq/EHS7a605YIH83dII3GMRORyT6ivpIeFbrxPn7NLDH5H3vNJGc+mAfSvzjOoYarm9KOLny03HV7d7fifpeTSxdDJa0sDTTqKWi+K+1+3S50w+JWif3Z/+/Q/xrF1jW7XXbhbizDiJU2Heu05yT/UVU/4VVqv/Pzaf99N/wDE019AuPDn+jXDxu7fvAYySMdO49jXkZphsnpYdywVZyndaczenXoehk2Lz6ti1HMMOoU7PXlS16a3f5HRWvj/AEaytooJEm82JBG5EYPIGD3qX/hZOh/3J/8Av0P8a5r/AIVpqV8BcJPbKk37xQzNnB5Haj/hVeqD/l5tMf7zf/E16NPCcPunFyxDvZX957216dzyauP4oVaShhYuN3b3VtfT7XYjfxFaeEYrjWL5Xe1soZJpAgBJAQ+tfJ3wz0nR/jF8V7u78feJ7bw9pkol1G+vJ5RGZQCP3MRboxBwBzhVOAcAH6J+KVrNe/DnxIkB+dbGWU9vlRdzf+Oqa+Jx0rs4Wo03QqVYv3r2+W52cS1qixFOEl7qSdvPqfd/hbxL4t8daFPbfCa00z4R/CfT2ZH8S6jEomuQuVeQb85PHLE5yvMgPyjCttO046sLaD9rjUP7UVs755JfshOegLT+WR/wIivL/AHxJ0/4ty6F4e+KPiNND8AeEtK8yLS7BWh/tJ4tqqrkHLSEHtg4BChSxavR5fHfgdvDEGpat+zkmm/DWdxbr4hjRRdJGSAspKxhxnKjPmck4DseD9c4tP8Ar9TxY1FOKd/vv+Udl5s6Lxh4k1rw5BYeGfj/AKTp3jHwXqLbLDxxpcYDW0jcqxKKNpxtOVCkgN/rBkV82W+sWv7Ov7QcV74Z16HxFpWlXiFb6ydZFurV1UyRkrlS2xmUkcBhkYI42/ib8R2+H2n+KPhl4O8R2/in4eakYp7aS5UyyWeSspjjbgA7sA8Ed8K26vDDx9K1hDRnFiK3vK2669fS/VH7ZwXsM8SSJMjI4DKwYcgjrTZ76OOMneGPYA5r48/Zk+G3xi0HSdTfWvEL6FYz+S1pa6iq6mx4YllHm/uhgrxnJPYY5+g9e0bxJfW1gmleI7fSpokK3MkmmC4E7YHIBkXZ0bjn73tWPsV3PQ+vTkvhsdIetc78RfD1z4u8A+I9Ds2ijutS0+e0ieYkIrvGVUsQCcZIzgGneFtda/m1LSbiZ7vUtGkitry7MCwxzyPCku5FDNgbZBwehz161B8T9HvvEPw38U6Xpkfm6jeaZcW9tHvCbpGjZVGSQByRySK3PPeqOmUEIAeSBS0i/dGc5xS0MYUUd6KQCj7wooX7wooGIaOKDRQIM4ozSZo7UDOb0LWbS98aeKdPh02K1u7H7L9ovEA3XW+Msu7gH5RkDJPXtXQXFvFd28sEyCSGVCjo3RlIwQfwrntBvNIm8a+KobO0lh1WIWn2+dvuTZjPlbfmPRcg8D8a6Wk0pJp7MlHzZ8Qvh1d+DL15okebSZG/dT9dmT9x/Q+/f9Bx31r7CngjuYXimjSWJwVZHUFWHoQa4HW/gn4f1SVpbbz9Nc84gYFM/wC6QfyBAr8mzXg2p7SVXL2mn9l6W9Htb1OuNb+Y8PvfFOsalpsOn3ep3NxYwgBLeSQlBjpx3x29Ky+le0xfs+WwlBk1uZ4wfupbhT+eT/Kuw8NfDDQPC8izQWxubpeVuLs72H0GAAfcDNeTR4TzXE1F9Zaiu7d3bytf8y5V16nE/CX4ZTW9xFrmrwmJk+a1tnHIP99h29h+PYV7Fn/Io6CjvX61lmW0cqw6w9H5vq33Zyyk5O7DNfC37RPxB8Y6N8ZfEdlpehC7sYnhEc32OZ92YIyeVODySK+6f0r4V/aH8ceM9I+MfiO00zw+15YxvD5c4sppN2YIyfmU4PJP5V7tL4jysfHmpr3U9erscnpvxs+J1tZRxw+EFkjXOG/sy5PU56hverP/AAvT4p/9CYn/AIK7r/4uq2nfFv4q29nGlv4NaWEZ2udKuTnk55DetWf+FxfFz/oST/4KLr/4qur5/geL7P8A6dx+8iuvjf8AFCa2lSTwcioykFv7LuRgev36wf8AhanxA/6Fkf8AgBP/APFVv3Xxf+LEttKkngspGykM39k3QwMc/wAVYB+JPxDz/wAis3/guuP/AIqi/mxOkv8An3H/AMCMvVfiL4yu51a68PiJwuAPscy8Z64LVQ/4TfxR/wBAVf8AwFl/+Kq9q3jvxvdzq1xoDQOFwFNjMvGTzyapf8Jj4v8A+gQf/ASX/Gpv5v7jWNNW+CP3iHxx4oOP+JKv/gLL/wDFV7j+x34m1vVfi/8AZ7/Thawf2dO3mCB05ymBknFeIf8ACY+MP+gQf/AOX/Gvb/2PPEXiDU/jAYNS0421t/Z07eZ9ndOcpgZJxUzfuvU3o00qkXyR37n158RP+RYm/wCuif8AoVfLuu/Dm/1TWby7iu7QRyyFwHZtwz2OFr6i+In/ACLE3/XRP/Qq+MfFwx4o1P8A67t/OqofAcWZ/wC8/JHpA0aXSfAD2EskckqhhujJKnMmfT3r5iPwD1kqf+JppW3181//AIivo7RuPhXkc/LIf/Ipr4jJAUn2qqjWhngo1Jc/JK3yue0+M/g7q3iDxJc3sN9p8MbxxLtlkYMNsaqein0ptz8GdXl8Jafpgv8AThLBdTTGQyPsIZUAA+XORtP5iuF+KfPje9J/542/P/bBKjvgP+Fb6Pn/AKCNz/6BFUXV3odUYVuSHv8AbouzPQvC/wAHdW0dNZSS90+VrzTpbVPKkc7WYrgt8vA4NZukfAzWLHVbG4bUdMdIZkkIWR8kBgePkrlfh7xD4px/0BLgf+PJWF4bOPEOlHv9qi/9DFTeOmhpyV7z/efguzPTfEnwS1jVfEOqXsd/pscdzdSzKkkrhlDOTg/L15qfWPgxq1/pOh2yX2no9lbtC5eR9rEyO2VO3kYavNfHBz4z1/v/AKfcf+jGq34nGPDvhLP/AD4yf+j5Kq6V9CVCt+79/wDBdj6b/ZH8AXvgf4hMby6tbn7UPk+zMzbdsUuc5A/vfpX2oK+BP2Ej/wAXDvwOm1P/AEVPX34K5qtmetglKKmpO7vv8keV/EHxBf6J4gNtZzeTD5Svt2KeTn1B9K4fTviH4guLyVHvwyKCQPJj9f8Adr1LX7bR7jUC2qtbrdlQP30u1tvbjI96w7XS/BiSuY308yHOdtzk/wDoVfk3tKSeLvSfvfDp8GvXsfqNWjXlLBONZJRfvK/xq2y7nEal8Q/EFvexpHfhUKgkeSh5yfarOqeP9dtrXdFehGyBnykP8xXW3Wl+C2nBlk0/zOMbrjB/9Cqa80/wfJFiZrALkfeuMD/0KmqtFPBv2T934tPj16d+xk8PiWsd+/XvfD738PTr/L3OP07x3rlxZRyPe7nbOSIkHQn0FUdI+IniC5mdZb4MMZx5MY7/AO7XfWum+EY7cCKSx8vnG24yPf8AiqGz0vwVGxMD6eXP925ycf8AfVQ6lLlxa9k/efu6fBrs+2mhfsMRz4F+3Xur3tfj03X83c4m8+IevxanHCt+BGxUEeSnfr2qfV/H+vW1qrx321i4GfKQ9j/s12EumeCzdK0j6eJgRgG55z243VJead4OljAnawCZ4LXGBn/vqtFVoe1wj9i7RXvK3x+a7mMsNifY46KxCvJ+6+b+Hto/5TjrTx7rk1gJWvcuVJz5SdvwqDRviDr92Z/N1Ddtxj9zGPX0Wu5g07wgtttR7DysH7txxj/vqmWWmeDI9/2d9POcbtlzn/2asfaUvY4qKp6yl7rt8Cvs+x0+wr/WMHL2ytGL5lf43Zar+bvc+cfiX8cPiXYeKrvTdP8ADyatplsUaC5OmzOW3RqW+ZCAcEkceledah8XPiLd3kks3hZY5GxlBp9wMcAf3q+hPj/4n1Twdpmjv4F0mPWZ5ppFuUhgluQihRtPyNxk561896l8UPiTc3sklx4TaOY43L/ZlwMYAxwW9MV+nZLKMsBS5U46duvV/Pc/Lc8pS/tCrzqMtd+bp2+WxQvPih48mtZI5vDapEw+Y/YZxj8S1YR8b+KP+gKv/gLL/jW5efEXx/JbSLL4aaNCOW/s+cY/EmsQeMvGH/QII/7c5f8AGvab839x4sKS/kj/AOBHXfCXxXr2o/EHSra90sW9s/m75fIkXH7pyOScdQK+iLnxBqGg7RYTiHzc7/kVs46dQfU188fCXxN4kv8A4g6Vb3+mGC0fzd8v2aRduInI5Jx1xX1Dolro1wZ/7Xe3XG3yvPk2eu7HI9q/Oc5q0qWcUp1qbqRUdY2vffofo+U0KtXI61PD1FSk5aS5rJbdfPY58fELXx/y+g/9sU/+Jqzb6vea3EZ72XzpVOwNtC4HXHA9Sa6v+zPBv/PTT/8AwJ/+yrG1eHTYLlV0swm3KZbyX3jdk55yecYry82xmBrYVxoYR05XWrjb8TryPA5hQxqniccqsbP3VPm+dr9DFk8c63aO0EV4BFESiKYkOAOAORSD4ha//wA/gx/1xT/4muvtdP8ACklvEbh7JZyoMm+4wd2Oc/N61L/Zng3/AJ6af/4E/wD2VenDH5aqUVLASbsteRdtzyK2WZs60pLM4pXentH323+Rxesrv0m8hOCk8LQOCoIZHGxhj3ViK+HfEWhXHhnWrvTbrJlgcruxjevZh7EYNffOlR2c1/EmomMWZz5hlbavQ4yeO+K5v4vfBfwb8R9GBsNSsNI123H+j3YmBRx/zzkGclT6jlScjPIPJw/mVLCUpU5UpPml8STaS6J27Ht59gKuIxEa3toqKgvdckm33V2t/wAT4ZwCa918RftZ634i+BFp8NJdGs4oobeCyfU1kbc1vCVMaiPGFb92gLZOecAZyPKvFngPW/BV/Jb6nZlUU4W5gcSwv6FXXIORzjqO4Fc+cEc4x0r9H92okz4eE507qL30Z9gfG34DaV4Z+Ad9rECXMcmn2mi3EMr2dukLl08mURuv7zLM5kcP/EExkdPn74E/Daf4rfE7R9DSMtZeYLi/k5xHbIQXJI6E8KP9phW94E8A/Fr43WkWlWVzrd34eIUGfVLyZdORVPH3iVbaQPlQMRxgV92/A34F6N8EPDRsbJzfapdbWvtRkXa0zDooHO1Bk4XJ6knk1KvFWbOifLWkpRjZHpQAAAAwB0FKTRRjipNTnfDqaQniTxU2nyyPqL3cJ1FHB2pL9miCBcgcGMRngnkn6VF8T49Tm+HHiePRTcjV2024FobMsJvO8ttmwryG3YxjnOKm8PaZYWXiPxTc2t8Lm7vLuGS7gBH+juLaJFXjplFVuf71Q/E7UtR0f4deJ77R3ePVrbTriW0aOMSMJVjYphSCGOQOMHNBG61OmXhVB64paRPuDnJxzS5oZQUUUdqQCj7wooB+YUUxiGjtQaM0hBRRSUAc3oMeijxn4oeymkfV3+y/2hG2diYjPlbeMcrknBP4V0tc3oeladaeMfE19bX4uL+8+y/a7UMD9n2RkJwORuBJ5rox9KBIXmijNZviLxFp/hTRrnVNUuVtbO3Xc8jfoAOpJ7AVMpRhFyk7JFxjKclCCu2TatrNjoNhJfaleQWFlFjfcXMgjRcnAyT74Fc3/wALj8CH/mcdE/8AA6P/ABr48+O3xf1D4nXB3brPR4ZP9Fsg3/j7+rEZ9gDgdyfIK+IrcSP2jWHgnFdXfX/gH6Bh+Fk6SliZtSfRW0/4J+kX/C4/An/Q46J/4HR/40f8Lj8CZ/5HHRP/AAOj/wAa/N2isf8AWOv/ACL8To/1Ww3/AD8l+B+kP/C4/Anbxjon/gfH/jXxx8dPiV4quvirr0vhiyTWNCZ4vs17bWzTRyjykDEOpwcNuHHpXkhFbFl4h8fWVrHDo1hLNpqD9y62m8HnJ5785r3snzapjq8qco2sr6eqPj+JslpYDCwqQfNeVvesls+x0GnfFD4uwWccdv4YlkhGdrDSpj3OefrVn/ha3xj/AOhVn/8ABRNVbT/G/wAZYrONLfRZnhGdp/s4Huc/rmrH/Cd/Gz/oBTf+C0V9jd92fnKgv5IfeR3XxT+L720iy+F5ljZSGJ0mYYGOec1hD4ifEkf8wCT/AMF8n+Nbtz44+NEltKsuiTrGUO4/2cBx3rB/4Sv4o/8AQLm/8AaL+pLgv5IfeZmq+NfHV1OjXejSRuFwB9hkXIz71R/4Svxh/wBAqT/wDer+qeIviBNOpu9PkSQLgA2oXjJqn/bvjb/nxf8A8BxUN+pooafBD7xn/CV+Mf8AoFyf+Aj17n+xzrviHUfjAYtSsXt7X+zpyXa3ZOcpjk14f/bvjb/nxf8A8BxXuH7Hep+JLr4wbNVtmitf7OnO4xbfmymOamT06nRQjarH3Y79GfXvxE/5Fib/AK6J/wChV8ua7rPhmHWbyO70aSe5WUiSQOcMe5+9X1H8Q+fDE3/XRP8A0KvkbxN4X1a78QahNDYTyRPMzK6rwRmtKHwHHmf+8fJHZpc2Nz4Akls7ZrexKttgJyQBJz37nP518wN4q+HOD/xSVz0/56n/AOLr6XsrG4s/hq1tPC0U4VwY2GCMyEj+Yr5BPw38T4I/sO8/791dS+mhhg4wbnzyt87HonjXxF4ItfEdxHqfhue8vQkReZJCAQYkK8bx0UgfhTLrxH4H/wCER0+eTw3O2ntdTLFbiQ5RwqbmJ3dwV79qwviH4H1/U/Ft1c2uk3U8DRQKJETIJEKA/qCKZeeBvEEngXS7NdIujdRXtxI8Qj5VWWMA/jg/lUXd2dcYUeSHv9vtevmdJ4V8R+CZ01o2Hhye1EenSyXG6QnzIgV3IPn75H5VmaT4o+H82q2SW/ha4iuGmQRyGU/K24YP3+xqn4K8Da/YxeIRcaTdRGfSZ4YwyffclMKPfg/lWPoPw98SW+t6dLJot2kcdxGzMY+AAwJNLmloPko80/f/APJvJnVeI/EvgK38Q6nHe+GLi4vI7qVZplkwHcOQzD5+5yas614m8DR6Toclz4buJYJbZmt0EhBiTzXBB+f+9k9+tcp4v8A+Ir3xTrVxBo91LDLeTPG6x8MpdiCPwqzr/gXxBc6F4aii0m6eSCzdJVCcoTM5AP4EH8aLvXT8BclG8Pf/APJvL1Pff2RdW8Oal8RGGgaTLpflr++8x92/MU23HzHpg/nX2sK+Ff2K/DWqeH/iHcnUrGaz81R5fmrjdiObOPzH5190jgVz1b/h/mezgVFRmou6v3v0R5T8RtEvtW8Rm4tIDPF5KqWUjgjNcJpngfXob2R302VUYEA7l55+teleMfFcnhrVzZxW6zDYJN7tg8/T6Vytj8W7q8upIjp0ShQSG8wk9fpX5Vz4lPHcsVr8fkr9O/4n6XXp4Nzy91JtNP8Ad6fE7dexz2qeBtenvY3j06R1CjJDL6n3qxqngvW7i22R6dI7EjgMv+NbN98Xbq0uUjGnRNuAOTIeOf8A61T6h8VLmzg8xbCJzkDBc01PFc2B91afBr8WvXtr6HP7PAcuZfvHr/E0+HT7PfQwtO8Ha1DYRRvp8iuu7IyvGSfeqWkeBNetp2aXTZEG3uy/411ll8Ubm6tY5jYxKWzxvJxg4qrp/wAXbm+lKnTokA5z5hPf6VPNiuTHe6rN+/5O/T5+pfs8D7TLvfd0v3enxLl69tPQ5+98Da6+qRyppshjBUlty9uverGr+CtcuLQJDp8jtvBwGXpg+9bN18XLqG+S3GnRMrFRuMhyM/hUuofFa5soA4sInywGDIR2P+Faxni/bYG0FdL3Nd159jCVPL3QzJSqS5ZS/eafC9Ph01/Ew7PwZrUWmqj6fIG2kY3L3/Gq+i+CdctvP8zTpF3Yx8y+/vXTW/xTuJ7MTfYIgSCdu89vwqLTPizdX4l3adEmzHSQnPX2rm58T7DGJxXK5Ln8nfp3Ov2eC+tYB875lF+z00kuVavs7anh3xP1z4s+DPEE0eleGjc6KxUW062hnZvkUtnYxI+Yt1ArzTUPiR8UJbuR7nw7KkzY3A6bKOwxxn0xXrvxk+LXxKv9aOn+G/C7rY2rBkvo4DMJwyKSORgYJI49K8i1Hxd8WJb2V7jSZkmONy/YcY4r9MyeVR4Cl7TTRWt26fgfmmd06Sx9X2UYtX1u7O/X8She+PviJPayJNoUiREYZv7PkGBWJ/wlfjH/AKBUh/7c3rcvPFPxMa2kE+mSpCR8x+xY4rF/t3xv/wA+T/8AgOK9d69WeNCGnwQ+8674Sa/4lvviDpUN/YPBaN5vmSG2ZMfunxyffFfRF9oV9rIjNlbNP5ed+0gYz06n2NfPHwk1bxTc/ELSY9RtXjsz5vmMYQuP3TY5+uK+l7fxZJ4X3eXAs/n9SzYxj6fWvz7NJ4mGd0ZYSKlPl0T0XW5+g5fTwk8grxxsuSnzauOvaxif8IPrn/QOk/76X/GrtppV1pERhvITBKW3hSQcjp2+hrU/4Wzcf8+MX/fw/wCFV7nxDJ4kYXTwrAUHl7VbPTn+tc+eVs4qYJxxlGMYXWqd3fp3DhuhkVPMFLAV5zqWlo1ZW0v0MmbwfrN1I80VhI8cjF1bcvIPIPWmf8IPrnfT5B/wJf8AGugT4n3Fii2wso2WEeWGLnJxx6e1L/wti4/58Yv+/h/wr2KOIz9UYqOHhy2Vtell59jwa+F4YeIm5YqpzczuuXrd+XczbqxuNTia2tozLM+MIMc45P6CqA8Ea4R/yDpP++l/xrXh1VtEmW9WMStF0RjgHIx/WrR+LNzn/jwi/wC/h/wrwchrZrTw8lgqUZR5ndt21PpOJsPktTFweY15QlyqySvp323MS08N6jpMjTXlo0MLKY9zEEEnnHB9jXrHwj8L6MdGmuzpFibpbpsT/Zk3j5U6NjNee3HjiXxMgtZLZIQh83crE9OMdPeuB8b/AB08WfDLVIdL0K6t4bSaEXLLNbrId5ZlJyfZVqZ47EYbN/bZjHlfLa0XdW6dT1Muy/C4rKFQyufPHmbvJWd769D7KACgAYAFLXwl/wANcfEf/n/sf/AJKP8Ahrj4j/8AP/Y/+ASV7v8ArBg/P7v+CZf6tY7vH7/+AfdtFfE3hb9sHxfZ+IbGXXjb6jpAkAuYLe2SOTYeCVPqM5weDjHFfZ+l6na61ptrf2U6XNndRLNDKh4dGGQR+Feng8woY6/snqujPJx2W18v5fbLR9VsZHh7w+uleIfFF+t4lw+qXcU7QKuDBst4ogpOeSQm7tww+tM+JHiC58J+APEmt2Sxtd6dp1xdwiVdyF0jZgGAIyMj1FHhvw7daT4m8W6jM0TQateQzwKhJZVS1iiO7gAHdGx4zxj6CXx/4hbwl4G8Qa2tul22nWE10LeQ4WXYhbaT2BxXpnkdDeQYQdyRk0tAJIyTnIooZQd6KKKQCj7wooH3hRQMQ0UGjtQIQ0dqXrRQBzeheHk07xj4o1VbtJjqf2XNuo+aHy4yvzc/xZz0FdHXM6B4autL8beKtXkkia11X7J5CIxLL5URVtwxgcnjBNdPQJFbU7+PSrC4u5ldo4ULlY1LMcdgB1NfIPxY1bxt8UNY8ybRb610qBj9lsgvCj+83qx9e3Qd8/WniQf8SO8z/c/qK8xaUKyozAFhwD9cV+ZcV4vG+3hgsLFyTjzNJNvR21t0R+h8MwwlCnLGYhpSUuVNtJarpfq/vPkbxD4B8RqIVOjXYByf9X/n3rG/4QDxH/0Brv8A7919aeIxm4twe47V56fiHai0uZ/7KlPlSpHt+1jncHOf9X/sfrX5tl1XOs1qVaWXUIyVNpO8rfFtufdZlmGW5ZGnPHVHHnvayvtvseG/8ID4i/6A91/37o/4QDxH/wBAe7/7919Dap4jh0nQbfVGs3mWfycQicKV3xl/vbTnGMdBUdp4qtr7W4NOSwliaa2SfzjcBgu6AS427Bn0zmtof6w1MNUxkcPDkhz3fN/JpLTyf39Dmnm2T08RDCyqy558llyv7esdfP8ADqfPv/CA+I+2j3f/AH7pDJ8TNFP2PTrWeGziGI0NvESM8n7wz1Jr33UfGdtpmrXFgdPkmMEe8yi5C7j5e/psOOuOprx7xdrXxH1bxFeXegQvb6RIVMEZNs+AFAPLAE/MD1Ffo3B2HzhV3iMdSjGnKCcXGV272a09D844zzPLcVh1hcLU5pxm7qSstLxevroRadr3xwSzjFrbXDQc7SLS3Pc56j1zVn/hIPjx/wA+tz/4B23/AMTTNPufjt9kj+yq3kc7DssvU56jPXNWftPx+9G/74sa/WvvPyflXaBVute+ObW8gmtbjytp3k2duOMc9qwv7Y+LH/PGb/wGh/wrobq5+PRt5fNDeVsO/wCSx6Y56VhrcfGADHzf982lGvmQ0u1P7zG1bU/iPJKhvYpd+3gGCIcZPoKo/wBoeOf+eUv/AH5j/wAK09Vk+Jrzp9tyJdvGRbdMn0H1qg83j6MAuwUZxkiCspzjTi5zdkurOmjSlWlGnTjFyeiS1+4j/tDxz/zyl/78x/4V7n+xxdeJ5vjAV1aN1szp0/LIi/NlMdK8TfUvEcTFH1pd44O21jIz3wcV23we+Lmr/C7xedau8a9CbaSD7IdlvyxHzbwrdMdMd68CWfZe07VH9zPraXDGaxnGToRXzV/zPvT4if8AIsTf9dE/9Cr5H8TeKtXtPEGoQwX8sUSTMqouMAflXQ+IP2zH17THsz4RWAMytv8A7R3dDnp5QryK/wDiLZ6rqs13Ppk0Ymk3uI7kHAJ5xlP61pRz7L4xs6n4M5sfwrm1atzwo3Vu6/zPZ7PULi9+GpubiVpZ9rkyN1OJCB/KvkQ/E/xVsI/tu5xjGMj/AAr68sW02T4bg6fdtd2DoSJiuG5f5sj1ByMe1fNDeDPh/sI/4S+TOOvlf/Y19BJ+0ipQlo/M+OwyjRlUhWg7rpa9t/uE+IXxA8Q6V4tu7a01aeCBYoGCLjAJhQnt6kmmXvxB8RJ4G0u9XVp1upL24jeUYyVCxkDp7n866Dxp4X8GXviO4n1DxM9ndNHEGhEecARqFPTuoB/GmXPhfwY/hOwgfxM6WCXUzRz+Xy7lU3LjHYAfnSald6/ibKdHkguT/wAl9fIxvBfj/wAQ36eIXuNWnmMGkzTRbiPkcFcMOOvJrI0L4k+J7rWNOgk1m5eKSeNGUkcgsAR0rtfC3hnwbaR60LLxG90JdOljnJjx5URK7n+724/OszSfCXgSHVbOS38VySzrOjRx+UcMwYYH3fWlZ6a/j5l89Dmn7np7vk/IxfFvxG8S2HijWba31i4ighvJo40XGFUOQAOPSrHiD4heI7bRfDlxFq08c1zaO8rgj5yJnAJ49AB+Fa3jfwRoP9oahfpf3dxdXF1KzwqoRUYuSwyR2OegPTrWHqVjYalYaZatHcItjC0Kssq5YF2fJ+T/AGsV4tbOcHQqSpzq6rtd/kfS4Th7G4ulTr0sP7r7pK+nZ67nt37F3inVfEnxEuP7TvZL3yVXy/Mx8uYps4x64H5V90D9K/N74KePbf4MeIZNVtdMl1NpAA0U10E6K68EIf7/AOle7f8ADcsn/Qlr/wCDT/7TXFUzzAS2qfgz2sNw5mNLmTpWV+68vM9u8ReFLXxJqJvLmSWOQKExEw2kDPqDWFB8KtKtJXlFzeZYEHcy/wDxNfP/AIo/ank8R6n9sXw79k/dhPLW/LDjvnyxXN2nx3mtrl5jpbSBgRtN2eOc/wByvz32muItW+Ly+PXr2769j7upgpuWF/2dPle91+703Xc+o7j4U6VdSrI1zeBlGOHUe/8AdqW6+F+mXURje4uwM5yrL/8AE18q3nx1mu7hZBpbRgADb9rJzz/u1oQ/HVdYuY7a6sXsYHYAzfaS4U+42jitKcpTnhYqvt5fw9fx7nNUwsqVPGTlhdHq7O/tNO3TtY+nIPhlplvCka3F1tXOCzLzk5/u1DafCjSrRmZLm7JYY+Z1/wDia890h5W0yAhnYHccgnnk4rP0E3P2h8mX7vfNauhV5Ma/afC/e/v6nB9Yw6qZcvYazT5d/c0/panqUnwp0qa5Sc3N5uXBADpjj/gNPuvhdpV3CI2uLvaG3ZDrn/0H3ryy/NwdYhIMmNydz61Z1xrg2a4Mv3x0z6GtlRrOtgkqus17r/k308znlisMqGYyeH0hL3l/O9NfI9Nj+GOmRwCJbi6KgbeWX/4mo7L4V6XYiQJcXbb8Z3OmeP8AgNec2LXA0peZc7G9feq3h83GbjJkB+Xrn3rm9jV9hjH7TSMveX8+r1/U61XofWsBH2Osovlf8i5Vp59it8fdA8Z+D7fTbnwNeX98biZkntXht5EhUKMFcxhuTnqT+FeB6hrPxga8kN1BOsxxuH2WAY4GOg9MV3/j+f4wr4ovF8NK50L5Ps+VtT/Au/8A1nzfe3dfwrhb+5+NH2yT7UCJ+Nw22foMdB6Yr9NyeM44ClzSb0XyXRfLY/Mc7cJY+s4wgter1v1fz3Mu81b4pvayLPFMISPmzbw9PyrD+3+Ohx5Uv/fmP/CugvZ/i01tILjd5GPm+W16fgM1ib/iD6/mIK9bXzPHgl2h951fwku/FkvxC0ldSR1sj5vmExoP+WTY6DPXFfUejeFbTxMZvtMssfkY2+UwGc565B9K+X/hM/jA/ELSRqp/0H975nEX/PJ8fd5646V7xrm8NFsLdDnb+Ffn+a0qtbO6NOjU9nJx+Ltv/wAMfoWXVaGHyGvUr0lUipaxXX4f+HO8Hwr0s9Li7/76T/4msjVtAt/Ds621u8joy+YTKQTnJHYD0rh91x2Mv61uaKXNm28tnecbvoK5c7wONoYNzr4t1I3Xu2/H5FcOZjl+Jx6p4bBeylZ+9d+WnzOvtvhrpt/bxXDz3QeZBIwVlwCRk4+X3r53uvEniS3+O9z4Ti0G5vNOSdoktE2pPJCBxMJWwozw2Thccdea9DuzcfaZseZt3tjGemahJnzkmTJ9c19JgMHjaNLmniuZOOif2dF2fTY+UzDMcuq13GGB5WpO7T+LV33XXc2JHvr8WVvHod3ffaULTQ21zBHJCQobaS7BTzkZBPT6VsXPghotDt7yPQ9VnvpH2yact5aiSEfN8xckIeg4Bz8w9DWdqeRYyeX6DG36iufxcH/np+tfN5DhcVXwzlh8R7NKTutdfx/qx9bxNjcFhsXGGJwvtW4Kz7Ltt/VzqLzQ5dD8OHVk0bUI9RMohGnT3NuzMp53BlO3tnluxr57+MWoXl74jt5LvS5dOlWzULDLLG5cb35yrED05PavbNF837W2/fjYfvZ9RUet+F9A1+/R9ThtJrtIjtE9xsby1y2cbhwPmOfrXzfEE62AxUvaJ15WT91Nuz6W10XfzPrOF6uGr4ONWmlQheSs2kr6a3fV9vI+WYZpZN++Bo8dMsDn8jSwzSyNh4GiGPvFgf5GvpeL4b+EpojLHYWUkI3bpUuSyLtGTlt2BgYPNRf8IF4M8pJPs+m7XYop+2jBIxkff9x+dfJxzudRzjDA1G07P3Xo7beTtrqfbezo01CU8VCz1V5R95X/AC6aHzZFPM0m1rZkX++WX+Wa+iP2WvjxeeGtUtfBOpWklzpl9dKljOZkUWzu3zA5P3WJyAOd3QEtV6b4deEbZkWWxsoWc4VZbnYT9AW5pYvhz4Rn3GCxs5zGQG8m53lT2zhuOhrfC8UywlsbDCVFC2/K+W19Xfby33OXF5ZQxkXgqmJjz32uua9rrTfz728j6a8K6PqGn+KvGV5driz1C9gms23hg0a2kKMcA/L86PwcdM96s/EHVrPQfAniHUtQsU1SwtLCee4sZACtxGqEtGQQQQQCOR3rR0F2l0PTnd2kdreMl2bcWO0cknqay/iNcaVbeAPEc2uW0l5oqWE7X1vCSHkgCEyKpBU5K5HBH1Ff0DSqKrTjUXVJ/ek/1Pw6rD2cpQfRtfdf/I6IEkZP4UpoB446ds0VqSFFHejpSAUdRRQv3hRTGIaKOtFIQGk6Upo7UAcn4b0jUbPx34wvrmNl068+x/Y2MgIbZERJhc5XkjqBntmurrk/DZ1T/hPfGH2v7V/ZhFn9h83d5X+qPmeXnj72M4711oFAkZniX/kCXn+5/UV5hLbJLJFI0jAqBwEz0JPrXp/iX/kB3n/XP+orzIyIjKhdQ7YwCeuTgV+V8S4jHYbNKc8Am5+zadlfS+v/AA599k2GwOKy6UMe0oKomrvl1tpr+hgeIVIuLfnp/jXjJ8M6r/Zt6n9nzb3uInVcDJAEmT/48Pzr2fxGQ89uDnBH9a87/wCFh2xs7iZtKl/cypFtF4Odwfn/AFf+x+tfCcI4rOMPiMX/AGVh41buHNzS5bb2t663Pf4sw2U16WG/tOvKnZT5eWPNfa/6WH+JtKu7zwZYWcEDzXMZtt8a9V2wsG/IkCq+kaLe2/i2zupbZ0t0sYo2kPQN9lC4/wC+uPrW3q3iGDStDt9UNpJNHN5OIRMFK74y5y205xjHQVFa+K4L3W4NNSxkjaa2WfzWuAwXMAlxt2DPXHX3r0cLjeIFk+KhDCQdJuvzS59VdvnsuvK9u55eJweRPNsNOeKkqqVHlXLo7Jcl305uvY57X/D+o3Hia+nis5JYZIMLIuME+SB/PivL9asfidaapPDpStFp6ECJGNuCOBn73PXPWva9Q8aQadq09idPllaGPzDILkLu/d7+BsOPTrXjvi+X4h6/4jvL/QTJbaTMVMERuITtAUA8nB+8D2r9L4VxOc1qcKeOw8YUlThyyjK7fuq110utX5nwHEuGyilUnPB4hzquc+ZTjZL3m3Z9bPReQ7To/jr9jj+ys4g524axHc56++as+X8ff7z/APfVhVTT9I+ODWcZtriQQc7f39t6nPU+uasf2P8AHf8A5+X/APAi1r9C+8+Iun/z7G3Ufx4+zS+cXMW07vmsemOelYQi+L7fxH87Stu50f46C2lMtzJ5Ww7/APSLXp36Vh/2Z8Wh/wAvD/8Af6D/ABo+8Tt1dMz7xfiF/aEUer3YtcrkyEQNhc+iZ561ttLJFbZmlado1JLtgFvyAFfVHwk02SH4YaHJ4hhgfUxC32mWVUYlvMbGSOOmK6TVdL02bRr147S1YCNgSsS8H8q/Gs7zHF4urOLTVKMmutrp9X1fkfvHDmBwGX0ac0ouvKKfS9mvsrdLXfqfA5bcxLHknJpM19Qare6To11bW9xZBnuD8pigQhRnHOTUnh+70nX5J1trMRmF0VvMgQZ3bumCf7tef9VxXsPrPsnyWvfTa9vzPaec4L6x9V9p+8va2u9r9ux8uUgx7V9JDxbobWE1y1hJiKWOMr9nj5LByCPm/wBg/nWnql5pOlaNBqUlpvhn8raiwJuG9C4zz2AxW08BjacowlRacnZarV2v37GMM/y+pGc4VU1BXe+ivbt3PAfB/jm58MQ3dkxMum3gxLDn7jdnX3459R9BXi0iGMsjAqw4KnqK+4LPVtGvdWi05LI+bLCswZoEC4MYkwefQ4rxX4q/FW78JeOdT0q00nTXhthFteSI7jmJG5wQOpNfZ5DXxVKq8Bio2SjzK+tle3TofA8QrB4in/aOAtKTlyytonZb6rdfieafFL/kd7z/AK42/wD6IjqO+Ofhto3/AGEbn/0CKvQPGvxe1DQfElxZRaZp0yJHE4eaNix3RKx7+pplz8X9Qi8JafqY0vTTJPdTQmMxHaAqoQRz1+b9K+7srvU/OVUrckLQ7dV2ZxPw7VpE8Toil3bRbgBVGSfmj4FaHhXwT9keK91A/v1IeOBT9wjkEkd/avV/2fviNc+N/H40+802wghW1kmzBGcsRgYOSeOc/hX0t/ZVkpINrbbsgbdq5yen51+Z8UZxjMNVWBwkG/d5m1e9m2ui0WmrP1DhTL8HVjLH49pPm5YptWukn5XeuiPi7xBPkxR555dv6f1rHyB0r7G8RaXZHU4l+ywAMgGREp7muF/4SvQDaNOLCXaHVNvkR5yQT/e9q/MMvxeYZl7SOBwjqKDSb5orV6re25+p5hjMBlzg8bXVPmTaVnstHsuh86ZFFfTWr6jpWhQW881mGSY/L5cKE4xnnJHrUlhqek6lqd3ZQ2hEturMTJAgU4YKehPrVxxeZywkscsE/ZR5m3zR+y7S89GrbGUsdlscVHBPEr2krWVn9pXXS2q13PmHvSZGetfTFxrujwXOqwNaOzaeD5hECYbEixnHPqwP4Va+06SPD41n7J/o5Tds8lN/+s8v1x1561tVq5tRVOVTAtKo1GPvR1cldL5oxp5nlNZ1FDEpuCcpaS0UXZvboz5dyKMgH0r6Vj8QaLcXVhAti++8UFCYEwuWZeefVamv9W0jT9SWxmsiZSm8lIExjBOOT7VTnnEcQsK8DLncXJLnj8Kdm/vBZplMqDxKxS5FJRvaXxNXS26oyfgB8fxodvF4a8RO89qMJYXWQWj/AOmTEn7v9306cjGPdbT4raTduypb3oI5+ZE/+KryfRbnTddtHntrQIiuY2WSFAc4B7Z9a7zT/hHeWsjN/aEJDDoENd+BxMav1zDY6m6Vely2Td9Xr0028zxsdKpOrg8Rl8lOhU5uZ26La19Vrpojcl+K2k290sBtrws2ACETHP8AwKpbz4n6VZQh2gu8FtuERc/+hVz918JLya+jnF/CApU42HtUuofCq7vYBGL6FCGDcofQ/wCNe6oYH2mFvL3Wv3mr0f3emx4squZqljGoLmT/AHWi1X36/OxuRfE7S5bcTrBdAYJ5Rc/+hVFZfFXSr/eEt70bcfeRB1/4F7VlQfCy6hsxB9uhJCkZCGotM+Et3YiTdqEL7sdEPbNY8mF9jiXze8n7mr1V+vR6dzo9pj/b4RcvuOL9pto7addNexwfx68WeNvEcWnW/gPT722e3lZp7uY2gjmUqMBQ7luDnOVH414NqEPxm+2ym6cifjdk2foMdOOmK9c+Mfw7+KWhaqt74Y1xLnT7ltqWUXlxmAKi5JMnXLZPFeRajpXxiS8kF1cOZ+N37+3PYY6e1fqGSqmsDSVNt6a+vX8T8pz2VV5hV9tyJ30utbdPwKN5D8WRbSfaG/c4+bm16fhWJt+IH94/nBW1eab8VVtpDPcOYcfMPOg6Vh/YvHn/AD1f/v5FXtNep4cHHvA7D4TL4x/4WDpR1Qk2I83zP9V/zybH3eeuOlfUGi+KrPwy032qOZ/Pxt8pQemc5yR618vfCW38XRfEHSm1ORjY/vfMBeM/8snx0564r6Ug8Jy+KN3l3CQ+R13gnOf/ANVfm+dxwss3pRxrap8ur++23mfpmTTxkMlrSy+KlV5tEkrdL726HRD4q6UP+WF5/wB8J/8AFVjavr9v4juFurZJURU8siYAHIJPYn1qMfCe6/6CEP8A3yain8PS+GiLWSZZi48zcoIHp/SvJzWhkkMM5YGo3O63benXdJHo5NiOIqmLUcypKNKz1tFa9Nm2btr8StMsLaK3eG7LxII2KouMgY4+b2qR/irpRU/uLw/8AT/4qsNfhjdXyLci9iRZh5oUqcgHnFL/AMKnuhz9vhP/AAE16NPDcNumnKq+ayvrLe3+HueVVxXFvtZKFBct3b3Y7X069iPTtWi0O8jvZg7RR5DCMAtyCOhx610A+KulD/lheD/gCf8AxVc1FpT65KtlHIsTSn77DgYGf6VZ/wCFTXf/AEEIB/wE15eVUcmqUZPHzanfRXa06bJns51Xz+niIrLKalDlV9IvXru0W9Z8bWXiOBbW2iuFkRhKTKqgYAI7E+teZeJh/wAVYOP+YXc8/wDbKau9n8ETeGkF1LdRzhj5e1ARjPOf0rMnvtOhv/Kn+yfavIkf9/bCRvK2tu+YqeNobjPr61jUxmEyrHOrl1OVaHLa0dXd7vW2i6lRwuNzTK1TzScaNTnveVkrLZaN6s5nwn/yT7VP967/APRCVx3A0jTv+vuX+UVer2d9p8+mvPZm0Ngnm+b5VsFj+4C+5Noz8uOxqk2teHRbQn/iVeQ0jCP/AIl643/LnH7vg4K8/wCFcGXcT1aOJx01gK0uepzNKKvH93a0vPr6E4/hulWw+Cg8bSjyU+W7ekvfvdeXT1Oe+IAA1rSj0+Y/+hCsFIdZm8KeLE8Pu0ernyxCVYK3323YJ6Hbux7+lek6lfaZayQrf/ZPOZiIxcWwkbrzglTgZpdO1DTLpblNONnlSBKLa2ERzzjJCjPevFp8SVKHDccN9Sm1GK95xTp6VObX+79l+Z7FTh+nW4hlifrkE5Sfup2nrT5dPPr6HYfsqWPxHsvh7dDxtM53SZ0tNSZpLlU2jmRt2SmcbQcNwe22u6k8L+KPFOk6voviy/0eXR9RspbR/wCx7WWCcFxtJDSSOuNpb+Hriur8P/8AIC03/r2j/wDQRV+v3uhP2lGE7Wuk/vSZ+bVafJUlC97Nr8WAGAB6UfhRRXQZhRRRSAUdRRQvUUUwENFBopAHWjtQaOlAHKeHda1C+8d+L7C5ctp9kLP7GDGAF3xFnw2MtyB1JxXVCuY0DxNc6p428VaPLHEttpX2XyGRSHbzYyzbjnB5HGAPxrp+fSmJGb4m50O8/wCuZ/mK8vktklkjkMjKUxlQuehJ65rq/it8SPDXw/0RF8Q6xb6Y99mO2SXJaUjGcKoJwMjJ6DIyeRXJw3EVxFDLFNHJFMqvHIjgq6nowPcGvy3iavmGFzKnVwEW5ODWkb6X16H3eTUcvxWAnSx0kkpp6u2ttOvqYniEA3Vtz0/xrxkeGtVbTL5Bp9xva4iZV8s5IAlyf1H517L4jANxbjsR/WvPh8Q7Y2dxMdLmzDKkYH2sc7g/P+r/ANj9a+B4RxWcYfE4v+y8PGrdw5uaXLbe3rfU+i4tw2U16WG/tLESpWU+W0ea+1/S2g/xPpF7c+CrG1htnluY/su+JBllxCwbI9iQKq6Ro99B4xs7iS1ljt0sY0aVlIUMLUIRn13cfWtvVfENvpehW+qtZvKsxh2wiYKU3xlzltpzjGOgplr4ot7/AFuDTRZyRmW2ScTG4DAZhEuNuwZ646+/tXpYbG5/HJsVThhIOk3X5pc+qu3z2XXld7dzy8Tg8iebYac8VJVUqPKuXR2S5Lvpzdexzev6Hf3PiW+nhtJpIJICElVCQx8kDj8eK8s13wr8RRqtx/ZtxPaWXy+XCbkR7flGflPTnJ/GvcL/AMY22marcWJsJZTBHv8AMFyF3Hy9+MbDj06mvG/GGieNvFPiO81TRtTk0/TLgqYbY37jYAoU9FA5IJ6d6/SeFMVnNelCnjsNGFJU4csoyu3ZRtddLx19T4DiXDZTRqzqYPE81VznzKUbJe827PraWi8huneDPjPJZxtbatOsBztA1BR3Oe/rmrP/AAhPxt/6DFx/4MV/xqHT/hl8XrizjktvE0kcJztX+1JRjk9sVY/4VZ8Zf+hpk/8ABrL/AIV+hW8mfFc0f5ofcQXXgr40pbStLq9wYgpLD+0FPGOe9YQ8LfFP/oIzf+Bi/wCNdBdfC/4wR28rTeKJDGqksP7Vl5GOe1YX/CCfEr/oYJP/AAYyf4UcvkxOS/nh9x9c/CHS79vhVodprszvf+U3nSbwxz5jEc854xXU39qtpod8iEkFHb5jnk1yXwrTUtA+EehpqU4u9ShiKyyNIZNxMrfxHk8EV1FxeNeeH9QdgMqHTA9BX4ljoYv2daXN+59o9Lr4rvpufumXTwXtqEXH9/7KOtnblsuu3yPIPEPhm413UbC5hubaBLcgMs2/cfmB4wpFS+EPDc3hua6kuLq2nE0iFRBvJABbJOVHqKzfGOqXdjq+kx21zJAjkb1RsBvmHWpfh7qd3qNzfi7uZLgJJFt8w5xkvn+Q/KvZUMf/AGOpc8fZ8q0trbn737/geC6mXf244+zl7Xmet9L8na21vxKC/Dy8/sq7tjqFiHluIpVOZMYVZAR9zr84/Wt3XfDcureGLXTIbmBJ7c2+ZJC+xtkTI2MKT1I6gVxKeItTOiX032+cyLdQIrbzkArKSB9do/Kup8Uard2ngrT7mG4eK4kNrvlU4ZswsTz7nk+9eriqWae3wynVhfn00ej5evlY8nCVcp+r4p06U+VQ968lqufp2d9b9h2neD7nT/EdvqLXdrJDFbJEUTfuLCEIcZUDGR69K8c+LXwf1vxT4+1XVLOayW2n8rYssjK/yxIpyApHUGvUtG1m+uPGFnbyXUrwNaxu0bMSpP2cNnH15r51+PjuvxY17DEAeRjB/wCmCV0YGOIjmv8AtclJ+z0tppcnEvD1Mof1FOC9prza68uv6HS+NPg5rfiLxHcX9tPYpE8cSASysG+WNVPAX1BpLn4M65N4Q0/TFnsftEF3NOzGVtu1lQDB29flPauH+KLsPG16AxA8q3OM8f6iOmXzsPhvo53HnUbnv/sRV9zeN3ofDRhX5Ie+unTyfme3/s8fC/VvBfxCW+v5rSSF7WSFfs7sx3HB5yo4wp719OGKN2LMrhtytwwxkAgdq+M/2TSzfFU5Y4+wTd/dK+yHlxcFAgI3ouf94E1+RcRQx9XNpf2fLlape9ql7t5X3X4LU/UsjlgqWWL+01zp1fdsn8Vo22f4vQwfEAA1SDJwAi5J7cmvLl+HV6NOeA39jvMquOZcYAYf3PcV6j4gP/E2g/3B/M14sniTVf7Hkc6hP5gnRd285xtbj9K+J4JpZvUli/7NqwgueN+eLlrZ2tZq3U+m4zq5VTeG/tGlObcJW5ZJWV1e90/I7LxR4Xn12xtIILm3ia36tNvw3AHGFPp3xTtF8LzaXruoX0l1byxzo6qke/eMurDOVA6A96oeN9Xu9P0vTnt7iSF5Dl2RsFvlHWl8NaveXXinVYJrmSWCKKQrG5yqkSKBj8K6qVDPP9Wq841qfseWtdcr5vjfNZ3tq9uyOSrVyb/WGjCVGp7a9Kz5ly35Fy6WvotH3ZJd+Crm5v8AxBMt7ZqmoBvKDeZlczpJ83yeinp3rQ/4R2U+DF0X7Vbi4EW3zjv8snzt+Pu56e3Wud1DW9Qi1XxWiXkypbh/KUNwmLmNRj04JH41rHUrofDhb7z3+2GH/X5+Yn7Ttzn6cfSvVzGhxAqeB9riKTTqUuW0JK0uR8rfvapLfa7PMwFfIpVMb7OhUTVOpzXmtY8/vJaaNvbyILbwPcwX2k3D31m4tFAdU8zJIkZuMpjo3qKsav4SuNU11L9Lu1ij8rYUkL7gcEdlI7+tYdhr2otqmgRveTOkyqZFZuH/AHrjn14AFXPEerX1r4pW3hu5YYfJ3bFbjO09vwrarh+Iv7apxeIpe09jOz5JW5edXVr732fYxpV8h/sico0Kns/awTXOr83Jo722tuu5ueFdAl8O6fLBNcQXDvIXBg3YAwBzuUeldBo/j3Xpp2R9QZkC8Axp/hXKeBNRudS0md7md52WfaGkOSBtXivZrO+8FFiIv7O3gc7IR/hXk4eWIpZlm1PHpVKr9neUVaK087tXWm57ihSrYPKquBm6dJc/uSleUtXppZOz12OGvvHuvJqkUS6gwjJUEeWnOT9Kn1jx3rlvah4r9kbeBkRp0wfau0mvvBQuQJBpxmOMZhG725xUl1eeDlj/AH40/ZkY3xAjPPtX0arU/aYRui7RWqsvf81pr87nnzw1b2GPj9YV5vR3f7vyeunyscVa+Odbm00O18xfYTnYvJ59qr6J48165Mxl1Bn24x+7QevtXfR3fg/7ODGtgIsHpEMfyqOzvfBjB/s66cem7ZEB/Ssfaw9jio+yd5SVnb4Ndn27aWOlUKn1jBS9urRi7q/x+7a61173dz5v+KFv8YfFXiS4fR9YddDUo1rHHPFCVOxQ+cAMcsG6k15pqHhP4sxXki3OpzNMMbib1T247+mK+iv2hPD+s+J9L0ZPAOpR6bNDNI1y0Fw1vuQqNoyo55zXzxqHw++KEF3Ilz4ikeYY3MdSkPYY5x6V+mZM1PAUnGLWn3+fz3Py3PLxzCqp1IN36628vlsZ154Y+JyW0hn1CUxAfMPtanI/OsUaJ434/wBMfj/p4Fbt54H+IsVtI82vO8QGWX7fIc/hisU+FfGH/QXb/wAC3r2uXyZ4sHG3xw+4634R6V4pt/iFpcmo3LvaL5u9TMGB/dPjj64r6KvNdv8AQ9n2G4MHm534UHOOnUe5r53+Efh7xLZfEDS57/UWntE83zENwzA/unA4Pvj8q+pNDm0aHzjq4tiDt8r7Qob1zjj6V+dZxUhQzmjOpSdRKPw2u3v01P0fKqM8RkdanSrRpty+K/Klt103Oa/4TzXf+f8Ab/v2n+FWrXVrvWITNeTGeUNsDEAYHXHH1Ndgb3wZ/d07/vyP8KxNZk02W5VtK8kW+zDeQoC7sn9cYrz84xuHr4Vwp4N0nde84pfK6S3OrIsvxWGxqqVcfGqrP3VJv52bexhSeNNZtHaGK+ZIoiUVdi8AcDtTP+E713/n/b/v2n+Fdta3XhOO1hW5FiZwgEheIFt2Oc8dc1KbzwZzgafn/riP8K9WlmWEVKKeXyei15F23+H5njVsqxsq0pLNIpXenPLTXb4vkcjdX0+mRvcW8pimTGHABxng/wA6pDx5rv8Az/sP+2af4VtaW9nHfxNqJj+x87/OGV6HGR9cV0JvPBh/h04f9sR/hXjZLjKGHoSjUwjq3b1UU7eWqZ7uf4DE4nExlSxyopRSs5NX89Gt+5xNr4l1LWZjDeXRmiUbwu1RznGeB7muU8Tf8jaPQ6Xc/wDoqavUdauPD8lqo0oWn2neN3kRhW24Oeg6ZxXLTajp9vf+RcTww3PkPJh4mYmMKxbkKeMK3Gf51y4nM5YfMHicLg5N8tuRJJ67y6Kx0UMs9rlKw2LxsX79/aNtrfSN7t3Oa8JgnwDqnHe7/wDRCVyGf+JVpuR/y9y/yir1awv9PutOlurS5iNinm+YwiZQNqAvldvPykduaonxBoJtoXF1b+U8jIn+jP8AeG3PGz/aWvLy3iLHUsTjpxy6rJzqXaVvdfIlyvz6+hpj8hwdXD4KEswpx5Kdk3e0lz35l5X0Of8AH5A1nSh/tH/0IU/4d8z6yccb0/m9dRf6jptjcQRX08Mc0jYjEkTP3HcKaNO1HTr/AO0iwmikaNgJVjiZDk5wTlRnoa+dnneLfCjwP1Kpyezt7TTltzt3726ep7tPJ8MuJljFjIc/Pf2evNfktb1tr6H0r4f/AOQDpv8A17R/+gitCs/w/wD8gHTf+vaP/wBBFaFfv+D/AN2pf4Y/+ko/NcR/Hn6v82FFAorrOYPxooo7UAKvUUUDqKKYxKM0ho7UhC0Ck7UetAGXrnhfSfEthc2Wp2EN3a3RQzIwx5m0grkjBOCARVDSvhx4a0PRb7SLDSIbXTL4EXNshbbLkYOec9OK6M9BR2oC3U+efjN+yH4P8X6da3ell/DVzYklzaJ5izoSMqQx4IxwQe5yDxjX0fQLTRdK0zT7Z5UttPt4raIMAzbIxgZORzgeleu+Jf8AkCXn+5/UV5lgY6V+V8V5tjMuxtL6tOycX0T3dn+CPvMgynB5hhKn1mF/eXVrZXRz/iEYuLbvjr+deNDwzqzaZfINOut73ETKvlHJAEmT+o/OvZPEv+si+hrCT71fkGT8VV+GsRiPY0lP2ji9W1bl9PU++zrhqjxBSo+2qOHJzLRJ35tOvoc94m0q9u/BdjaQWss11GbbfCi5ZcQsDkexOKr6Tot/b+MLO5ls5ordLCNGldCFDC1CkZ9d3H1rrDxIPxpyjPXnitaPHWIo5fXwKoRtU9o27u69o23bppfTv1OatwbhquNo451pXpqnZWVn7NaffbX8DhvEHh/UrnxPfzQ2U8sEkOElVCVY+SBwfrxXl+tfDrx1danPLZ60+m2zEbLWS7miaPgZyoXAycn8a+hsn5OfSvlH4z+JdXsviZrkNvqt7BCjx7Y4rh1Vf3SdADX6rwNxbWzir/Z1Sioxp01qm7vl5Y9dNdz864w4Wp5XT+v0arcpzd00re9eWno9DtdO+EHxWubNHg8Y+XCcgJ/atyMcnPAX1qz/AMKW+Lf/AEOn/lWuv/ia8Ri8deJIkCp4h1VFHQLeyAD/AMep/wDwnvib/oY9W/8AA6X/AOKr9o0Py9U61t4/+Ans118HPivBbStL4z3RhSWX+1bo5GP92sH/AIVn8Q8f8jP/AOVC4/8Aia83PjvxK6MreIdVZSMEG9lIP/j1Qf8ACXa7/wBBrUf/AAKk/wAaTsg9lXezj/4Cfob8GNN1DSvhloNrqU/2q/jhYSzCQvvO9udx5PBArp9byNHvM55ibrXm/wAFLqa9+APhue4mkuJ3gYtLKxZmPnN1J5rto/8AkXNR/wC2lfimOwHNRrY/m/5eONvm9T9qwGY8uIoZc4a+yUub5LS3/BPL9Y/sP7XZnVDGLon9xv8ANz1H9zjr61J4dGi+bc/2MyeYJE80J5vX5tv3/wDgXSub8ef8h3Rvw/8AQxUvww/4/NS/67RfzevZWXf8I6xPtZfCtL6fHbbt19TwXmX/AAuPC+yh8TXNy+98De/fp6Fpf+EPGnT7WgNp50fmZW5/1mH2ds9N/T8e1a+rDRhoUA1BoTpSmHyc+bz+7Pl42/N93PX8ea8vH/Ivaj/1+W//AKBPXX+Mf+Sf6V9bP/0navTxWVKFfCx9tN887fFqvd3Xnr9x5WEzn2mHxc/q9NckL6R0fvbPuv1Nmz/4R46zCLRoTqXkr5e3zgfL8oY+8Nv3MdefxrxL4r6v4CtfH+px6zot/eamvlGaWFyEb90m3H7xf4cDpXomgf8AI92X/XlH/wCkq14B8fv+Ssa//wBsP/REddGCw31PNuTncv3d/ed+v5EYjEf2hlMnyqFqlvd937O7t111Oo8a6v8AD+DxJcR6romoXV8EiLywuQpBjUqP9aOi4HTt3pt1rHw+Xwlp7voeoNpjXUwihEh3LIFTeT+96EFe/auE+Kf/ACO97/1xt/8A0QlM1D/km+jf9hC6/wDQIq+4bd2fFRwy5IPmevn6nuP7PWo+DL34gqnh3Sbywvhays0tw5KmPjIH7xuc7e3rzX0+QxU/KxUdT2r4v/ZK/wCSrH/rwm/mlfYjc3r55/fQ/wDoJr8k4jyz+1c1cXPl5aXNot7N6bo/TslzP+xMsUuTn56qjq9rpa7GN4g51SHoMoo5+prgFbwcLF8G38jzF3cXP3sHHbPTNd7r3/ITt/8AcX+ZrweP/kBzf9fCf+gvXxXBOTrM5YuTxFSnyzivcly30er01fY+o4zzV5b9WSoU6l4y+OPNazW336np2u/2F9lt/wC1TF9nyfI3rLzx2289MdaNN/sRtUvfsPkjUQjCbb5ucbxu+98vXFc98Q/+QVpP+f4Vo8K/8jjrf/XOX/0aldNDIlU4Zr4v6zVXLGt7vP7r5Ztaq3W133ZyVc6ceIaOF+r09ZUlzcvvK8E9Hfpey7I27hfDf2rWhM0Hnjd9tyZ8/wCtXPQY/wBZt+7/ACzVv/iUf8IyNxi/sMR5X/W4x5vt8/3/APOK4fUv+Qz40+kn/pXFW4//ACStf+uH/t1XqZjw8qdLAP63WfPUpLWfw80G7x00a2T6I8rL8+dapjY/VaS5KdR6Q3tNK0tdU933ZcgXww11p5hMInwPsn+vzje2Oox97d1/lU2oHQP7VX7cYvt+w43CYHbg/wB3jpmuM0//AJC3hz/dX/0dJV/xT/yOS/8AXD/2Vq3q8OxWdU8P9bra0Zyvz+9pNKydtne7XfUwpcQN5RLEfVaX8WEbcnu6wve191sn2Ot0IaSLNv7G2tb+Yd4XzOGwOu/npjpW7pXw81+CV2ksNqkcHzozn/x6uI+G/wDyB7n/AK+P/ZRX08v3V/CvCpc+V5tmmXxm5qXInKbvJ2V9/wCtLH09GnSzbLsuzKcFBw52oxVo6trb/g7njN58PNfk1OKVbDMaspLedH2/4FU2reANeubZUjsNzbwf9bGOx/2q9h9aE5BzzzXurMqqnh6iS/cq0f8AgnNLJqDp4qk27V3eX/A/pnkNp4D12LThE9lhwpGPNT396h0b4e+ILPzvNsNobGP30Z9f9qvZe9D8Gs/rtT2VenZWqu79b30NVllF1sPVu70VaPpa2p8h/Er4NfFG78VXl/pviH+yNJnKCC3/ALTmj24jUN8iAgfMGPXvXnt38LPiNDqTRXfi4scjfIuoXDnGB6qM8e9e0/tra1qGjaV4SOn39zYmS9lVzbTNHvG1eDtIzVWQktk8kgEk9+K9nHcRYjLcsw8aEVzyurvZKLS27/gfneY4KP8AaVW/w6O1le8vM8qvfhhrUEIWXxvqkxbOeXC/l5hrltQ+HPiy2kY2+vvcwj+J7iRG/wC+ef517Zq/3Y/x/pWbXyeG4vzWlUjKpU50+jS/SzRlPBUXH3Y2+SOD+EvhrxHp/wAQNKuL7VDcWimXfF9pkfdmJwOCMHkivoi68O6hrrKbGDzhF9/51XGenUj0NfOHgjULo/tAwWv2mb7MJpwIfMOz/UOenTrX2F4EPy3v/AP/AGavrs3zOeHx1DHUY68idnrvf07n02R5bDMsqrYOu/dc+mm1v8jhP+Fe6/8A8+H/AJFT/wCKq1baPeaJF5F7D5MrHeF3Bsjpng+xr1zJ9TXEeNedSi/64j+bV4+Y8SYrMaDoVoxSunonfT5s9fLOE8FlGJWKoSk5Wa1atr8jk5fAut3btPFZbopSXQ+agyp5B60z/hXuv/8APh/5Gj/+Kr1vTDjSrL/rin8hVrJx1rthxfjoQVNQjZK2z7W7nnz4Ey6pUdVzndtvdd79jyW4sJ9Vja1to/NnkxtTcBnHJ5PHQVU/4V9r2P8AjwH/AH+j/wDiq6Pwp/yHrT6v/wCgNXoLH5jXBl/EGJyunKlRjFpu+qe7+a7HqZpwtg85qxrV5STSS0a2XyZ5BbeFtT0SQz3tr5MTDYG3q3zHnsT6GuT8TAnxaMDP/EruP/RU1e1eNSf7Ii5/5bD/ANBauMS7ngwI5pIweoRiK5cXxNUwuIeZ16ak2uWy032et9jWjwrSlgllWHqOMVLnu9dntpY4vwnkeANU473f/ohK48AnSdO4wPtcvP4RV7GbydpQ5nkLKDtYucj6U4ahdH/l5m4/6aGvncD4gwwtXF1vqzftZ89uZae5y22173OvF8CSxNHC0vrCXsocnwvX3+a++nY4Px8Cdb0oY53H/wBCFP8Ah2CZtZODjen83rtlu54YD5c0iZYH5WIolupplKyTSSKOQGYkV48+MYy4feTew1cOXm5v7zle1vluevDhKUc8/tf220ublt/d5d7/AD2Pobw//wAgLTf+vaP/ANBFaHSqGgf8gLTf+vaP/wBBFXj1r+mcH/u1L/DH/wBJR+N4j+PP1f5sdSUlBrsMBaKQ9aO1IBy/eFFIv3x9aKYj/9kA"/></td></tr><tr><td><img width="552" height="138" src="data:image/jpg;base64,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"/></td></tr></table></span></p></body></html>
""";
  int selectedIndex = 0;
  bool isLoading = false;

  List<MicroLearningModel> microLearningList = [
    MicroLearningModel(
      title: "Technology in Sustainable Urban Planning",
    ),
    MicroLearningModel(title: "Components of Eco-Conscious Cities"),
    MicroLearningModel(
      title: "Challenges in Urban Sustainability",
      questionType: MicrolearningTypes.question,
    ),
    MicroLearningModel(title: "Inspiring Action for Resilient Cities"),
  ];

  Future<void> save() async {
    CoCreateContentAuthoringModel coCreateContentAuthoringModel = widget.arguments.coCreateContentAuthoringModel;
    microLearningList.insert(
      2,
      MicroLearningModel(title: "Challenges in Urban Sustainability", questionType: MicrolearningTypes.question, quizQuestionModel: quizModel),
    );
    MicroLearningContentModel microLearningContentModel = MicroLearningContentModel(microLearningModelList: microLearningList);
    coCreateContentAuthoringModel.microLearningContentModel = microLearningContentModel;
    MyPrint.printOnConsole("mainMicroLearningModel:  ${coCreateContentAuthoringModel.microLearningContentModel?.microLearningModelList}");
    CourseDTOModel? courseDTOModel = coCreateContentAuthoringModel.courseDTOModel ?? coCreateContentAuthoringModel.newCurrentCourseDTOModel;

    if (courseDTOModel != null) {
      courseDTOModel.ContentName = coCreateContentAuthoringModel.title;
      courseDTOModel.Title = coCreateContentAuthoringModel.title;
      courseDTOModel.TitleName = coCreateContentAuthoringModel.title;

      courseDTOModel.ShortDescription = coCreateContentAuthoringModel.description;
      courseDTOModel.LongDescription = coCreateContentAuthoringModel.description;

      courseDTOModel.Skills = coCreateContentAuthoringModel.skills;

      courseDTOModel.thumbNailFileBytes = coCreateContentAuthoringModel.thumbNailImageBytes;

      courseDTOModel.microLearningContentModel = microLearningContentModel;

      if (!coCreateContentAuthoringModel.isEdit) {
        context.read<CoCreateKnowledgeProvider>().myKnowledgeList.setList(list: [courseDTOModel], isClear: false, isNotify: true);
      }
    }
  }

  Future<void> showMoreActions({required CourseDTOModel model, int index = 0, List<InstancyUIActionModel>? actions}) async {
    InstancyUIActions().showAction(
      context: context,
      actions: actions ?? getActionsList(model: model, index: index),
    );
  }

  List<InstancyUIActionModel> getActionsList({required CourseDTOModel model, int index = 0}) {
    List<InstancyUIActionModel> actions = [
      InstancyUIActionModel(
        text: "Regenerate All Pages",
        actionsEnum: InstancyContentActionsEnum.Regenerate,
        onTap: () {
          Navigator.pop(context);
        },
        iconData: InstancyIcons.regenerate,
      ),
      InstancyUIActionModel(
        text: "Regenerate this Page",
        actionsEnum: InstancyContentActionsEnum.RegenerateThisPage,
        onTap: () {
          Navigator.pop(context);
        },
        iconData: InstancyIcons.regenerate,
        // iconData: InstancyIcons.,
      ),
      InstancyUIActionModel(
        text: "Delete",
        actionsEnum: InstancyContentActionsEnum.Delete,
        onTap: () {
          Navigator.pop(context);
        },
        iconData: InstancyIcons.delete,
      ),
    ];

    return actions;
  }

  Future<void> onSaveAndExitPressed() async {
    await save();
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Future<void> onSaveAndViewPressed() async {
    await save();
  }

  void initialize() {
    // microLearningList = widget.arguments.coCreateContentAuthoringModel.mainMicroLearningModel?.microLearningModelList ?? [];
    mySetState();
    microLearningList.forEach((element) {
      MyPrint.printOnConsole("microLearningLists : ${element.questionType}");
    });
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: RefreshIndicator(
          onRefresh: () async {},
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: getBottomButton(),
            ),
            // bottomNavigationBar: Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: CommonButton(
            //     minWidth: double.infinity,
            //     onPressed: () {
            //       // onGenerateTap();
            //     },
            //     text: AppStrings.generateWithAI,
            //     fontColor: themeData.colorScheme.onPrimary,
            //   ),
            // ),
            appBar: AppConfigurations().commonAppBar(
              title: "",
              isAutomaticImplyLeading: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.clear),
                  ),
                )
              ],
            ),
            body: AppUIComponents.getBackGroundBordersRounded(
              context: context,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
                child: getMainWidget(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getMainWidget() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 10),
                child: Row(
                  children: List.generate(
                    microLearningList.length,
                    (index) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        height: 5,
                        decoration: BoxDecoration(
                          color: index == selectedIndex ? themeData.primaryColor : Styles.textFieldBorderColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
                onTap: () {
                  showMoreActions(model: CourseDTOModel());
                },
                child: const Icon(Icons.more_vert))
          ],
        ),
        Expanded(child: getPageView())
      ],
    );
  }

  Widget getBottomButton() {
    // if ((selectedIndex + 1) == microLearningList.length) {
    //   return CommonSaveExitButtonRow(
    //     onSaveAndExitPressed: onSaveAndExitPressed,
    //     onSaveAndViewPressed: onSaveAndViewPressed,
    //   );
    // }
    return Row(
      children: [
        Expanded(
          child: CommonButton(
            onPressed: () {
              if (selectedIndex == 0 || (selectedIndex + 1) == microLearningList.length) {
                onSaveAndExitPressed();
              } else {
                pageController.jumpToPage(selectedIndex - 1);
              }
            },
            text: selectedIndex == 0 || (selectedIndex + 1) == microLearningList.length ? "Save & Exit" : "Previous",
            fontColor: themeData.primaryColor,
            backGroundColor: themeData.colorScheme.onPrimary,
            borderColor: themeData.primaryColor,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: CommonButton(
            onPressed: () {
              pageController.jumpToPage(selectedIndex + 1);
              // onNextPressed();
            },
            text: "Next",
            fontColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget getPageView() {
    return PageView.builder(
      controller: pageController,
      onPageChanged: (int index) {
        selectedIndex = index;
        mySetState();
      },
      itemCount: microLearningList.length,
      itemBuilder: (BuildContext context, int index) {
        MyPrint.printOnConsole("microLearningList : ${microLearningList[index].questionType}");
        MicroLearningModel model = microLearningList[index];
        if (model.questionType == MicrolearningTypes.question) {
          return getQuizEditingWidget(model: quizModel, index: index);
        }
        return Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              microLearningList[index].title,
              style: TextStyle(fontSize: 22, color: themeData.primaryColor, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: getMainBody(
                htmlCode: defaultArticleScreen,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget getQuizEditingWidget({required QuizQuestionModel model, int index = 0}) {
    return MicroLearningQuizQuestionEditingWidget(
      questionModel: model,
      index: index,
      onPreviousClick: () {
        if (index != 0) {
          pageController.jumpToPage(index - 1);
        }
      },
      onNextClick: () {
        pageController.jumpToPage(index + 1);
      },
      // onSaveAndExitPressed: onSaveAndExitTap,
      // onSaveAndViewPressed: onSaveAndViewTap,
    );
  }

  Widget getMainBody({required String htmlCode}) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        maxHeight ??= constraints.maxHeight;
        return Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: HtmlEditor(
              controller: controller,
              htmlEditorOptions: HtmlEditorOptions(hint: 'Your text here...', shouldEnsureVisible: true, initialText: htmlCode
                  // initialText: widget.arguments.coCreateContentAuthoringModel.articleHtmlCode.checkNotEmpty ? widget.arguments.coCreateContentAuthoringModel.articleHtmlCode : defaultArticleScreen,
                  ),
              htmlToolbarOptions: HtmlToolbarOptions(
                  textStyle: themeData.textTheme.labelMedium,
                  dropdownIconSize: 20,
                  toolbarPosition: ToolbarPosition.aboveEditor,
                  toolbarType: ToolbarType.nativeScrollable,
                  onButtonPressed: (ButtonType type, bool? status, Function? updateStatus) {
                    print("button '${type.name}' pressed, the current selected status is $status");
                    return true;
                  },
                  onDropdownChanged: (DropdownType type, dynamic changed, Function(dynamic)? updateSelectedItem) {
                    print("dropdown '${type.name}' changed to $changed");
                    return true;
                  },
                  mediaLinkInsertInterceptor: (String url, InsertFileType type) {
                    print(url);
                    return true;
                  },
                  audioExtensions: ["audio"]
                  /*mediaUploadInterceptor: (PlatformFile file, InsertFileType type) async {
          print(file.name); //filename
          print(file.size); //size in bytes
          print(file.extension); //file extension (eg jpeg or mp4)
          return true;
        },*/
                  ),
              otherOptions: OtherOptions(height: maxHeight!),
              callbacks: Callbacks(
                onBeforeCommand: (String? currentHtml) {
                  print('html before change is $currentHtml');
                },
                onChangeContent: (String? changed) {
                  print('content changed to $changed');
                },
                onChangeCodeview: (String? changed) {
                  print('code changed to $changed');
                },
                onChangeSelection: (EditorSettings settings) {
                  print('parent element is ${settings.parentElement}');
                  print('font name is ${settings.fontName}');
                },
                onDialogShown: () {
                  print('dialog shown');
                },
                onEnter: () {
                  print('enter/return pressed');
                },
                onFocus: () {
                  print('editor focused');
                },
                onBlur: () {
                  print('editor unfocused');
                },
                onBlurCodeview: () {
                  print('codeview either focused or unfocused');
                },
                onInit: () {
                  print('init');
                },
                //this is commented because it overrides the default Summernote handlers
                /*onImageLinkInsert: (String? url) {
          print(url ?? "unknown url");
        },
        onImageUpload: (FileUpload file) async {
          print(file.name);
          print(file.size);
          print(file.type);
          print(file.base64);
        },*/
                onImageUploadError: (FileUpload? file, String? base64Str, UploadError error) {
                  print(error.name);
                  print(base64Str ?? '');
                  if (file != null) {
                    print(file.name);
                    print(file.size);
                    print(file.type);
                  }
                },
                onKeyDown: (int? keyCode) {
                  print('$keyCode key downed');
                  print('current character count: ${controller.characterCount}');
                },
                onKeyUp: (int? keyCode) {
                  print('$keyCode key released');
                },
                onMouseDown: () {
                  print('mouse downed');
                },
                onMouseUp: () {
                  print('mouse released');
                },
                onNavigationRequestMobile: (String url) {
                  print(url);
                  return NavigationActionPolicy.ALLOW;
                },
                onPaste: () {
                  print('pasted into editor');
                },
                onScroll: () {
                  print('editor scrolled');
                },
              ),
              plugins: [
                SummernoteAtMention(
                  getSuggestionsMobile: (String value) {
                    var mentions = <String>['test1', 'test2', 'test3'];
                    return mentions.where((element) => element.contains(value)).toList();
                  },
                  mentionsWeb: ['test1', 'test2', 'test3'],
                  onSelect: (String value) {
                    print(value);
                  },
                ),
              ],
            ));
      },
    );
  }
}

class MicroLearningQuizQuestionEditingWidget extends StatefulWidget {
  final QuizQuestionModel questionModel;
  final int index;
  final void Function()? onPreviousClick;
  final void Function()? onNextClick;
  final void Function()? onSaveAndExitPressed;
  final void Function()? onSaveAndViewPressed;

  const MicroLearningQuizQuestionEditingWidget({
    super.key,
    required this.questionModel,
    required this.index,
    this.onPreviousClick,
    this.onNextClick,
    this.onSaveAndExitPressed,
    this.onSaveAndViewPressed,
  });

  @override
  State<MicroLearningQuizQuestionEditingWidget> createState() => _MicroLearningQuizQuestionEditingWidgetState();
}

class _MicroLearningQuizQuestionEditingWidgetState extends State<MicroLearningQuizQuestionEditingWidget> with MySafeState {
  late QuizQuestionModel questionModel;
  late int index;

  TextEditingController correctFeedbackController = TextEditingController();
  TextEditingController incorrectFeedbackController = TextEditingController();

  void save() {
    questionModel.correctFeedback = correctFeedbackController.text;
    questionModel.inCorrectFeedback = incorrectFeedbackController.text;
  }

  void onNextPressed() {
    save();
    widget.onNextClick?.call();
  }

  void onPreviousPressed() {
    save();
    widget.onPreviousClick?.call();
  }

  void onSaveAndExitPressed() {
    save();
    widget.onSaveAndExitPressed?.call();
  }

  void onSaveAndViewPressed() {
    save();
    widget.onSaveAndViewPressed?.call();
  }

  @override
  void initState() {
    super.initState();

    questionModel = widget.questionModel;
    index = widget.index;

    correctFeedbackController.text = questionModel.correctFeedback;
    incorrectFeedbackController.text = questionModel.inCorrectFeedback;
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  getQuestionWidget(questionModel: questionModel, index: index),
                  const SizedBox(
                    height: 10,
                  ),
                  getAnswerList(questionModel.choices, questionModel, index),
                  const SizedBox(
                    height: 20,
                  ),
                  getCorrectAnswerWidget(optionList: questionModel.choices, answer: questionModel.correct_choice, questionModel: questionModel),
                  const SizedBox(
                    height: 10,
                  ),
                  getCorrectFeedback(),
                  const SizedBox(
                    height: 10,
                  ),
                  getInCorrectFeedback(),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          // getBottomButton(index),
        ],
      ),
    );
  }

  Widget getQuestionWidget({required QuizQuestionModel questionModel, int index = 0}) {
    return InkWell(
      onLongPress: () {
        questionModel.isQuestionEditable = true;
        mySetState();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: questionModel.isQuestionEditable
            ? getEditableTextField(
                controller: TextEditingController(text: questionModel.question),
                onSubmitted: (String? val) {
                  if (val == null) return null;
                  questionModel.question = val;
                  questionModel.isQuestionEditable = false;
                  mySetState();
                  return "";
                },
              )
            : Text(
                questionModel.question,
                style: const TextStyle(fontSize: 16),
              ),
      ),
    );
  }

  Widget getCorrectAnswerWidget({required QuizQuestionModel questionModel, required List<String> optionList, required String? answer}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Correct Answer",
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(
          height: 10,
        ),
        getCommonDropDown(
          list: optionList,
          value: answer,
          hintText: "Correct Answer",
          onChanged: (val) {
            answer = val;
            questionModel.correct_choice = val ?? "";
            mySetState();
          },
          iconUrl: "assets/cocreate/commonText.png",
        ),
      ],
    );
  }

  Widget getCommonDropDown({
    required String? value,
    required List<String> list,
    required ValueChanged<String?> onChanged,
    required String hintText,
    double iconHeight = 15,
    double iconWidth = 15,
    String iconUrl = "",
  }) {
    return CommonBorderDropdown<String>(
      isExpanded: true,
      isDense: false,
      items: list,
      value: value,
      hintText: hintText,
      onChanged: onChanged,
    );
  }

  Widget getCorrectAndIncorrectAnswerWidget(
    QuizQuestionModel questionModel,
  ) {
    if (!questionModel.isAnswerGiven) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (questionModel.selectedAnswer != questionModel.correct_choice)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Incorrect Answer",
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
          ),
        const SizedBox(
          height: 6,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Correct Answer${questionModel.selectedAnswer != questionModel.correct_choice ? ":" : ""}",
            style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        if (questionModel.selectedAnswer != questionModel.correct_choice)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              questionModel.correct_choice,
              style: const TextStyle(fontSize: 14),
            ),
          ),
      ],
    );
  }

  Widget getAnswerList(List<String> answerList, QuizQuestionModel questionModel, int quizListIndex) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      itemCount: answerList.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: questionModel.isAnswerGiven
              ? null
              : () {
                  questionModel.selectedAnswer = answerList[index];
                  mySetState();
                },
          onLongPress: () {
            questionModel.isEditModeEnable = [false, false, false, false];
            questionModel.isEditModeEnable[index] = true;
            mySetState();
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              // border: Border.all(
              //   color: isSelected ? themeData.primaryColor : const Color(0xffDCDCDC),
              // ),
            ),
            child: questionModel.isEditModeEnable[index]
                ? getEditableTextField(
                    controller: TextEditingController(text: answerList[index]),
                    onSubmitted: (String? val) {
                      if (answerList[index] == questionModel.correct_choice) {
                        questionModel.correct_choice = val ?? "";
                      }
                      answerList[index] = val ?? "";
                      questionModel.choices[index] = val ?? "";
                      MyPrint.printOnConsole("questionModel.optionList[index] : ${questionModel.choices[index]}");
                      questionModel.isEditModeEnable[index] = false;
                      mySetState();
                      return "";
                    },
                  )
                : Text(
                    answerList[index],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget getEditableTextField({
    required TextEditingController controller,
    required String? Function(String?)? onSubmitted,
  }) {
    return getTexFormField(
        isMandatory: false,
        showPrefixIcon: false,
        isHintText: true,
        controller: controller,
        labelText: "Correct Feedback",
        keyBoardType: TextInputType.text,
        iconUrl: "assets/cocreate/commonText.png",
        minLines: 1,
        maxLines: 1,
        onSubmitted: onSubmitted);
  }

  Widget getCorrectFeedback() {
    return getTexFormField(
      isMandatory: false,
      showPrefixIcon: false,
      controller: correctFeedbackController,
      labelText: "Correct Feedback",
      keyBoardType: TextInputType.text,
      iconUrl: "assets/cocreate/commonText.png",
      minLines: 3,
      maxLines: 3,
    );
  }

  Widget getInCorrectFeedback() {
    return getTexFormField(
      isMandatory: false,
      showPrefixIcon: false,
      controller: incorrectFeedbackController,
      labelText: "Incorrect Feedback",
      keyBoardType: TextInputType.text,
      iconUrl: "assets/cocreate/commonText.png",
      minLines: 3,
      maxLines: 3,
    );
  }

  //region textFieldView
  Widget getTexFormField({
    TextEditingController? controller,
    String iconUrl = "",
    String? Function(String?)? validator,
    String? Function(String?)? onSubmitted,
    String labelText = "Label",
    Widget? suffixWidget,
    required bool isMandatory,
    int? minLines,
    int? maxLines,
    bool showPrefixIcon = false,
    bool isHintText = false,
    TextInputType? keyBoardType,
    double iconHeight = 15,
    double iconWidth = 15,
  }) {
    return CommonTextFormFieldWithLabel(
      controller: controller,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      label: isMandatory ? labelWithStar(labelText) : null,
      isHintText: isHintText,
      labelText: isMandatory ? null : labelText,
      validator: validator,
      floatingLabelColor: Colors.black.withOpacity(.6),
      minLines: minLines,
      maxLines: maxLines,
      borderColor: Styles.borderColor,
      enabledBorderColor: Styles.borderColor,
      focusColor: Styles.borderColor,
      borderWidth: 1,
      isOutlineInputBorder: true,
      keyboardType: keyBoardType,
      onSubmitted: onSubmitted,
      // prefixWidget: showPrefixIcon
      //     ? iconUrl.isNotEmpty
      //     ? getImageView(url: iconUrl, height: iconHeight, width: iconWidth)
      //     : const Icon(
      //   FontAwesomeIcons.globe,
      //   size: 15,
      //   color: Colors.grey,
      // )
      //     : null,
      suffixWidget: suffixWidget,
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
