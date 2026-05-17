import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:laundrylane/models/delivery_zone.dart';
import 'package:laundrylane/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getTimeOfDay() {
  TimeOfDay timeOfDay = TimeOfDay.now();
  if (timeOfDay.hour >= 6 && timeOfDay.hour < 12) return "morning";
  if (timeOfDay.hour >= 12 && timeOfDay.hour < 18) return "afternoon";
  if (timeOfDay.hour >= 18 && timeOfDay.hour < 22) return "evening";
  return "night";
}

Future<void> saveToken(String token, int userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
  await prefs.setInt('userId', userId);
}

Future<void> saveUserModel(UserModel user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('user', jsonEncode(user.toJson()));
}

num haversineDistance(num centerLat, num centerLng, num lat, num lng) {
  const EARTH_RADIUS_METERS = 6371000;
  final deltaLatitude = toRadians(lat - centerLat);
  final deltaLongitude = toRadians(lng - centerLng);
  final haversine =
      pow(sin(deltaLatitude / 2), 2) +
      cos(toRadians(centerLat)) *
          cos(toRadians(lat)) *
          pow(sin(deltaLongitude / 2), 2);
  final angularDistance = 2 * asin(sqrt(haversine));
  final distance = EARTH_RADIUS_METERS * angularDistance;
  return distance;
}

num toRadians(num degrees) => degrees * (pi / 180);

bool isPointWithinCircle(
  num centerLat,
  num centerLng,
  num pointLat,
  num pointLng,
  num radiusInMeters,
) {
  final distance = haversineDistance(centerLat, centerLng, pointLat, pointLng);
  return distance <= radiusInMeters;
}

DeliveryZone? getDeliveryZone(List<DeliveryZone> zones, num lat, num lng) {
  for (var zone in zones) {
    if (isPointWithinCircle(
      zone.latitude!,
      zone.longitude!,
      lat,
      lng,
      zone.radius!,
    )) {
      return zone;
    }
  }
  return null;
}
