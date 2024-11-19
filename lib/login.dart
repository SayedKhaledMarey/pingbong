import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _appVersion = 'Unknown';
  String _appBuild = 'Unknown';
  String _appPackageName = 'Unknown';

  // Function to fetch app version
  Future<String> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
      _appBuild = packageInfo.buildNumber;
      _appPackageName = packageInfo.packageName;
    });
    return _appVersion;
  }

  Dio createDioInstance() {
    Dio dio = Dio();

    // Disable SSL verification
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    return dio;
  }

  Future<String> downloadFile(String url, String fileName) async {
    try {
      // Use the custom Dio instance
      Dio dio = createDioInstance();

      Directory? directory = Directory('/storage/emulated/0/Download');
      if (!directory.existsSync()) directory.createSync();

      String filePath = "${directory.path}/$fileName";

      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print("Download progress: ${(received / total * 100).toStringAsFixed(0)}%");
          }
        },
      );

      print("File downloaded to: $filePath");
      return filePath;
    } catch (e) {
      print("Error downloading file: $e");
      throw Exception("Failed to download file");
    }
  }

  void startDownload() async {
    String fileUrl = 'https://dl.bandicam.com/bdcamsetup.exe';
    String fileName = 'latest_app';

    try {
      String filePath = await downloadFile(fileUrl, fileName);
      print("File downloaded successfully at: $filePath");
      // You can now trigger installation using InstallPlugin
    } catch (e) {
      print("Download failed: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Version Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'App Version: $_appVersion',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'App Package Name: $_appPackageName',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'App Build Number: $_appBuild',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:(){
                _getAppVersion();
                startDownload();
              } ,
              child: Text('Get App Version'),
            ),
          ],
        ),
      ),
    );
  }
}
