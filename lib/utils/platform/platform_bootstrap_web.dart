import 'package:web/web.dart' as web;

Future<void> initializeWebPlatform(String? mapKey) async {
  if (mapKey == null || mapKey.isEmpty) return;
  final script = web.Document().createElement('script') as web.HTMLScriptElement;
  script.src = 'https://maps.googleapis.com/maps/api/js?key=$mapKey';
  script.defer = true;
  web.document.head?.append(script);
}
