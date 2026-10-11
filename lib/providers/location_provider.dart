import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/legacy.dart';

class LocationProvider extends ChangeNotifier {
  LatLng? _position;
  LatLng? get position => _position;
  set position(LatLng? position) {
    _position = position;
    notifyListeners();
  }

  void setPostion(LatLng? position) {
    _position = position;
    notifyListeners();
  }
}

final locationProvider = ChangeNotifierProvider<LocationProvider>(
  (ref) => LocationProvider(),
);
