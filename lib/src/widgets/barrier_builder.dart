import 'package:flutter/material.dart';

class BarrierBilder<T extends Object?> extends StatelessWidget {
  
  const BarrierBilder({
    super.key,
    this.popResult
  });

  final T? popResult;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, popResult),
      child: const ColoredBox(
        color: Colors.transparent,
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
        ),
      )
    );
  }
  
}