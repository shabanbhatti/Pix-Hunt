
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

final downloadProgressProvider = StateProvider<double?>((ref) => null);

Future<void> downloadImage(String url,BuildContext context,WidgetRef ref,) async {
  try {
    
    ref.read(downloadProgressProvider.notifier).state = 0.0;

    
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isDenied) {
        print('MANAGED EXTERNAL STORAGE DENIED');
        final status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Storage access permission required')),
          );
          Navigator.pop(context);
          return;
        }
      }

      // For all versions
      if (await Permission.storage.isDenied) {
        print('DENIED');
        await Permission.storage.request();
      }
    }

    // Get appropriate directory based on Android version
    Directory downloadDir;
    if (Platform.isAndroid) {
      try {
        // First try external storage
        print('TRY EXTERNAL STORAGE ');
        downloadDir = Directory('/storage/emulated/0/Pictures/PixHunt');
        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }
      } catch (e) {
        print('APP SPECIFIC DIRECTORY');
        // Fallback to app-specific directory if external storage fails
        final appDir = await getApplicationDocumentsDirectory();
        downloadDir = Directory('${appDir.path}/PixHunt');
        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }
      }
    } else {
      // For iOS/other platforms
      final appDir = await getApplicationDocumentsDirectory();
      downloadDir = Directory('${appDir.path}/PixHunt');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }
    }

    // Create unique filename
    final filename = 'PixHunt_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savePath = '${downloadDir.path}/$filename';

    // Download with Dio
    final dio = Dio();
    await dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        log('$total');
        log('$received');
        if (total != -1) {
          ref.read(downloadProgressProvider.notifier).state = received / total;
        }
      },
    );

    // Verify file was saved
    final savedFile = File(savePath);
    if (!await savedFile.exists()) {
      Navigator.pop(context);
      throw Exception('File not saved');
    }

    // Update UI
    ref.read(downloadProgressProvider.notifier).state = 1.0;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Image saved to: /InternalStorage/Pictures/PixHunt'),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      ref.read(downloadProgressProvider.notifier).state = null;
    });
  } catch (e) {
    ref.read(downloadProgressProvider.notifier).state = null;
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Download failed: ${e.toString()}')));
    debugPrint('Download error: $e');
  }
}
