import 'package:dart_dev_utils/dart_dev_utils.dart' show printLog;
import 'dart:typed_data';
import 'dart:ui';

// https://api.flutter.dev/flutter/dart-ui/instantiateImageCodec.html
// https://api.flutter.dev/flutter/dart-ui/decodeImageFromList.html
// https://api.flutter.dev/flutter/dart-ui/ImageByteFormat-class.html

/// Renderizar uma imagem no formato `.png`
/// Formatos suportados suportados: JPEG, PNG, GIF, GIF animado, WebP, WebP animado, BMP e WBMP
Future<Uint8List> resizeImage({
  required Uint8List bytes, 
  int? height, 
  int? width,
  bool allowUpscaling = true,
  ImageByteFormat format = ImageByteFormat.png
}) async{

  /*
    Esse recurso de redimencionar uma imagem usando o flutter, funcionar, mais não 
    é viável pelo fato de aumentar drasticamente o tamanho[bytes] do arquivo. 
  */
  
  printLog(
    'Tamanho atual do arquivo: ${bytes.lengthInBytes/1000}',
    name: 'resizeImage',
  );

  try {

    Codec codec = await instantiateImageCodec(
      bytes, 
      targetHeight: height, 
      targetWidth: width,
      allowUpscaling: allowUpscaling
    );

    FrameInfo frameInfo = await codec.getNextFrame();
    

    printLog(
      'Altura da imagem: ${frameInfo.image.height}',
      name: 'resizeImage',
    );
    printLog(
      'Largura da imagem: ${frameInfo.image.width}',
      name: 'resizeImage',
    );

    bytes = await frameInfo.image
      .toByteData(format: format)
        .then<Uint8List>((bytes) => bytes?.buffer.asUint8List() ?? Uint8List.fromList(<int>[]));

    printLog(
      'Tamanho do arquivo renderizado: ${bytes.lengthInBytes/1000}',
      name: 'resizeImage',
    );

    codec.dispose();
    frameInfo.image.dispose();

    return bytes;

  } catch (e) {
    printLog('---- Erro ao tentar renderizar a imagem ----');
    return bytes;
  }

}
