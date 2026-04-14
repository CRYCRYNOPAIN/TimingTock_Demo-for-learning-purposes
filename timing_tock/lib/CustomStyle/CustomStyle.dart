import 'package:flutter/material.dart';
class CustomStyle{
  static _CustomTextStyle customTextStyle=_CustomTextStyle();
}
class _CustomTextStyle{
     TextStyle TitleText1=const TextStyle(
      color: Colors.black,
       fontFamily: "CustomFont"

    );
     TextStyle PageViewText1=const TextStyle(
       fontSize: 30,
       fontWeight: FontWeight.bold,
         fontFamily: "CustomFont"
     );
}