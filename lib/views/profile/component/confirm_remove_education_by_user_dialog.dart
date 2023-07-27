import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/local_str.dart';
import 'package:flutter_instancy_2/views/common/components/common_confirmation_dialog.dart';
import 'package:provider/provider.dart';

class ConfirmRemoveEducationByUserDialog extends StatelessWidget {
  final LocalStr? localStr;

  const ConfirmRemoveEducationByUserDialog({
    Key? key,
    this.localStr,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalStr localStrNew = localStr ?? context.read<AppProvider>().localStr;

    return CommonConfirmationDialog(
      title: localStrNew.asktheexpertActionsheetDeleteoption,
      description: localStrNew.profileAlertsubtitleDeleteeducation,
      confirmationText: localStrNew.profileAlertbuttonDeletebutton,
    );
  }
}
