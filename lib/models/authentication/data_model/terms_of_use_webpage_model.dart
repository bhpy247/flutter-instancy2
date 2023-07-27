import '../../../utils/parsing_helper.dart';

class TermsOfUseWebpageModel {
  String termsofusewebpage = "";

  TermsOfUseWebpageModel({this.termsofusewebpage = ""});

  TermsOfUseWebpageModel.fromJson(Map<String, dynamic> json) {
    termsofusewebpage = ParsingHelper.parseStringMethod(json['termsofusewebpage']);
  }

  Map<String, dynamic> toJson() {
    return {
      "termsofusewebpage":termsofusewebpage
    };
  }
}