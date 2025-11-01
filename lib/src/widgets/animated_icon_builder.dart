import 'package:flutter/material.dart';

// Created by `Suebersson Montalvão` - 23/11/2020 
// Upgraded 14/07/2023

/// Widget que usa uma [IconButton] com animação para alternar entre dois ícones
/// semelhante ao widget [AnimatedIcon]
/// 
/// A diferença é que o mesmo permite uma customização maior
@immutable
class AnimatedIconBuilder extends StatefulWidget {

  final Icon icon, trasitionIcon;
  // final GestureTapCallback onPressed;
  final void Function(bool) onPressed;
  final void Function(bool Function())? afterRender;
  final Duration transitionTime;
  final Curve curve, reverseCurve;
  final String? tooltip;
  final double? iconSize, splashRadius;
  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;
  final Color? color,focusColor, hoverColor, highlightColor, splashColor, disabledColor;
  final MouseCursor mouseCursor;
  final FocusNode? focusNode;
  final bool autofocus; 
  final bool? enableFeedback, isSelected;
  final BoxConstraints? constraints;
  final ButtonStyle?  style;

  const AnimatedIconBuilder({
    super.key, 
    required this.icon, 
    required this.trasitionIcon, 
    required this.onPressed,
    this.afterRender,
    this.transitionTime = const Duration(milliseconds: 400), 
    this.curve = Curves.ease,
    this.reverseCurve = Curves.ease,
    /// propriedades para a widget [IconButton]
    this.tooltip,
    this.iconSize,
    this.visualDensity,
    this.padding = const EdgeInsets.all(8.0),
    this.alignment = Alignment.center,
    this.splashRadius,
    this.color,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.disabledColor,
    this.mouseCursor = SystemMouseCursors.click,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback,
    this.isSelected,
    this.constraints,
    this.style,
    });

  @override
  State<AnimatedIconBuilder> createState() => _AnimatedIconBuilderState();

}

class _AnimatedIconBuilderState extends State<AnimatedIconBuilder> with SingleTickerProviderStateMixin {

  late final Animation<double> _animation;
  late final AnimationController _animationController;
  /// Usar uma variável boleana para o controle de animação é mais performática
  /// do que usar o getter do proprio contoller 
  /// `_animationController.isCompleted` ou `_animation.isCompleted` 
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();

    _animationController =  AnimationController(
      duration: widget.transitionTime,
      reverseDuration: widget.transitionTime,
      debugLabel: 'AnimatedIconBuilder',
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0, end: 1.0,
    ).animate(CurvedAnimation(
        parent: _animationController, 
        curve: widget.curve, 
        reverseCurve: widget.reverseCurve,
      )
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async{
      widget.afterRender?.call(trigger);
    });
  }
  
  @override
  void dispose() {
    if(_isCompleted){
      _animationController.reverse();
      _animationController.dispose();
    }else{
      _animationController.dispose();
    }
    super.dispose();
  }

  bool trigger(){
    if(_isCompleted){
      _animationController.reverse();
    }else{
      _animationController.forward();
    }
    return _isCompleted = !_isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return IconButton(
      tooltip: widget.tooltip,
      iconSize: widget.iconSize ?? theme.iconTheme.size,
      visualDensity: widget.visualDensity ?? theme.iconButtonTheme.style?.visualDensity,
      padding: widget.padding,
      alignment: widget.alignment,
      splashRadius: widget.splashRadius,
      color: widget.color ?? theme.iconTheme.color,
      focusColor: widget.focusColor ?? theme.focusColor,
      hoverColor: widget.hoverColor ?? theme.hoverColor,
      highlightColor: widget.highlightColor ?? theme.highlightColor,
      splashColor: widget.splashColor ?? theme.splashColor,
      disabledColor: widget.disabledColor,
      mouseCursor: widget.mouseCursor,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      style: widget.style ?? theme.iconButtonTheme.style,
      isSelected: widget.isSelected,
      enableFeedback: widget.enableFeedback ?? theme.iconButtonTheme.style?.enableFeedback,
      constraints: widget.constraints,
      icon: AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) {
          // return RotationTransition(
          //   turns: _animation,
          //   child: _isCompleted ? widget.trasitionIcon : widget.icon,
          // );
          return RotationTransition(
            turns: _animation,
            child: AnimatedCrossFade(
              alignment: Alignment.center,
              duration: widget.transitionTime,
              firstChild: widget.icon,
              firstCurve: widget.curve,
              secondCurve: widget.reverseCurve,
              secondChild: widget.trasitionIcon,
              crossFadeState: _isCompleted 
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst
            )
          );
        },
      ),
      onPressed: () {
        widget.onPressed(trigger());
      },
    );
  }
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
///         title: const Text('Teste AnimatedIconBuilder'),
///       ),
///       body: Center(
///         child: AnimatedIconBuilder(
///           icon: const Icon(Icons.search),
///           trasitionIcon: const Icon(Icons.close),
///           onPressed: (trasition){
///             print(trasition);
///           },
///         ),
///       ),
///     );
///   }
/// }
/// ```



// class HomePageMaterial extends StatelessWidget {
//   const HomePageMaterial({ Key? key }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(child: Text('teste')),
//         actions: [
//           AnimatedIconBuilder(
//             icon: const Icon(Icons.search),
//             trasitionIcon: const Icon(Icons.close),
//             tooltip: 'search_events',
//             // padding: const EdgeInsets.only(right: 15),
//             onPressed: (trasition){
//               print(trasition);
//             },
//           ),
//         ],
//       ),
//       body: const Center(child: Text('teste')),
//     );
//   }
// }


// class HomePageCupertino extends StatelessWidget {
//   const HomePageCupertino({ Key? key }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       navigationBar: CupertinoNavigationBar(
//         middle: const Text('CupertinoApp'),
//         trailing: Material(
//           color: Colors.transparent,
//           child: AnimatedIconBuilder(
//             icon: const Icon(Icons.search),
//             trasitionIcon: const Icon(Icons.close),
//             onPressed: (trasition){
//               print(trasition);
//             },
//           ),
//         ),
//       ),
//       child: const Center(child: Text('teste')),
//     );
//   }
// }
