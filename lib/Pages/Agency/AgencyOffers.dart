// ignore_for_file: prefer_const_constructors

import 'package:aqar_mobile/Controllers/AuthController.dart';
import 'package:aqar_mobile/Controllers/PropertiesController.dart';
import 'package:aqar_mobile/Pages/NeedToSignUp.dart';
import 'package:aqar_mobile/Widgets/PropertyCardHorizontal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Controllers/MiscController.dart';

class AgencyOffers extends ConsumerStatefulWidget {
  AgencyOffers({Key? key}) : super(key: key);

  @override
  _AgencyOffersState createState() => _AgencyOffersState();
}

class _AgencyOffersState extends ConsumerState<AgencyOffers> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("Vos Offres")),
      body: ref.read(authProvider).isLoggedIn
          ? FutureBuilder(
              future: ref.read(propertiesController).loadAllPropertiesAgency(
                  ref.read(authProvider).userData["id"]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    width: size.width,
                    height: size.height,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ref.read(propertiesController).allProperties.isEmpty
                        ? Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Pas D'Offres",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w900),
                              ),
                              Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  height: 50,
                                  width: 150,
                                  child: TextButton(
                                    child: Text(
                                      "Ajoutez Offre",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        ref
                                            .read(generalProvider)
                                            .homePageController
                                            ?.animateTo(2);
                                      });
                                    },
                                  )),
                            ],
                          ))
                        : ListView.builder(
                            itemCount: ref
                                .read(propertiesController)
                                .allProperties
                                .length,
                            itemBuilder: ((context, index) {
                              return PropertyCardHorizontal(
                                  property: ref
                                      .read(propertiesController)
                                      .allProperties[index]);
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
