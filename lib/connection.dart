import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'IBMVisualRecognition.dart';
import 'package:flutter_ibm_watson/utils/IamOptions.dart';
import 'package:flutter_ibm_watson/utils/Language.dart';

void ProcessIMGURL(String url, String apikey) async {
  var uname = 'apikey';
  var pword = apikey;
  var authn = 'Basic ' + base64Encode(utf8.encode('$uname:$pword'));
  //url=https://www.lifeprint.com/asl101/signjpegs/b/b3.jpg
  var res = await http.get(
      'https://gateway.watsonplatform.net/visual-recognition/api/v3/classify?url=${url}&version=2018-03-19',
      headers: {'Authorization': authn});
  if (res.statusCode != 200)
    throw Exception('get error: statusCode= ${res.statusCode}');
  print(res.body);
}

Stream<String> StreamVR(File image, String apikey) async* {
  IamOptions options = await IamOptions(
          iamApiKey: apikey,
          url: "https://gateway.watsonplatform.net/visual-recognition/api")
      .build();
  IBMVisualRecognition visualRecognition =
      new IBMVisualRecognition(iamOptions: options, language: Language.ENGLISH);
  ClassifiedImages classifiedImages =
      await visualRecognition.classifyImageFile(image.path);
  String out = classifiedImages
      .getImages()[0]
      .getClassifiers()[0]
      .getClasses()[0]
      .className;
  yield out;
}
