import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/src/apis/api_service.dart';

class OrderDetails extends ConsumerWidget {
  const OrderDetails({super.key});
  static const String routeName = "/OrderDetails";
  @override
  Widget build(BuildContext context, ref) {
    final int id = ModalRoute.of(context)!.settings.arguments as int;
    final watchOrderDetails = ref.watch(orderDetailsState(id));
    return Scaffold(
      appBar: AppBar(title: Text("Order Details"), centerTitle: true),
      body: watchOrderDetails.when(
        data: (order) {
          return Center(child: Text(order!.id.toString()));
        },
        error: (e, s) => Center(child: Text(e.toString())),
        loading:
            () => const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}
