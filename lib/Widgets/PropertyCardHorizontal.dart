import 'dart:math';

import 'package:aqar_mobile/Controllers/ThemeController.dart';
import 'package:aqar_mobile/Pages/PropertyPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PropertyCardHorizontal extends ConsumerWidget {
  const PropertyCardHorizontal({Key? key, required this.property})
      : super(key: key);
  final Map<String, dynamic> property;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) =>
                    PropertyPage(propertyId: property["id"])));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
            width: size.width,
            height: 150,
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
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
                              color: Colors.grey[200]),
                        ),
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
