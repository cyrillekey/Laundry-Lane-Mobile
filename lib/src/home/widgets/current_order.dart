import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:laundrylane/src/apis/api_service.dart';
import 'package:laundrylane/src/orders/order_details.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class CurrentOrder extends ConsumerWidget {
  const CurrentOrder({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final listenOrder = ref.watch(ongoingOrderState);
    return listenOrder.when(
      loading:
          () => Column(
            children: [
              Shimmer.fromColors(
                baseColor: Theme.of(context).scaffoldBackgroundColor,
                highlightColor: Theme.of(context).highlightColor,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 26),
            ],
          ),
      error: (error, stackTrace) => SizedBox.shrink(),
      data: (data) {
        if (data == null) {
          return SizedBox.shrink();
        }
        return Column(
          children: [
            InkWell(
              onTap:
                  () => Navigator.of(
                    context,
                  ).pushNamed(OrderDetails.routeName, arguments: data.id),
              borderRadius: BorderRadius.circular(14),
              child: Card.outlined(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: Theme.of(context).dividerColor),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.productCatalog?.name ?? "Laundry Service",
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 6),
                              Text(
                                Jiffy.parseFromDateTime(
                                  data.date,
                                ).format(pattern: "MMMM dd, yyyy / hh:mm a"),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Color.fromRGBO(254, 223, 106, 1),
                            ),
                            child: Text(
                              data.orderStatus,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(157, 126, 36, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      DottedLine(
                        dashColor: Theme.of(context).dividerColor,
                        lineThickness: 1.5,
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                TablerIcons.circle_check_filled,
                                color: Color.fromRGBO(113, 196, 119, 1),
                              ),
                              SizedBox(width: 4),
                              Text("Washing", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                TablerIcons.circle_check_filled,
                                color: Color.fromRGBO(113, 196, 119, 1),
                              ),
                              SizedBox(width: 4),
                              Text("Drying", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                TablerIcons.circle_check_filled,
                                color: Color.fromRGBO(113, 196, 119, 1),
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Ironing",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(TablerIcons.circle),
                              SizedBox(width: 4),
                              Text("Delivery", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 26),
          ],
        );
      },
    );
  }
}
