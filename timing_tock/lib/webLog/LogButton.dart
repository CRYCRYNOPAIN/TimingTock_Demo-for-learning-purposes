import 'package:flutter/material.dart';
class LogButton extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;
  final double borderRadius;
  final Color color;
  late void Function()? onTap ;
  LogButton({Key? key, this.onTap,required this.height, required this.width, required this.child, required this.borderRadius, this.color=Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
          shadows: const [
            BoxShadow(
                color: Colors.black26,
                offset: Offset(0.0,10.0),
                blurRadius: 30
            )
          ],
          color: color,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          )
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: child
        ),
      ),
    );
  }
}

