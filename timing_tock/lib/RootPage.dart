import 'package:flutter/material.dart';
import 'package:timing_tock/CustomStyle/CustomStyle.dart';
import 'package:timing_tock/HomePage/HomeList.dart';
import 'package:timing_tock/HomePage/HomePage.dart';
import 'package:timing_tock/DataProcessing/DataModel.dart';
import 'package:timing_tock/StateManager.dart';
import 'package:timing_tock/webLog/LogButton.dart';

///根页面 - 定义了基础的骨架
class RootPage extends StatefulWidget {

  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with SingleTickerProviderStateMixin {
  bool ifBuildFAB=false;
  int currentIndex=0;

  late Future future;
  late Future futureLogin;
  late GlobalKey<HomeListState> globalKey;

  @override
  void initState() {
    super.initState();
    StateManager.changeFAB=changeFAB;
    globalKey=GlobalKey();
    future =FlutterData.CheckLogIn();
    futureLogin=FlutterData.CheckLogIn();
  }
  void changeFAB(value){

    setState(() {
      ifBuildFAB=value;
    });
  }
  Future setFutureLogin() {
    futureLogin= FlutterData.CheckLogIn();
    return futureLogin;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ifBuildFAB?
        FutureBuilder(
            future: ()async{
               await () async{
                 while(globalKey.currentState==null&&!globalKey.currentState!.mounted
                 ){
                   await Future.delayed(Duration(milliseconds: 100));
                 }
               }();
            }(),
            builder: (bc,arg){
              return FloatingActionButton(
                backgroundColor: Color.fromARGB(100, 255, 0, 137),
                  foregroundColor: Colors.white,
                  child: Icon(Icons.add),
                  onPressed: (){
                    globalKey.currentState?.NavToAddNewList(context);
              });
            })
          :null,
      appBar: AppBar(

        title: Text("Timing Tock - 你的计划助手",style: CustomStyle.customTextStyle.TitleText1,),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: Column(
            children: [
              LogButton(
                onTap: (){},
                height: 150,//
                width: double.infinity,
                borderRadius: 70,
                child: Center(
                  child: FutureBuilder(
                    future: futureLogin,
                    builder: (bc,a){
                      if(a.connectionState==ConnectionState.none||a.connectionState==ConnectionState.waiting){
                        print("waiting");
                        return CircularProgressIndicator();
                      }
                      if(a.hasData){
                        Map<String,String> map =(a.data as Map<Object?,Object?>).cast<String,String>();
                        print("========");
                        print(map);
                        print("========");
                        //ASP将匿名对象解析成json并传回时，键名默认变驼峰式命名
                        if(map["Account"]=="null"||map["account"]=="null"){

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              LogButton(
                                  onTap: (){
                                    Navigator.of(context).pushNamed("/Login").then((value) => setFutureLogin().then((value) {
                                      FlutterData.SyncData(map["Account"]!).then((value) {

                                        globalKey.currentState!.restartSync();
                                        globalKey.currentState!.setState(() {
                                          setState(() {

                                          });
                                        });
                                      });

                                    }));
                                  },
                                  height: 50,
                                  width: 100,
                                  borderRadius: 40,
                                  child: Center(
                                    child: Text("登陆",style: TextStyle(fontSize: 20,fontFamily: "CustomFont")),
                                  )
                              ),
                              LogButton(
                                  onTap: (){
                                    Navigator.of(context).pushNamed("/Signin").then((value) => setFutureLogin().then((value) {
                                      setState(() {

                                      });
                                    }));;
                                  },
                                  height: 50,
                                  width: 100,
                                  borderRadius: 40,
                                  child: Center(
                                    child: Text("注册",style: TextStyle(fontSize: 20,fontFamily: "CustomFont"),
                                    ),
                                  )
                              ),

                            ],
                          );
                        }else{
                          print(map);
                          return Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20,),
                              Text("用户 "+map["Account"].toString(),style: TextStyle(fontSize: 30,fontFamily: "CustomFont"),),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  LogButton(
                                    onTap: (){
                                      FlutterData.ExitAccount().then((value) {
                                        setFutureLogin();
                                        setState(() {
                                          globalKey.currentState?.restartSync();
                                          globalKey.currentState?.setState(() {

                                          });

                                        });
                                      });
                                    },
                                      color: Colors.redAccent.shade100,
                                      height: 50,
                                      width: 100,
                                      child: Center(
                                          child: Text("退出账号",style: TextStyle(fontSize: 20,fontFamily: "CustomFont"))
                                      ),
                                      borderRadius: 20
                                  ),
                                  SizedBox(width: 10,),
                                  LogButton(
                                    onTap: (){
                                      FlutterData.SyncData(map["Account"]!).then((value) {

                                        globalKey.currentState!.restartSync();
                                        globalKey.currentState!.setState(() {

                                        });
                                      });
                                    },
                                    color: Colors.blue.shade100,
                                      height: 50,
                                      width: 100,
                                      child: Center(
                                          child: Text("同步数据",style: TextStyle(fontSize: 20,fontFamily: "CustomFont"))
                                      ),
                                      borderRadius: 20)
                                  ,
                                ],
                              )
                            ],
                          ),
                          );
                        }

                      }
                      return SizedBox();
                    },
                  ),//
                ),
              )

            ],
          ),
        ),
      ),
      body: [HomePage(globalKey: globalKey,),Container(color: Colors.red,)][currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromARGB(100, 255, 0, 137),
        currentIndex: currentIndex,
        onTap: (index){

          setState(() {
            currentIndex=index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "首页"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: "统计"
          )
        ],
        
      ),
    );
  }
}


