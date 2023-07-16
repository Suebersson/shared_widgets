import 'package:flutter/material.dart';

class StatusBarSpacer extends StatelessWidget {
  const StatusBarSpacer({
    Key? key,
    this.color,
  }) : super(key: key);
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).padding.top,
      width: double.infinity,
      child: ColoredBox(
        color: color ?? Theme.of(context).appBarTheme.backgroundColor ?? Colors.amber,
      ),
    );
  }
}
