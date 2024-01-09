import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/my_print.dart';
import 'package:flutter_chat_bot/view/common/components/bottom_sheet_dragger.dart';
import 'package:flutter_instancy_2/backend/discussion/discussion_provider.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/forum_info_user_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../configs/app_configurations.dart';
import '../../../utils/my_safe_state.dart';
import '../../../utils/my_utils.dart';
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
  TextEditingController searchController = TextEditingController();

  bool checkIsModeratorSelected(int UserId) {
    bool isSelected = false;
    for (var element in selectedModeratorList) {
      if (element.UserID == UserId) {
        isSelected = true;
        break;
      }
    }
    return isSelected;
  }

  @override
  void initState() {
    super.initState();
    selectedModeratorList.addAll(widget.selectedModeratorList.map((e) => ForumUserInfoModel.fromJson(e.toJson())).toList());
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
              getBottomButton()
            ],
          );
        },
      ),
    );
  }

  Widget getBottomButton() {
    if (searchController.text.checkNotEmpty) {
      if (searchedList.checkEmpty) {
        return SizedBox();
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: CommonButton(
        onPressed: () {
          Navigator.pop(context, selectedModeratorList);
        },
        text: "Done",
        fontColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        fontSize: 16,
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
        controller: searchController,
        contentPadding: EdgeInsets.zero,
        hintText: "Search",
        suffixWidget: Visibility(
          visible: searchController.text.checkNotEmpty,
          child: InkWell(
              onTap: () {
                searchController.clear();
                mySetState();
              },
              child: Icon(Icons.clear)),
        ),
        prefixWidget: Icon(Icons.search),
      ),
    );
  }

  Widget getModeratorList({required List<ForumUserInfoModel> modelList}) {
    if (searchController.text.checkNotEmpty) {
      if (searchedList.checkEmpty) {
        return Center(
          child: AppConfigurations.commonNoDataView(height: 150, width: 150, sizeBetweenImageAndText: 10),
        );
      }
    }
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.grey, width: .5)),
      child: ListView.builder(
        padding: const EdgeInsets.all(17),
        shrinkWrap: true,
        itemCount: modelList.length,
        itemBuilder: (BuildContext context, int index) {
          ForumUserInfoModel model = modelList[index];
          return getSingleItem(model: model, index: index);
        },
      ),
    );
  }

  Widget getSingleItem({required ForumUserInfoModel model, int index = 0}) {
    String profileImageUrl = MyUtils.getSecureUrl(
      AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(
        imagePath: model.UserThumb,
      ),
    );
    return InkWell(
      onTap: () {
        MyPrint.printOnConsole("model : ${index}");
        if (checkIsModeratorSelected(model.UserID)) {
          selectedModeratorList.removeWhere((element) => element.UserID == model.UserID);
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
                  imageUrl: profileImageUrl,
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
                // selectedModeratorList.contains(model) ? FontAwesomeIcons.solidSquareMinus : FontAwesomeIcons.solidSquarePlus,
                checkIsModeratorSelected(model.UserID) ? FontAwesomeIcons.solidSquareMinus : FontAwesomeIcons.solidSquarePlus,
                size: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
