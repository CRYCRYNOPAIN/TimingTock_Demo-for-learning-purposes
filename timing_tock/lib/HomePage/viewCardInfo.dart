import 'package:flutter/material.dart';

class CardInfo extends StatelessWidget {
  final int recordTypeNumber;
  final String title;
  final double time;
  final bool ifDaKa;
  final bool ifFinish;
  final double progress;
  final String recordTime;

  const CardInfo({
    super.key,
    required this.recordTypeNumber,
    required this.title,
    required this.time,
    required this.ifDaKa,
    required this.ifFinish,
    required this.progress,
    required this.recordTime,
  });

  @override
  Widget build(BuildContext context) {
    String typeText = recordTypeNumber == 0 ? "每日" : (recordTypeNumber == 1 ? "每周" : "每月");

    return Center(
      child: Container(
        width: 250,
        height: 350,
        padding: const EdgeInsets.all(20),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(100)
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold,fontFamily: "CustomFont"),
            ),
            const SizedBox(height: 10),

            //
            Text(
              "$typeText任务 · ${ifDaKa ? "打卡制" : "计时制"}",
              style: const TextStyle(color: Color.fromARGB(100, 255, 0, 137), fontSize: 14,fontFamily: "CustomFont"),
            ),

            const Spacer(),


            if (ifDaKa) ...[

              Icon(ifFinish ? Icons.check_circle : Icons.circle_outlined,
                  size: 50, color: ifFinish ? Color.fromARGB(100, 255, 0, 137) : Colors.grey),
              Text(ifFinish ? "已完成" : "未完成",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500,fontFamily: "CustomFont")),
            ] else ...[

              Text("进度: ${(progress / time * 100).toStringAsFixed(0)}%",style: TextStyle(fontFamily: "CustomFont"),),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress / time,
                minHeight: 8,

                //borderRadius: BorderRadius.circular(4),
                backgroundColor: Colors.grey[200],
                color: Color.fromARGB(100, 255, 0, 137),

              ),
              const SizedBox(height: 8),
              Text("计划: $time 小时", style: const TextStyle(color: Colors.grey,fontFamily: "CustomFont")),
              SizedBox(height: 20,),

            ],
            SizedBox(
              width: double.infinity, //
              child: ElevatedButton.icon(
                onPressed: () {

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("确认删除",style: TextStyle(fontFamily: "CustomFont"),),
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.white,


                        content: const Text("删除后任务数据将无法恢复，确定要继续吗？",style: TextStyle(fontSize: 16,fontFamily: "CustomFont"),),

                        shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(50)),

                        actions: [

                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("取消", style: TextStyle(color: Colors.grey,fontFamily: "CustomFont")),
                          ),

                          TextButton(
                            onPressed: () {

                              Navigator.of(context).pop(true);
                            },
                            child: const Text("删除", style: TextStyle(color: Color.fromARGB(100, 255, 0, 137), fontWeight: FontWeight.bold,fontFamily: "CustomFont")),
                          ),
                        ],
                      );
                    },
                  ).then((value){
                    if(value){
                      Navigator.of(context).pop(true);
                    }
                  });
                  print("点击了删除: $title");

                },
                icon: const Icon(Icons.delete_rounded, size: 18),
                label: const Text("删除任务"),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  foregroundColor: Colors.red,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}