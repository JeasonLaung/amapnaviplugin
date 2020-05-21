class TransUtil {


  ///米转换成公里 如果少于1公里则显示米
  static String distance(int meter) {
    String info = "";
    if (meter > 1000) {
      double kilometer = meter * 0.001;
      info = kilometer.toStringAsFixed(2) + "公里";
    } else {
      info = meter.toString() + "米";
    }
    return info;
  }

  ///将秒转换成时分秒，例如2000秒 转换为  33分钟
  static String secToTime(int time) {


    int hour = time ~/ 3600;
    int minute = time % 3600 ~/ 60;
    int second = time % 60;

    String hourString = "";
    if (hour != 0) {
      hourString = hour.toString() + "小时";
    }
    String minuteString;
    if (minute != 0) {
      minuteString = minute.toString() + "分钟";
    } else {
      minuteString = "1分钟";
    }

//        String secondString = second + "秒";
    return hourString + minuteString;
  }
}