import 'package:aqar_mobile/Controllers/AuthController.dart';
import 'package:aqar_mobile/Controllers/PropertiesController.dart';
import 'package:aqar_mobile/Pages/NeedToSignUp.dart';
import 'package:aqar_mobile/Widgets/PropertyCardHorizontal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritePage extends ConsumerStatefulWidget {
  FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends ConsumerState<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: ref.read(authProvider).isLoggedIn
          ? FutureBuilder(
              future: ref
                  .read(propertiesController)
                  .getFavorites(ref.read(authProvider).userData["id"]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    width: size.width,
                    height: size.height,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ref
                            .read(propertiesController)
                            .favoriteProperties
                            .isEmpty
                        ? const Center(
                            child: Text(
                            "Pas De Favorites",
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.w900),
                          ))
                        : ListView.builder(
                            itemCount: ref
                                .read(propertiesController)
                                .favoriteProperties
                                .length,
                            itemBuilder: ((context, index) {
                              return PropertyCardHorizontal(
                                  property: ref
                                      .read(propertiesController)
                                      .favoriteProperties[index]);
                            })),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })
          : NeedToSignUp(),
    );
  }
}
