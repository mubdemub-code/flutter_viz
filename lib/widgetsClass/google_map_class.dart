import 'package:flutter/material.dart';

import 'platform/google_map_platform.dart';

const double DEFAULT_LATITUDE = 37.7749;
const double DEFAULT_LONGITUDE = -122.4194;
const double DEFAULT_ZOOM = 12.0;

class GoogleMapClass {
  double? latitude;
  double? longitude;
  double? zoom;
  bool? isDisableDefaultUI;

  GoogleMapClass({
    this.latitude,
    this.longitude,
    this.zoom,
    this.isDisableDefaultUI = true,
  });

  GoogleMapClass.fromJson(Map<String, dynamic> json) {
    latitude = (json['latitude'] ?? DEFAULT_LATITUDE).toDouble();
    longitude = (json['longitude'] ?? DEFAULT_LONGITUDE).toDouble();
    zoom = (json['zoom'] ?? DEFAULT_ZOOM).toDouble();
    isDisableDefaultUI = json['isDisableDefaultUI'] ?? true;
  }

  Map<String, dynamic> toJson() => {
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (zoom != null) 'zoom': zoom,
        if (isDisableDefaultUI != null) 'isDisableDefaultUI': isDisableDefaultUI,
      };

  Widget getMap() {
    final viewType = 'flutterviz-google-map-${identityHashCode(this)}';
    return buildGoogleMap(
      viewType: viewType,
      latitude: latitude ?? DEFAULT_LATITUDE,
      longitude: longitude ?? DEFAULT_LONGITUDE,
      zoom: zoom ?? DEFAULT_ZOOM,
      disableDefaultUI: isDisableDefaultUI ?? true,
    );
  }

  Widget getGoogleMapWidget({bool absorb = false}) => AbsorbPointer(absorbing: absorb, child: getMap());

  String getCodeAsString() => '';

  List<String> getHeaderClassFiles() => ['Your Google map lib'];

  List<String> getYamlLib() => ['# Google Maps for Flutter Web', 'google_maps: any'];
}
