import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/mmy_toast.dart';
import 'package:flutter_instancy_2/backend/Catalog/catalog_controller.dart';
import 'package:flutter_instancy_2/models/catalog/response_model/user_coming_soon_response.dart';

import '../../common/components/common_loader.dart';

class CommentDialog extends StatefulWidget {
  final String contentId;
  final CatalogController? catalogController;

  const CommentDialog({
    Key? key,
    this.contentId = "",
    this.catalogController,
  }) : super(key: key);

  @override
  State<CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  Future? getFuture;

  TextEditingController notesController = TextEditingController();
  UserComingSoonResponse? userComingSoonResponse;

  Future<void> getUserComingSoonResponse() async {
    userComingSoonResponse = await widget.catalogController?.getComingResponseTable(
      contentId: widget.contentId,
    );
    if ((userComingSoonResponse?.table ?? []).isNotEmpty) {
      notesController.text = userComingSoonResponse?.table.first.comingSoonResponse ?? "";
    }
  }

  Future<void> createUserComingSoon() async {
    if (formKey.currentState?.validate() ?? false) {
      bool isUpdate = false;
      if ((userComingSoonResponse?.table ?? []).isNotEmpty) {
        ComingSoonResponseTable comingSoonResponseTable = (userComingSoonResponse?.table ?? []).first;
        isUpdate = comingSoonResponseTable.comingSoonResponse.isEmpty ? false : true;
      }
      userComingSoonResponse = await widget.catalogController?.createUpdateUserComingSoonResponse(
        contentId: widget.contentId,
        text: notesController.text.trim(),
        isUpdate: isUpdate,
      );
      if ((userComingSoonResponse?.table ?? []).isNotEmpty) {
        if (context.mounted) {
          MyToast.showSuccess(context: context, msg: "Thank you for your interest");
        }
      }
      if (context.mounted) Navigator.pop(context);
    }
  }

  late ThemeData themeData;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getFuture = getUserComingSoonResponse();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return FutureBuilder(
        future: getFuture,
        builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.done) {
            return AlertDialog(
              title: Container(
                child: const Text(
                  "Comments",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              content: Form(
                key: formKey,
                child: TextFormField(
                  minLines: 4,
                  maxLines: 4,
                  validator: (String? val) {
                    if (val == null || val.isEmpty) {
                      return "Please enter the comment";
                    }
                    return null;
                  },
                  controller: notesController,
                  decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Type your Comment"),
                ),
              ),
              actionsAlignment: MainAxisAlignment.end,
              actionsOverflowDirection: VerticalDirection.up,
              actions: [
                MaterialButton(
                    onPressed: () {
                      createUserComingSoon();
                    },
                    color: themeData.primaryColor,
                    child: const Text(
                      "Send",
                      style: TextStyle(color: Colors.white),
                    )),
                MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: themeData.primaryColor),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: themeData.primaryColor),
                    ))
              ],
            );
          } else {
            return const CommonLoader();
          }
        });
  }
}
