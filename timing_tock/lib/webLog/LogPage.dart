import 'package:flutter/material.dart';
import 'package:timing_tock/DataProcessing/DataModel.dart';
import 'package:timing_tock/webLog/LogButton.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late TextEditingController textEditingController;
  late TextEditingController textEditingController1;
  final curves = Curves.easeInCirc;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    textEditingController = TextEditingController();
    textEditingController1 = TextEditingController();
    animationController.reset();
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                getAnimatedWidget(
                    child: Text(
                      "TimingTocK",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Customfont"),
                    ),
                    interval: Interval(0.0, 0.4, curve: curves)),
                SizedBox(
                  height: 30,
                ),
                getAnimatedWidget(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "账号：",
                          style:
                              TextStyle(fontSize: 20, fontFamily: "Customfont"),
                        ),
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                              color: Colors.white,
                              shadows: [
                                BoxShadow(color: Colors.black26, blurRadius: 30)
                              ],
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          width: 200,
                          height: 40,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                            child: TextField(
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                              ),
                              cursorColor: Color.fromARGB(100, 255, 0, 137),
                              controller: textEditingController,
                            ),
                          ),
                        )
                      ],
                    ),
                    interval: Interval(0.2, 0.6, curve: curves)),
                SizedBox(
                  height: 30,
                ),
                getAnimatedWidget(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "密码：",
                          style:
                              TextStyle(fontSize: 20, fontFamily: "Customfont"),
                        ),
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                              color: Colors.white,
                              shadows: [
                                BoxShadow(color: Colors.black26, blurRadius: 30)
                              ],
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          width: 200,
                          height: 40,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                            child: TextField(
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                              ),
                              cursorColor: Color.fromARGB(100, 255, 0, 137),
                              controller: textEditingController1,
                            ),
                          ),
                        )
                      ],
                    ),
                    interval: Interval(0.4, 0.8, curve: curves)),
                SizedBox(
                  height: 40,
                ),
                getAnimatedWidget(
                    child: LogButton(
                        onTap: () {
                          if (textEditingController.text.isEmpty ||
                              textEditingController1.text.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (bc) {
                                  return AlertDialog(
                                    elevation: 0,
                                    content: SizedBox(
                                      width: 150,
                                      height: 50,
                                      child: Center(
                                        child: Text(
                                          "账号或密码不能为空",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: "CustomFont"),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            Future future=FlutterData.TryLogIn(textEditingController.text,
                                textEditingController1.text);
                            showDialog(barrierDismissible: false,context: context, builder: (bc){
                              return Loading(future: future,);
                            }).then((value) {
                              if(value.toString().startsWith("{")){
                                print(value);
                                Navigator.of(context).pop(value);
                              }else{
                                showDialog(
                                    context: context,
                                    builder: (bc) {
                                      return AlertDialog(
                                        elevation: 0,
                                        content: SizedBox(
                                          width: 150,
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: "CustomFont"),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              }

                            }) ;

                          }
                        },
                        height: 50,
                        width: 100,
                        child: Center(
                          child: Text(
                            "登陆",
                            style: TextStyle(
                                fontSize: 20, fontFamily: "Customfont"),
                          ),
                        ),
                        borderRadius: 30),
                    interval: Interval(0.6, 1.0, curve: curves)),
              ],
            ),
            Center(

            )
          ],
        ),
      ),
    );
  }

  Widget getAnimatedWidget({
    required Widget child,
    required Interval interval,
  }) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: interval,
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(2.0, 0.0), end: Offset.zero)
            .animate(
          CurvedAnimation(
            parent: animationController,
            curve: interval,
          ),
        ),
        child: child, // 这里直接使用传入的 widget
      ),
    );
  }
}
class Loading extends StatelessWidget {
  final Future future;

  const Loading({Key? key, required this.future}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      backgroundColor: Colors.white,
      content: FutureBuilder(
        future: future,
        builder: (bc,a){
          if(a.connectionState==ConnectionState.waiting){

            return Container(
              width: double.infinity,
              height: double.infinity,
              //color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if(a.hasData){
            Navigator.of(context).pop(a.data);
          }

          return SizedBox();
        },
      ),
    );
  }
}

