import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/view/common/components/bottom_sheet_dragger.dart';
import 'package:flutter_instancy_2/backend/discussion/discussion_provider.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/forum_info_user_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../utils/my_safe_state.dart';
import '../../common/components/common_text_form_field.dart';

class ModeratorBottomSheet extends StatefulWidget {
  final List<ForumUserInfoModel> selectedModeratorList;

  ModeratorBottomSheet({super.key, required this.selectedModeratorList});

  @override
  State<ModeratorBottomSheet> createState() => _ModeratorBottomSheetState();
}

class _ModeratorBottomSheetState extends State<ModeratorBottomSheet> with MySafeState {
  List<ForumUserInfoModel> selectedModeratorList = [];
  List<ForumUserInfoModel> searchedList = [];

  @override
  void initState() {
    super.initState();
    selectedModeratorList = widget.selectedModeratorList;
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      body: Consumer<DiscussionProvider>(
        builder: (context, DiscussionProvider provider, _) {
          List<ForumUserInfoModel> userList = provider.moderatorsList.getList();
          return Column(
            children: [
              const BottomSheetDragger(),
              getSearchTextFromField(userList),
              Expanded(
                child: getModeratorList(modelList: searchedList.isEmpty ? userList : searchedList),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: CommonButton(
                  onPressed: () {
                    Navigator.pop(context, selectedModeratorList);
                  },
                  text: "Done",
                  fontColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  fontSize: 16,
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget getSearchTextFromField(List<ForumUserInfoModel> userList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: CommonTextFormField(
        isOutlineInputBorder: true,
        onChanged: (String? val) {
          if (val == null) return;
          searchedList = userList.where((element) => element.UserName.toLowerCase().contains(val.toLowerCase())).toList();
          mySetState();
        },
        borderRadius: 6,
        contentPadding: EdgeInsets.zero,
        hintText: "Search",
        prefixWidget: Icon(Icons.search),
      ),
    );
  }

  Widget getModeratorList({required List<ForumUserInfoModel> modelList}) {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.grey, width: .5)),
      child: ListView.builder(
        padding: const EdgeInsets.all(17),
        shrinkWrap: true,
        itemCount: modelList.length,
        itemBuilder: (BuildContext context, int index) {
          ForumUserInfoModel model = modelList[index];
          return getSingleItem(model: model);
        },
      ),
    );
  }

  Widget getSingleItem({required ForumUserInfoModel model}) {
    return InkWell(
      onTap: () {
        if (selectedModeratorList.contains(model)) {
          selectedModeratorList.remove(model);
        } else {
          selectedModeratorList.add(model);
        }
        mySetState();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14.0),
        child: Row(
          children: [
            if (model.UserThumb.checkNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CommonCachedNetworkImage(
                  placeholder: null,
                  errorWidget: (context, url, error) {
                    return Container();
                  },
                  imageUrl: model.UserThumb,
                  height: 40,
                  width: 40,
                ),
              ),
            const SizedBox(
              width: 10,
            ),
            Text(model.UserName),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Icon(
                selectedModeratorList.contains(model) ? FontAwesomeIcons.solidSquareMinus : FontAwesomeIcons.solidSquarePlus,
                size: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
