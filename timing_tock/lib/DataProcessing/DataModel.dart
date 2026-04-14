import 'package:flutter/services.dart';
class FlutterData{

  static const String CHANNEL="com.timing.tock/data";
  static const String CHANNEL2="com.timing.tock/web";


  ///
  /// 向服务端提交本地端Json
  ///
  static Future submitRecordData(RecordData recordData)=>
      MethodChannel(CHANNEL).invokeMethod("submitData",
        {
          "title":recordData.title,
          "recordTypeNumber":recordData.recordTypeNumber,
          "time":recordData.time,
          "ifDaKa":recordData.ifDaKa
        }
      );

  ///
  ///将新计划传给Java，Java端将其.add进内存中并写入文件,同时返回map
  ///
  static Future AddRecordData(RecordData recordData)=>
      MethodChannel(CHANNEL).invokeMethod("AddData",
        {
          "title":recordData.title,
          "recordTypeNumber":recordData.recordTypeNumber,
          "time":recordData.time,
          "ifDaKa":recordData.ifDaKa,
          "ifFinish":recordData.ifFinish,
          "progress":recordData.progress
        }
      );
  static Future ChangeRecordData(RecordData recordData,String TimeStamp)=>
      MethodChannel(CHANNEL).invokeMethod("ChangeRecordData",
        {
          "title":recordData.title,
          "recordTypeNumber":recordData.recordTypeNumber,
          "time":recordData.time,
          "ifDaKa":recordData.ifDaKa,
          "ifFinish":recordData.ifFinish,
          "progress":recordData.progress,
          "TimeStamp":TimeStamp
        }
      );
  static Future DeleteRecordData(String TimeStamp,int recordTypeNumber){
    return MethodChannel(CHANNEL).invokeMethod("DeleteRecordData",{
      "TimeStamp":TimeStamp,
      "recordTypeNumber":recordTypeNumber
    });
  }

  ///
  ///询问是否是第一次启动
  ///
  static Future AskIfFirst()=>
      MethodChannel(CHANNEL).invokeMethod("AskIfFirst");

  ///
  /// Java端从本地读json，读完后自己存一份在内存中，并转成map<string，object>传给dart
  ///
  static Future<Map<String, dynamic>>   SyncJsonFromJavaLocal()async{

    Map<Object?,Object?> r= await MethodChannel(CHANNEL).invokeMethod("SyncJsonFromJavaLocal");
    return r.cast<String,dynamic>();
  }


  static Future SyncJsonFromWeb(){
    return MethodChannel(CHANNEL2).invokeMethod("SyncJsonFromWeb");
  }
  static Future CheckLogIn(){
    return MethodChannel(CHANNEL2).invokeMethod("CheckLogIn");
  }

  //若成功，向本地写入用户信息，返回用户信息到dart
  static Future TryLogIn(String account,String password){
    return MethodChannel(CHANNEL2).invokeMethod("TryLogIn",[account,password]);
  }

  //若成功，返回用户信息到dart，用来判断是否注册成功，通常成功后会跳转到登陆页
  static Future TrySignIn(String account,String password){
    return MethodChannel(CHANNEL2).invokeMethod("TrySignIn",[account,password]);
  }
  static Future ExitAccount(){
    return MethodChannel(CHANNEL2).invokeMethod("ExitAccount");


  }
  static Future SyncData(String Account){
    return new MethodChannel(CHANNEL2).invokeMethod("SyncData",Account);
  }


}

///
///计划对象
///
class RecordData{
  late int recordTypeNumber;
  late String title;
  late double time;
  late bool ifDaKa;
  late bool ifFinish;
  late double progress;
  RecordData({required this.progress,  required this.ifFinish,required this.ifDaKa,required this.recordTypeNumber, required this.title, required this.time});
}
