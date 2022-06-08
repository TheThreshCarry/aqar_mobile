// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:aqar_mobile/Pages/PropertyPage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Controllers/ThemeController.dart';

class PropertyCard extends ConsumerWidget {
  const PropertyCard({Key? key, required this.property}) : super(key: key);
  final Map<String, dynamic> property;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        /*var result = await Dio().get(
            "https://aqar-server.herokuapp.com/properties/${property['id']}");
        print(result.data);*/

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) =>
                    PropertyPage(propertyId: property['id'])));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
            width: 200,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: ref.read(themeProvider.notifier).state ==
                        ThemeController.lightTheme
                    ? Colors.white
                    : const Color(0xFF282828),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.25), blurRadius: 10)
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  height: 144,
                  width: 180,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
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
                          : SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    property["name"],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 24),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      property["description"] ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    property["price"] != null
                        ? (property["price"] +
                            (property["offer_type"] == 'r'
                                ? "DZ/month"
                                : " DZ"))
                        : "",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
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
                ),
              ],
            )),
      ),
    );
  }
}
