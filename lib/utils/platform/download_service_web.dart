import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

Future<void> downloadTextFile({required String fileName, required String content}) async {
  final bytes = Uint8List.fromList(utf8.encode(content));
  final blob = html.Blob([bytes], 'text/plain');
  final href = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: href)
    ..setAttribute('download', fileName)
    ..click();
  html.Url.revokeObjectUrl(href);
}

Future<void> openOrDownloadRemote(String url, {String? fileName}) async {
  html.AnchorElement(href: url)
    ..setAttribute('download', fileName ?? '')
    ..click();
}
