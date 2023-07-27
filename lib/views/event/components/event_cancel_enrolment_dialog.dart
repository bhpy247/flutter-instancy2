import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/local_str.dart';
import 'package:provider/provider.dart';

class EventCancelEnrollmentDialog extends StatelessWidget {
  final LocalStr? localStr;

  const EventCancelEnrollmentDialog({
    Key? key,
    this.localStr,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalStr localStrNew = localStr ?? context.read<AppProvider>().localStr;

    return AlertDialog(
      title: Text(
        localStrNew.mylearningAlerttitleStringareyousure,
        // style: TextStyle(color: InsColor(appBloc).appTextColor, fontWeight: FontWeight.bold),
      ),
      content: Text(
        localStrNew.mylearningAlertsubtitleDoyouwanttocancelenrolledevent,
        // style: TextStyle(color: InsColor(appBloc).appTextColor, fontWeight: FontWeight.normal),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(localStrNew.catalogAlertbuttonCancelbutton),
          onPressed: () async {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: Text(localStrNew.eventsAlertbuttonOkbutton),
          onPressed: () async {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
