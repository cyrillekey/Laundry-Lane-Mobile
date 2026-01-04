import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/models/catalog_model.dart';
import 'package:laundrylane/src/apis/api_service.dart';
import 'package:laundrylane/src/cart/cart_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:tabler_icons/tabler_icons.dart';

class ServiceSelect extends StatefulHookConsumerWidget {
  const ServiceSelect({super.key});
  static const String routeName = "/ServiceSelect";

  @override
  ConsumerState<ServiceSelect> createState() => _ServiceSelectState();
}

class _ServiceSelectState extends ConsumerState<ServiceSelect> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final catalogListener = ref.watch(catalogState);
    return Scaffold(
      // backgroundColor: Color.fromRGBO(252, 251, 255, 1),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: selected != 0,
        child: TextButton(
          onPressed:
              selected == 0
                  ? null
                  : () {
                    final service = ref
                        .read(catalogState)
                        .value!
                        .firstWhere((e) => e.id == selected);
                    Navigator.of(
                      context,
                    ).pushNamed(CartPage.routeName, arguments: service);
                  },
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Color.fromRGBO(121, 20, 199, 1),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            fixedSize: WidgetStatePropertyAll(
              Size(MediaQuery.of(context).size.width * 0.92, 46),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "CONTINUE",
                style: GoogleFonts.urbanist(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Icon(CupertinoIcons.arrow_right, color: Colors.white),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/laundy_header.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: InkWell(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Container(
                    alignment: Alignment.center,
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      CupertinoIcons.back,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                  label: Text(
                    "Laundry & Dry Cleaning",
                    style: GoogleFonts.almarai(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Select your services",
              style: GoogleFonts.almarai(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: 16),
          catalogListener.when(
            data: (services) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.59,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  separatorBuilder: (_, __) => SizedBox(height: 10),
                  itemCount: services.length,
                  itemBuilder: (_, index) {
                    Catalog service = services[index];
                    return ServiceItem(
                      catalog: service,
                      isSelected: selected == service.id,
                      onSelected: (value) {
                        setState(() {
                          selected = value;
                        });
                      },
                    );
                  },
                ),
              );
            },
            error: (_, __) {
              return Center(child: Text("Something went wrong"));
            },
            loading: () {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.59,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  separatorBuilder: (_, __) => SizedBox(height: 10),
                  itemCount: 6,
                  itemBuilder: (_, index) {
                    return Shimmer.fromColors(
                      baseColor: Theme.of(context).scaffoldBackgroundColor,
                      highlightColor: Theme.of(context).highlightColor,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1.5),
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.18,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

typedef OnSelected = void Function(int id);

class ServiceItem extends StatelessWidget {
  const ServiceItem({
    super.key,
    required this.isSelected,
    required this.onSelected,
    required this.catalog,
  });

  final OnSelected onSelected;
  final bool isSelected;

  final Catalog catalog;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onTap: () {
        onSelected(catalog.id!);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(243, 243, 245, 1),
            width: 1.5,
          ),
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20),
        ),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: InkWell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    child: SvgPicture.network(
                      catalog.imageUrl!,
                      height: 26,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 6),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        catalog.name!,
                        style: GoogleFonts.almarai(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(text: "From "),
                            TextSpan(
                              text: '\$${catalog.price}/kg ',
                              style: GoogleFonts.almarai(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: "Price per weight"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    alignment: Alignment.center,
                    height: 26,
                    width: 26,
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Color.fromRGBO(116, 19, 209, 1)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color:
                            isSelected
                                ? Colors.white
                                : Color.fromRGBO(241, 241, 241, 1),
                      ),
                    ),
                    child: Icon(
                      TablerIcons.check,
                      size: 18,
                      color:
                          isSelected
                              ? Colors.white
                              : Color.fromRGBO(241, 241, 241, 1),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 26,
                width: MediaQuery.of(context).size.width,
                child: ListView.separated(
                  separatorBuilder: (_, __) => SizedBox(width: 10),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    String service = (catalog.services![index]);
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(243, 243, 245, 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        service.capitalize,
                        style: GoogleFonts.almarai(
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 30, 30, 1),
                          letterSpacing: 0.1,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                  itemCount: catalog.services!.length,
                ),
              ),
              SizedBox(height: 8),
              Text(
                catalog.description!,
                style: GoogleFonts.almarai(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}
