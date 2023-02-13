import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:dart_dev_utils/dart_dev_utils.dart';

enum HyperLinkType{url, email, phone}

// Creted by `Suebersson Montalvão` - 08/10/2020
// Upgraded: 30/01/2023

/// Criar uma [Widget] usando a widget [RichText] semelhante a uma [Text], 
/// que detecta `URLs`, `Emails` e `Phones` dentro do texto e criar um 
/// hyperLink nos endereços encontrados
@immutable
class TextHyperLink extends StatelessWidget {

  final String text;
  final TextStyle? style;
  final TextStyle hyperLinkStyle;
  final void Function(String, HyperLinkType) onClicked;
  
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int? maxLines;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  const TextHyperLink({
    Key? key,
    required this.text,
    required this.onClicked,
    this.style,
    this.hyperLinkStyle = const TextStyle(
      color: Color(0xFF448AFF),//Colors.blueAccent,
      decoration: TextDecoration.underline,
    ),
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
  }) : super(key: key);

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

    return RichText(
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      text: TextSpan(
        // style: style ?? DefaultTextStyle.of(context).style,
        style: style ?? Theme.of(context).textTheme.bodyText2,
        children: newText.split(_split).map<InlineSpan>((_text) {
          if(_text.isNetworkURL) {
            return TextSpan(
              text: _text,
              style: hyperLinkStyle,
              recognizer: TapGestureRecognizer()..onTap = 
                () => onClicked(_text, HyperLinkType.url),
            );
          } else if(_text.isEmail) {
            return TextSpan(
              text: _text,
              style: hyperLinkStyle,
              recognizer: TapGestureRecognizer()..onTap = 
                () => onClicked(_text, HyperLinkType.email),
            );
          } else if(_text.isPhone) {
            return TextSpan(
              text: _text,
              style: hyperLinkStyle,
              recognizer: TapGestureRecognizer()..onTap = 
                () => onClicked(_text, HyperLinkType.phone),
            );
          } else {
            return TextSpan(text: _text);
          }
        }).toList(),
      ),
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
///         title: const Text('Teste Hyperlink'),
///       ),
///       body: Center(
///         child: TextHyperLink(
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
