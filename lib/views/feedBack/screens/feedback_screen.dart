import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/backend/feedback/feedback_controller.dart';
import 'package:flutter_instancy_2/backend/feedback/feedback_provider.dart';
import 'package:provider/provider.dart';

import '../../../backend/main_screen/main_screen_provider.dart';
import '../../common/components/modal_progress_hud.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> with MySafeState {
  bool isLoading = false;
  late FeedbackProvider feedbackProvider;
  late FeedbackController feedbackController;

  @override
  void initState() {
    super.initState();
    feedbackProvider = context.read<FeedbackProvider>();
    feedbackController = FeedbackController();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FeedbackProvider>.value(value: feedbackProvider),
      ],
      child: Consumer2<FeedbackProvider, MainScreenProvider>(
        builder: (context, FeedbackProvider discussionProvider, MainScreenProvider mainScreenProvider, _) {
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Scaffold(
              floatingActionButton: Padding(
                padding: EdgeInsets.only(
                  bottom: mainScreenProvider.isChatBotButtonEnabled.get() && !mainScreenProvider.isChatBotButtonCenterDocked.get() ? 70 : 0,
                ),
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  child: const Icon(Icons.add),
                  onPressed: () async {},
                ),
              ),
              body: getMainWidget(),
            ),
          );
        },
      ),
    );
  }

  Widget getMainWidget() {
    return Container();
  }
}
