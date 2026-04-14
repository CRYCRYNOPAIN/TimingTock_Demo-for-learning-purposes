import 'package:flutter/material.dart';
import 'package:timing_tock/HomePage/HomeList.dart';
///首页
class HomePage extends StatefulWidget {
  final  GlobalKey globalKey;
  const HomePage({Key? key, required this.globalKey}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late GlobalKey globalKey;//方便后续从widget拿state

  late HomeList homeList;//列表

  late PageController pageController;//首页日期段选择

  int currentIndex =0;//当前索引值

  @override
  void initState() {
    super.initState();

    pageController=PageController(viewportFraction: 0.5);

    globalKey=widget.globalKey;

    homeList=HomeList(key: globalKey, onChange: (index) {
        pageController.animateToPage(index, duration: Duration(milliseconds: 100), curve: Curves.linear);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: PageView(
              controller: pageController,
              onPageChanged: (index){
                currentIndex=index;
                setState(() {
                  (globalKey.currentState as HomeListState).setPageGoTo(index);
                });
              },
              //三个大字
              children: [
                Center(
                  child: CustomAnimatedDefaultTextStyle(index: 0, currentIndex: currentIndex, text: '今日计划',),
                ),
                Center(
                  child: CustomAnimatedDefaultTextStyle(index: 1, currentIndex: currentIndex, text: '本周计划',),
                ),
                Center(
                  child: CustomAnimatedDefaultTextStyle(index: 2, currentIndex: currentIndex, text: '当月计划',),
                ),
              ],
            ),
          ), //日期段
          Expanded(
              child:homeList
          )

        ],
      ),
    );
  }
}
class CustomAnimatedDefaultTextStyle extends StatelessWidget {
  late int currentIndex;
  late int index;
  late String text;
  CustomAnimatedDefaultTextStyle({Key? key,required this.index,required this.currentIndex,required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      child: Text(text),
      style: TextStyle(
          fontSize: currentIndex==index?40:26,
          fontFamily: "CustomFont",
          color: Colors.black,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.5), // 阴影颜色
              offset: Offset(3.0, 4.0),            // 偏移量：向右 2，向下 2
              blurRadius: 10.0,
            )
          ]
      ),
      duration: Duration(milliseconds: 100)
      ,
    );
  }
}//封装的AnimatedDefaultTextStyle类
