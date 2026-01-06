import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/src/address/add_address.dart';
import 'package:laundrylane/src/apis/api_service.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tabler_icons/tabler_icons.dart';

class AddressBar extends ConsumerWidget {
  const AddressBar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final addressListener = ref.watch(addressState);
    return addressListener.when(
      data: (data) {
        if (data?.id == null) {
          return InkWell(
            onTap:
                () => Navigator.of(context).pushNamed(AddAddressPage.routeName),
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/map.jpg"),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Set your address now",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(TablerIcons.plus),
                ],
              ),
            ),
          );
        } else {
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap:
                () => Navigator.of(context).pushNamed(AddAddressPage.routeName),
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromRGBO(29, 30, 77, 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // SizedBox(width: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(224, 107, 80, 1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: 36,
                    height: 36,
                    child: Center(
                      child: Icon(TablerIcons.map_pin, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  SizedBox(
                    height: 36,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your location",
                          style: GoogleFonts.almarai(
                            color: Color.fromRGBO(148, 152, 186, 1),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.60,
                                child: Text(
                                  "${data!.street}",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.almarai(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 1),
                              Icon(
                                TablerIcons.chevron_down,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
      loading: () {
        return Shimmer.fromColors(
          baseColor: Theme.of(context).scaffoldBackgroundColor,
          highlightColor: Theme.of(context).highlightColor,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
            width: MediaQuery.of(context).size.width,
            height: 60,
          ),
        );
      },
      error: (error, stackTrace) {
        return InkWell(
          onTap:
              () => Navigator.of(context).pushNamed(AddAddressPage.routeName),
          child: Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/map.jpg"),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Set your address now",
                  style: GoogleFonts.almarai(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(TablerIcons.plus),
              ],
            ),
          ),
        );
      },
    );
  }
}
