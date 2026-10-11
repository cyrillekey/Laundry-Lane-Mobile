import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storeProvider = FutureProvider<int>((ref) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? storeId = prefs.getInt("store");
  if (storeId != null) {
    return storeId;
  }
  return 0;
});

Future<void> saveStoreId(int storeId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt("store", storeId);
}
