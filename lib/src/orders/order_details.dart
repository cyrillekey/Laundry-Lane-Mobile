import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/models/order_model.dart';
import 'package:laundrylane/src/apis/api_service.dart';

class OrderDetails extends ConsumerWidget {
  const OrderDetails({super.key});
  static const String routeName = "/OrderDetails";
  @override
  Widget build(BuildContext context, ref) {
    final int id = ModalRoute.of(context)!.settings.arguments as int;
    final watchOrderDetails = ref.watch(orderDetailsState(id));
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz_rounded)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        child: watchOrderDetails.when(
          data: (order) {
            if (order == null) {
              return const Center(child: Text("Order not found"));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderProgress(order: order.order),
                OrderDetails(),
                OrderTotal(),
              ],
            );
          },
          error: (e, s) => Center(child: Text(e.toString())),
          loading:
              () => const Center(child: CircularProgressIndicator.adaptive()),
        ),
      ),
    );
  }
}

class OrderProgress extends StatelessWidget {
  const OrderProgress({super.key, required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order placed",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).unselectedWidgetColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Text(
                    order.orderStatus.toUpperCase(),
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: Colors.blueGrey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderTotal extends StatelessWidget {
  const OrderTotal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Orderitems extends StatelessWidget {
  const Orderitems({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
