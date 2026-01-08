import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/models/catalog_model.dart';
import 'package:laundrylane/models/clothing_type.dart';
import 'package:laundrylane/models/goecode_reverse.dart';
import 'package:laundrylane/models/home_address.dart';
import 'package:laundrylane/models/order_model.dart';
import 'package:laundrylane/models/payment_card.dart';
import 'package:laundrylane/providers/token_provider.dart';
import 'package:laundrylane/utils/constants.dart';

final Dio apiDio = Dio(BaseOptions(baseUrl: apiUrl));
Future<GeocodeReverse?> reverseGeocode(LatLng? latLang) async {
  if (latLang != null) {
    try {
      final response = await apiDio.post(
        "/address/reverse-geocode",
        data: {"latitude": latLang.latitude, "longitude": latLang.longitude},
      );

      GeocodeReverse reverse = GeocodeReverse.fromJson(response.data);
      return reverse;
    } catch (e) {
      return null;
    }
  }
  return null;
}

Future<List<GeocodeReverse>> autoCompleteApi(String location) async {
  try {
    final result = await apiDio.get(
      "/address/autocomplete",
      queryParameters: {"query": location},
    );
    if (result.data == null) {
      return [];
    }
    List data = (result.data);

    List<GeocodeReverse> features =
        data.map((e) => GeocodeReverse.fromJson(e)).toList();
    return features;
  } catch (e) {
    return [];
  }
}

FutureProvider<HomeAddress?> addressState =
    FutureProvider.autoDispose<HomeAddress?>((ref) async {
      try {
        String? token = ref.watch(tokenProvider).value;

        final CancelToken cancelToken = CancelToken();

        ref.onDispose(cancelToken.cancel);
        final response = await apiDio
            .get(
              "/address",
              cancelToken: cancelToken,
              options: Options(headers: {"Authorization": "Bearer $token"}),
            )
            .then((resp) => resp.data)
            .catchError((e) {
              return null;
            });

        if (response == null) return null;
        HomeAddress homeAddress = HomeAddress.fromJson(response);

        return homeAddress;
      } catch (e) {
        return null;
      }
    });
FutureProvider<List<Order>> ordersState = FutureProvider.autoDispose((
  ref,
) async {
  String? token = ref.read(tokenProvider).value;

  final CancelToken cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  final response = await apiDio
      .get(
        "/order",
        cancelToken: cancelToken,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      )
      .then((resp) => resp.data)
      .catchError((e) {
        return [];
      });
  List data = List.from(response);

  List<Order> orders = data.map((e) => Order.fromJson(e)).toList();
  return orders;
});

FutureProvider<List<Catalog>> catalogState = FutureProvider.autoDispose((
  ref,
) async {
  try {
    final CancelToken cancelToken = CancelToken();
    ref.onDispose(cancelToken.cancel);
    final response = await apiDio
        .get("/catalog", cancelToken: cancelToken)
        .then((resp) => resp.data)
        .catchError((e) {
          return [];
        });
    List data = List.from(response);

    List<Catalog> catalog = data.map((e) => Catalog.fromJson(e)).toList();
    return catalog;
  } catch (e) {
    return [];
  }
});

FutureProvider<List<ClothingType>> clothingTypeState =
    FutureProvider.autoDispose((ref) async {
      try {
        final CancelToken cancelToken = CancelToken();
        ref.onDispose(cancelToken.cancel);
        final response = await apiDio
            .get("/catalog/clothes", cancelToken: cancelToken)
            .then((resp) => resp.data)
            .catchError((e) {
              return [];
            });
        List data = List.from(response);

        List<ClothingType> clothingType =
            data.map((e) => ClothingType.fromJson(e)).toList();
        return clothingType;
      } catch (e) {
        return [];
      }
    });

FutureProvider<Order?> ongoingOrderState = FutureProvider.autoDispose((
  ref,
) async {
  String? token = ref.read(tokenProvider).value;

  final CancelToken cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  final response = await apiDio
      .get(
        "/order",
        cancelToken: cancelToken,
        options: Options(headers: {"Authorization": "Bearer $token"}),
        queryParameters: {"ongoing": true},
      )
      .then((resp) => resp.data)
      .catchError((e) {
        return [];
      });
  List data = List.from(response);

  List<Order> orders = data.map((e) => Order.fromJson(e)).toList();
  return orders.firstOrNull;
});

FutureProvider<List> cardsState = FutureProvider.autoDispose((ref) async {
  final token = ref.watch(tokenProvider).value;
  final CancelToken cancelToken = CancelToken();

  ref.onDispose(cancelToken.cancel);
  List response = await apiDio
      .get(
        "/payments/card",
        options: Options(headers: {"Authorization": "Bearer $token"}),
        cancelToken: cancelToken,
      )
      .then((resp) => resp.data)
      .catchError((e) {
        return [];
      });
  return paymentCardFromJson(jsonEncode(response));
});
