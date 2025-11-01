import 'package:flutter/material.dart';

/// Botão tipo interruptor semelhante ao widget [Switch]
@immutable
class TriggerSwitch extends StatefulWidget {

  /// Criar um botão interruptor que retornará [true] ou [false] através
  /// da função `onChange` quando clicado
  /// Exemplo de uso:
  /// ```
  /// TriggerSwitch(
  ///   boxShadowList: const [
  ///     BoxShadow(
  ///       blurRadius: 3.0,
  ///     )
  ///   ],
  ///   value: false,
  ///   onChanged: (bool value){
  ///     print(value);
  ///   },
  /// ),
  /// ```
  /// 
  final Size size;
  final Color backgroundColorChecked, 
    backgroundColorUnchecked,
    checkedColor, 
    uncheckedColor;
  final bool value;
  final ValueChanged<bool> onChanged;
  /// Computar se pode alterar o stado do widget, caso o valor de retorno [true] ou essa propriedade 
  /// seja nula a função [onChanged] será executada
  final Future<bool> Function()? computeBefore;
  final Curve curve, reverseCurve;
  final Duration animationTime;
  final List<BoxShadow>? boxShadowList;

  const TriggerSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.computeBefore,
    this.size = const Size(38.0, 18.0),
    this.backgroundColorChecked = Colors.black45,
    this.backgroundColorUnchecked = Colors.black45,
    this.checkedColor = Colors.greenAccent,
    this.uncheckedColor = Colors.red,
    this.curve = Curves.bounceInOut, //Curves.bounceIn,
    this.reverseCurve = Curves.bounceInOut,
    this.animationTime = const Duration(milliseconds: 450),
    this.boxShadowList,
  });

  @override
  State<TriggerSwitch> createState() => _TriggerSwitchState();
}

class _TriggerSwitchState extends State<TriggerSwitch> with SingleTickerProviderStateMixin{

  late final Animation<Alignment> animation;
  late final AnimationController animationController;
  /// Usar uma variável boleana para o controle de animação é mais performática
  /// do que usar o getter do proprio contoller 
  /// `_animationController.isCompleted` ou `_animation.isCompleted` 
  late bool _isCompleted;

  @override
  void initState() {

    animationController = AnimationController(
      vsync: this, 
      duration: widget.animationTime
    );
    
    animation = Tween<Alignment>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(CurvedAnimation(
      parent: animationController, 
      curve: widget.curve,
      reverseCurve: widget.reverseCurve
      )
    );

    if(!widget.value){
      _isCompleted = false;
      animationController.reverse();
    }else{
      _isCompleted = true;
      animationController.forward();
    }
    
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        Future<bool>.value(await widget.computeBefore?.call() ?? true)
          .then((canChange) {
            if (canChange) {
              if(_isCompleted){
                animationController.reverse();
                widget.onChanged(false);
              }else{
                animationController.forward();
                widget.onChanged(true);
              }
              _isCompleted = !_isCompleted;
            }
          }
        );
      },
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Container(
            height: widget.size.height,
            width: widget.size.width,
            decoration: BoxDecoration(
              color: _isCompleted 
                ? widget.backgroundColorChecked 
                : widget.backgroundColorUnchecked,
              borderRadius: BorderRadius.circular(widget.size.height/2),
              boxShadow: widget.boxShadowList
            ),
            child: Align(
              alignment: animation.value,
              child: Container(
                height: widget.size.height-4,
                width: widget.size.height-4,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  color: _isCompleted ? widget.checkedColor : widget.uncheckedColor,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  height: widget.size.height-(widget.size.height*0.65),
                  width: _isCompleted
                    ? widget.size.height-(widget.size.height*0.65)
                    : widget.size.height-(widget.size.height*0.85),
                  decoration: BoxDecoration(
                    color: _isCompleted 
                      ? widget.backgroundColorChecked
                      : widget.backgroundColorUnchecked,
                    borderRadius: BorderRadius.circular(widget.size.height),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
