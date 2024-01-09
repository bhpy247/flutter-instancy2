import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/backend/my_learning/my_learning_controller.dart';
import 'package:flutter_instancy_2/models/my_learning/response_model/page_notes_response_model.dart';

import '../../common/components/common_button.dart';
import '../../common/components/common_loader.dart';

class NotesDialog extends StatefulWidget {
  final PageNotesResponseModel? pageNotesResponseModel;
  final String contentId;
  final int componentId, componentInsId;
  final MyLearningController? myLearningController;

  const NotesDialog({
    Key? key,
    this.pageNotesResponseModel,
    this.contentId = "",
    this.myLearningController,
    this.componentId = 0,
    this.componentInsId = 0,
  }) : super(key: key);

  @override
  State<NotesDialog> createState() => _NotesDialogState();
}

class _NotesDialogState extends State<NotesDialog> {
  Future? getNotes;

  TextEditingController notesController = TextEditingController();
  PageNotesResponseModel? pageNotesResponseModel;

  Future<void> getNotesData() async {
    pageNotesResponseModel = await widget.myLearningController?.getAllUserPageNotes(
      contentId: widget.contentId,
      componentId: widget.componentId,
      componentInstanceId: widget.componentInsId,
    );
    setState(() {});
  }

  late ThemeData themeData;

  @override
  void initState() {
    super.initState();
    getNotes = getNotesData();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Notes",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                minLines: 4,
                maxLines: 4,
                controller: notesController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Type your notes"),
              ),
              const SizedBox(
                height: 10,
              ),
              CommonButton(
                onPressed: () async {
                  await widget.myLearningController?.savePageNote(contentID: widget.contentId, text: notesController.text.trim());
                  notesController.clear();
                  getNotes = getNotesData();
                  setState(() {});
                },
                text: "Submit",
              ),
              const Divider(),
              Text(
                pageNotesResponseModel?.name ?? "",
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              Container(
                child: FutureBuilder(
                  future: getNotes,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: pageNotesResponseModel?.userNotes.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: pageNotesResponseModel!.userNotes[index].isEditEnabled
                                  ? editEnabledView(TextEditingController(text: pageNotesResponseModel?.userNotes[index].userNotesText),
                                      index: index, userNotes: pageNotesResponseModel?.userNotes[index])
                                  : Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(pageNotesResponseModel?.userNotes[index].userNotesText ?? ""),
                                              Text(pageNotesResponseModel?.userNotes[index].noteDate ?? ""),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            pageNotesResponseModel!.userNotes[index].isEditEnabled = true;
                                            setState(() {});
                                          },
                                          child: const Icon(
                                            Icons.edit,
                                            size: 15,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            UserNotes userNotes = pageNotesResponseModel!.userNotes[index];
                                            widget.myLearningController!.deletePageNotes(
                                              contentID: widget.contentId,
                                              trackId: userNotes.trackID,
                                              seqId: ParsingHelper.parseIntMethod(userNotes.sequenceID),
                                              pageId: ParsingHelper.parseIntMethod(userNotes.pageID),
                                              count: ParsingHelper.parseIntMethod(userNotes.noteCount),
                                            );
                                            pageNotesResponseModel!.userNotes.removeAt(index);

                                            setState(() {});
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            size: 15,
                                          ),
                                        )
                                      ],
                                    ),
                            );
                          });
                    } else {
                      return const CommonLoader();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget editEnabledView(TextEditingController controller, {UserNotes? userNotes, int index = 0}) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        InkWell(
            onTap: () {
              if (userNotes != null) {
                widget.myLearningController!.savePageNote(
                    contentID: widget.contentId,
                    text: controller.text.trim(),
                    trackId: userNotes.trackID,
                    seqId: ParsingHelper.parseIntMethod(userNotes.sequenceID),
                    pageId: ParsingHelper.parseIntMethod(userNotes.pageID),
                    count: ParsingHelper.parseIntMethod(userNotes.noteCount));

                userNotes.userNotesText = controller.text;
                userNotes.isEditEnabled = false;
                setState(() {});
              }
            },
            child: Icon(
              Icons.check,
              color: themeData.primaryColor,
            ))
      ],
    );
  }
}
