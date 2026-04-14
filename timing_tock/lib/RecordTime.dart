import 'dart:async';
import 'dart:math'; // 用于 pow
import 'package:timing_tock/DataProcessing/DataModel.dart';

class RecordTIme {
  bool ifRecordTime = false;
  Timer? timer;


  static double getTimeNow() {
    return DateTime.now().millisecondsSinceEpoch.toDouble();
  }

  void startRecordTime(RecordData recordData, String timeStamp, Function function) {
    ifRecordTime = !ifRecordTime;


    final double startTimeMillis = getTimeNow();
    final double initialProgress = recordData.progress;


    timer?.cancel();

    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (ifRecordTime) {

        double msElapsed = getTimeNow() - startTimeMillis;


        double hoursElapsed = msElapsed / 3600000.0;


        double totalProgress = initialProgress + hoursElapsed;
        print(totalProgress);
        recordData.progress = (totalProgress * 10000).truncateToDouble() / 10000;
        if(recordData.time<=recordData.progress){
          recordData.ifFinish=true;

        }


        await FlutterData.ChangeRecordData(recordData, timeStamp);
        function();
        if(recordData.time<=recordData.progress){
          timer.cancel();

        }
      }
    });
  }

  void stopRecordTime() {
    ifRecordTime = false;
    timer?.cancel();
  }
}