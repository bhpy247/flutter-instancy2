import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';

class AddContentDialog extends StatelessWidget {
  AddContentDialog({super.key});

  final List<KnowledgeTypeModel> knowledgeTypeList = [
    KnowledgeTypeModel(name: "Flashcard", iconUrl: "assets/cocreate/Card.png"),
    KnowledgeTypeModel(name: "Quiz", iconUrl: "assets/cocreate/Chat Question.png"),
    KnowledgeTypeModel(name: "Podcast Episode", iconUrl: "assets/cocreate/Vector-4.png"),
    KnowledgeTypeModel(name: "Article", iconUrl: "assets/cocreate/Vector-2.png"),
    KnowledgeTypeModel(name: "Video", iconUrl: "assets/cocreate/video.png"),
    KnowledgeTypeModel(name: "Reference Link", iconUrl: "assets/cocreate/Vector-1.png"),
    KnowledgeTypeModel(name: "Documents", iconUrl: "assets/cocreate/Vector.png"),
    KnowledgeTypeModel(name: "Event", iconUrl: "assets/cocreate/Vector-3.png"),
    KnowledgeTypeModel(name: "Roleplay", iconUrl: "assets/cocreate/video.png"),
    KnowledgeTypeModel(name: "Learning Maps", iconUrl: "assets/cocreate/Business Hierarchy.png"),
    KnowledgeTypeModel(name: "AI Agents", iconUrl: "assets/cocreate/Ai.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(knowledgeTypeList.length, (index) {
                  return ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      if (index == 5) {
                        NavigationController.navigateToReferenceLinkScreen(
                          navigationOperationParameters: NavigationOperationParameters(
                            context: context,
                            navigationType: NavigationType.pushNamed,
                          ),
                        );
                      }
                    },
                    leading: Image.asset(
                      knowledgeTypeList[index].iconUrl,
                      height: 20,
                      width: 27,
                    ),
                    title: Text(
                      knowledgeTypeList[index].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  );
                }),
                // children: knowledgeTypeList.map((e) {
                //   return ListTile(
                //     onTap: (){
                //
                //     },
                //     leading: Image.asset(
                //       e.iconUrl,
                //       height: 20,
                //       width: 27,
                //     ),
                //     title: Text(
                //       e.name,
                //       style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 14,
                //       ),
                //     ),
                //   );
                // }).toList(),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(
                  Icons.clear,
                  size: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class KnowledgeTypeModel {
  final String name;
  final String iconUrl;
  final int objectTypeId;

  KnowledgeTypeModel({this.name = "", this.iconUrl = "", this.objectTypeId = 0});
}
