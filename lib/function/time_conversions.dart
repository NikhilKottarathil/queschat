import 'package:intl/intl.dart';

String getTimeDifferenceFromNow(DateTime dateTime) {
  Duration difference = DateTime.now().difference(dateTime);
  if (difference.inSeconds < 5) {
    return "Just now";
  } else if (difference.inMinutes < 1) {
    return "${difference.inSeconds}s ago";
  } else if (difference.inHours < 1) {
    return "${difference.inMinutes}m ago";
  } else if (difference.inHours < 24) {
    return "${difference.inHours}h ago";
  } else {
    return "${difference.inDays}d ago";
  }
}
String get24HourFormatTime(DateTime dateTime) {
  final dayNodeFormat = new DateFormat.Hm();

  String time = dayNodeFormat.format(dateTime);

  return time;
}

String getTimeDifferenceFromNowString(String date) {
  // Dat  dateTime = DateFormat.w.format(DateTime.now());
  DateTime dateTime = DateFormat('EEE, dd MMM yyyy hh:mm:ss')
      .parse(date.substring(0, date.length - 3));

  print(dateTime);
  Duration difference = DateTime.now().difference(dateTime);
  if (difference.inSeconds < 5) {
    return "Just now";
  } else if (difference.inMinutes < 1) {
    return "${difference.inSeconds}s ago";
  } else if (difference.inHours < 1) {
    return "${difference.inMinutes}m ago";
  } else if (difference.inHours < 24) {
    return "${difference.inHours}h ago";
  } else {
    return "${difference.inDays}d ago";
  }
}

String getCurrentDayNode() {
  final dayNodeFormat = new DateFormat('yyyy/MM/dd');

  String dayNode = dayNodeFormat.format(DateTime.now());

  return dayNode;
}
String getDayNode(DateTime dateTime) {
  final dayNodeFormat = new DateFormat('yyyy/MM/dd');

  String dayNode = dayNodeFormat.format(dateTime);

  return dayNode;
}
String getDisplayDate(DateTime dateTime) {
 if( dateTime.difference(DateTime.now()).inDays==0){
   return 'Today';
 }else if(dateTime.difference(DateTime.now()).inDays==-1){
   return 'Yesterday';
 }else {
   final dayNodeFormat = new DateFormat.yMMMMd('en_US');
   // ('dd/MM/dd');

   String dayNode = dayNodeFormat.format(dateTime);

   return dayNode;
 }
}

String getDisplayDateOrTime(DateTime dateTime) {
  if( dateTime.difference(DateTime.now()).inDays==0){
    return getTimeDifferenceFromNow(dateTime);
  }else if(dateTime.difference(DateTime.now()).inDays==-1){
    return 'Yesterday';
  }else {
    final dayNodeFormat = new DateFormat.yMMMMd('en_US');
    // ('dd/MM/dd');

    String dayNode = dayNodeFormat.format(dateTime);

    return dayNode;
  }
}
String getDurationTime(String string) {
  DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch(int.parse(string) - 19800000);

  final full = new DateFormat('hh-mm');
  final hour = new DateFormat('hh');
  final min = new DateFormat('mm');
  final sec = new DateFormat('s');
  final ampm = new DateFormat('a');
  String f = full.format(dateTime);
  String h = hour.format(dateTime);
  String m = min.format(dateTime);
  String s = sec.format(dateTime);
  String a = ampm.format(dateTime);

  String time = '';
  if (int.parse(string) < 60000) {
    time = s + " seconds";
  } else if (f == '12-30') {
    time = '30 minutes';
  } else if (f == '01-00') {
    time = '1 hour';
  } else if (f == '01-30') {
    time = '1 hour 30 minutes';
  } else if (f == '02-00') {
    time = '2 hour';
  } else if (f == '02-30') {
    time = '2 hour 30 minutes';
  } else if (f == '03-00') {
    time = '3 hour';
  } else {
    if (h == '12') {
      if (a == 'AM') {
        time = m + " minutes";
      } else {
        time = h + " hour " + m + " minutes";
      }
    } else {
      time = h + " hour " + m + " minutes";
    }
  }

  return time;
}
