import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:laundrylane/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String apiUrl = "https://laundry-lane-server.onrender.com";
// const String apiUrl = "https://bf3cdb70bcf8.ngrok-free.app";
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
const clothingTypes = [
  {
    "name": "Tops",
    "subtypes": [
      "T-Shirt",
      "Polo Shirt",
      "Button-Down Shirt",
      "Blouse",
      "Tank Top",
      "Crop Top",
      "Henley Shirt",
      "Tunic",
      "Sweater",
      "Pullover",
      "Hoodie",
      "Cardigan",
      "Vest",
    ],
  },
  {
    "name": "Bottoms",
    "subtypes": [
      "Jeans",
      "Trousers",
      "Dress Pants",
      "Chinos",
      "Shorts",
      "Cargo Pants",
      "Leggings",
      "Jeggings",
      "Skirt",
      "Mini Skirt",
      "Midi Skirt",
      "Maxi Skirt",
    ],
  },
  {
    "name": "Dresses",
    "subtypes": [
      "Casual Dress",
      "Evening Dress",
      "Cocktail Dress",
      "Formal Dress",
      "Maxi Dress",
      "Mini Dress",
      "Midi Dress",
      "Bodycon Dress",
      "Wrap Dress",
      "A-Line Dress",
      "Shift Dress",
      "Shirt Dress",
    ],
  },
  {
    "name": "Outerwear",
    "subtypes": [
      "Jacket",
      "Leather Jacket",
      "Denim Jacket",
      "Blazer",
      "Coat",
      "Trench Coat",
      "Raincoat",
      "Puffer Jacket",
      "Windbreaker",
      "Overcoat",
    ],
  },
  {
    "name": "Suits & Formal Wear",
    "subtypes": [
      "Two-Piece Suit",
      "Three-Piece Suit",
      "Suit Jacket",
      "Suit Trousers",
      "Tuxedo",
      "Waistcoat",
      "Formal Shirt",
    ],
  },
  {
    "name": "Traditional & Cultural Wear",
    "subtypes": [
      "Kitenge",
      "Ankara",
      "Dashiki",
      "Kanzu",
      "Kaftan",
      "Saree",
      "Salwar Kameez",
      "Kimono",
      "Agbada",
    ],
  },
  {
    "name": "Sportswear & Activewear",
    "subtypes": [
      "Tracksuit",
      "Training Top",
      "Sports T-Shirt",
      "Sports Shorts",
      "Joggers",
      "Yoga Pants",
      "Compression Wear",
      "Sports Bra",
      "Athletic Jacket",
    ],
  },
  {
    "name": "Sleepwear & Loungewear",
    "subtypes": ["Pajamas", "Nightgown", "Sleep Shirt", "Lounge Pants", "Robe"],
  },
  {
    "name": "Underwear",
    "subtypes": [
      "Briefs",
      "Boxers",
      "Boxer Briefs",
      "Panties",
      "Bra",
      "Undershirt",
      "Thermal Wear",
    ],
  },
  {
    "name": "Accessories",
    "subtypes": ["Socks", "Tie", "Scarf", "Hat", "Cap", "Gloves", "Belt"],
  },
];

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

final cloudinary = CloudinaryPublic("ddia14anf", 'laundry_lane', cache: false);
