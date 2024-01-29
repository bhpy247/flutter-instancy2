import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:intl/intl.dart';

abstract class DatePresentation {
  static String hhMMssFormatter(String timeStamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp));
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  static String ddMMyyyyFormatter(String timeStamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp));
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  static String yMMMdFormatter(String timeStamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp));
    return DateFormat('yMMMMd').format(dateTime);
  }

  static String yyyyMMddHHmmssFormatter(Timestamp timeStamp) {
    DateTime dateTime = timeStamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  static String yyyyMMddFormatter(Timestamp timeStamp) {
    DateTime dateTime = timeStamp.toDate();
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static String mmmmDDYYYYHHMMAFormatter(Timestamp timeStamp) {
    DateTime dateTime = timeStamp.toDate();
    return DateFormat('MMMM dd,yyyy HH:mm a').format(dateTime);
  }

  static String ddMMMMyyyyTimeStamp(Timestamp timeStamp) {
    DateTime dateTime = timeStamp.toDate();
    return DateFormat('dd MMMM yyyy').format(dateTime);
  }

  static String fullDateTimeFormat(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy hh:mm:ss.SSS').format(dateTime);
  }

  static String dateTimeFormatWithSlash(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  static String activeDateFormat(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy • hh:mm a').format(dateTime);
  }

  static String hhMM(Timestamp timeStamp) {
    DateTime dateTime = timeStamp.toDate();
    return DateFormat('HH:mm a').format(dateTime);
  }

  static String hhMMFromString(String timeStamp) {
    if (timeStamp.isEmpty) return "";
    DateTime dateTime = DateFormat("MM/dd/yyyy HH:mm a").parse(timeStamp);
    return DateFormat('HH:mm a').format(dateTime);
  }

  static String hhMMFromStringWithSeconds(String timeStamp) {
    if (timeStamp.isEmpty) return "";
    DateTime dateTime = DateFormat("MM/dd/yyyy HH:mm:ss aa").parse(timeStamp);
    return DateFormat('MM/dd/yyyy HH:mm aa').format(dateTime);
  }

  static String reEnrollmentHistoryFromString(String timeStamp) {
    if (timeStamp.isEmpty) return "";
    DateTime dateTime = DateFormat("MM/dd/yyyy HH:mm:ss aa").parse(timeStamp);
    return DateFormat('dd MMMM yyyy HH:mm aa').format(dateTime);
  }

  static String onlyDateFromString(String timeStamp) {
    if (timeStamp.isEmpty) return "";
    DateTime dateTime = DateFormat("MM/dd/yyyy HH:mm a").parse(timeStamp);
    return DateFormat('d MMMM y').format(dateTime);
  }

  static String getDifferenceInHours(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return "";

    // MyPrint.printOnConsole("StartDate : $startDate end Date: $endDate");

    Duration duration = startDate.difference(endDate);
    String difference;
    if(duration.inDays >=1){
      difference = "${duration.inDays} day";
    } else if(duration.inMinutes >= 59){
      difference = "${duration.inHours} hour";
    } else {
      difference = "${duration.inMinutes} minutes";
    }
    MyPrint.printOnConsole(duration.inMinutes);


    return difference;
  }


  static DateTime timeStampToDate(String timeStamp) {
    return DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp));
  }

  static String niceDateFormatter(Timestamp startTimeStamp, Timestamp endTimeStamp) {
    Duration time = endTimeStamp.toDate().difference(startTimeStamp.toDate());
    String postDate = '';

    if (time.inDays >= 30) {
      postDate = DateFormat('yMMMd').format(startTimeStamp.toDate());
    }
    else if(time.inDays >= 7 && time.inDays < 30) {
      postDate = '${time.inDays~/7}w ago';
    }
    else if (time.inDays > 0 && time.inDays < 27) {
      postDate = '${time.inDays}d ago';
    }
    else if (time.inHours > 0) {
      postDate = '${time.inHours}h ago';
    }
    else if (time.inMinutes > 0) {
      postDate = '${time.inMinutes}m ago';
    }
    else {
      postDate = '${time.inSeconds}s ago';
    }
    return postDate;
  }

  static bool isSameDay(DateTime dateTime1, DateTime dateTime2) {
    DateTime new1 = DateTime(dateTime1.year, dateTime1.month, dateTime1.day);
    DateTime new2 = DateTime(dateTime2.year, dateTime2.month, dateTime2.day);

    if (new1.day == new2.day && new1.month == new2.month && new1.year == new2.year) {
      return true;
    } else {
      return false;
    }
  }

  static bool isSameMonth(DateTime dateTime1, DateTime dateTime2) {
    return dateTime1.month == dateTime2.month && dateTime1.year == dateTime2.year;
  }

  static bool isDayAfter(DateTime dateTime1, DateTime dateTime2) {
    DateTime new1 = DateTime(dateTime1.year, dateTime1.month, dateTime1.day);
    DateTime new2 = DateTime(dateTime2.year, dateTime2.month, dateTime2.day);

    return new2.isAfter(new1);
  }

  static bool isDayBefore(DateTime dateTime1, DateTime dateTime2) {
    DateTime new1 = DateTime(dateTime1.year, dateTime1.month, dateTime1.day);
    DateTime new2 = DateTime(dateTime2.year, dateTime2.month, dateTime2.day);

    return new2.isBefore(new1);
  }

  static int getDifferenceBetweenDatesInDays(DateTime dateTime1, DateTime dateTime2) {
    DateTime new1 = DateTime(dateTime1.year, dateTime1.month, dateTime1.day);
    DateTime new2 = DateTime(dateTime2.year, dateTime2.month, dateTime2.day);

    Duration duration = new1.difference(new2);
    if (duration.inDays.isNegative) {
      return duration.inDays * -1;
    } else {
      return duration.inDays;
    }
  }

  static int getDifferenceBetweenDatesInMinutes(DateTime dateTime1, DateTime dateTime2) {
    //MyPrint.printOnConsole("Date1:${dateTime1}");
    //MyPrint.printOnConsole("Date2:${dateTime2}");
    DateTime new1 = DateTime(dateTime1.year, dateTime1.month, dateTime1.day, dateTime1.hour, dateTime1.minute, dateTime1.second);
    DateTime new2 = DateTime(dateTime2.year, dateTime2.month, dateTime2.day, dateTime2.hour, dateTime2.minute, dateTime2.second);

    Duration duration = new1.difference(new2);
    //MyPrint.printOnConsole("Difference:${duration.inMinutes}");
    if(duration.inMinutes.isNegative) {
      return duration.inMinutes * -1;
    }
    else {
      return duration.inMinutes;
    }
  }


  static String EEEddMMMMyyhhmmaFormatter(Timestamp date){
    String formattedDate = DateFormat('EEE dd, MMMM yy – hh:mm a').format(date.toDate());
    return formattedDate;
  }

  static String? getFormattedDate({required String dateFormat, DateTime? dateTime}) {
    // MyPrint.printOnConsole("getFormattedDate called with dateFormat:'$dateFormat', dateTime:'$dateTime'");

    if(dateFormat.isEmpty || dateTime == null) {
      return null;
    }

    try {
      return DateFormat(dateFormat).format(dateTime);
    } catch (e, s) {
      String tag = MyUtils.getNewId();
      MyPrint.printOnConsole("Error in formatting date:'$dateTime' into format:'$dateFormat'", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return null;
    }
  }

  static String? getLastChatMessageFormattedDate({required DateTime? dateTime}) {
    // MyPrint.printOnConsole("getLastChatMessageFormattedDate called with dateTime:'$dateTime'");

    if (dateTime == null) {
      return null;
    }

    String? timeString;
    DateTime current = DateTime.now();

    if (dateTime.year == current.year && dateTime.month == current.month && dateTime.day == current.day) {
      timeString = DateFormat("hh:mm a").format(dateTime);
    } else if (DatePresentation.getDifferenceBetweenDatesInDays(dateTime, current) == 1) {
      timeString = "yesterday";
    } else if (DatePresentation.getDifferenceBetweenDatesInDays(dateTime, current) <= 7) {
      timeString = getFormattedDate(dateFormat: "EEEE", dateTime: dateTime) ?? "";
    } else {
      timeString = DateFormat("").format(dateTime);
      timeString = getFormattedDate(dateFormat: "dd MMM yy", dateTime: dateTime) ?? "";
    }

    return timeString;
  }
}
