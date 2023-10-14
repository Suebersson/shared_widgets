import 'package:flutter/widgets.dart';

class BooleanBuilder extends StatelessWidget {

  /// [BooleanBuilder] é um widget simple, para uso alternativo a widget [Visibility]
  /// 
  /// Diferenças:
  /// 
  /// - A principal diferença é que os parâmetros [whenTrue] e [whenFalse] são apenas uma 
  /// função[WidgetBuilder] que retorna uma widget, sendo assim, a widget só será
  /// instânciada quando a função for chamada no teste condicional.
  /// 
  /// - É feito Apenas um teste condicional de IF ELSE, com isso a widget é
  /// processada e renderizado mais rápido.
  const BooleanBuilder({
    super.key,
    required this.test,
    required this.whenTrue,
    this.whenFalse,
  });

  final bool test;
  final WidgetBuilder whenTrue;
  final WidgetBuilder? whenFalse;

  @override
  Widget build(BuildContext context) {
    return test 
      ? whenTrue.call(context) 
      : whenFalse?.call(context) ?? const SizedBox.shrink();
  }
}