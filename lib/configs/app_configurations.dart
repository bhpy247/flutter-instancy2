import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/parser.dart';

import '../backend/app_theme/style.dart';
import 'app_constants.dart';
import 'ui_configurations.dart';

class AppConfigurations {
  static const String conditionSeparator1 = "#@#";
  static const String conditionSeparator2 = "=";
  String _eventDateTimeFormat = "";

  static String getContentIconFromObjectAndMediaType({int objectTypeId = -1, int mediaTypeId = -1}) {
    String path = "assets/myLearning/test.png";

    //region Learning Module
    if (objectTypeId == InstancyObjectTypes.contentObject) {
      // // type = InstancyContentTypeEnum.Learning_Module;

      path = "assets/myLearning/learningModule.png";
      if (mediaTypeId == 61) {
        path = "assets/myLearning/microLearning.png";
        // // subType = InstancyContentSubTypeEnum.Microlearning;
      } else if (mediaTypeId == 62) {
        path = "assets/myLearning/learningModule.png";
        // // subType = InstancyContentSubTypeEnum.Learning_Module;
      }
    }
    //endregion

    //region Assessment
    else if (objectTypeId == InstancyObjectTypes.assessment) {
      // type = InstancyContentTypeEnum.Assessment;
      path = "";
      if (mediaTypeId == 27) {
        // subType = InstancyContentSubTypeEnum.Test;
        path = "assets/myLearning/test.png";
      } else if (mediaTypeId == 28) {
        // subType = InstancyContentSubTypeEnum.Survey;
        path = "assets/myLearning/survey.png";
      }
    }
    //endregion

    //region Learning Track
    else if (objectTypeId == 10) {
      path = "assets/myLearning/learningPath.png";

      // type = InstancyContentTypeEnum.Learning_Track;
    }
    //endregion

    //region Video And Audio
    else if (objectTypeId == 11) {
      // type = InstancyContentTypeEnum.Video_and_Audio;

      if (mediaTypeId == 1) {
        // subType = InstancyContentSubTypeEnum.Image;
        path = "assets/myLearning/image.png";
      } else if (mediaTypeId == 3) {
        // subType = InstancyContentSubTypeEnum.Video;
        path = "assets/myLearning/video.png";
      } else if (mediaTypeId == 4) {
        // subType = InstancyContentSubTypeEnum.Audio;
        path = "assets/myLearning/audio.png";
      } else if (mediaTypeId == 57) {
        // subType = InstancyContentSubTypeEnum.Embeded_Audio;
        path = "assets/myLearning/audio.png";
      } else if (mediaTypeId == 58) {
        // subType = InstancyContentSubTypeEnum.Embeded_Video;
        path = "assets/myLearning/video.png";
      }
    }
    //endregion

    //region Documents
    else if (objectTypeId == 14) {
      // type = InstancyContentTypeEnum.Documents;

      if (mediaTypeId == 8) {
        // subType = InstancyContentSubTypeEnum.Word;
        path = "assets/myLearning/document.png";
      } else if (mediaTypeId == 9) {
        // subType = InstancyContentSubTypeEnum.PDF;
        path = "assets/myLearning/pdf.png";
      } else if (mediaTypeId == 10) {
        // subType = InstancyContentSubTypeEnum.Excel;
        path = "assets/myLearning/excel.png";
      } else if (mediaTypeId == 17) {
        // subType = InstancyContentSubTypeEnum.PPT;
        path = "assets/myLearning/ppt.png";
      } else if (mediaTypeId == 18) {
        // subType = InstancyContentSubTypeEnum.MPP;
      } else if (mediaTypeId == 19) {
        // subType = InstancyContentSubTypeEnum.Visio_Types;
      }
    }
    //endregion
    //region Glossary
    else if (objectTypeId == 20) {
      // type = InstancyContentTypeEnum.Glossary;
    }
    //endregion
    //region HTML Package
    else if (objectTypeId == 21) {
      // type = InstancyContentTypeEnum.HTML_Package;

      if (mediaTypeId == 40) {
        // subType = InstancyContentSubTypeEnum.HTML_Zip_File;
        path = "assets/myLearning/html.png";
      } else if (mediaTypeId == 41) {
        // subType = InstancyContentSubTypeEnum.Single_HTML_File;
        path = "assets/myLearning/html.png";
      }
    }
    //endregion

    //region E-Learning Course
    else if (objectTypeId == 26) {
      // type = InstancyContentTypeEnum.E_Learning_Course;

      if (mediaTypeId == 30) {
        // subType = InstancyContentSubTypeEnum.SCORM_12;
      } else if (mediaTypeId == 31) {
        // subType = InstancyContentSubTypeEnum.SCORM_2004;
      }
    }
    //endregion

    //region AICC
    else if (objectTypeId == 27) {
      // type = InstancyContentTypeEnum.AICC;
    }
    //endregion

    //region Reference
    else if (objectTypeId == 28) {
      // type = InstancyContentTypeEnum.Reference;

      if (mediaTypeId == 5) {
        // subType = InstancyContentSubTypeEnum.Online_Course;
      } else if (mediaTypeId == 6) {
        // subType = InstancyContentSubTypeEnum.Classroom_Course;
      } else if (mediaTypeId == 7) {
        // subType = InstancyContentSubTypeEnum.Virtual_Classroom;
      } else if (mediaTypeId == 13) {
        // subType = InstancyContentSubTypeEnum.URL;
        path = "assets/myLearning/url.png";
      } else if (mediaTypeId == 14) {
        // subType = InstancyContentSubTypeEnum.LiveMeeting;
      } else if (mediaTypeId == 15) {
        // subType = InstancyContentSubTypeEnum.Recording;
      } else if (mediaTypeId == 20) {
        // subType = InstancyContentSubTypeEnum.Book;
      } else if (mediaTypeId == 21) {
        // subType = InstancyContentSubTypeEnum.Document;
        path = "assets/myLearning/document.png";
      } else if (mediaTypeId == 22) {
        // subType = InstancyContentSubTypeEnum.Conference;
      } else if (mediaTypeId == 23) {
        // subType = InstancyContentSubTypeEnum.Video;
        path = "assets/myLearning/video.png";
      } else if (mediaTypeId == 24) {
        // subType = InstancyContentSubTypeEnum.Audio;
        path = "assets/myLearning/audio.png";
      } else if (mediaTypeId == 25) {
        // subType = InstancyContentSubTypeEnum.Web_Link;
      } else if (mediaTypeId == 26) {
        // subType = InstancyContentSubTypeEnum.Blended_Online_and_Classroom;
      } else if (mediaTypeId == 33) {
        // subType = InstancyContentSubTypeEnum.Assessor_Service;
      } else if (mediaTypeId == 42) {
        // subType = InstancyContentSubTypeEnum.Image;
        path = "assets/myLearning/image.png";
      } else if (mediaTypeId == 43) {
        // subType = InstancyContentSubTypeEnum.Teaching_Slides;
      } else if (mediaTypeId == 44) {
        // subType = InstancyContentSubTypeEnum.Animation;
      } else if (mediaTypeId == 52) {
        // subType = InstancyContentSubTypeEnum.PsyTech_Assessment;
      } else if (mediaTypeId == 53) {
        // subType = InstancyContentSubTypeEnum.DISC_Assessment;
      } else if (mediaTypeId == 54) {
        // subType = InstancyContentSubTypeEnum.Coorpacademy;
      }
    }
    //endregion

    //region Webpage
    else if (objectTypeId == 36) {
      // type = InstancyContentTypeEnum.Webpage;
    }
    //endregion

    // region Certificate
    else if (objectTypeId == 52) {
      // type = InstancyContentTypeEnum.Certificate;
    }
    //endregion

    //region Events
    else if (objectTypeId == 70) {
      path = "assets/myLearning/online.png";
      // type = InstancyContentTypeEnum.Event;

      if (mediaTypeId == 46) {
        path = "assets/myLearning/classroom.png";
        // subType = InstancyContentSubTypeEnum.Classroom_IN_Person;
      } else if (mediaTypeId == 47) {
        // subType = InstancyContentSubTypeEnum.Virtual_Class_Online;
      } else if (mediaTypeId == 48) {
        path = "assets/myLearning/classroom.png";

        // subType = InstancyContentSubTypeEnum.Networking_In_Person;
      } else if (mediaTypeId == 49) {
        path = "assets/myLearning/classroom.png";

        // subType = InstancyContentSubTypeEnum.Lab_In_Person;
      } else if (mediaTypeId == 50) {
        path = "assets/myLearning/classroom.png";

        // subType = InstancyContentSubTypeEnum.Project_In_Person;
      } else if (mediaTypeId == 51) {
        path = "assets/myLearning/classroom.png";

        // subType = InstancyContentSubTypeEnum.Field_Trip_In_Person;
      }
    }
    //endregion

    // region XApi
    else if (objectTypeId == 102) {
      // type = InstancyContentTypeEnum.xAPI;
    }
    //endregion

    // region cmi5
    else if (objectTypeId == 693) {
      // type = InstancyContentTypeEnum.cmi5;
    }
    //endregion

    // region Assignment
    else if (objectTypeId == 694) {
      // type = InstancyContentTypeEnum.Assignment;
    }
    //endregion

    return path;

    /*  if(courseName.contains(CoursesName.video) ){
      return "assets/myLearning/video.png";
    } else if(courseName == CoursesName.learningModule){
      return "assets/myLearning/learningModule.png";
    } else if(courseName == CoursesName.learningPath) {
      return "assets/myLearning/eLearningCourse.png";
    } else if(courseName == CoursesName.classroom) {
      return "assets/myLearning/classroom.png";
    } else if(courseName == CoursesName.document) {
      return "assets/myLearning/document.png";
    } else if(courseName == CoursesName.excel) {
      return "assets/myLearning/excel.png";
    } else if(courseName == CoursesName.html) {
      return "assets/myLearning/html.png";
    } else if(courseName == CoursesName.image) {
      return "assets/myLearning/image.png";
    } else if(courseName == CoursesName.learningPath) {
      return "assets/myLearning/learningPath.png";
    } else if(courseName == CoursesName.microLearning) {
      return "assets/myLearning/microLearning.png";
    } else if(courseName == CoursesName.pdf) {
      return "assets/myLearning/pdf.png";
    } else if(courseName == CoursesName.ppt) {
      return "assets/myLearning/ppt.png";
    } else if(courseName == CoursesName.survey) {
      return "assets/myLearning/survey.png";
    } else if(courseName == CoursesName.test) {
      return "assets/myLearning/test.png";
    } else if(courseName == CoursesName.url) {
      return "assets/myLearning/url.png";
    } else if(courseName.contains(CoursesName.audio)) {
      return "assets/myLearning/audio.png";
    } else {
      return "assets/myLearning/test.png";
    }*/
  }

  static IconData getIconDataFromInstancyModelString(String iconString) {
    if (iconString == "") {
      return FontAwesomeIcons.arrowUp;
    } else {
      return FontAwesomeIcons.arrowUp;
    }
  }

  static bool getFilterEnabledFromShowIndexes({required String showIndexes}) {
    return ["top", "true"].contains(showIndexes);
  }

  static bool getSortEnabledFromContentFilterBy({required List<String> contentFilterBy}) {
    return contentFilterBy.contains(ContentFilterByTypes.SortItems) || contentFilterBy.contains(ContentFilterByTypes.sortItems);
  }

  //region Instancy icons
  Map<Enum, String> icons = {
    InstancyIconType.shareWithConnection: "${FontAwesomeIcons.userGroup.codePoint}",
    InstancyIconType.shareViaEmail: "${FontAwesomeIcons.envelope.codePoint}",
    InstancyIconType.shareWithPeople: "0xf079",
    InstancyIconType.pause: "${FontAwesomeIcons.pause.codePoint}",
    InstancyIconType.archived: "0xf187",
  };

  static IconData getIconDataFromString(String iconString) {
    if (iconString.isNotEmpty) {
      if (iconString.contains("-")) {
        return IconDataSolid(int.parse('0x${"f02d"}'));
      } else {
        return IconDataSolid(
          int.parse(iconString),
        );
      }
    } else {
      return IconDataSolid(int.parse('0x${"f02d"}'));
    }
  }

  IconData getInstancyIconFromType(Enum iconType) {
    String icon = icons[iconType] ?? "";
    return getIconDataFromString(icon);
  }

  //endregion

  //region commonAppBar Method
  AppBar commonAppBar({String title = "", List<Widget>? actions}) {
    return AppBar(
      title: Text(title),
      actions: actions,
      // backgroundColor: themeData.primaryColor,
    );
  }

  //endregion

  //region imageView
  Widget getImageView({String url = "assets/addContentLogo.png", double height = 159, double width = 135}) {
    return Image.asset(
      url,
      height: height,
      width: width,
    );
  }

  //endregion

  String get eventDateTimeFormat => _eventDateTimeFormat;

  void setEventDateTimeFormat(String value) {
    _eventDateTimeFormat = value;
  }

  static Color getContentStatusColor({required String status}) {
    if (status.contains('Progress')) {
      return InstancyColors.orange;
    } else if (status.contains('Not Attended')) {
      return InstancyColors.red;
    } else if (status.toLowerCase().contains('failed')) {
      return InstancyColors.red;
    } else if (status.contains('Attended')) {
      return InstancyColors.green;
    } else if (status.contains('Registered')) {
      return InstancyColors.orange;
    } else if (status.contains('Completed')) {
      return InstancyColors.green;
    } else if (status.contains('Pending')) {
      return InstancyColors.blue;
    } else {
      return InstancyColors.grey;
    }

    /*Color? statuscolor;

    if (status == 'completed') {
      statuscolor = const Color(0xff4ad963);
    }
    else if (['completed(passed)', 'completed (passed)'].contains(status.toLowerCase())) {
      statuscolor = const Color(0xff4ad963);
    }
    else if (['completed(failed)', 'completed (failed)'].contains(status.toLowerCase())) {
      MyPrint.printOnConsole("Got In Completed (failed)");
      statuscolor = const Color(0xfffe2c53);
    }
    else if (status.toLowerCase() == 'not started') {
      statuscolor = const Color(0xfffe2c53);
    }
    else if (status.toLowerCase() == 'in progress') {
      statuscolor = const Color(0xffff9503);
    }

    return statuscolor;*/
  }

  static Color getContentStatusColorFromActualStatus({required String status}) {
    if ([ContentStatusTypes.failed, ContentStatusTypes.notattended].contains(status)) {
      return InstancyColors.red;
    } else if ([ContentStatusTypes.passed, ContentStatusTypes.attended, ContentStatusTypes.completed, ContentStatusTypes.registered].contains(status)) {
      return InstancyColors.green;
    } else if ([ContentStatusTypes.grade].contains(status)) {
      return InstancyColors.purple;
    } else if ([ContentStatusTypes.incomplete].contains(status)) {
      return InstancyColors.orange;
    } else if ([ContentStatusTypes.notAttempted].contains(status)) {
      return InstancyColors.blue;
    } else if ([ContentStatusTypes.passed, ContentStatusTypes.attended, ContentStatusTypes.completed, ContentStatusTypes.registered].contains(status)) {
      return InstancyColors.green;
    } else {
      return InstancyColors.grey;
    }
  }

  static Widget commonNoDataView({String url = "assets/noDataView.png", String bottomText = "Nothings here!", double height = 250, double width = 300}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          url,
          height: height,
          width: width,
        ),
        const SizedBox(height: 38),
        Text(
          bottomText,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }

  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    if (document.body?.text != null) {
      return parse(document.body!.text).documentElement!.text;
    }

    return "";
  }

  ShapeBorder bottomSheetShapeBorder() => const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)));

  BorderRadiusGeometry borderRadiusGeometry() => const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20));

  Container bottomSheetContainer({Widget? child}) => Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        decoration: const BoxDecoration(color: Styles.backgroundColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: child,
      );
}
