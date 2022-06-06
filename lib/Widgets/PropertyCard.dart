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
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      (property["images"] != null)
                          ? property["images"][0]
                          : "https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Grey_Square.svg/800px-Grey_Square.svg.png",
                      height: 144,
                      width: 180,
                      fit: BoxFit.cover,
                    ),
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
                )
              ],
            )),
      ),
    );
  }
}
