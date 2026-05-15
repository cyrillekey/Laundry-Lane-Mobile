import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/models/catalog_model.dart';
import 'package:laundrylane/providers/token_provider.dart';
import 'package:laundrylane/src/apis/api_service.dart';
import 'package:laundrylane/src/cart/cart_page.dart';
import 'package:laundrylane/src/home/widgets/address_bar.dart';
import 'package:laundrylane/src/home/widgets/current_order.dart';
import 'package:laundrylane/src/notifications/notifications_view.dart';
import 'package:laundrylane/theme/util.dart';
import 'package:laundrylane/utils/constants.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tabler_icons/tabler_icons.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = ref.watch(themeProvider).value;
    final user = ref.watch(userProvider).value;
    final catalogListener = ref.watch(catalogState);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: false,
          // backgroundColor: Color.fromRGBO(244, 245, 247, 1),
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image:
                            user?.avatar?.isNotEmpty == true
                                ? NetworkImage(user!.avatar!)
                                : AssetImage("assets/icons/user-icon.png"),
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                    ),
                    height: 46,
                    width: 46,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Good ${getTimeOfDay()} 👋',
                          style: GoogleFonts.almarai(
                            color: Color(0xFF757575),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          "${user?.name}",
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamed(NotificationsView.routeName);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(120),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Badge.count(
                      count: 0,
                      isLabelVisible: false,
                      child: const Icon(TablerIcons.bell, size: 24),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 26),
                AddressBar(),
                SizedBox(height: 26),
                CurrentOrder(),
                Text(
                  "Categories",
                  style: GoogleFonts.almarai(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                catalogListener.when(
                  data: (data) {
                    final catalog = data.firstWhere(
                      (element) => element.bulk == false,
                    );
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.21,
                      child: GridView.count(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          CategoryCard(
                            title: "Kids",
                            assetName: "assets/svgs/shirt-svgrepo-com.svg",
                            themeData: theme,
                            catalog: catalog,
                          ),
                          CategoryCard(
                            title: "Women",
                            assetName:
                                "assets/svgs/skirt-fashion-clothes-svgrepo-com.svg",
                            themeData: theme,
                            catalog: catalog,
                          ),
                          CategoryCard(
                            title: "Men",
                            assetName: "assets/svgs/coat-svgrepo-com.svg",
                            themeData: theme,
                            catalog: catalog,
                          ),
                          CategoryCard(
                            title: "Curtains",
                            assetName:
                                "assets/svgs/blinds-circus-curtain-svgrepo-com.svg",
                            themeData: theme,
                            catalog: catalog,
                          ),
                          CategoryCard(
                            title: 'Coach',
                            assetName: "assets/svgs/sofa-2-svgrepo-com.svg",
                            themeData: theme,
                            catalog: catalog,
                          ),
                          CategoryCard(
                            title: "Others",
                            assetName:
                                "assets/svgs/socks-christmas-winter-svgrepo-com.svg",
                            themeData: theme,
                            catalog: catalog,
                          ),
                          CategoryCard(
                            title: "Blankets",
                            assetName:
                                "assets/svgs/blanket-laundry-clean-svgrepo-com.svg",
                            themeData: theme,
                            catalog: catalog,
                          ),
                          CategoryCard(
                            title: "Bags",
                            assetName: "assets/svgs/bag-svgrepo-com.svg",
                            themeData: theme,
                            catalog: catalog,
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.21,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            highlightColor: Theme.of(context).highlightColor,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.5,
                                ),
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
                  error: (error, stackTrace) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.21,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            highlightColor: Theme.of(context).highlightColor,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.5,
                                ),
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
          ),
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.title,
    required this.assetName,
    required this.catalog,
    this.themeData,
  });
  final String title;
  final ThemeMode? themeData;
  final String assetName;
  final Catalog catalog;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap:
          () => Navigator.of(
            context,
          ).pushNamed(CartPage.routeName, arguments: catalog),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              themeData == ThemeMode.light
                  ? Colors.white
                  : Color.fromRGBO(29, 30, 77, 1),

          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              assetName,
              height: 40,
              width: 40,
              color: themeData == ThemeMode.light ? null : Colors.white,
            ),
            SizedBox(height: 2),
            Text(
              title,
              // style: GoogleFonts.almarai(color: Color.fromRGBO(70, 64, 139, 1)),
            ),
          ],
        ),
      ),
    );
  }
}
