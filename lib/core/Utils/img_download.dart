import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:http/http.dart' as http;
import 'package:pix_hunt_project/core/typedefs/typedefs.dart';

abstract class ImageDownloadMethodUtils {
  static Future<ImageDownloadedMessageModel?> downloadImg(
    String url,
    String onSuccess,
  ) async {
    try {
      var responce = await http.get(Uri.parse(url));
      if (responce.statusCode == 200 || responce.statusCode == 201) {
        final result = await ImageGallerySaverPlus.saveImage(
          responce.bodyBytes,
          quality: 100,

          name: "pixhunt_${DateTime.now().millisecondsSinceEpoch}",
        );

        debugPrint("Save result: $result");
        return (message: '🎉 ${onSuccess}', isDownload: true);
      } else {
        return null;
      }
    } catch (e) {
      return (message: e.toString(), isDownload: false);
    }
  }
}
