import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

const String apiUrl = "https://laundry-lane-server.onrender.com";

const List<Color> cartColors = [
  Color.fromRGBO(235, 240, 254, 1),
  Color.fromRGBO(249, 244, 246, 1),
  Color.fromRGBO(251, 248, 242, 1),
  Color.fromRGBO(242, 250, 243, 1),
  Color.fromRGBO(239, 239, 253, 1),
  Color.fromRGBO(253, 246, 246, 1),
  Color.fromRGBO(248, 247, 241, 1),
  Color.fromRGBO(238, 240, 253, 1),
];
final serviceTypesIcons = [
  {"title": "Self-Service Laundromat", "icon": Icons.local_laundry_service},
  {"title": "Wash and Fold", "icon": TablerIcons.shirt},
  {"title": "Dry Cleaning", "icon": CupertinoIcons.sparkles},
  {"title": "Pickup and Delivery Laundry", "icon": Icons.delivery_dining},
  {"title": "Commercial Laundry", "icon": Icons.business},
  {"title": "Specialty Laundry", "icon": TablerIcons.diamond},
  {"title": "Franchise Laundry", "icon": Icons.storefront},
  {"title": "On-Demand Laundry", "icon": CupertinoIcons.device_phone_portrait},
  {"title": "Ironing and Pressing", "icon": TablerIcons.ironing},
  {"title": "Industrial Laundry", "icon": Icons.factory},
];
final cloudinary = CloudinaryPublic("ddia14anf", 'laundry_lane', cache: false);
