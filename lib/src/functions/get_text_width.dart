import 'package:flutter/painting.dart';

/// Obter o tamanho do texto
double getTextWidth(String text, {TextStyle? style, double textScaleFactor = 1.0}){
    
  TextPainter painter = TextPainter(
    text: TextSpan(
      text: text,
      style: style
    ),
    maxLines: 1,
    textScaleFactor: textScaleFactor,
    textDirection: TextDirection.ltr
  );

  painter.layout();

  return painter.size.width;
}
