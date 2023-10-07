import 'package:flutter/material.dart';

/// Solicitar confirmação para uma ação do usuário
Future<bool> requestConfirmation({
  required String question,
  required BuildContext context,
  String labelToTrue = 'Sim',
  String labelToFalse = 'Não',
  TextStyle? questionStyle,
  TextStyle? buttonTextStyle,
  double? height,
  double? width,
  Color? backgroundColor,
  Color? barrierColor,
  EdgeInsetsGeometry? margin,
  EdgeInsetsGeometry? padding,
  BorderRadiusGeometry? borderRadius,
  Tween<Offset>? position,
  DismissDirection? direction,
  Duration? transitionDuration,
  AlignmentGeometry? alignment,
}) async{

  /*
    Exemplo de uso

    const TextStyle style = TextStyle(
      color: Colors.white,
      fontSize: 17.0
    );

    requestConfirmation(
      context: context,
      question: 'Deseja remover sua foto do perfil?',
      questionStyle: style,
      buttonTextStyle: style.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w700
      ),
      backgroundColor: Colors.blueGrey,
    ).then((questionResult) {
      if (questionResult) {
        
        debugPrint('Run: $questionResult');
        
      }
    });

  */

  // Exibir a animação de baixo  para cima
  position ??= Tween(begin: const Offset(0, 1), end: const Offset(0, 0));
  
  return await showGeneralDialog<bool>(
    context: context,
    barrierLabel: "requestConfirmation",
    barrierDismissible: true,
    barrierColor: barrierColor ?? Colors.black45,
    transitionDuration: transitionDuration ?? const Duration(milliseconds: 400),
    routeSettings: const RouteSettings(name: 'requestConfirmation'),
    pageBuilder: (context, animation, animation2){
      return Material(
          color: Colors.transparent,
          child: SafeArea(
            child: Stack(
              alignment: alignment ?? Alignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context, false),
                  child: const ColoredBox(
                    color: Colors.transparent,
                    child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  )
                ),
                Dismissible(
                  onDismissed: (_) => Navigator.pop(context, false),
                  key: const Key("requestConfirmationDialog"),
                  direction:  direction ?? DismissDirection.down,
                  child: Container(
                    height: height ?? 120.0,
                    width: width ?? double.infinity,
                    alignment: Alignment.center,
                    margin: margin ?? const EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                    padding: padding ?? const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: backgroundColor ?? Theme.of(context).dialogBackgroundColor,
                      borderRadius: borderRadius ?? BorderRadius.circular(8.0),
                    ),
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              question,
                              style: questionStyle,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, true), 
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    labelToTrue,
                                    style: buttonTextStyle,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    labelToFalse,
                                    style: buttonTextStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
  ) ?? false;
}