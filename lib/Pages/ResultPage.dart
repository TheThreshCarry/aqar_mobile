import 'package:aqar_mobile/Controllers/AuthController.dart';
import 'package:aqar_mobile/Controllers/PropertiesController.dart';
import 'package:aqar_mobile/Pages/NeedToSignUp.dart';
import 'package:aqar_mobile/Widgets/PropertyCardHorizontal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultPage extends ConsumerStatefulWidget {
  ResultPage({Key? key}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends ConsumerState<ResultPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(title: const Text("Résultats")),
        body: FutureBuilder(
            future: ref.read(propertiesController).loadFilteredProperties(
                ref.read(authProvider).userPosition?.latitude,
                ref.read(authProvider).userPosition?.longitude),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  width: size.width,
                  height: size.height,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child:
                      ref.read(propertiesController).filteredProperties.isEmpty
                          ? const Center(
                              child: Text(
                              "Pas De Résultats",
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.w900),
                            ))
                          : ListView.builder(
                              itemCount: ref
                                  .read(propertiesController)
                                  .filteredProperties
                                  .length,
                              itemBuilder: ((context, index) {
                                return PropertyCardHorizontal(
                                    property: ref
                                        .read(propertiesController)
                                        .filteredProperties[index]);
                              })),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
