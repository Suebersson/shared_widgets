import 'package:flutter/widgets.dart';

/// widget para alternar entre duas cores sobre o widget child
@immutable
class FlashesLight extends StatefulWidget {
  /// Obs: a widget do parâmentro [child] é reconstruida constantimente
  /// 
  final Widget child;
  final Color beginColor;
  final Color endColor;
  final Duration transitionTime;
  
  const FlashesLight({
    super.key,
    required this.child,
    required this.beginColor,
    required this.endColor,
    this.transitionTime = const Duration(milliseconds: 1000),
  });

  @override
  State<FlashesLight> createState() => _FlashesLightState();
}

class _FlashesLightState extends State<FlashesLight> with SingleTickerProviderStateMixin{

  late final AnimationController _animatedContainer;
  late final Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();

    _animatedContainer = AnimationController(
      duration: widget.transitionTime,
      reverseDuration: widget.transitionTime,
      debugLabel: 'FlashesLight',  
      vsync: this
    );

    _animation = ColorTween(begin: widget.beginColor, end: widget.endColor).animate(_animatedContainer);

    _animatedContainer.forward();
    
    _animatedContainer.addListener(() {
      
      if(_animatedContainer.isCompleted){
        _animatedContainer.reverse();
      }else if(_animatedContainer.isDismissed){
        _animatedContainer.forward();
      }
      
      setState(() {});

    });
  }

  @override
  void dispose() {
    _animatedContainer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.modulate,
      shaderCallback: (Rect rect){
        return LinearGradient(colors: [_animation.value!, _animation.value!]).createShader(rect);
      },
      child: widget.child,
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
///         title: const Text('Teste FlashesLight'),
///       ),
///       body: Column(
///         mainAxisAlignment: MainAxisAlignment.center,
///         crossAxisAlignment: CrossAxisAlignment.center,
///         children: [
///           FlashesLight(
///             beginColor: Colors.red,
///             endColor: Colors.yellow,
///             child: Container(
///               color: Colors.white,
///               height: 200.0,
///               margin: const EdgeInsets.all(20.0),
///             ),
///           ),
///           const FlashesLight(
///             beginColor: Colors.yellowAccent,
///             endColor: Colors.brown,
///             child: FlutterLogo(
///               size: 300,
///             ),
///           ),
///         ],
///       ),
///     );
///   }
/// }
/// ```
