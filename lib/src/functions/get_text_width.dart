import 'package:flutter/painting.dart';

/// Obter o tamanho do texto
double getTextWidth(String text, {TextStyle? style, TextScaler? textScale}){
  final TextPainter painter = TextPainter(
    text: TextSpan(
      text: text,
      style: style
    ),
    maxLines: 1,
    textScaler: textScale ?? const TextScaler.linear(1.0),
    textDirection: TextDirection.ltr
  );
  painter.layout();
  return painter.size.width;
}