// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:math';

import 'package:aqar_mobile/Controllers/AuthController.dart';
import 'package:aqar_mobile/Controllers/MiscController.dart';
import 'package:aqar_mobile/Controllers/PropertiesController.dart';
import 'package:aqar_mobile/Controllers/ThemeController.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:webviewx/webviewx.dart';

class PropertyPage extends ConsumerStatefulWidget {
  PropertyPage({Key? key, required this.propertyId}) : super(key: key);
  String propertyId;

  @override
  _PropertyPageState createState() => _PropertyPageState();
}

class _PropertyPageState extends ConsumerState<PropertyPage> {
  CarouselController controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Container(
            height: size.height,
            width: size.width,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: FutureBuilder(
                future: ref.read(propertiesController).getPropertyById(
                    widget.propertyId, ref.read(authProvider).userData["id"]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    CameraPosition position = CameraPosition(
                      target: LatLng(
                          double.parse(ref
                                  .read(propertiesController)
                                  .selectedProperty?["lat"] ??
                              "2"),
                          double.parse(ref
                                  .read(propertiesController)
                                  .selectedProperty?["long"] ??
                              "2")),
                      zoom: 14.4746,
                    );
                    GoogleMapController mapController;
                    List<Marker> markers = [];

                    if (ref
                                .read(propertiesController)
                                .selectedProperty?["lat"] !=
                            null &&
                        ref
                                .read(propertiesController)
                                .selectedProperty?["long"] !=
                            null) {
                      markers.add(Marker(
                          markerId: MarkerId(ref
                              .read(propertiesController)
                              .selectedProperty?["id"]),
                          position: LatLng(
                              double.parse(ref
                                  .read(propertiesController)
                                  .selectedProperty?["lat"]),
                              double.parse(ref
                                  .read(propertiesController)
                                  .selectedProperty?["long"]))));
                    }
                    print(ref.read(propertiesController).selectedProperty);
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            height: 50,
                            width: size.width,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                      iconSize: 32,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                          Icons.arrow_circle_left_rounded)),
                                  Container(
                                    height: 30,
                                    width: 74,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: ref
                                                      .read(propertiesController)
                                                      .selectedProperty?[
                                                  "available"] ??
                                              false
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                          : const Color(0xFF282828),
                                    ),
                                    child: Center(
                                      child: Text(
                                        ref
                                                        .read(propertiesController)
                                                        .selectedProperty?[
                                                    "available"] ??
                                                false
                                            ? "Available"
                                            : "Not Available",
                                        style: const TextStyle(
                                            fontSize: 8, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.menu_rounded),
                                    iconSize: 32,
                                  )
                                ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ref
                                      .read(propertiesController)
                                      .selectedProperty?["name"],
                                  style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox(
                                    height: size.height * 0.35,
                                    width: double.infinity,
                                    child: CarouselSlider.builder(
                                      itemCount: ref
                                              .read(propertiesController)
                                              .selectedProperty?["images"]
                                              .length ??
                                          1,
                                      itemBuilder: (BuildContext context,
                                          int index, int page) {
                                        if (ref
                                                .read(propertiesController)
                                                .selectedProperty?["images"] ==
                                            null) {
                                          return Image.network(
                                            ref
                                                    .read(propertiesController)
                                                    .selectedProperty?["images"]
                                                [index],
                                            fit: BoxFit.fitHeight,
                                          );
                                        }
                                        return Image.network(
                                          ref
                                                  .read(propertiesController)
                                                  .selectedProperty?["images"]
                                              [index],
                                          fit: BoxFit.fitHeight,
                                        );
                                      },
                                      options: CarouselOptions(
                                          height: size.height * 0.35,
                                          viewportFraction: 1,
                                          enableInfiniteScroll: true),
                                      carouselController: controller,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ref
                                                .read(propertiesController)
                                                .selectedProperty?["city"] !=
                                            null
                                        ? Text(
                                            ref
                                                        .read(propertiesController)
                                                        .selectedProperty?[
                                                    "line_one"] +
                                                ", " +
                                                ref
                                                    .read(propertiesController)
                                                    .selectedProperty?["city"] +
                                                ", " +
                                                ref
                                                    .read(propertiesController)
                                                    .selectedProperty?["country"],
                                            style:
                                                const TextStyle(fontSize: 13),
                                          )
                                        : const Text("Pas D'Adresse Spécifié")
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 82,
                                  width: size.width,
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            var lat = ref
                                                .read(propertiesController)
                                                .selectedProperty?["lat"];
                                            var long = ref
                                                .read(propertiesController)
                                                .selectedProperty?["long"];
                                            if (lat != null && long != null) {
                                              ref.read(generalProvider).openMap(
                                                  double.parse(lat),
                                                  double.parse(long));
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Pas De Location Specifié'),
                                                ),
                                              );
                                            }
                                          },
                                          child: Column(children: [
                                            Icon(
                                              Icons.map_outlined,
                                              size: 50,
                                              color: ref
                                                              .read(
                                                                  propertiesController)
                                                              .selectedProperty?[
                                                          "lat"] ==
                                                      null
                                                  ? Colors.grey
                                                  : ref
                                                              .read(
                                                                  themeProvider
                                                                      .notifier)
                                                              .state ==
                                                          ThemeController
                                                              .darkTheme
                                                      ? Colors.white
                                                      : Colors.black,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("Location")
                                          ]),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            if (snapshot.data == false) {
                                              await ref
                                                  .read(propertiesController)
                                                  .addFavorite(
                                                      ref
                                                              .read(
                                                                  propertiesController)
                                                              .selectedProperty?[
                                                          "id"],
                                                      ref
                                                          .read(authProvider)
                                                          .userData["id"],
                                                      ref
                                                          .read(authProvider)
                                                          .getToken());
                                              setState(() {});
                                            } else {
                                              print(ref
                                                  .read(propertiesController)
                                                  .selectedProperty?["id"]);
                                              await ref
                                                  .read(propertiesController)
                                                  .deleteFavorite(
                                                      ref
                                                              .read(
                                                                  propertiesController)
                                                              .selectedProperty?[
                                                          "id"],
                                                      ref
                                                          .read(authProvider)
                                                          .userData["id"]);
                                              setState(() {});
                                            }
                                          },
                                          child: Column(children: [
                                            Icon(
                                              Icons.favorite,
                                              size: 50,
                                              color: snapshot.data == false
                                                  ? ref
                                                              .read(
                                                                  themeProvider
                                                                      .notifier)
                                                              .state ==
                                                          ThemeController
                                                              .darkTheme
                                                      ? Colors.white
                                                      : Colors.black
                                                  : Colors.red,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("Favorite")
                                          ]),
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Column(children: const [
                                            Icon(
                                              Icons.share,
                                              size: 50,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("Share")
                                          ]),
                                        )
                                      ]),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.money,
                                      size: 24,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      ref
                                                  .read(propertiesController)
                                                  .selectedProperty?["price"] ==
                                              null
                                          ? " Pas de Prix Mentioné"
                                          : ref
                                                  .read(propertiesController)
                                                  .selectedProperty!["price"]
                                                  .toString() +
                                              " dz/Mois",
                                      style: const TextStyle(fontSize: 20),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Description",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 24),
                                ),
                                Text(ref
                                        .read(propertiesController)
                                        .selectedProperty?["description"] ??
                                    "Pas De Description Specifié"),
                                SizedBox(
                                  height: 20,
                                ),
                                (ref
                                                .read(propertiesController)
                                                .selectedProperty?["lat"] !=
                                            null &&
                                        ref
                                                .read(propertiesController)
                                                .selectedProperty?["long"] !=
                                            null)
                                    ? Container(
                                        height: 400,
                                        width: size.width,
                                        child: GoogleMap(
                                          mapType: MapType.normal,
                                          initialCameraPosition: position,
                                          markers: markers.toSet(),
                                          onMapCreated:
                                              (GoogleMapController controller) {
                                            mapController = controller;
                                          },
                                          onTap: (pos) {},
                                        ))
                                    : SizedBox(),
                                Container(
                                  height: 100,
                                  width: size.width * 0.8,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.1),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey),
                                  child: FutureBuilder(
                                    future: ref
                                        .read(propertiesController)
                                        .getOwnerData(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Container(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          Random().nextInt(254),
                                                          Random().nextInt(254),
                                                          Random().nextInt(254),
                                                          1),
                                                  backgroundImage: NetworkImage(ref
                                                              .read(
                                                                  propertiesController)
                                                              .selectedPropertyOwner?[
                                                          "imageurl"] ??
                                                      "https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png")),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                ref
                                                            .read(
                                                                propertiesController)
                                                            .selectedPropertyOwner?[
                                                        "name"] ??
                                                    "",
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              )
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })),
      ),
    );
  }
}
