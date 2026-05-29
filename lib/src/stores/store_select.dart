import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/models/store_model.dart';
import 'package:laundrylane/services/location_service.dart';
import 'package:laundrylane/src/address/add_address.dart';
import 'package:laundrylane/src/apis/api_service.dart';
import 'package:speech_balloon/speech_balloon.dart';
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
                          borderRadius: 10,
                          height: 60,
                          innerBorderRadius: 10,
                          child: Row(
                            children: [
                              SizedBox(width: 12),
                              CircleAvatar(
                                foregroundImage: AssetImage(
                                  "assets/icons/favicon.png",
                                ),
                                // store.logo == null ||
                                //         store.logo == "" ||
                                //         store.logo?.contains(".svg") == true
                                //     ? AssetImage("assets/icons/favicon.png")
                                //     : NetworkImage(stores[0].logo ?? ""),
                              ),
                              SizedBox(width: 8),
                              Text(
                                store.name,
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
                    liteModeEnabled: true,
                    style: snapshot.data,
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                    markers: Set<Marker>.of(
                      stores.map(
                        (store) => Marker(
                          onTap: () {
                            showModalBottomSheet(
                              enableDrag: true,
                              context: context,
                              showDragHandle: true,
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadiusGeometry.only(
                              //     topLeft: Radius.circular(20),
                              //     topRight: Radius.circular(20),
                              //   ),
                              // ),
                              builder:
                                  (context) => StoreSelectItem(store: store),
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
    return SizedBox(
      width: double.infinity,

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [SizedBox(height: 12)],
      ),
    );
  }
}
