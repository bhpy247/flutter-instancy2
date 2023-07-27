import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:provider/provider.dart';

import '../../../backend/app_theme/style.dart';
import '../../../models/course/data_model/gloassary_model.dart';

class GlossaryTabWidget extends StatefulWidget {
  final List<GlossaryModel> glossaryData;

  const GlossaryTabWidget({
    Key? key,
    required this.glossaryData,
  }) : super(key: key);

  @override
  State<GlossaryTabWidget> createState() => _GlossaryTabWidgetState();
}

class _GlossaryTabWidgetState extends State<GlossaryTabWidget> {
  late AppProvider appProvider;

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return getGlossaryTabWidget();
  }

  Widget getGlossaryTabWidget() {
    List<GlossaryModel> glossaryData = widget.glossaryData;

    if (glossaryData.isEmpty) {
      return Center(
        child: Text(appProvider.localStr.commoncomponentLabelNodatalabel),
      );
    }

    return ListView.builder(
      itemCount: glossaryData.length,
      itemBuilder: (BuildContext context, int index) {
        GlossaryModel glossaryModel = glossaryData[index];

        return glossaryItemWidget(glossaryModel);
      },
    );
  }

  Widget glossaryItemWidget(GlossaryModel glossaryModel) {
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Styles.borderColor))),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          collapsedBackgroundColor: Styles.expansionTileBackground,
          title: Text(glossaryModel.Type),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5,),
              child: Html(data: glossaryModel.Meaning),
            ),
            /*Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 18, right: 5, top: 5, bottom: 5),
                child: Row(
                  children: const [
                    Expanded(
                      flex: 3,
                      child: Text(
                        "active",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(":"),
                    ),
                    Expanded(
                      flex: 7,
                      child: Text(
                        "involved in activity",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                child: Row(
                  children: const [
                    Expanded(
                      flex: 3,
                      child: Text(
                        "abbrevations",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(":"),
                    ),
                    Expanded(
                      flex: 7,
                      child: Text(
                        "a short form of a word or phrase",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
