import 'package:flutter_instancy_2/utils/my_utils.dart';

class NativeAuthoringGetResourcesRequestModel {
  String learning_objective = "";
  String BotId = "";
  String metadata = "1";
  String pinecone_index = "";
  String client_url = "";
  bool from_sql_data = false;
  bool from_internet = false;
  bool from_youtube = false;
  bool from_kb = false;
  bool isLearningModule = false;

  NativeAuthoringGetResourcesRequestModel({
    this.learning_objective = "",
    this.BotId = "",
    this.metadata = "1",
    this.pinecone_index = "",
    this.client_url = "",
    this.from_sql_data = false,
    this.from_internet = false,
    this.from_youtube = false,
    this.from_kb = false,
    this.isLearningModule = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "learning_objective": learning_objective,
      "BotId": BotId,
      "metadata": metadata,
      "pinecone_index": pinecone_index,
      "client_url": client_url,
      "from_sql_data": from_sql_data ? "1" : "0",
      "from_internet": from_internet ? "1" : "0",
      "from_youtube": from_youtube ? "1" : "0",
      "from_kb": from_kb ? "1" : "0",
      "isLearningModule": isLearningModule ? "1" : "0",
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
