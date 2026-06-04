import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/models/notification_model.dart';
import 'package:laundrylane/providers/token_provider.dart';
import 'package:laundrylane/src/apis/api_service.dart';

final FutureProvider<List<AppNotification>> notificationsState =
    FutureProvider.autoDispose((ref) async {
      try {
        final token = ref.watch(tokenProvider).value;

        CancelToken cancelToken = CancelToken();
        ref.onDispose(cancelToken.cancel);
        final response = await apiDio
            .get(
              "/notifications",
              options: Options(headers: {"Authorization": "Bearer $token"}),
              cancelToken: cancelToken,
            )
            .then((resp) => resp.data)
            .onError<DioException>((e, s) {
              return [];
            });

        return List<AppNotification>.from(
          response.map((e) {
            return AppNotification.fromJson(e);
          }),
        );
      } catch (e) {
        return [];
      }
    });
final FutureProvider<int> notificationCountState = FutureProvider((ref) async {
  try {
    final token = ref.watch(tokenProvider).value;
    CancelToken cancelToken = CancelToken();
    ref.onDispose(cancelToken.cancel);
    final response = await apiDio
        .get(
          "/notifications/unread-count",
          options: Options(headers: {"Authorization": "Bearer $token"}),
          cancelToken: cancelToken,
        )
        .then((resp) => resp.data)
        .onError<DioException>((e, s) {
          return {'count': 0};
        });

    return response['count'];
  } catch (e) {
    return 0;
  }
});
