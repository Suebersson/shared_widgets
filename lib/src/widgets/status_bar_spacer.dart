import 'package:flutter/material.dart';

class StatusBarSpacer extends StatelessWidget {
  const StatusBarSpacer({
    super.key,
    this.color,
  });
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.paddingOf(context).top,
      width: double.infinity,
      child: ColoredBox(
        color: color ?? Theme.of(context).appBarTheme.backgroundColor ?? Colors.amber,
      ),
    );
  }
}
