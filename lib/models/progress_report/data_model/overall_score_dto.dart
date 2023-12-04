import '../../../utils/parsing_helper.dart';

class OverallScoreDTO {
  int overallscore = 0;

  OverallScoreDTO({
    this.overallscore = 0,
  });

  OverallScoreDTO.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    overallscore = ParsingHelper.parseIntMethod(json["overallscore"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "overallscore": overallscore,
    };
  }
}

class ScoreMaxDTO {
  int ScoreMax = 0;

  ScoreMaxDTO({
    this.ScoreMax = 0,
  });

  ScoreMaxDTO.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    ScoreMax = ParsingHelper.parseIntMethod(json["ScoreMax"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "ScoreMax": ScoreMax,
    };
  }
}
