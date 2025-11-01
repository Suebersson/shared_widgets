import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dart_dev_utils/dart_dev_utils.dart';

import 'text_hyperlink.dart' show HyperLinkType;

// Creted by `Suebersson Montalvão` - 08/10/2020
// Upgraded: 26/10/2025

/// Criar uma [Widget] usando a Widget `SelectableText.rich`, que detecta `URLs`, `Emails` e `Phones` 
/// dentro do text selecionável e criar um hyperLink nos endereços encontrados
class SelectableTextHyperLink extends StatelessWidget {

  final String text;
  final TextStyle? style;
  final TextStyle hyperLinkStyle;
  final void Function(String, HyperLinkType) onClicked;

  final FocusNode? focusNode;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool showCursor, autofocus, enableInteractiveSelection;
  final int? minLines, maxLines;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final DragStartBehavior dragStartBehavior;
  final SelectionChangedCallback? onSelectionChanged;
  final ScrollPhysics? scrollPhysics;
  final TextHeightBehavior? textHeightBehavior;
  final TextWidthBasis? textWidthBasis;
  final TextScaler? textScale;

  const SelectableTextHyperLink({
    super.key,
    required this.text,
    required this.onClicked,
    this.style,
    this.hyperLinkStyle = const TextStyle(
      color: Colors.blueAccent,
      decoration: TextDecoration.underline,
    ),
    this.focusNode,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.textScale,
    this.showCursor = false,
    this.autofocus = false,
    this.minLines,
    this.maxLines,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.onSelectionChanged,
    this.scrollPhysics,
    this.textHeightBehavior,
    this.textWidthBasis,
  });

  final String _split = '!##!';

  @override
  Widget build(BuildContext context) {
    
    String newText = text;

    if (dartDevUtils.regExpUrls.hasMatch(newText)) {
      newText = newText.replaceAll(
        dartDevUtils.regExpUrls, 
        '$_split${dartDevUtils.regExpUrls.stringMatch(newText)}$_split'
      );
    }

    if (dartDevUtils.regExpEmails.hasMatch(newText)) {
      newText = newText.replaceAll(
        dartDevUtils.regExpEmails, 
        '$_split${dartDevUtils.regExpEmails.stringMatch(newText)}$_split'
      );
    }

    if (dartDevUtils.regExpGlobalPhone.hasMatch(newText)) {
      newText = newText.replaceAll(
        dartDevUtils.regExpGlobalPhone, 
        '$_split${dartDevUtils.regExpGlobalPhone.stringMatch(newText)}$_split'
      );
    }

    return SelectableText.rich(
      TextSpan(
        // style: style ?? DefaultTextStyle.of(context).style,
        style: style ?? Theme.of(context).textTheme.bodyMedium,
        children: newText.split(_split).map<InlineSpan>((t) {
          if(t.isNetworkURL) {
            return TextSpan(
              text: t,
              style: hyperLinkStyle,
              recognizer: TapGestureRecognizer()..onTap = 
                () => onClicked(t, HyperLinkType.url),
            );
          } else if(t.isEmail) {
            return TextSpan(
              text: t,
              style: hyperLinkStyle,
              recognizer: TapGestureRecognizer()..onTap = 
                () => onClicked(t, HyperLinkType.email),
            );
          } else if(t.isPhone) {
            return TextSpan(
              text: t,
              style: hyperLinkStyle,
              recognizer: TapGestureRecognizer()..onTap = 
                () => onClicked(t, HyperLinkType.phone),
            );
          } else {
            return TextSpan(text: t);
          }
        }).toList(),
      ),

      focusNode: focusNode,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      textScaler: textScale ?? const TextScaler.linear(1.0),
      showCursor: showCursor,
      autofocus: autofocus,
      minLines: minLines,
      maxLines: maxLines,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      dragStartBehavior: dragStartBehavior,
      enableInteractiveSelection: enableInteractiveSelection,
      scrollPhysics: scrollPhysics,
      textHeightBehavior: textHeightBehavior,
      textWidthBasis: textWidthBasis,
      // contextMenuBuilder: (context, editableTextState) {
      // },
      onSelectionChanged: onSelectionChanged,
    );
  }
}


/// `Exemplo de uso`
/// ```dart
/// class HomePage extends StatelessWidget {
///   const HomePage({ Key? key }) : super(key: key);
///   final TextStyle style = const TextStyle(
///     color: Colors.grey,
///     fontSize: 18.0
///   );
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(
///         title: const Text('Teste SelectableTextHyperLink'),
///       ),
///       body: Center(
///         child: SelectableTextHyperLink(
///           text: '''
///             Suebersson montalvão \n\n\n
///             Email: suebersson.dev@gmail.com \n\n\n
///             WhatsApp: (+55) 2190000-0000 \n\n\n
///             Flutter: https://flutter.dev/ 
///           ''',
///           onClicked: (text, type){
///             print(text);
///           },
///           style: style,
///           hyperLinkStyle: style.copyWith(
///             color: Colors.blueAccent,
///             decoration: TextDecoration.underline,
///           ),
///         ),
///       ),
///     );
///   }
/// }
///```
