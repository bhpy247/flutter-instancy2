import '../../../utils/parsing_helper.dart';
import '../data_model/profile_config_data_model.dart';
import '../data_model/terms_of_use_webpage_model.dart';

class SignupFieldResponseModel {
  List<ProfileConfigDataModel> profileConfigData = [];
  // List<Attributechoices> attributeChoices = [];
  List<TermsOfUseWebpageModel> termsOfUseWebpage = [];

  SignupFieldResponseModel({
    this.profileConfigData = const [],
    // this.attributeChoices = const [],
    this.termsOfUseWebpage = const [],
  });

  SignupFieldResponseModel.fromJson(Map<String, dynamic> json) {
    profileConfigData = ParsingHelper.parseMapsListMethod<String, dynamic>(json["profileconfigdata"]).map((x) => ProfileConfigDataModel.fromJson(x)).toList();
    // attributeChoices = ParsingHelper.parseMapsListMethod<String, dynamic>(json["attributechoices"]).map((x) => Attributechoices.fromJson(x)).toList();
    termsOfUseWebpage = ParsingHelper.parseMapsListMethod<String, dynamic>(json["termsofusewebpage"]).map((x) => TermsOfUseWebpageModel.fromJson(x)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "profileconfigdata": profileConfigData.map((x) => x.toJson()).toList(),
      // "attributechoices": attributeChoices.map((x) => x.toJson()).toList(),
      "termsofusewebpage": termsOfUseWebpage.map((x) => x.toJson()).toList(),
    };
  }
}

/*class Attributechoices {
  int attributeconfigid = 0;
  String choicetext = "";
  String choicevalue = "";

  Attributechoices({this.attributeconfigid = 0, this.choicetext = "", this.choicevalue = ""});

  Attributechoices.fromJson(Map<String, dynamic> json) {
    attributeconfigid = ParsingHelper.parseIntMethod(json['attributeconfigid']);
    choicetext = ParsingHelper.parseStringMethod(json['choicetext']);
    choicevalue = ParsingHelper.parseStringMethod(json['choicevalue']);
  }

  Map<String, dynamic> toJson() {
    return {
      'attributeconfigid': attributeconfigid,
      'choicetext': choicetext,
      'choicevalue': choicevalue,
    };
  }
}*/


