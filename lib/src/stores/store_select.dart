import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/models/store_model.dart';
import 'package:laundrylane/providers/store_provider.dart';
import 'package:laundrylane/services/location_service.dart';
import 'package:laundrylane/src/address/add_address.dart';
import 'package:laundrylane/src/apis/api_service.dart';
import 'package:laundrylane/src/home/home.dart';
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
      appBar: AppBar(title: const Text("Select Store"), centerTitle: true),
      body: FutureBuilder(
        future: getMapStyle(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          return watchStores.when(
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
                              SizedBox(width: 12),
                              CircleAvatar(
                                foregroundImage:
                                    store.logo == null ||
                                            store.logo == "" ||
                                            store.logo?.contains(".svg") == true
                                        ? AssetImage("assets/icons/favicon.png")
                                        : NetworkImage(stores[0].logo ?? ""),
                              ),
                              SizedBox(width: 8),
                              Text(
                                store.name,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ).toBitmapDescriptor(),
                  ),
                ),
                builder: (context, asyncSnapshot) {
                  return GoogleMap(
                    zoomControlsEnabled: true,
                    scrollGesturesEnabled: true,
                    liteModeEnabled: true,
                    style: snapshot.data,
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
                    mapType: MapType.terrain,
                    compassEnabled: true,
                    zoomGesturesEnabled: true,
                    myLocationEnabled: true,
                    buildingsEnabled: true,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: postion ?? LatLng(-1.242811, 36.655768),
                      zoom: 13.5,
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
          );
        },
      ),
    );
  }
}

class StoreSelectItem extends StatelessWidget {
  const StoreSelectItem({super.key, required this.store});
  final Stores store;
  @override
  Widget build(BuildContext context) {
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
                backgroundImage:
                    store.logo != null
                        ? NetworkImage(store.logo!)
                        : AssetImage("assets/icons/favicon.png"),
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
