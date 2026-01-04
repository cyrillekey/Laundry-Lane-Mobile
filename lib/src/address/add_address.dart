import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/models/default_response.dart';
import 'package:laundrylane/models/home_address.dart';
import 'package:laundrylane/src/apis/api_service.dart';
import 'package:laundrylane/models/goecode_reverse.dart';
import 'package:laundrylane/src/apis/mutations.dart';
import 'package:laundrylane/widgets/progress_button.dart';
import 'package:tabler_icons/tabler_icons.dart';

class AddAddressPage extends StatefulHookConsumerWidget {
  const AddAddressPage({super.key});
  static const String routeName = "/AddAddressPage";

  @override
  ConsumerState<AddAddressPage> createState() => _AddAddressPageState();
}

enum Addressstate { create, submit }

class _AddAddressPageState extends ConsumerState<AddAddressPage> {
  Addressstate state = Addressstate.create;
  GoogleMapController? mapController;

  LatLng? postion;
  @override
  void initState() {
    super.initState();
    HomeAddress? address = ref.read(addressState).value;
    if (address?.latitude != null && address?.longitude != null) {
      setState(() {
        postion = LatLng(address!.latitude!, address.longitude!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet:
          state == Addressstate.create
              ? SelectAddress(
                position: postion,
                onSubmit: () {
                  setState(() {
                    state = Addressstate.submit;
                  });
                },
              )
              : SubmitAddress(
                position: postion,
                onBack: () {
                  setState(() {
                    state = Addressstate.create;
                  });
                },
              ),
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
              },
              markers:
                  postion != null
                      ? {
                        Marker(
                          markerId: MarkerId("postion"),
                          position: postion!,
                          infoWindow: InfoWindow(
                            title: "Move pin to set your exact location",
                          ),
                        ),
                      }
                      : {},
              onTap: (argument) {
                setState(() {
                  postion = argument;
                });
                mapController!.animateCamera(CameraUpdate.newLatLng(argument));
              },
              mapType: MapType.terrain,
              compassEnabled: true,
              myLocationEnabled: true,
              buildingsEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target: postion ?? LatLng(-1.242811, 36.655768),
                zoom: 14.4746,
              ),
            ),
          ),
          Positioned(
            top: 00,
            left: 0,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Container(
                          height: 60,
                          width: 60,
                          alignment: Alignment.center,
                          child: Icon(Icons.arrow_back, size: 30),
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    Visibility(
                      visible: state == Addressstate.create,
                      child: Expanded(
                        child: Autocomplete<Properties>(
                          optionsBuilder: (controler) async {
                            if (controler.text.isNotEmpty) {
                              final result = await autoCompleteApi(
                                controler.text,
                              );

                              return result.map((e) => e.properties!);
                            }

                            return List<Properties>.empty();
                          },
                          onSelected: (option) {
                            setState(() {
                              postion = LatLng(option.lat!, option.lon!);
                            });
                            if (mapController != null) {
                              mapController!.animateCamera(
                                CameraUpdate.newLatLng(
                                  LatLng(option.lat!, option.lon!),
                                ),
                              );
                            }
                          },
                          displayStringForOption:
                              (option) => option.formatted ?? "N/A",

                          fieldViewBuilder:
                              (
                                context,
                                textEditingController,
                                focusNode,
                                onFieldSubmitted,
                              ) => TextField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(TablerIcons.map_search),
                                  hintText: "Search for delivery area",
                                  hintStyle: GoogleFonts.almarai(
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(182, 182, 182, 1),
                                  ),
                                  filled: true,
                                  fillColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(
                                            context,
                                          ).scaffoldBackgroundColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(
                                            context,
                                          ).scaffoldBackgroundColor,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(
                                            context,
                                          ).scaffoldBackgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectAddress extends StatelessWidget {
  const SelectAddress({super.key, this.position, required this.onSubmit});
  final LatLng? position;
  final VoidCallback onSubmit;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.32,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Confirm your laundry delivery location",
              style: GoogleFonts.almarai(
                fontSize: 17,
                color: Color.fromRGBO(152, 152, 152, 1),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 12),
          Divider(color: Color.fromRGBO(250, 250, 250, 1), thickness: 2),
          Spacer(),
          FutureBuilder(
            future: reverseGeocode(position),
            builder: (context, result) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color.fromRGBO(241, 241, 254, 1),
                      ),
                      child: Icon(TablerIcons.map_pin_filled),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            result.data?.properties?.name ??
                                result.data?.properties?.street ??
                                result.data?.properties?.city ??
                                "Address",
                            style: GoogleFonts.almarai(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Spacer(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              result.data?.properties?.formatted ?? "Address",
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (result.connectionState == ConnectionState.waiting) ...[
                      CircularProgressIndicator.adaptive(),
                    ],
                  ],
                ),
              );
            },
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton(
              onPressed: position == null ? null : onSubmit,
              style: ButtonStyle(
                fixedSize: WidgetStatePropertyAll(
                  Size(MediaQuery.of(context).size.width, 50),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                backgroundColor: WidgetStatePropertyAll(
                  position == null
                      ? Theme.of(context).disabledColor
                      : Colors.black,
                ),
              ),

              child: Text(
                "Confirm and add details",
                style: GoogleFonts.almarai(
                  color:
                      position == null
                          ? Theme.of(context).disabledColor
                          : Colors.white,
                  fontSize: 20,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

class SubmitAddress extends StatefulHookConsumerWidget {
  const SubmitAddress({super.key, this.position, required this.onBack});
  final LatLng? position;
  final VoidCallback onBack;

  @override
  ConsumerState<SubmitAddress> createState() => _SubmitAddressState();
}

class _SubmitAddressState extends ConsumerState<SubmitAddress> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  List<Map<String, dynamic>> houseTypes = [
    {"icon": TablerIcons.home_2, "name": "House"},
    {"icon": TablerIcons.building, "name": "Apartment"},
    {"icon": TablerIcons.building_cottage, "name": "Bungalow"},
    {"icon": TablerIcons.home_star, "name": "Villa"},
    {"icon": TablerIcons.building_store, "name": "Maisonette"},
    {"icon": TablerIcons.building_skyscraper, "name": "Condo"},
    {"icon": TablerIcons.home_eco, "name": "Cottage"},
  ];
  String? addressType;

  @override
  void initState() {
    super.initState();
    final address = ref.read(addressState).value;
    if (address?.type != null) {
      setState(() {
        addressType = address!.type;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final address = ref.read(addressState);
    return Container(
      height: MediaQuery.of(context).size.height * 0.66,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Address details",
                          style: GoogleFonts.almarai(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "A complete address would assist us better in serving you",
                          style: GoogleFonts.almarai(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton.outlined(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    onPressed: widget.onBack,
                    icon: Icon(TablerIcons.x),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Divider(color: Color.fromRGBO(246, 246, 246, 1), thickness: 2),
            SizedBox(height: 12),
            FormBuilder(
              initialValue: {
                "name": address.value?.recipientName,
                "phonenumber": address.value?.recipientPhone,
                "type": address.value?.type,
                "landmark": address.value?.landmark,
              },
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select address type",
                      style: GoogleFonts.almarai(
                        color: Color.fromRGBO(163, 163, 163, 1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          InkWell(
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromRGBO(238, 238, 238, 1),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(TablerIcons.plus),
                            ),
                          ),
                          SizedBox(width: 12),
                          FormBuilderField(
                            name: "type",
                            validator: FormBuilderValidators.required(),
                            builder: (builder) {
                              return Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (context, index) => InkWell(
                                          onTap: () {
                                            setState(() {
                                              addressType =
                                                  houseTypes[index]['name'];
                                            });
                                            builder.didChange(addressType);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  addressType ==
                                                          houseTypes[index]['name']
                                                      ? Color.fromRGBO(
                                                        239,
                                                        239,
                                                        253,
                                                        1,
                                                      )
                                                      : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color:
                                                    addressType ==
                                                            houseTypes[index]['name']
                                                        ? Color.fromRGBO(
                                                          114,
                                                          111,
                                                          210,
                                                          1,
                                                        )
                                                        : Color.fromRGBO(
                                                          238,
                                                          238,
                                                          238,
                                                          1,
                                                        ),
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  houseTypes[index]['icon'],
                                                  size: 20,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  houseTypes[index]['name'],
                                                  style: GoogleFonts.almarai(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    separatorBuilder:
                                        (context, index) => SizedBox(width: 12),
                                    itemCount: houseTypes.length,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    FormBuilderTextField(
                      name: "name",
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Please provide receiver's name",
                        ),
                      ]),
                      decoration: InputDecoration(
                        labelText: "Receiver's name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(224, 224, 224, 1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Color.fromRGBO(224, 224, 224, 1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Color.fromRGBO(87, 87, 87, 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    FormBuilderTextField(
                      name: "phonenumber",
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Please provide phone number",
                        ),
                      ]),
                      decoration: InputDecoration(
                        labelText: "Receiver's phone number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(224, 224, 224, 1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Color.fromRGBO(224, 224, 224, 1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Color.fromRGBO(87, 87, 87, 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    if (addressType == "Apartment" ||
                        addressType == "Condo") ...[
                      FormBuilderTextField(
                        name: "houseNo",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.required(
                          errorText: "Please provide unit no",
                        ),

                        decoration: InputDecoration(
                          hintText: "Apartment Number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(224, 224, 224, 1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Color.fromRGBO(224, 224, 224, 1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Color.fromRGBO(87, 87, 87, 1),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                    FormBuilderTextField(
                      name: "landmark",
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: "Nearby Landmark (optional)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(224, 224, 224, 1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Color.fromRGBO(224, 224, 224, 1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Color.fromRGBO(87, 87, 87, 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    ProgressButton(
                      onPress: () async {
                        if (formKey.currentState?.saveAndValidate() == true) {
                          HomeAddress? address = ref.read(addressState).value;
                          Map values = formKey.currentState!.value;
                          if (address?.id == null) {
                            DefaultResponse response = await createAddress(
                              position: widget.position!,
                              type: values['type'],
                              recipientName: values['name'],
                              recipientPhone: values['phonenumber'],
                            );
                            if (response.success == true) {
                              ref.invalidate(addressState);
                              Navigator.pop(context);
                            }
                          } else {
                            DefaultResponse response = await updateAddress(
                              address!.id!,
                              position: widget.position!,
                              type: values['type'],
                              recipientName: values['name'],
                              recipientPhone: values['phonenumber'],
                            );
                            if (response.success == true) {
                              ref.invalidate(addressState);
                              Navigator.pop(context);
                            }
                          }
                        }
                      },
                      textStyle: GoogleFonts.almarai(
                        color: Colors.white,
                        fontSize: 20,
                        letterSpacing: 1.2,
                      ),
                      label:
                          address.value?.id != null
                              ? "Update Address"
                              : "Submit Address",
                      style: ButtonStyle(
                        fixedSize: WidgetStatePropertyAll(
                          Size(MediaQuery.of(context).size.width, 50),
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        backgroundColor: WidgetStatePropertyAll(Colors.black),
                      ),
                    ),

                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
