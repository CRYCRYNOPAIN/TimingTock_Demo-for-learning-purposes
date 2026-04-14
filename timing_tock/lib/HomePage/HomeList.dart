import 'package:flutter/material.dart';
import 'package:timing_tock/HomePage/AddNewList.dart';
import 'package:timing_tock/HomePage/HomeListButton.dart';
import 'package:timing_tock/HomePage/viewCardInfo.dart';

import '../DataProcessing/DataModel.dart';
import '../RecordTime.dart';
import '../StateManager.dart';
class HomeList extends StatefulWidget {
  final Function(int) onChange;
  const HomeList({Key? key, required this.onChange}) : super(key: key);

  @override
  State<HomeList> createState() => HomeListState();
}

class HomeListState extends State<HomeList> {
  int current = 0;
  late PageController pageController;
  Map<String, dynamic> dailyList = {};
  Map<String, dynamic> weekList = {};
  Map<String, dynamic> mouthList = {};
  List<Widget> daily = [];
  List<Widget> week = [];
  List<Widget> month = [];
  late Future syncJson;

  void restartSync() {
    syncJson = FlutterData.SyncJsonFromJavaLocal();

    syncJson.then((value) {
      final map = value.cast<String, dynamic>();
      setState(() {
        dailyList = (map["Days"] as Map<Object?, Object?>?)?.cast<String, dynamic>() ?? {};
        weekList = (map["Weeks"] as Map<Object?, Object?>?)?.cast<String, dynamic>() ?? {};
        mouthList = (map["Months"] as Map<Object?, Object?>?)?.cast<String, dynamic>() ?? {};
        daily = setList(dailyList);
        week = setList(weekList);
        month = setList(mouthList);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    restartSync();
    StateManager.navToAddNewList = NavToAddNewList;
  }

  List<Widget> setList(Map<String, dynamic> map) {
    List<Widget> list = [];
    if (map.isNotEmpty) {
      map.forEach((key, value) {
        Map<String, dynamic> listContent = (value as Map<Object?, Object?>).cast<String, dynamic>();

        list.add(
          HomeListItemWidget(
            key: ValueKey(listContent['recordTime']),
            title: listContent["title"],
            recordTypeNumber: (listContent["recordTypeNumber"] as num).toInt(),
            time: (listContent["time"] as num).toDouble(),
            ifDaKa: listContent["ifDaKa"],
            ifFinish: listContent["ifFinish"],
            progress: (listContent["progress"] as num).toDouble(),
            recordTime: listContent['recordTime'],
            onRefresh: restartSync,
          ),
        );
      });
    }

    if (map.isEmpty) {
      list.add(getToAddHomeListBtn());
    }
    changeFAB(current);
    return list;
  }

  void setPageGoTo(index) {
    pageController.animateToPage(index, duration: const Duration(milliseconds: 100), curve: Curves.linear);
  }

  void NavToAddNewList(BuildContext buildContext) {
    showDialog(
        context: context,
        builder: (bc) {
          return AddNewList(fun: () {
            restartSync();
          });
        }).then((value) async {
      if (value != null) {
        var map = value as Map<String, dynamic>;
        RecordData recordData = RecordData(
            ifDaKa: map["ifDaKa"],
            recordTypeNumber: map["recordTypeNumber"],
            title: map["title"],
            time: map["time"],
            ifFinish: map["ifFinish"],
            progress: map["progress"]);
        await FlutterData.AddRecordData(recordData);
        restartSync();
      }
    });
  }

  Widget getToAddHomeListBtn() {
    return ToAddHomeList(
        color: const Color.fromARGB(100, 255, 0, 137),
        onTap: () {
          NavToAddNewList(context);
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "点击以添加一个计划",
                style: TextStyle(color: Colors.white, fontFamily: "CustomFont"),
              ),
              Icon(Icons.add, color: Colors.white)
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        widget.onChange(index);
        current = index;
        changeFAB(index);
      },
      children: [
        FutureBuilder(
          future: syncJson,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) return ListView(children: daily);
            return Container();
          },
        ),
        FutureBuilder(
          future: syncJson,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) return ListView(children: week);
            return Container();
          },
        ),
        FutureBuilder(
          future: syncJson,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) return ListView(children: month);
            return Container();
          },
        ),
      ],
    );
  }

  void changeFAB(index) {
    switch (index) {
      case 0:
        StateManager.changeFAB(dailyList.isNotEmpty);
        break;
      case 1:
        StateManager.changeFAB(weekList.isNotEmpty);
        break;
      case 2:
        StateManager.changeFAB(mouthList.isNotEmpty);
        break;
    }
  }
}
class HomeListItemWidget extends StatefulWidget {
  final int recordTypeNumber;
  final String title;
  final double time;
  final bool ifDaKa;
  final bool ifFinish;
  final double progress;
  final String recordTime;
  final VoidCallback onRefresh; // 对应之前的 restartSync

  const HomeListItemWidget({
    Key? key,
    required this.recordTypeNumber,
    required this.title,
    required this.time,
    required this.ifDaKa,
    required this.ifFinish,
    required this.progress,
    required this.recordTime,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<HomeListItemWidget> createState() => _HomeListItemWidgetState();
}

class _HomeListItemWidgetState extends State<HomeListItemWidget> {
  bool bool1=false;

  final RecordTIme _timer = RecordTIme();



  @override
  Widget build(BuildContext context) {
    return HomeListButton(
      title: widget.title,
      color: const Color.fromARGB(255, 255, 255, 255),
      onTap: () {
        showDialog(context: context, builder: (bc) {
          return CardInfo(
              recordTypeNumber: widget.recordTypeNumber,
              title: widget.title,
              time: widget.time,
              ifDaKa: widget.ifDaKa,
              ifFinish: widget.ifFinish,
              progress: widget.progress,
              recordTime: widget.recordTime
          );
        }).then((value) async {
          if (value != null && value) {
            await FlutterData.DeleteRecordData(widget.recordTime, widget.recordTypeNumber);
            widget.onRefresh();
          }
        });
      },
      floating: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          children: [
            const Expanded(flex: 9, child: SizedBox()),
            ...widget.ifDaKa ? [
              Expanded(
                flex: 6,
                child: Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(100, 255, 0, 137),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.done),
                    label: const Text("完成"),
                  ),
                ),
              )
            ] : [
              Expanded(
                flex: 6,
                child: SizedBox(
                  height: double.infinity,
                  child: Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color.fromARGB(100, 255, 0, 137),
                      ),
                      onPressed: () {
                        if(!widget.ifFinish){
                          bool1=!bool1;
                        }

                        setState((){});
                        RecordData r = RecordData(
                            progress: widget.progress,
                            ifFinish: widget.ifFinish,
                            ifDaKa: widget.ifDaKa,
                            recordTypeNumber: widget.recordTypeNumber,
                            title: widget.title,
                            time: widget.time
                        );

                        _timer.startRecordTime(r, widget.recordTime, widget.onRefresh);

                      },
                      icon: bool1?const Icon(Icons.stop):const Icon(Icons.play_arrow_rounded),
                      label: bool1?Text("暂停"):const Text("计时"),

                    ),
                  ),
                ),
              )
            ],
            const SizedBox(width: 10),
          ],
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: widget.ifDaKa
                          ? const Icon(Icons.check, color: Color.fromARGB(100, 255, 0, 137))
                          : const Icon(Icons.pending_actions_rounded, color: Color.fromARGB(100, 255, 0, 137)),
                    ),
                  ),
                )
            ),
            Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(fontFamily: "CustomFont"),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          widget.ifFinish
                              ? "已完成"
                              : (widget.ifDaKa ? "未完成" : "${widget.progress.toStringAsFixed(4)} / ${widget.time.toStringAsFixed(1)} h"),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(fontFamily: "CustomFont"),
                        ),
                      ),
                    ),
                  ],
                )
            ),
            const Expanded(flex: 6, child: SizedBox())
          ],
        ),
      ),
    );
  }
}



