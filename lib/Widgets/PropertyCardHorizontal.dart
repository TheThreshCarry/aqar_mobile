// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:aqar_mobile/Controllers/AuthController.dart';
import 'package:aqar_mobile/Controllers/ThemeController.dart';
import 'package:aqar_mobile/Pages/Agency/ModifyOffer.dart';
import 'package:aqar_mobile/Pages/PropertyPage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PropertyCardHorizontal extends ConsumerWidget {
  const PropertyCardHorizontal({Key? key, required this.property})
      : super(key: key);
  final Map<String, dynamic> property;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(property);
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => PropertyPage(
                    propertyId: property["property_id"] ?? property["id"])));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
            width: size.width,
            height: 175,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ref.read(themeProvider.notifier).state ==
                        ThemeController.lightTheme
                    ? Colors.white
                    : const Color(0xFF282828),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.25), blurRadius: 10)
                ]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          (property["images"] != null)
                              ? (property["images"] as List<dynamic>).isNotEmpty
                                  ? property["images"][0]
                                  : "https://www.iconsdb.com/icons/preview/dark-gray/square-xxl.png"
                              : "https://www.iconsdb.com/icons/preview/dark-gray/square-xxl.png",
                          height: 144,
                          width: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      property["offer_type"] != null
                          ? Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                height: 20,
                                width: 70,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                child: Center(
                                    child: Text(
                                  property["offer_type"] == 'r'
                                      ? "Location"
                                      : "Vente",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white),
                                )),
                              ))
                          : const SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: Container(
                    width: size.width * 0.5,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            property["name"],
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 24),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            property["description"] ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          property["price"] != null
                              ? (property["price"] + " DZ/month")
                              : "",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.remove_red_eye),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              property["views"] != null
                                  ? (property["views"].toString())
                                  : "",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              property["favorites"] != null
                                  ? (property["favorites"].toString())
                                  : "0",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        property["owner"] ==
                                ref.read(authProvider).userData["id"]
                            ? Row(
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ModifyOffer(
                                              property: property);
                                        }));
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        await Dio().delete(
                                            "https://aqar-server.herokuapp.com/properties/deleteProperty/${property["id"]}");
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                ],
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
