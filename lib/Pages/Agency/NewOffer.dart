// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:aqar_mobile/Controllers/ImagePickerController.dart';
import 'package:aqar_mobile/Controllers/LocationHandeler.dart';
import 'package:aqar_mobile/Controllers/PropertiesController.dart';
import 'package:aqar_mobile/Controllers/RegisterFormController.dart';
import 'package:aqar_mobile/Controllers/StorageController.dart';
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

class NewOffer extends ConsumerStatefulWidget {
  NewOffer({Key? key}) : super(key: key);

  @override
  _NewOfferState createState() => _NewOfferState();
}

class _NewOfferState extends ConsumerState<NewOffer> {
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(propertiesController).newOffer["offer_type"] = 'r';
    ref.read(propertiesController).newOffer["imagesFiles"] = <XFile?>[
      null,
      null,
      null
    ];
    ref.read(propertiesController).newOffer["imagesUrl"] = <String?>[
      null,
      null,
      null
    ];
  }

  final ImagePicker _picker = ImagePicker();
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
            body: Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Container(
          width: size.width,
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Nouvelle Offre",
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 20),
            Text(
              "Entrez Vos Informations Pour Créer Une Offre",
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
                        cursorColor: Theme.of(context).colorScheme.secondary,
                        style: const TextStyle(color: Color(0xFF282828)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field is Neccessary";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Titre",
                          hintStyle: TextStyle(
                              color: const Color(0xFF282828).withOpacity(0.3)),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          ref.watch(propertiesController).newOffer["name"] =
                              value;
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
                        cursorColor: Theme.of(context).colorScheme.secondary,
                        style: const TextStyle(color: Color(0xFF282828)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field is Neccessary";
                          }
                          return null;
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        decoration: InputDecoration(
                          suffixText: "㎡",
                          suffixStyle: TextStyle(color: Colors.black),
                          hintText: "Area",
                          hintStyle: TextStyle(
                              color: const Color(0xFF282828).withOpacity(0.3)),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          ref.watch(propertiesController).newOffer["area"] =
                              value;
                        },
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (ref.read(authProvider).userPosition == null) {
                          await determinePosition();
                          setState(() {});
                        }
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFF4F4F4)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                ref.read(authProvider).userPosition == null
                                    ? "Localisation"
                                    : "${ref.read(authProvider).userPosition?.latitude.toStringAsFixed(2)} / ${ref.read(authProvider).userPosition?.longitude.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Color(0xFF282828),
                                )),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: const Icon(
                                Icons.gps_fixed,
                                color: Color(0xFF282828),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: size.width,
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFF4F4F4)),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFF4F4F4)),
                        child: TextFormField(
                          cursorColor: Theme.of(context).colorScheme.secondary,
                          style: const TextStyle(color: Color(0xFF282828)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is Neccessary";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "City",
                            hintStyle: TextStyle(
                                color:
                                    const Color(0xFF282828).withOpacity(0.3)),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            ref.watch(propertiesController).newOffer["city"] =
                                value;
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
                          cursorColor: Theme.of(context).colorScheme.secondary,
                          style: const TextStyle(color: Color(0xFF282828)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is Neccessary";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Country",
                            hintStyle: TextStyle(
                                color:
                                    const Color(0xFF282828).withOpacity(0.3)),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            ref
                                .watch(propertiesController)
                                .newOffer["country"] = value;
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
                          cursorColor: Theme.of(context).colorScheme.secondary,
                          style: const TextStyle(color: Color(0xFF282828)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is Neccessary";
                            }
                            return null;
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          decoration: InputDecoration(
                            hintText: "Zip Code",
                            hintStyle: TextStyle(
                                color:
                                    const Color(0xFF282828).withOpacity(0.3)),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            ref
                                .watch(propertiesController)
                                .newOffer["zipcode"] = value;
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 70,
                width: size.width,
                padding: EdgeInsets.only(top: 15, right: 10, bottom: 15),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            ref
                                .read(propertiesController)
                                .newOffer["offer_type"] = 'r';
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 150,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ref
                                        .read(propertiesController)
                                        .newOffer["offer_type"] ==
                                    'r'
                                ? Theme.of(context).colorScheme.secondary
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
                            ref
                                .read(propertiesController)
                                .newOffer["offer_type"] = 's';
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 150,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ref
                                        .read(propertiesController)
                                        .newOffer["offer_type"] ==
                                    's'
                                ? Theme.of(context).colorScheme.secondary
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
                  cursorColor: Theme.of(context).colorScheme.secondary,
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
                        color: const Color(0xFF282828).withOpacity(0.3)),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    ref.watch(propertiesController).newOffer["description"] =
                        value;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      ref.read(propertiesController).newOffer["images"][0] =
                          await _picker.pickImage(source: ImageSource.gallery);
                      setState(() {});
                    },
                    child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10)),
                        child: ref
                                    .read(propertiesController)
                                    .newOffer["imagesFiles"][0] ==
                                null
                            ? const Icon(
                                Icons.image,
                                size: 70,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(ref
                                      .read(propertiesController)
                                      .newOffer["imagesFiles"][0]!
                                      .path),
                                  fit: BoxFit.cover,
                                ),
                              )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      ref.read(propertiesController).newOffer["imagesFiles"]
                              [1] =
                          await _picker.pickImage(source: ImageSource.gallery);
                      setState(() {});
                    },
                    child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10)),
                        child: ref
                                    .read(propertiesController)
                                    .newOffer["imagesFiles"][1] ==
                                null
                            ? const Icon(
                                Icons.image,
                                size: 70,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(ref
                                      .read(propertiesController)
                                      .newOffer["imagesFiles"][1]!
                                      .path),
                                  fit: BoxFit.cover,
                                ),
                              )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      ref.read(propertiesController).newOffer["imagesFiles"]
                              [2] =
                          await _picker.pickImage(source: ImageSource.gallery);
                      setState(() {});
                    },
                    child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10)),
                        child: ref
                                    .read(propertiesController)
                                    .newOffer["imagesFiles"][2] ==
                                null
                            ? const Icon(
                                Icons.image,
                                size: 70,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(ref
                                      .read(propertiesController)
                                      .newOffer["imagesFiles"][2]!
                                      .path),
                                  fit: BoxFit.cover,
                                ),
                              )),
                  ),
                ],
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
                          ? Text("Ajoutez Offre")
                          : CircularProgressIndicator(
                              color: Colors.white,
                            ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          try {
                            for (var i = 0;
                                i <
                                    ref
                                        .read(propertiesController)
                                        .newOffer["imagesFiles"]
                                        .length;
                                i++) {
                              if (ref
                                      .read(propertiesController)
                                      .newOffer["imagesFiles"][i] !=
                                  null) {
                                String profileImageID = Uuid().v4();
                                FirebaseStorage instance =
                                    ref.read(storageProvider).storage;
                                final profileImageRef = instance
                                    .ref()
                                    .child("propertyImages/" + profileImageID);
                                await profileImageRef.putFile(File(ref
                                    .read(propertiesController)
                                    .newOffer["imagesFiles"][i]!
                                    .path));
                                String profileImageURL =
                                    await profileImageRef.getDownloadURL();
                                print(profileImageURL);
                                ref
                                    .read(propertiesController)
                                    .newOffer["imagesUrl"][i] = profileImageURL;
                              }
                            }
                            print(ref.read(propertiesController).newOffer);
                            ref.read(propertiesController).newOffer["owner"] =
                                ref.read(authProvider).userData["id"];

                            ref.read(propertiesController).newOffer["images"] =
                                ref
                                    .read(propertiesController)
                                    .newOffer["imagesUrl"];
                            await ref.read(propertiesController).postOffer(
                                ref.read(propertiesController).newOffer);
                            setState(() {
                              loading = false;
                            });
                          } catch (e) {
                            setState(() {
                              loading = false;
                            });
                          }
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
