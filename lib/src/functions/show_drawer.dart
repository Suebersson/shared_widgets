import 'package:flutter/material.dart';

// Created by `Suebersson Montalvão` - 15/08/2020
// Upgraded 01/02/2023

/// Widget de sobreposição(overlay) semelhante a `drawer` da biblioteca [Material],
void showDrawer({
  required Widget child, 
  required BuildContext context, 
  double width = 304.0, 
  Color barrierColor = Colors.black12,
  Duration transitionDuration = const Duration(milliseconds: 500),
}){

  showGeneralDialog(
    context: context,
    barrierLabel: "showDrawer",
    barrierDismissible: true,
    barrierColor: barrierColor,
    transitionDuration: transitionDuration,
    pageBuilder: (context, animation, secondAnimation){
      return Dismissible(
        onDismissed: (_) => Navigator.pop(context),
        key: const Key("showDrawer"),
        direction: DismissDirection.horizontal,
        child: Stack(
          alignment: Alignment.centerLeft,
          children:[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: ColoredBox(
                  color: Colors.transparent,
                ),
              )
            ),
            SizedBox(
              height: double.infinity,
              width: width,
              child: child,
            ),
          ],
        ),
      );
    },
    transitionBuilder: (context, animation, secondAnimation, widget){
      return SlideTransition(
        // position: Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero).animate(animation),
        position: animation.drive(
          Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.linear))
        ),
        child: widget,
      );
    },
  );
}


/// `Exemplo de uso`
///
/// ```dart
/// class HomePage extends StatelessWidget {
///   const HomePage({ Key? key }) : super(key: key);
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(
///         title: const Text('Teste showDrawer'),
///       ),
///       body: Center(
///         child: ElevatedButton(
///           child: const Text('drawer'),
///           onPressed: (){
///             showDrawer(
///               child: const DrawerDemo(),
///               context: context
///             );
///           },
///         )
///       ),
///     );
///   }
/// }
/// ```
