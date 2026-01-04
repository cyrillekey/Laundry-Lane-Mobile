import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:laundrylane/models/order_model.dart';
import 'package:laundrylane/src/apis/api_service.dart';
import 'package:laundrylane/src/orders/order_details.dart';
import 'package:tabler_icons/tabler_icons.dart';

class OrdersTab extends ConsumerWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final orderListener = ref.watch(ordersState);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 18),
          Text(
            "My Orders",
            style: GoogleFonts.almarai(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: () async {
                ref.invalidate(ordersState);
              },
              child: orderListener.when(
                data: (data) {
                  return ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 6),
                    itemCount: data.length,
                    itemBuilder:
                        (context, index) => OrderItem(order: data[index]),
                  );
                },
                error: (_, __) {
                  return Center(child: Text("Error"));
                },
                loading: () {
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  const OrderItem({super.key, required this.order});
  final Order order;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(OrderDetails.routeName),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: Colors.white,
        elevation: 0.0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            children: [
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "5 Items, 9 Pieces",
                        style: GoogleFonts.almarai(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        "Dry cleaning",
                        style: GoogleFonts.almarai(
                          fontSize: 14,
                          color: Color.fromRGBO(129, 129, 129, 1),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "\$${order.total}",
                        style: GoogleFonts.almarai(
                          fontSize: 18,
                          color: Color.fromRGBO(20, 132, 242, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Details",
                        style: GoogleFonts.almarai(
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(20, 132, 242, 1),
                        ),
                      ),
                      Icon(
                        TablerIcons.chevrons_right,
                        color: Color.fromRGBO(20, 132, 242, 1),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Divider(),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ordered",
                        style: GoogleFonts.almarai(
                          fontSize: 13,
                          color: Color.fromRGBO(129, 129, 129, 1),
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            TablerIcons.calendar_due,
                            size: 20,
                            color: Color.fromRGBO(20, 132, 242, 1),
                          ),
                          SizedBox(width: 4),
                          Text(
                            Jiffy.parseFromDateTime(
                              order.createdat!,
                            ).format(pattern: "MMM dd,yyyy HH:mm a"),
                            style: GoogleFonts.almarai(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${order.status}",
                        style: GoogleFonts.almarai(
                          fontSize: 12,
                          color: Color.fromRGBO(129, 129, 129, 1),
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(TablerIcons.rotate_clockwise_2, size: 20),
                          SizedBox(width: 4),
                          Text(
                            Jiffy.now().format(pattern: "MMM dd,yyyy HH:mm a"),
                            style: GoogleFonts.almarai(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
