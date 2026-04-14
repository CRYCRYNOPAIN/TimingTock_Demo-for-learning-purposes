import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timing_tock/DataProcessing/DataModel.dart';
import 'package:timing_tock/StateManager.dart';
import 'package:timing_tock/RootPage.dart';
import 'package:timing_tock/webLog/LogPage.dart';
import 'package:timing_tock/webLog/SignPage.dart';

import 'WelcomePage.dart';


void main() {
  runApp(RootWidget());



}
class RootWidget extends StatefulWidget {
  const RootWidget({Key? key}) : super(key: key);

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  late bool ifFirst;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (setting){
        if(setting.name=="/RootPage"){
          return MaterialPageRoute(builder: (bc){
            return RootPage();
          });
        }
        if(setting.name=="/Login"){
          return MaterialPageRoute(builder: (bc)=>Login());
        }if(setting.name=="/Signin"){
          return MaterialPageRoute(builder: (bc)=>Signin());
        }
      },
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
            brightness: Brightness.light,
          )
      ),
      home:FutureBuilder(
        future: FlutterData.AskIfFirst(),//应用启动时向java询问是否初次启动
        builder: (BuildContext context,
            AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.hasData){
                return (snapshot.data as bool)?RootPage():WelcomePage();
              }
              return RootPage();

        },

      ),
    );
  }
}

///根节点 - 用来放MaterialApp




