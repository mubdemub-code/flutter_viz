import 'package:flutter/material.dart';

Widget buildGoogleMap({
  required String viewType,
  required double latitude,
  required double longitude,
  required double zoom,
  required bool disableDefaultUI,
}) {
  return Container(
    color: Colors.grey.shade200,
    alignment: Alignment.center,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.map_outlined, size: 32),
        const SizedBox(height: 8),
        Text('Google Maps preview', style: TextStyle(color: Colors.grey.shade700)),
        Text('${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      ],
    ),
  );
}
