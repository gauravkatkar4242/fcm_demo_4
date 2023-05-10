import 'package:flutter/services.dart';

Future<String> addCssToHtml(String content) async {
  String cssFont = await getCssFont("assets/fonts/DancingScript-Regular.ttf");
  content = content.replaceAll(
    "window.SQJSInterface.loadVideo",
    "loadVideo.postMessage",
  );

  return '''
 <!DOCTYPE html>
 <html>
   <head>
     <style>
       body {
         background-color: gray;
          margin:0 auto;
       }
       $cssFont
     </style>
   </head>
   <body>
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
     $content
   </body>
 </html>
    ''';

  '''
  <style>
  $cssFont,
  body {
  background-color: linen;
  }
  </style>
  <body>

  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  $content
  </body>

  ''';
}

String getFontUri(ByteData data, String mime) {
  final buffer = data.buffer;
  return Uri.dataFromBytes(
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
          mimeType: mime)
      .toString();
}

Future<String> getCssFont(String fontPath) async {
  final fontData = await rootBundle.load(fontPath);
  final fontUri = getFontUri(fontData, "font/opentype").toString();
  final fontCss =
      '@font-face {font-family: DancingScript; src: url($fontUri); } * { font-family: DancingScript; }';
  // String completeHtml = ;
  return fontCss;
}
