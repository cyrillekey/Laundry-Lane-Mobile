import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final FutureProvider<List> notificationsState = FutureProvider.autoDispose((
  ref,
) async {
  CancelToken cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return [];
});
