import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/message/message_controller.dart';
import 'package:flutter_instancy_2/backend/message/message_provider.dart';

import '../../../configs/app_constants.dart';
import '../../common/components/instancy_ui_actions/bottomsheet_drager.dart';

class RoleFilterWidget extends StatelessWidget {
  const RoleFilterWidget({super.key, required this.messageProvider});

  final MessageProvider messageProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.,
        children: [
          const BottomSheetDragger(),
          AppBar(
            // backgroundColor: Colors.transparent,
            elevation: 2,
            centerTitle: false,
            title: const Text("Role Filters"),
          ),
          ListView(
            padding: const EdgeInsets.all(10),
            shrinkWrap: true,
            children: RoleFilterType.values.map((e) {
              return InkWell(
                onTap: () {
                  Navigator.pop(context);
                  messageProvider.selectedFilterRole.set(value: e, isNotify: true);
                  MessageController(provider: messageProvider).setSelectedFilterRole(selectedFilterRole: e, selectedMessageFilter: messageProvider.selectedMessageFilter.get());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: messageProvider.selectedFilterRole.get() == e ? Colors.grey[100] : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        messageProvider.selectedFilterRole.get() == e
                            ? const Icon(
                                Icons.check,
                                size: 23,
                              )
                            : const Icon(Icons.check, color: Colors.transparent, size: 23),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          e,
                          style: const TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
