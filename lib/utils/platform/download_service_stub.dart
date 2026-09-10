import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> downloadTextFile({required String fileName, required String content}) async {
  final bytes = Uint8List.fromList(content.codeUnits);
  try {
    await FilePicker.platform.saveFile(fileName: fileName, bytes: bytes);
  } catch (_) {
    await Clipboard.setData(ClipboardData(text: content));
  }
}

Future<void> openOrDownloadRemote(String url, {String? fileName}) async {
  final uri = Uri.tryParse(url);
  if (uri != null) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
