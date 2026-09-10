import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps/google_maps.dart' as gmaps;

Widget buildGoogleMap({
  required String viewType,
  required double latitude,
  required double longitude,
  required double zoom,
  required bool disableDefaultUI,
}) {
  // registerViewFactory is intentionally isolated to the web implementation.
  ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    final myLatLng = gmaps.LatLng(latitude, longitude);
    final mapOptions = gmaps.MapOptions()
      ..zoom = zoom
      ..disableDefaultUI = disableDefaultUI
      ..center = myLatLng;

    final elem = html.DivElement()
      ..id = '$viewType-$viewId'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.border = 'none';

    final map = gmaps.Map(elem, mapOptions);
    gmaps.Marker(gmaps.MarkerOptions()
      ..position = myLatLng
      ..map = map
      ..title = 'FlutterViz preview');
    return elem;
  });

  return HtmlElementView(viewType: viewType);
}
