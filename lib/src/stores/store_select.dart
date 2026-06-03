import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/models/store_model.dart';
import 'package:laundrylane/providers/store_provider.dart';
import 'package:laundrylane/services/location_service.dart';
import 'package:laundrylane/src/apis/api_service.dart';
import 'package:laundrylane/src/home/home.dart';
import 'package:laundrylane/utils/constants.dart';
import 'package:speech_balloon/speech_balloon.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class StoreSelectPage extends StatefulHookConsumerWidget {
  const StoreSelectPage({super.key});
  static const routeName = '/store-select';

  @override
  ConsumerState<StoreSelectPage> createState() => _StoreSelectPageState();
}

class _StoreSelectPageState extends ConsumerState<StoreSelectPage> {
  GoogleMapController? mapController;

  LatLng? postion;

  void initPosition() async {
    final locationEnabled = await isLocationServiceEnabled();
    if (locationEnabled) {
      final currentPosition = await determineCurrentPosition();
      if (currentPosition != null) {
        setState(() {
          postion = currentPosition;
        });
      }
    } else {
      requestLocationPermission();
    }
  }

  @override
  void initState() {
    super.initState();
    initPosition();
  }

  @override
  Widget build(BuildContext context) {
    final watchStores = ref.watch(storesState);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(HomePage.routeName);
        },
        icon: Icon(TablerIcons.player_skip_forward),
        label: Text("Skip", style: Theme.of(context).textTheme.bodyLarge),
      ),
      appBar: AppBar(
        title: const Text("Select Store"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: StoreSearchDelegate(
                  onSelected: (store) {
                    Navigator.of(context).pop();
                    postion = LatLng(
                      store.latitude.toDouble(),
                      store.longitude.toDouble(),
                    );
                    mapController?.animateCamera(
                      CameraUpdate.newLatLng(postion!),
                    );
                    showDialog(
                      context: context,
                      useSafeArea: true,
                      builder:
                          (context) => Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            insetPadding: EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.bottomCenter,
                            child: StoreSelectItem(store: store),
                          ),
                    );
                  },
                ),
              );
            },
            icon: Icon(TablerIcons.search),
          ),
        ],
      ),
      body: watchStores.when(
        data: (stores) {
          return FutureBuilder(
            future: Future.wait(
              stores.map(
                (store) =>
                    SpeechBalloon(
                      width: 220,
                      nipLocation: NipLocation.bottom,
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: 16,
                      height: 60,
                      innerBorderRadius: 10,
                      child: Row(
                        children: [
                          SizedBox(width: 8),
                          CircleAvatar(
                            radius: 18,
                            child: Icon(TablerIcons.location),
                          ),
                          SizedBox(width: 6),
                          SizedBox(
                            width: 160,
                            child: Text(
                              store.name,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).toBitmapDescriptor(),
              ),
            ),
            builder: (context, asyncSnapshot) {
              return RefreshIndicator.adaptive(
                onRefresh: () async => ref.invalidate(storeProvider),
                child: GoogleMap(
                  zoomControlsEnabled: true,
                  scrollGesturesEnabled: true,
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  markers: Set<Marker>.of(
                    stores.map(
                      (store) => Marker(
                        onTap: () {
                          showDialog(
                            context: context,
                            useSafeArea: true,
                            builder:
                                (context) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  insetPadding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  alignment: Alignment.bottomCenter,
                                  child: StoreSelectItem(store: store),
                                ),
                          );
                        },
                        markerId: MarkerId(store.id.toString()),
                        icon:
                            asyncSnapshot.data?[stores.indexOf(store)] ??
                            BitmapDescriptor.defaultMarker,

                        position: LatLng(
                          store.latitude.toDouble(),
                          store.longitude.toDouble(),
                        ),
                      ),
                    ),
                  ),
                  onTap: (argument) {
                    setState(() {
                      postion = argument;
                    });
                    mapController!.animateCamera(
                      CameraUpdate.newLatLng(argument),
                    );
                  },
                  markerType: GoogleMapMarkerType.advancedMarker,
                  mapId:
                      Platform.isAndroid
                          ? "835d79a7bbcf05a6db02109c"
                          : "835d79a7bbcf05a610562e82",
                  mapToolbarEnabled: true,
                  mapType: MapType.normal,
                  compassEnabled: true,
                  zoomGesturesEnabled: true,
                  myLocationEnabled: true,
                  buildingsEnabled: true,
                  myLocationButtonEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: postion ?? LatLng(-1.242811, 36.655768),
                    zoom: 13.5,
                  ),
                ),
              );
            },
          );
        },
        error: (err, _) {
          // TODO: implement render view
          return Center(child: Text(watchStores.error.toString()));
        },
        loading:
            () => const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}

class StoreSelectItem extends ConsumerWidget {
  const StoreSelectItem({super.key, required this.store});
  final Stores store;
  @override
  Widget build(BuildContext context, ref) {
    final openningHours = TimeOfDay(
      hour: int.parse(store.opening.split(":").first),
      minute: int.parse(store.opening.split(":").last),
    );
    final closingHours = TimeOfDay(
      hour: int.parse(store.closing.split(":").first),
      minute: int.parse(store.closing.split(":").last),
    );
    final currentTime = TimeOfDay.now();
    bool isStoreOpen =
        currentTime.isAfter(openningHours) &&
        currentTime.isBefore(closingHours);
    bool getDay = store.daysOff.contains(DateTime.now().weekday);
    final isOpen = isStoreOpen && !getDay;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  store.name,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ),
              InkWell(child: Icon(CupertinoIcons.bookmark)),
            ],
          ),
          SizedBox(height: 12),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              store.location.capitalize,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).hintColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),

          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color:
                  isOpen
                      ? Color.fromRGBO(207, 241, 216, 1)
                      : Color.fromRGBO(239, 57, 53, 0.2),
            ),
            child: Text(
              isOpen ? "Open now" : "Closed now",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isOpen ? Color.fromRGBO(57, 142, 77, 1) : Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                minRadius: 28,
                child: Icon(
                  (serviceTypesIcons
                              .where((e) => e['title'] == store.category)
                              .firstOrNull?['icon'] ??
                          Icons.local_laundry_service)
                      as IconData,
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    store.category,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 2),
                  SizedBox(
                    height: 30,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder:
                          (context, index) => Text(
                            store.serviceNames[index],
                            style: TextStyle(color: Colors.grey),
                          ),
                      separatorBuilder:
                          (context, index) => Container(
                            height: 30,
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              "-",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                      itemCount: store.serviceNames.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.secondaryFixed,
                    ),
                    fixedSize: WidgetStatePropertyAll(Size.fromHeight(48)),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      isOpen
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).disabledColor,
                    ),
                    fixedSize: WidgetStatePropertyAll(Size.fromHeight(48)),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                  onPressed:
                      isOpen
                          ? () async {
                            await saveStoreId(store.id);
                            ref.invalidate(storeProvider);
                            if (context.mounted) {
                              Navigator.pop(context);
                              Navigator.of(
                                context,
                              ).pushNamed(HomePage.routeName);
                            }
                          }
                          : null,
                  child: Text(
                    "Start",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StoreSearchDelegate extends SearchDelegate {
  final void Function(Stores store)? onSelected;
  StoreSearchDelegate({required this.onSelected});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(TablerIcons.x),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(TablerIcons.arrow_left),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final watchStores = ref.watch(storesState);
        return watchStores.when(
          data: (stores) {
            final filteredStores =
                stores
                    .where(
                      (store) => store.name.toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                    )
                    .toList();
            return ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemBuilder:
                  (context, index) => StoreTile(
                    store: filteredStores[index],
                    onTap: onSelected,
                  ),
              itemCount: filteredStores.length,
            );
          },
          error: (err, _) => Center(child: Text(watchStores.error.toString())),
          loading:
              () => const Center(child: CircularProgressIndicator.adaptive()),
        );
      },
    );
  }
}

class StoreTile extends StatelessWidget {
  const StoreTile({super.key, required this.store, this.onTap});
  final Stores store;
  final void Function(Stores store)? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        if (onTap != null) {
          onTap!(store);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: store.logo ?? "",
                      errorWidget:
                          (context, url, error) => Container(
                            width: 56,
                            height: 56,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SvgPicture.asset(
                              "assets/svgs/laundry-washer-svgrepo-com.svg",
                            ),
                          ),
                      imageBuilder:
                          (context, imageProvider) => Container(
                            width: 56,
                            height: 56,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                onError:
                                    (exception, stackTrace) =>
                                        AssetImage('assets/icons/favicon.png'),
                                repeat: ImageRepeat.noRepeat,
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store.name,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          store.category,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).hintColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12),
                SizedBox(
                  height: 26,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder:
                        (context, index) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Theme.of(
                              context,
                            ).unselectedWidgetColor.withValues(alpha: 0.2),
                          ),
                          child: Text(
                            store.serviceNames[index],
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                    separatorBuilder: (context, index) => Container(width: 8),
                    itemCount:
                        store.serviceNames.length > 2
                            ? 2
                            : store.serviceNames.length,
                    scrollDirection: Axis.horizontal,
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
