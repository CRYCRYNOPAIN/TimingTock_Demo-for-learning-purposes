import 'package:flutter/material.dart';
class BaseHomeListButton extends StatelessWidget {
  final Color color;
  final Widget child;
  final void Function() onTap;
  final Widget? floating;

  BaseHomeListButton({Key? key, required this.color, required this.child, required this.onTap, this.floating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30,20 ,30,20),
      width: 250,
      height: 100,
      decoration: ShapeDecoration(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        shadows: const [
          BoxShadow(
              color: Color.fromARGB(50, 0, 0, 0),
              offset: Offset(0,15),
              blurRadius: 20
          )
        ],

      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: ShapeDecoration(
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            color: color,
          ),
          child: Stack(
            children: [
              InkWell(
                onTap: onTap,
                customBorder: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(50),

                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: child,
                ),
              ),
              floating??SizedBox(width: 0,height: 0,)
            ],
          ),
        ),
      ),
    );
  }
}
class ToAddHomeList extends BaseHomeListButton {
  ToAddHomeList({super.key,required super.color, required super.child, required super.onTap});

}
class HomeListButton extends BaseHomeListButton {
  final String title;
  HomeListButton({super.key, super.floating,required this.title, required super.child, required super.color, required super.onTap});

}



