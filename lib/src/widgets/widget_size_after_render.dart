
// Created by `Suebersson Montalvão` - 14/07/2023
// Upgraded 14/07/2023

import 'package:flutter/widgets.dart';

/// Obter a o tamanho de uma [Widget] após a renderizeção
class WidgetSizeAfterRender extends StatefulWidget {
  const WidgetSizeAfterRender({
    Key? key,
    required this.child,
    required this.afterRendering
  }) : super(key: key);

  final Widget child;
  final Function(Size) afterRendering;

  @override
  State<WidgetSizeAfterRender> createState() => _WidgetSizeAfterRenderState();
}

class _WidgetSizeAfterRenderState extends State<WidgetSizeAfterRender> {
  
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.afterRendering(context.size ?? const Size(0.0, 0.0));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}