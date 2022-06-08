// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:aqar_mobile/Controllers/ImagePickerController.dart';
import 'package:aqar_mobile/Controllers/LocationHandeler.dart';
import 'package:aqar_mobile/Controllers/PropertiesController.dart';
import 'package:aqar_mobile/Controllers/RegisterFormController.dart';
import 'package:aqar_mobile/Controllers/StorageController.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../Controllers/AuthController.dart';

class ModifyOffer extends ConsumerStatefulWidget {
  ModifyOffer({Key? key, required this.property}) : super(key: key);
  Map<String, dynamic> property;
  @override
  _ModifyOfferState createState() => _ModifyOfferState();
}

class _ModifyOfferState extends ConsumerState<ModifyOffer> {
  bool loading = false;
  late Map<String, dynamic> property;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    property = widget.property;
  }

  final formKey = GlobalKey<FormState>();
  bool showPassword = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (ref.read(authProvider).userPosition != null) {
      ref.read(propertiesController).newOffer["lat"] =
          ref.read(authProvider).userPosition?.latitude;
      ref.read(propertiesController).newOffer["long"] =
          ref.read(authProvider).userPosition?.longitude;
    }
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text("Modifier Offre")),
            body: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Container(
                  width: size.width,
                  padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          "Entrez Vos Informations Pour Modifier Une Offre",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xFFF4F4F4)),
                                  child: TextFormField(
                                    cursorColor:
                                        Theme.of(context).colorScheme.secondary,
                                    style: const TextStyle(
                                        color: Color(0xFF282828)),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "This field is Neccessary";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Titre",
                                      hintStyle: TextStyle(
                                          color: const Color(0xFF282828)
                                              .withOpacity(0.3)),
                                      border: InputBorder.none,
                                    ),
                                    initialValue: property["name"] ?? "",
                                    onChanged: (value) {
                                      property["name"] = value;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xFFF4F4F4)),
                                  child: TextFormField(
                                    cursorColor:
                                        Theme.of(context).colorScheme.secondary,
                                    style: const TextStyle(
                                        color: Color(0xFF282828)),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "This field is Neccessary";
                                      }
                                      return null;
                                    },
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ],
                                    decoration: InputDecoration(
                                      suffixText: "㎡",
                                      suffixStyle:
                                          TextStyle(color: Colors.black),
                                      hintText: "Area",
                                      hintStyle: TextStyle(
                                          color: const Color(0xFF282828)
                                              .withOpacity(0.3)),
                                      border: InputBorder.none,
                                    ),
                                    initialValue: property["area"].toString(),
                                    onChanged: (value) {
                                      property["area"] = value;
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFFF4F4F4)),
                            child: TextFormField(
                              cursorColor:
                                  Theme.of(context).colorScheme.secondary,
                              style: const TextStyle(color: Color(0xFF282828)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This field is Neccessary";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Prix",
                                hintStyle: TextStyle(
                                    color: const Color(0xFF282828)
                                        .withOpacity(0.3)),
                                border: InputBorder.none,
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              initialValue: property["price"] != null
                                  ? property["price"].toString()
                                  : "",
                              onChanged: (value) {
                                property["price"] = int.parse(value);
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFFF4F4F4)),
                            child: TextFormField(
                              cursorColor:
                                  Theme.of(context).colorScheme.secondary,
                              style: const TextStyle(color: Color(0xFF282828)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This field is Neccessary";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Chambres",
                                hintStyle: TextStyle(
                                    color: const Color(0xFF282828)
                                        .withOpacity(0.3)),
                                border: InputBorder.none,
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              initialValue: property["bedrooms"] != null
                                  ? property["bedrooms"].toString()
                                  : "",
                              onChanged: (value) {
                                property["bedrooms"] = int.parse(value);
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 70,
                            width: size.width,
                            padding:
                                EdgeInsets.only(top: 15, right: 10, bottom: 15),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        property["offer_type"] = 'r';
                                      });
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 150,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: property["offer_type"] == 'r'
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                            : Color(0xFFABABAB),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Rent',
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        property["offer_type"] = 's';
                                      });
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 150,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: property["offer_type"] == 's'
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                            : Color(0xFFABABAB),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Buy',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            height: 250,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFFF4F4F4)),
                            child: TextFormField(
                              maxLines: 4,
                              cursorColor:
                                  Theme.of(context).colorScheme.secondary,
                              style: const TextStyle(color: Color(0xFF282828)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This field is Neccessary";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Description",
                                hintStyle: TextStyle(
                                    color: const Color(0xFF282828)
                                        .withOpacity(0.3)),
                                border: InputBorder.none,
                              ),
                              initialValue: property["description"],
                              onChanged: (value) {
                                property["description"] = value;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              height: 50,
                              width: 300,
                              child: TextButton(
                                  child: loading == false
                                      ? Text("Modifier Offre")
                                      : CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                  onPressed: () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    try {
                                      var result = await Dio().patch(
                                          "https://aqar-server.herokuapp.com/properties/editProperty",
                                          data: {
                                            ...property,
                                            "token": ref
                                                .read(authProvider)
                                                .getToken()
                                          });
                                      Navigator.of(context)
                                          .popAndPushNamed("/");
                                      setState(() {
                                        loading = false;
                                      });
                                    } catch (e) {
                                      print(e);
                                      setState(() {
                                        loading = false;
                                      });
                                    }
                                  })),
                        ]),
                        const SizedBox(
                          height: 75,
                        )
                      ]),
                ),
              ),
            )));
  }
}
