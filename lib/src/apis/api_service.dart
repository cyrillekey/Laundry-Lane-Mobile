import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:laundrylane/models/billing_address.dart';
import 'package:laundrylane/models/catalog_model.dart';
import 'package:laundrylane/models/clothing_type.dart';
import 'package:laundrylane/models/delivery_zone.dart';
import 'package:laundrylane/models/store_model.dart';
import 'package:laundrylane/models/store_payment_model.dart';
import 'package:laundrylane/models/support_models.dart';
import 'package:laundrylane/models/full_order_details.dart';
import 'package:laundrylane/models/goecode_reverse.dart';
import 'package:laundrylane/models/home_address.dart';
import 'package:laundrylane/models/order_model.dart';
import 'package:laundrylane/models/payment_card.dart';
import 'package:laundrylane/models/service_model.dart';
import 'package:laundrylane/providers/store_provider.dart';
import 'package:laundrylane/providers/token_provider.dart';
import 'package:laundrylane/utils/constants.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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

FutureProvider<HomeAddress?> addressState = FutureProvider<HomeAddress?>((
  ref,
) async {
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
FutureProvider<List<Order>> ordersState = FutureProvider((ref) async {
  String? token = ref.watch(tokenProvider).value;

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

FutureProvider<List<Catalog>> catalogState = FutureProvider((ref) async {
  try {
    final storeId = ref.watch(storeProvider).value;
    final CancelToken cancelToken = CancelToken();
    ref.onDispose(cancelToken.cancel);
    final response = await apiDio
        .get(
          "/catalog",
          cancelToken: cancelToken,
          queryParameters: {"storeId": storeId},
        )
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

FutureProvider<List<ClothingType>> clothingTypeState = FutureProvider((
  ref,
) async {
  try {
    final CancelToken cancelToken = CancelToken();
    ref.onDispose(cancelToken.cancel);
    final response = await apiDio
        .get(
          "/catalog/clothes",
          cancelToken: cancelToken,
          queryParameters: {"storeId": ref.watch(storeProvider).value},
        )
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

FutureProvider<Order?> ongoingOrderState = FutureProvider((ref) async {
  try {
    String? token = ref.watch(tokenProvider).value;

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
  } catch (e) {
    return null;
  }
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

FutureProvider<List<ServiceType>> serviceTypeState = FutureProvider((
  ref,
) async {
  try {
    final token = ref.watch(tokenProvider).value;
    final CancelToken cancelToken = CancelToken();

    ref.onDispose(cancelToken.cancel);
    final response = await apiDio
        .get(
          "/catalog/service-types",
          options: Options(headers: {"Authorization": "Bearer $token"}),
          cancelToken: cancelToken,
          queryParameters: {"storeId": ref.watch(storeProvider).value},
        )
        .then((resp) => resp.data)
        .catchError((e) {
          return [];
        });
    return List<ServiceType>.from(
      response.map((e) {
        return ServiceType.fromJson(e);
      }),
    );
  } catch (e) {
    return [];
  }
});

FutureProvider<List<DeliveryZone>> deliveryZoneState =
    FutureProvider.autoDispose((ref) async {
      try {
        final token = ref.watch(tokenProvider).value;
        final CancelToken cancelToken = CancelToken();

        ref.onDispose(cancelToken.cancel);
        final response = await apiDio
            .get(
              "/delivery/zones",
              cancelToken: cancelToken,
              options: Options(headers: {"Authorization": "Bearer $token"}),
              queryParameters: {"storeId": ref.watch(storeProvider).value},
            )
            .then((resp) => resp.data)
            .onError<DioException>((e, s) {
              return [];
            });
        return List<DeliveryZone>.from(
          response.map((e) {
            return DeliveryZone.fromJson(e);
          }),
        );
      } catch (e) {
        return [];
      }
    });

FutureProviderFamily<FullOrderDetails?, int> orderDetailsState = FutureProvider
    .autoDispose
    .family((ref, id) async {
      try {
        final token = ref.watch(tokenProvider).value;
        final CancelToken cancelToken = CancelToken();
        ref.onDispose(cancelToken.cancel);
        final response = await apiDio
            .get(
              "/order/$id",
              cancelToken: cancelToken,
              options: Options(headers: {"Authorization": "Bearer $token"}),
            )
            .then((resp) => resp.data)
            .onError<DioException>((e, s) {
              return null;
            })
            .catchError((e) {
              return null;
            });
        if (response == null) return null;
        return FullOrderDetails.fromJson(response);
      } catch (e) {
        return null;
      }
    });

FutureProvider<List<FaqModel>> faqsState = FutureProvider.autoDispose((
  ref,
) async {
  try {
    final CancelToken cancelToken = CancelToken();
    ref.onDispose(cancelToken.cancel);
    final response = await apiDio
        .get(
          "/faq",
          cancelToken: cancelToken,
          queryParameters: {"storeId": ref.watch(storeProvider).value},
        )
        .then((resp) => resp.data)
        .onError<DioException>((e, s) {
          return [];
        });
    return List<FaqModel>.from(
      response.map((e) {
        return FaqModel.fromJson(e);
      }),
    );
  } catch (e) {
    return [];
  }
});

FutureProvider<List<SupportContactsModel>> supportContactsState =
    FutureProvider.autoDispose((ref) async {
      try {
        final CancelToken cancelToken = CancelToken();
        ref.onDispose(cancelToken.cancel);
        final response = await apiDio
            .get(
              "/support-contacts",
              cancelToken: cancelToken,
              queryParameters: {"storeId": ref.watch(storeProvider).value},
            )
            .then((resp) => resp.data)
            .onError<DioException>((e, s) {
              return [];
            });
        return List<SupportContactsModel>.from(
          response.map((e) {
            return SupportContactsModel.fromJson(e);
          }),
        );
      } catch (e) {
        return [];
      }
    });
FutureProvider<List<Stores>> storesState = FutureProvider.autoDispose((
  ref,
) async {
  try {
    final CancelToken cancelToken = CancelToken();
    ref.onDispose(cancelToken.cancel);
    final token = ref.watch(tokenProvider).value;

    final response = await apiDio
        .get(
          "/store",
          cancelToken: cancelToken,
          options: Options(headers: {"Authorization": "Bearer $token"}),
        )
        .then((resp) => resp.data)
        .onError<DioException>((e, s) {
          return [];
        });
    return List<Stores>.from(
      response.map((e) {
        return Stores.fromJson(e);
      }),
    );
  } catch (e) {
    return [];
  }
});

FutureProvider<List<StorePaymentMethod>> storePaymentMethodsProvider =
    FutureProvider((ref) async {
      try {
        final token = ref.watch(tokenProvider).value;
        final CancelToken cancelToken = CancelToken();
        final storeId = ref.watch(storeProvider).value;
        ref.onCancel(cancelToken.cancel);
        final response = await apiDio
            .get(
              "/payments/store-method",
              options: Options(headers: {"Authorization": "Bearer $token"}),
              cancelToken: cancelToken,
              queryParameters: {"storeId": storeId},
            )
            .then((resp) => resp.data)
            .onError<DioException>((e, s) {
              Sentry.captureException(e);
              return [];
            });
        final paymentMethods = List<StorePaymentMethod>.from(
          response.map((e) {
            return StorePaymentMethod.fromJson(e);
          }),
        );
        return paymentMethods;
      } catch (e) {
        Sentry.captureException(e);
        return [];
      }
    });

FutureProvider<BillingAddress?> billingAddressState =
    FutureProvider.autoDispose((ref) async {
      try {
        final token = ref.watch(tokenProvider).value;
        final CancelToken cancelToken = CancelToken();
        ref.onDispose(cancelToken.cancel);
        final response = await apiDio
            .get(
              "/user/billing-address",
              cancelToken: cancelToken,
              options: Options(headers: {"Authorization": "Bearer $token"}),
            )
            .then((resp) => resp.data)
            .onError<DioException>((e, s) {
              Sentry.captureException(e);

              return null;
            });
        if (response == null) return null;
        return BillingAddress.fromJson(response);
      } catch (e) {
        Sentry.captureException(e);
        return null;
      }
    });
