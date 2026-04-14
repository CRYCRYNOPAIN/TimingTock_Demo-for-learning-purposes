

import 'package:flutter/material.dart';
class AddNewList extends StatefulWidget {
  final void Function() fun;
  AddNewList({Key? key, required this.fun}) : super(key: key);

  @override
  State<AddNewList> createState() => _AddNewListState();
}

class _AddNewListState extends State<AddNewList> {
  int? dropdownIndex;
  bool ifDaKa=false;
  String? title;
  double time=0;
  late TextEditingController textEditingController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController=TextEditingController();
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Container(
        width: 250,
        height: 400,
        decoration: ShapeDecoration(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(50)
          ),
          color: Colors.white,

        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            SizedBox(height: 30,),
            SizedBox(height: 30,child:Text("新建计划",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,fontFamily: "CustomFont"),) ,),
            ///计划名称
            Row(
            children: [
              SizedBox(width: 30,),
              SizedBox(width: 80,child: Text("名称：",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,fontFamily: "CustomFont"),),),
              Expanded(child: Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                width: double.infinity,
                height: 50,
                child: Material(
                  color: Colors.transparent,
                  clipBehavior: Clip.antiAlias,
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16,fontFamily: "CustomFont"),
                    onChanged: (value){
                      title=value;
                    },
                    onSubmitted:(value){
                      title=value;
                    },
                  ),
                ),
              )),
              SizedBox(width: 30,)
            ],
          ),
            ///计划周期
            Row(
              children: [
                SizedBox(width: 30,),
                SizedBox(width: 80,child: Text("计划周期：",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,fontFamily: "CustomFont"),),),
                Expanded(child: SizedBox(

                  width: double.infinity,
                  height: 50,
                  child: Material(
                    color: Colors.transparent,
                    clipBehavior: Clip.antiAlias,
                    child: DropdownButton<int>(
                      alignment: Alignment.center,
                      isExpanded: true  ,
                      value: dropdownIndex,
                      hint: Text("选择计划周期",style: TextStyle(fontSize: 14,fontFamily: "CustomFont"),),
                      items: [
                        DropdownMenuItem<int>(value: 0,child: Center(
                          child: Text("每日",style: TextStyle(fontFamily: "CustomFont"),),
                        )),
                        DropdownMenuItem<int>(value: 1,child: Center(
                          child: Text("每周",style: TextStyle(fontFamily: "CustomFont"),),
                        )),
                        DropdownMenuItem<int>(value: 2,child: Center(
                          child: Text("每月",style: TextStyle(fontFamily: "CustomFont"),),
                        )),
                      ],
                      onChanged: (int? value) {
                        dropdownIndex=value!;
                        setState(() {
                          }
                          );
                        },


                    ),
                  ),
                )),
                SizedBox(width: 30,)
              ],
            ),
            ///是否是纯打卡
            Row(
              children: [
                SizedBox(width: 30,),
                SizedBox(width: 80,child: Text("纯打卡：",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,fontFamily: "CustomFont"),),),
                Expanded(child: Material(
                  color: Colors.transparent,
                  child: Switch(
                    activeColor: Color.fromARGB(100, 255, 0, 137),
                    value: ifDaKa, onChanged: (bool value) {
                    ifDaKa=value;
                    setState(() {


                    });
                  },

                  )),),
                SizedBox(width: 30,)
              ],
            ),
            ///周期时长
            ifDaKa?Row():Row(
              children: [
                SizedBox(width: 30,),
                SizedBox(width: 80,child: Text("周期时长：",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,fontFamily: "CustomFont"),),),
                Expanded(child: Container(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  width: double.infinity,
                  height: 50,
                  child: Material(
                    color: Colors.transparent,
                    clipBehavior: Clip.antiAlias,
                    child: TextField(
                      controller: textEditingController,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16,fontFamily: "CustomFont"),
                      keyboardType: TextInputType.number,
                      onChanged: (value){
                        try{
                          time=double.parse(value);
                        }catch(e){
                          time=0;
                          textEditingController.text="";
                        }

                      },
                      onSubmitted:(value){
                        try{
                          time=double.parse(value);
                        }catch(e){
                          time=0;
                          textEditingController.text="";

                        }
                      },
                    ),
                  ),
                )),
                Text("h",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "CustomFont"),),
                SizedBox(width: 30,),

              ],
            ),
            Expanded(child: Align(
              alignment: Alignment.bottomCenter,
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color.fromARGB(100, 255, 0, 137)
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.cancel_rounded),
                    label: Text("取消"),

                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color.fromARGB(100, 255, 0, 137)
                    ),
                    onPressed: () {
                      if(!(title==null)){
                        if(!(title!.isEmpty||dropdownIndex==null)){
                          if((!ifDaKa&&time!=0)||ifDaKa){
                            Navigator.of(context).pop(
                                {
                                  "title":title,//标题
                                  "recordTypeNumber":dropdownIndex,//日周月
                                  "time":time,//时长
                                  "ifDaKa":ifDaKa,//是否纯打卡
                                  "ifFinish":false,//是否完成
                                  "progress":0.0
                                }
                            );
                            //widget.fun();//异步刷新
                          }
                        }
                      }

                    },
                    icon: Icon(Icons.next_plan_rounded),
                    label: Text("确认"),

                  ),
                ],

              ),
            )),
            SizedBox(height: 20,)


          ],
        ),
      ),
    );
  }
}
