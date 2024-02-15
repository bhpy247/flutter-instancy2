import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/view/common/components/modal_progress_hud.dart';
import 'package:flutter_instancy_2/backend/learning_communities/learning_communities_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/learning_communities/data_model/learning_communities_dto_model.dart';
import '../components/learning_communities_card.dart';

class MyLearningCommunitiesScreen extends StatefulWidget {
  const MyLearningCommunitiesScreen({super.key});

  @override
  State<MyLearningCommunitiesScreen> createState() => _MyLearningCommunitiesScreenState();
}

class _MyLearningCommunitiesScreenState extends State<MyLearningCommunitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LearningCommunitiesProvider>(builder: (context, LearningCommunitiesProvider provider, _) {
      List<PortalListing> list = provider.myLearningCommunitiesList.getList();

      return ModalProgressHUD(
        inAsyncCall: provider.isLoading.get(),
        child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              PortalListing model = list[index];
              return getQuestionsContentWidget(model: model);
            }),
      );
    });
  }

  Widget getQuestionsContentWidget({required PortalListing model}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: LearningCommunitiesCard(
        model: model,
        onGoToCommunityTap: () {},
        onJoinCommunityTap: () {},
      ),
    );
  }
}
