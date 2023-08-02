/*
import 'package:flutter/widgets.dart';

// Exemplo de chamada
// touthMeTogoPage(widget: AnyPage(), alignment: Alignment(0.8, 0.9), routeName: '/AnyPage', transitionTime: 7000);
Route touthMeTogoPage({@required Widget widget, @required Alignment alignment, String routeName, Object argument, int transitionTime = 300, Curve curve = Curves.ease, bool fullscreenDialog = false}){
  /// Widget para transição de rotas customizado, atrevés da propriedadde `Aligment(x,y)`
  /// podemos definir o lugar da tela para abrir a página 
  assert(widget != null, 'Insira o página("widget") para navegação');
  return PageRouteBuilder(
    fullscreenDialog: fullscreenDialog,
    settings: RouteSettings(name: routeName, arguments: argument),
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionDuration: Duration(milliseconds: transitionTime),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular((1-animation.value)*45),
            child: widget
          ),
          alignment: alignment ?? Alignment(0.0, 0.0),
        ),
      );
    },
  );
}
*/