/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../backend/co_create_knowledge/co_create_knowledge_controller.dart';
import '../../../backend/co_create_knowledge/co_create_knowledge_provider.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../common/components/common_loader.dart';
import '../component/add_content_dialog.dart';
import '../component/custom_search_view.dart';
import '../component/item_widget.dart';

class ShareKnowledgeTab extends StatefulWidget {
  const ShareKnowledgeTab({super.key});

  @override
  State<ShareKnowledgeTab> createState() => _ShareKnowledgeTabState();
}

class _ShareKnowledgeTabState extends State<ShareKnowledgeTab> {
  void showKnowledgeContentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddContentDialog();
      },
    );
  }

  Future<void> getFutureData() async {
    await _controller.getMyKnowledgeList();
  }

  late CoCreateKnowledgeController _controller;

  late CoCreateKnowledgeProvider _provider;

  late Future future;

  @override
  void initState() {
    super.initState();
    _provider = context.read<CoCreateKnowledgeProvider>();
    _controller = CoCreateKnowledgeController(coCreateKnowledgeProvider: _provider);
    future = getFutureData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mainWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showKnowledgeContentDialog();
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget mainWidget() {
    return FutureBuilder(
        future: future,
        builder: (context, AsyncSnapshot asyncSnapshot) {
          if (asyncSnapshot.connectionState != ConnectionState.done) return const Center(child: CommonLoader());

          return MultiProvider(
            providers: [
              ChangeNotifierProvider<CoCreateKnowledgeProvider>.value(value: _provider),
            ],
            child: Consumer<CoCreateKnowledgeProvider>(builder: (context, CoCreateKnowledgeProvider provider, _) {
              if (provider.isLoading.get()) return const CommonLoader();
              List<CourseDTOModel> list = provider.myKnowledgeList.getList();
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0).copyWith(top: 15, bottom: 10),
                    child: CustomSearchView(),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: list.length,
                        padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 10),
                        itemBuilder: (BuildContext listContext, int index) {
                          return MyKnowledgeItemWidget(
                            model: list[index],
                            // onMoreTap: (){
                            //   showPopupMenu(listContext);
                            // },
                          );
                        }),
                  ),
                ],
              );
            }),
          );
        });
  }
}
*/
