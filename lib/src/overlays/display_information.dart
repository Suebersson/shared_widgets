import 'package:flutter/material.dart';

/// Exibir uma mensagem de text usando a função [showGeneralDialog]
Future<void> displayInformation({
  required String message,
  required BuildContext context,
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

  return showGeneralDialog<void>(
    context: context,
    barrierLabel: barrierLabel ?? 'displayInformation',
    barrierDismissible: true,
    barrierColor: barrierColor ?? Colors.black45,
    transitionDuration: transitionDuration ?? const Duration(milliseconds: 400),
    pageBuilder: (context, animation, animation2){
      return Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const ColoredBox(
                  color: Colors.transparent,
                  child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                )
              ),
              Dismissible(
                onDismissed: (_) => Navigator.pop(context),
                key: const Key("displayInformationDismissible"),
                direction:  direction ?? DismissDirection.down,
                child: Container(
                  height: height ?? 320.0,
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: margin ?? const EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                  padding: padding ?? const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: backgroundColor ?? Theme.of(context).dialogBackgroundColor,
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
                        Visibility(
                          visible: buttonOk != null,
                          replacement: FilledButton(
                            onPressed: () => Navigator.pop(context),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'OK',
                                style: messageStyle,
                              ),
                            )
                          ),
                          child: buttonOk ?? const SizedBox.shrink(),
                        )
                      ],
                    )
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