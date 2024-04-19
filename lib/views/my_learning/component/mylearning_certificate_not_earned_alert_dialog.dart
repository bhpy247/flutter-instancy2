import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/local_str.dart';
import 'package:provider/provider.dart';

class MyLearningCertificateNotEarnedAlertDialog extends StatelessWidget {
  final LocalStr? localStr;

  const MyLearningCertificateNotEarnedAlertDialog({
    super.key,
    this.localStr,
  });

  @override
  Widget build(BuildContext context) {
    LocalStr localStrNew = localStr ?? context.read<AppProvider>().localStr;

    return AlertDialog(
      title: Text(
        localStrNew.mylearningActionsheetViewcertificateoption,
        // style: TextStyle(color: InsColor(appBloc).appTextColor, fontWeight: FontWeight.bold),
      ),
      content: Text(
        localStrNew.mylearningAlertsubtitleForviewcertificate,
        // style: TextStyle(color: InsColor(appBloc).appTextColor, fontWeight: FontWeight.normal),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(localStrNew.mylearningClosebuttonactionClosebuttonalerttitle),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
