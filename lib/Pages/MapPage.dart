// ignore_for_file: prefer_const_constructors

import 'package:aqar_mobile/Controllers/AuthController.dart';
import 'package:aqar_mobile/Controllers/PropertiesController.dart';
import 'package:aqar_mobile/Pages/PropertyPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Controllers/LocationHandeler.dart';
import '../Controllers/MiscController.dart';

class MapPage extends ConsumerStatefulWidget {
  MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  GoogleMapController? controller;
  List<Marker> markers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    () async {
      if (ref.read(generalProvider).isRequesting == false) {
        ref.read(generalProvider).isRequesting = true;
        ref.read(authProvider).userPosition = await determinePosition();
        ref.read(generalProvider).isRequesting = false;
      }
      if (ref.read(authProvider).userPosition != null) {
        await ref
            .read(propertiesController)
            .loadSurroundingProperties(ref.read(authProvider).userPosition!);
        ref.read(propertiesController).surroundingProperties.forEach((element) {
          markers.add(Marker(
              markerId: MarkerId(element["id"]),
              position: LatLng(
                  double.parse(element["lat"]), double.parse(element["long"])),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue)));
        });
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition position = CameraPosition(
      target: LatLng(ref.read(authProvider).userPosition?.latitude ?? 2,
          ref.read(authProvider).userPosition?.longitude ?? 2),
      zoom: 10.4746,
    );
    Size size = MediaQuery.of(context).size;
    markers.add(Marker(
      markerId: MarkerId("user"),
      position: LatLng(ref.read(authProvider).userPosition?.latitude ?? 2,
          ref.read(authProvider).userPosition?.longitude ?? 2),
    ));
    return Container(
      height: size.height,
      width: size.width,
      color: Colors.black,
      child: FutureBuilder(
          future: ref
              .read(propertiesController)
              .loadSurroundingProperties(ref.read(authProvider).userPosition!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              ref
                  .read(propertiesController)
                  .surroundingProperties
                  .forEach((element) {
                print(element["name"]);
                markers.add(
                  Marker(
                      markerId: MarkerId(element["id"]),
                      position: LatLng(double.parse(element["lat"]),
                          double.parse(element["long"])),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue),
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: ((context) {
                          return PropertyPage(
                              propertyId: element["property_id"]);
                        })));
                      }),
                );
              });
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: position,
                markers: markers.toSet(),
                onMapCreated: (GoogleMapController controlle) {
                  controller = controlle;
                },
                onTap: (pos) {},
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
