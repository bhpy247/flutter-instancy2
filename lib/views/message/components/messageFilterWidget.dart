import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/message/message_provider.dart';

import '../../../backend/message/message_controller.dart';
import '../../../configs/app_constants.dart';
import '../../common/components/instancy_ui_actions/bottomsheet_drager.dart';

class MessageFilterWidget extends StatelessWidget {
  const MessageFilterWidget({super.key, required this.messageProvider});

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
            title: Text("Message Filters"),
          ),
          ListView(
            padding: EdgeInsets.all(10),
            shrinkWrap: true,
            children: MessageFilterType.values.map((e) {
              return InkWell(
                onTap: () {
                  Navigator.pop(context);
                  messageProvider.selectedMessageFilter.set(value: e, isNotify: true);
                  MessageController(provider: messageProvider).setSelectedFilterRole(selectedFilterRole: messageProvider.selectedFilterRole.get(), selectedMessageFilter: e);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: messageProvider.selectedMessageFilter.get() == e ? Colors.grey[100] : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        messageProvider.selectedMessageFilter.get() == e
                            ? const Icon(
                                Icons.check,
                                size: 23,
                              )
                            : const Icon(Icons.check, color: Colors.transparent, size: 23),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          e,
                          style: TextStyle(fontSize: 17),
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
