import 'package:flutter/material.dart';

class CustomText extends Text {

  CustomText(String text , { textAlign = TextAlign.center , color = Colors.grey , fontSize  = 15.0 , fontStyle  = FontStyle.normal , factor = 1.0  } ) 
 
  :super(
      text ,
      textAlign: textAlign,
      textScaleFactor: factor,
      style: TextStyle(
        color:color,
        fontSize:fontSize,
        fontStyle: fontStyle,
        
      )
  );

}