import 'package:flutter/material.dart';

import '../widgets/boolean_builder.dart';
import '../widgets/barrier_builder.dart';

/// Exibir uma mensagem de text usando a função [showGeneralDialog]
Future<void> displayInformation({
  required String message,
  required BuildContext context,
  ThemeData? theme,
  Widget? buttonOk,
  TextStyle? messageStyle,
  double? height,
  double? width,
  Color? backgroundColor,
  ScrollPhysics? backgroundPhysics,
  Color? barrierColor,
  String? barrierLabel,
  EdgeInsetsGeometry? margin,
  EdgeInsetsGeometry? padding,
  BorderRadiusGeometry? borderRadius,
  Tween<Offset>? position,
  DismissDirection? direction,
  Duration? transitionDuration,
}) {

  /*
    Exemplo de uso

    const TextStyle style = TextStyle(
      color: Colors.white,
      fontSize: 17.0
    );

    await displayInformation(
      context: context,
      messageStyle: style,
      barrierLabel: 'showGuestAccessAlert',
      message: 
        'Ao acessar o app como convidado(a), você tem limitações e não pode:\n\n'
        '- Criar uma foto de perfil\n'
        '- Criar uma live\n'
        '- Publicar um evento\n'
        '- Ver os eventos reais, apenas os eventos fictícios são visíveis\n'
        '- ...',
    );

  */


  // Exibir a animação de baixo  para cima
  position ??= Tween(begin: const Offset(0, 1), end: const Offset(0, 0));

  theme ??= Theme.of(context);

  messageStyle ??= theme.textTheme.bodySmall;

  return showGeneralDialog<void>(
    context: context,
    barrierLabel: barrierLabel ?? 'displayInformation',
    barrierDismissible: true,
    barrierColor: barrierColor ?? Colors.black45,
    transitionDuration: transitionDuration ?? const Duration(milliseconds: 400),
    routeSettings: const RouteSettings(name: 'displayInformation'),
    pageBuilder: (context, animation, animation2){
      return Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              const BarrierBilder(),
              FittedBox(
                fit: BoxFit.fitHeight,
                child: LimitedBox(
                  maxWidth: MediaQuery.sizeOf(context).width,
                  child: Dismissible(
                    onDismissed: (_) => Navigator.pop(context),
                    key: const Key("displayInformationDismissible"),
                    direction:  direction ?? DismissDirection.down,
                    child: Container(
                      height: height,
                      width: width,
                      alignment: Alignment.center,
                      margin: margin ?? const EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                      padding: padding ?? const EdgeInsets.symmetric(horizontal: 14.0, vertical: 20.0),
                      decoration: BoxDecoration(
                        color: backgroundColor ?? theme?.dialogTheme.backgroundColor,
                        borderRadius: borderRadius ?? BorderRadius.circular(8.0),
                      ),
                      child: SingleChildScrollView(
                        physics: backgroundPhysics ?? const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              message,
                              style: messageStyle,
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 20.0),
                            BooleanBuilder(
                              test: buttonOk is Widget, 
                              whenTrue: (_) => buttonOk ?? const SizedBox.shrink(),
                              whenFalse: (_) => ActionChip(
                                tooltip: 'OK',
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                label: Text('OK', style: messageStyle,),
                                onPressed: () => Navigator.pop(context),
                              ),
                              // whenFalse: (_) => FilledButton(
                              //   onPressed: () => Navigator.pop(context),
                              //   style: theme?.filledButtonTheme.style?.copyWith(
                              //     padding: const MaterialStatePropertyAll(EdgeInsets.all(4.0))
                              //   ),
                              //   child: Text('OK', style: messageStyle,),
                              // ),
                            ),
                          ],
                        )
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, animation2, widget){
      return SlideTransition(
        position: position!.animate(animation),
        child: widget,
      );
    },
  );
}