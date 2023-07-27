import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';

import '../../../configs/app_constants.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import '../../authentication/data_model/profile_config_data_ui_control_model.dart';

class DataFieldModel extends Equatable {
  String datafieldname = "";
  String aliasname = "";
  String attributedisplaytext = "";
  String name = "";
  String valueName = "";
  int groupid = 0;
  int displayorder = 0;
  int attributeconfigid = 0;
  int uicontroltypeid = 0;
  int minlength = 0;
  int maxlength = 0;
  bool isrequired = false;
  bool iseditable = false;
  bool enduservisibility = false;
  ProfileConfigDataUIControlModel? profileConfigDataUIControlModel;
  // Table5? table5;

  DataFieldModel({
    this.datafieldname = "",
    this.aliasname = "",
    this.attributedisplaytext = "",
    this.name = "",
    this.valueName = "",
    this.groupid = 0,
    this.displayorder = 0,
    this.attributeconfigid = 0,
    this.uicontroltypeid = 0,
    this.minlength = 0,
    this.maxlength = 0,
    this.isrequired = false,
    this.iseditable = false,
    this.enduservisibility = false,
    this.profileConfigDataUIControlModel,
  });

  DataFieldModel.fromJson(Map<String, dynamic> json) {
    datafieldname = ParsingHelper.parseStringMethod(json["datafieldname"]);
    aliasname = ParsingHelper.parseStringMethod(json["aliasname"]);
    attributedisplaytext = ParsingHelper.parseStringMethod(json["attributedisplaytext"]);
    name = ParsingHelper.parseStringMethod(json["name"]);
    valueName = ParsingHelper.parseStringMethod(json["valueName"]);
    groupid = ParsingHelper.parseIntMethod(json["groupid"]);
    displayorder = ParsingHelper.parseIntMethod(json["displayorder"]);
    attributeconfigid = ParsingHelper.parseIntMethod(json["attributeconfigid"]);
    uicontroltypeid = ParsingHelper.parseIntMethod(json["uicontroltypeid"]);
    minlength = ParsingHelper.parseIntMethod(json["minlength"]);
    maxlength = ParsingHelper.parseIntMethod(json["maxlength"]);
    isrequired = ParsingHelper.parseBoolMethod(json["isrequired"]);
    iseditable = ParsingHelper.parseBoolMethod(json["iseditable"]);
    enduservisibility = ParsingHelper.parseBoolMethod(json["enduservisibility"]);
  }

  void initializeProfileConfigDataUIControlModel() {
    // MyPrint.printOnConsole("initializeProfileConfigDataUIControlModel called for ${toJson()}");

    ProfileConfigDataUIControlModel model = ProfileConfigDataUIControlModel();

    model.isRequired = isrequired;
    // model.displayText = "$attributedisplaytext${isrequired ? " *" : ''}";
    model.displayText = attributedisplaytext;

    // MyPrint.printOnConsole("asdjasnkjabkabsck: ${profileConfigData.datafieldname} ${profileConfigData.attributeconfigid}");

    //region For TextField
    if(UIControlTypes.textFieldTypeIds.contains(uicontroltypeid)) {
      model.textEditingController = TextEditingController(text: valueName);

      if(isrequired) {
        model.validator = (String? text) {
          if(text.checkEmpty) {
            return "$attributedisplaytext cannot be empty";
          }
          else {
            return null;
          }
        };
      }

      //For Password
      if (attributeconfigid == 6) {
        model.confirmPasswordTextEditingController = TextEditingController();

        if(isrequired) {
          model.validator = (String? text) {
            if(text.checkEmpty) {
              return "$attributedisplaytext cannot be empty";
            }
            else {
              if(text!.length <= 2) {
                return "Passwords length should be greater than 3";
              }


              // MyPrint.printOnConsole("model.textEditingController!.text:'${model.textEditingController!.text}'");
              // MyPrint.printOnConsole("model.confirmPasswordTextEditingController!.text:'${model.confirmPasswordTextEditingController!.text}'");
              if(model.textEditingController!.text != model.confirmPasswordTextEditingController!.text) {
                return "Passwords do not match";
              }
              return null;
            }
          };

          model.confirmPasswordValidator = (String? text) {
            if(text.checkEmpty) {
              return "Confirm Password cannot be empty";
            }
            else {
              if(model.textEditingController!.text != model.confirmPasswordTextEditingController!.text) {
                return "Passwords do not match";
              }
              return null;
            }
          };
        }

        model.keyboardType = TextInputType.visiblePassword;
        model.isPassword = true;
      }
      else if([18, 1438, 1439, 16].contains(attributeconfigid)) {
        model.keyboardType = TextInputType.number;
      }
      else if (attributeconfigid == 15) {
        model.keyboardType = TextInputType.emailAddress;
        model.isEmail = true;

        model.validator = (String? text) {
          if(text.checkEmpty) {
            if(isrequired) {
              return "$attributedisplaytext cannot be empty";
            }
            else {
              return null;
            }
          }
          else {
            if(RegExp(r"([0-9a-zA-Z].*?@([0-9a-zA-Z].*\.\w{2,4}))").hasMatch(text!)) {
              return null;
            }
            else {
              return "Invalid $attributedisplaytext";
            }
          }
        };
      }
      else {
        model.keyboardType = TextInputType.text;
      }
    }
    //endregion



    profileConfigDataUIControlModel = model;
  }

  Map<String, dynamic> toJson() {
    return {
      "datafieldname": datafieldname,
      "aliasname": aliasname,
      "attributedisplaytext": attributedisplaytext,
      "name": name,
      "valueName": valueName,
      "groupid": groupid,
      "displayorder": displayorder,
      "attributeconfigid": attributeconfigid,
      "uicontroltypeid": uicontroltypeid,
      "minlength": minlength,
      "maxlength": maxlength,
      "isrequired": isrequired,
      "iseditable": iseditable,
      "enduservisibility": enduservisibility,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }

  @override
  List<Object?> get props => [
    datafieldname,
    aliasname,
    attributedisplaytext,
    name,
    valueName,
    groupid,
    displayorder,
    attributeconfigid,
    uicontroltypeid,
    minlength,
    maxlength,
    isrequired,
    iseditable,
    enduservisibility,
  ];
}