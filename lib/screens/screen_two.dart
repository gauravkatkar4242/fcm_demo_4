import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class ScreenTwo extends StatelessWidget {
  const ScreenTwo({Key? key}) : super(key: key);

  checkStatus() async {
    var status = await Permission.storage.status;
    print("-------- $status");
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    checkStatus();
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        onPressed: () async {
          // Directory? dict = await getExternalStorageDirectory();
          // print(dict!.path);
          // print(await getExternalStorageDirectories());

          Directory dict;
          if (Platform.isIOS) {
            dict = await getApplicationDocumentsDirectory();
          } else {
            dict = Directory("/storage/emulated/0/Download");
            /*
            https://stackoverflow.com/questions/61966810/flutter-save-file-to-download-folder-downloads-path-provider
            ** Alternate Options **
            1.
            https://pub.dev/packages/external_path
            Directory(await ExternalPath.getExternalStoragePublicDirectory(
                ExternalPath.DIRECTORY_DOWNLOADS));
            2.
            https://pub.dev/packages/downloads_path_provider
            Future<Directory> downloadsDirectory = DownloadsPathProvider.downloadsDirectory;
            */
          }
          final imagePath = "${dict.path}/image3.png";
          File file = File(imagePath);
          final response = await Dio().download(
            "https://media.kasperskycontenthub.com/wp-content/uploads/sites/103/2019/09/26105755/fish-1.jpg",
            file.path,
          );
          print("file downloaded to ${file.path} --------");
          await Share.shareXFiles(
            [XFile(file.path)],
            text: 'Custom Text',
            subject: "Custom Subject",
          );
        },
        child: const Text("Screen Two"),
      )),
    );
  }
}
