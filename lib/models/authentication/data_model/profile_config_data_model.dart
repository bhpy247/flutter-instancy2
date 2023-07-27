import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';

import '../../../configs/app_constants.dart';
import '../../../utils/parsing_helper.dart';
import 'profile_config_data_ui_control_model.dart';

class ProfileConfigDataModel {
  int attributeconfigid = 0;
  int objecttypeid = 0;
  String datafieldname = "";
  String aliasname = "";
  bool isrequired = false;
  bool enduservisibility = false;
  bool showinlists = false;
  bool isprepopulatedlist = false;
  bool ispredefined = false;
  bool requiredconfirmvalidation = false;
  int displayorder = 0;
  int minlength = 0;
  int maxlength = 0;
  int minvalue = 0;
  int maxvalue = 0;
  String defaultvalue = "";
  int uicontroltypeid = 0;
  String columntype = "";
  int nooflines = 0;
  bool iseditable = false;
  String columnbasetype = "";
  bool showindetails = false;
  bool basicsearch = false;
  bool advancedsearch = false;
  bool showinselfregistration = false;
  String isderivedfield = "";
  String generatepreview = "";
  String copymedia = "";
  String showashidden = "";
  String usercontrolpath = "";
  int groupid = 0;
  bool showinpublicprofile = false;
  String showothertextbox = "";
  int showinreport = 0;
  int showsiteadmin = 0;
  String displaymode = "";
  String nooffiles = "";
  String filetypes = "";
  int ispublicfield = 0;
  int siteid = 0;
  String localename = "";
  String displaytext = "";
  String attributecomments = "";
  String configmappingids = "";
  String parentconfigid = "";
  ProfileConfigDataUIControlModel? profileConfigDataUIControlModel;

  ProfileConfigDataModel({
    this.attributeconfigid = 0,
    this.objecttypeid = 0,
    this.datafieldname = "",
    this.aliasname = "",
    this.isrequired = false,
    this.enduservisibility = false,
    this.showinlists = false,
    this.isprepopulatedlist = false,
    this.ispredefined = false,
    this.requiredconfirmvalidation = false,
    this.displayorder = 0,
    this.minlength = 0,
    this.maxlength = 0,
    this.minvalue = 0,
    this.maxvalue = 0,
    this.defaultvalue = "",
    this.uicontroltypeid = 0,
    this.columntype = "",
    this.nooflines = 0,
    this.iseditable = false,
    this.columnbasetype = "",
    this.showindetails = false,
    this.basicsearch = false,
    this.advancedsearch = false,
    this.showinselfregistration = false,
    this.isderivedfield = "",
    this.generatepreview = "",
    this.copymedia = "",
    this.showashidden = "",
    this.usercontrolpath = "",
    this.groupid = 0,
    this.showinpublicprofile = false,
    this.showothertextbox = "",
    this.showinreport = 0,
    this.showsiteadmin = 0,
    this.displaymode = "",
    this.nooffiles = "",
    this.filetypes = "",
    this.ispublicfield = 0,
    this.siteid = 0,
    this.localename = "",
    this.displaytext = "",
    this.attributecomments = "",
    this.configmappingids = "",
    this.parentconfigid = "",
    this.profileConfigDataUIControlModel,
  });

  ProfileConfigDataModel.fromJson(Map<String, dynamic> json) {
    attributeconfigid = ParsingHelper.parseIntMethod(json['attributeconfigid'] ?? 0);
    objecttypeid = ParsingHelper.parseIntMethod(json['objecttypeid'] ?? 0);
    datafieldname = ParsingHelper.parseStringMethod(json['datafieldname'] ?? "");
    aliasname = ParsingHelper.parseStringMethod(json['aliasname'] ?? "");
    isrequired = ParsingHelper.parseBoolMethod(json['isrequired'] ?? false);
    enduservisibility = ParsingHelper.parseBoolMethod(json['enduservisibility'] ?? false);
    showinlists = ParsingHelper.parseBoolMethod(json['showinlists'] ?? false);
    isprepopulatedlist = ParsingHelper.parseBoolMethod(json['isprepopulatedlist'] ?? false);
    ispredefined = ParsingHelper.parseBoolMethod(json['ispredefined'] ?? false);
    requiredconfirmvalidation = ParsingHelper.parseBoolMethod(json['requiredconfirmvalidation'] ?? false);
    displayorder = ParsingHelper.parseIntMethod(json['displayorder'] ?? 0);
    minlength = ParsingHelper.parseIntMethod(json['minlength'] ?? 0);
    maxlength = ParsingHelper.parseIntMethod(json['maxlength'] ?? 0);
    minvalue = ParsingHelper.parseIntMethod(json['minvalue'] ?? 0);
    maxvalue = ParsingHelper.parseIntMethod(json['maxvalue'] ?? 0);
    defaultvalue = ParsingHelper.parseStringMethod(json['defaultvalue'] ?? "");
    uicontroltypeid = ParsingHelper.parseIntMethod(json['uicontroltypeid'] ?? 0);
    columntype = ParsingHelper.parseStringMethod(json['columntype'] ?? "");
    nooflines = ParsingHelper.parseIntMethod(json['nooflines'] ?? 0);
    iseditable = ParsingHelper.parseBoolMethod(json['iseditable'] ?? false);
    columnbasetype = ParsingHelper.parseStringMethod(json['columnbasetype'] ?? "");
    showindetails = ParsingHelper.parseBoolMethod(json['showindetails'] ?? false);
    basicsearch = ParsingHelper.parseBoolMethod(json['basicsearch'] ?? false);
    advancedsearch = ParsingHelper.parseBoolMethod(json['advancedsearch'] ?? false);
    showinselfregistration = ParsingHelper.parseBoolMethod(json['showinselfregistration'] ?? false);
    isderivedfield = ParsingHelper.parseStringMethod(json['isderivedfield'] ?? "");
    generatepreview = ParsingHelper.parseStringMethod(json['generatepreview'] ?? "");
    copymedia = ParsingHelper.parseStringMethod(json['copymedia'] ?? "");
    showashidden = ParsingHelper.parseStringMethod(json['showashidden'] ?? "");
    usercontrolpath = ParsingHelper.parseStringMethod(json['usercontrolpath'] ?? "");
    groupid = ParsingHelper.parseIntMethod(json['groupid'] ?? 0);
    showinpublicprofile = ParsingHelper.parseBoolMethod(json['showinpublicprofile'] ?? false);
    showothertextbox = ParsingHelper.parseStringMethod(json['showothertextbox'] ?? "");
    showinreport = ParsingHelper.parseIntMethod(json['showinreport'] ?? 0);
    showsiteadmin = ParsingHelper.parseIntMethod(json['showsiteadmin'] ?? 0);
    displaymode = ParsingHelper.parseStringMethod(json['displaymode'] ?? "");
    nooffiles = ParsingHelper.parseStringMethod(json['nooffiles'] ?? "");
    filetypes = ParsingHelper.parseStringMethod(json['filetypes'] ?? "");
    ispublicfield = ParsingHelper.parseIntMethod(json['ispublicfield'] ?? 0);
    siteid = ParsingHelper.parseIntMethod(json['siteid'] ?? 0);
    localename = ParsingHelper.parseStringMethod(json['localename'] ?? "");
    displaytext = ParsingHelper.parseStringMethod(json['displaytext'] ?? "");
    attributecomments = ParsingHelper.parseStringMethod(json['attributecomments'] ?? "");
    configmappingids = ParsingHelper.parseStringMethod(json['configmappingids'] ?? "");
    parentconfigid = ParsingHelper.parseStringMethod(json['parentconfigid'] ?? "");
  }

  void initializeProfileConfigDataUIControlModel() {
    ProfileConfigDataUIControlModel model = ProfileConfigDataUIControlModel();

    model.isRequired = isrequired;
    model.displayText = "$displaytext${isrequired ? " *" : ''}";

    // MyPrint.printOnConsole("asdjasnkjabkabsck: ${profileConfigData.datafieldname} ${profileConfigData.attributeconfigid}");

    //region For TextField
    if(UIControlTypes.textFieldTypeIds.contains(uicontroltypeid)) {
      model.textEditingController = TextEditingController();

      if(isrequired) {
        model.validator = (String? text) {
          if(text.checkEmpty) {
            return "$displaytext cannot be empty";
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
              return "$displaytext cannot be empty";
            }

            if(text!.length <= 2) {
              return "Passwords length should be greater than or equal to 3";
            }

            if(text.characters.where((p0) => ["\/", "\\", "*", "{", "}"].contains(p0)).isNotEmpty) {
              return "Please make sure you are not including the following characters (/\\\*{})";
            }

            // MyPrint.printOnConsole("model.textEditingController!.text:'${model.textEditingController!.text}'");
            // MyPrint.printOnConsole("model.confirmPasswordTextEditingController!.text:'${model.confirmPasswordTextEditingController!.text}'");
            if(model.textEditingController!.text != model.confirmPasswordTextEditingController!.text) {
              return "Passwords do not match";
            }
            return null;
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
              return "$displaytext cannot be empty";
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
              return "Invalid $displaytext";
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
    'attributeconfigid' : attributeconfigid,
    'objecttypeid' : objecttypeid,
    'datafieldname' : datafieldname,
    'aliasname' : aliasname,
    'isrequired' : isrequired,
    'enduservisibility' : enduservisibility,
    'showinlists' : showinlists,
    'isprepopulatedlist' : isprepopulatedlist,
    'ispredefined' : ispredefined,
    'requiredconfirmvalidation' : requiredconfirmvalidation,
    'displayorder' : displayorder,
    'minlength' : minlength,
    'maxlength' : maxlength,
    'minvalue' : minvalue,
    'maxvalue' : maxvalue,
    'defaultvalue' : defaultvalue,
    'uicontroltypeid' : uicontroltypeid,
    'columntype' : columntype,
    'nooflines' : nooflines,
    'iseditable' : iseditable,
    'columnbasetype' : columnbasetype,
    'showindetails' : showindetails,
    'basicsearch' : basicsearch,
    'advancedsearch' : advancedsearch,
    'showinselfregistration' : showinselfregistration,
    'isderivedfield' : isderivedfield,
    'generatepreview' : generatepreview,
    'copymedia' : copymedia,
    'showashidden' : showashidden,
    'usercontrolpath' : usercontrolpath,
    'groupid' : groupid,
    'showinpublicprofile' : showinpublicprofile,
    'showothertextbox' : showothertextbox,
    'showinreport' : showinreport,
    'showsiteadmin' : showsiteadmin,
    'displaymode' : displaymode,
    'nooffiles' : nooffiles,
    'filetypes' : filetypes,
    'ispublicfield' : ispublicfield,
    'siteid' : siteid,
    'localename' : localename,
    'displaytext' : displaytext,
    'attributecomments' : attributecomments,
    'configmappingids' : configmappingids,
    'parentconfigid' : parentconfigid,
    };
  }
}