// ignore_for_file: unused_catch_stack

import 'dart:io';
import 'package:dart_dev_utils/dart_dev_utils.dart' show printLog;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

Future<String?> getAppVersion() async{

  File file = File('.${Platform.pathSeparator}pubspec.yaml');
  
  String body = '';

  // Primeira tentativa(funciona bem no windows)
  try {

    if (file.existsSync()) {

      body = await file.readAsString();

      body = getVersionOnBodyPubSpecYaml(body) ?? '';

      if (body.isNotEmpty) return body;

    }

  } on PathAccessException catch (error, stackTrace) {

    printLog(
      'É necessario ter permissão para acessar e editar arquivos no dispositivo.\n\n\n$error\n\n\n$stackTrace',
      error: error,
      stackTrace: stackTrace,
      name: 'getAppVersion',
    );

  }


  // Segunda tentativa(Ler como um arquivo assets)
  try {

    body = await rootBundle.loadString('pubspec.yaml');

    return getVersionOnBodyPubSpecYaml(body);

  } on FlutterError catch (error, stackTrace) {

    printLog(
      'Adicione o arquivo [pubspec.yaml] dentro das configurações dos assets.\n\nassets:\n   - pubspec.yaml',
      error: error,
      stackTrace: stackTrace,
      name: 'getAppVersion',
    );

    return null;
    
  } catch (error, stackTrace) {
    throw _GetAppVersionException('Erro ao tentar ler o arquivo pubspec.yaml, Faça um tratamento para essa erro.\n\n\n$error\n\n\n$stackTrace');
  }

}

String? getVersionOnBodyPubSpecYaml(String body){

  RegExp regExpForGetAppVersion = 
    RegExp(r'(version:\s.*\+\d{1})|(version:\s\w.*\d{1})|(version:\s\d{1}\.\d{1}\.\d{1})');

  RegExp regExpForComments = RegExp(r'(#\s.*)|(#.*)');

  // Remover os comentários  
  if(regExpForComments.hasMatch(body)){
    body = body.replaceAll(regExpForComments, '');
  }

  if(regExpForGetAppVersion.hasMatch(body)){
  
    body = regExpForGetAppVersion.stringMatch(body) ?? '';
    body = body.split(': ').last;
    
    return body;

  } else {
    return null;
  }

}

class _GetAppVersionException implements Exception {
  final String message;

  const _GetAppVersionException(this.message);

  @override
  String toString() => message;

}


// Rascunho:
/*
  RegExp regExpForGetVersionApp = RegExp(r'(version:\s\d{1}\.\d{1}\.\d{1})|(version:\s\w.*\n)');

  Directory dir = Directory('./');

  List<FileSystemEntity>  fileList = dir.listSync();
  
  File? filePubspecYaml;

  bool containsPubspec = fileList.any((file) {
    if(file.path.contains('pubspec.yaml')){
      filePubspecYaml = file as File;
      return true;
    } else{
      return false;
    }
  });

  if (containsPubspec) {
    // print(filePubspecYaml?.path);
    String body = filePubspecYaml!.readAsStringSync();

    if(regExpForGetVersionApp.hasMatch(body)){
      body = regExpForGetVersionApp.stringMatch(body) ?? 'undefined';
      body = body.split(': ').last;

      print('App Version: $body');
    } else{
      print('Versão da app não localizada');
    }

  } else {
    print('Versão da app não localizada');
  }
*/
