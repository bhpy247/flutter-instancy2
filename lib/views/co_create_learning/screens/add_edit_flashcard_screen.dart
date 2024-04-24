import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_arguments.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/co_create_learning/screens/flash_card_screen.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';

class AddEditFlashcardScreen extends StatefulWidget {
  static const String routeName = "/AddEditFlashcardScreen";

  final AddEditFlashcardScreenNavigationArguments arguments;

  const AddEditFlashcardScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<AddEditFlashcardScreen> createState() => _AddEditFlashcardScreenState();
}

class _AddEditFlashcardScreenState extends State<AddEditFlashcardScreen> with MySafeState {
  bool isLoading = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<String> skills = <String>[];
  String thumbnailImageUrl = "";

  List<QuestionAnswerModel> questionList = [];

  // Future<>

  @override
  void initState() {
    super.initState();
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
            appBar: AppConfigurations().commonAppBar(title: widget.arguments.courseDTOModel != null ? "Edit Flashcard" : "Add Flashcard"),
            body: Column(
              children: [
              ],
            ),
          ),
        ),
      ),
    );
  }
}
