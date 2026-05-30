import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

FutureProvider<bool> locationPermission = FutureProvider((ref) async {
  bool permission = await Geolocator.isLocationServiceEnabled();
  return permission;
});
