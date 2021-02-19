import 'dart:ui' ;
import 'package:flutter/material.dart';

fontStyle(var color, double size, bool bold){
  return(
      TextStyle(
        fontFamily: 'Barlow',
        color: color,
        fontWeight: bold ? FontWeight.bold: null,
        fontSize: size,
      )
  );

}