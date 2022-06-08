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

class UpdateName extends ConsumerStatefulWidget {
  UpdateName({Key? key}) : super(key: key);

  @override
  _UpdateNameState createState() => _UpdateNameState();
}

class _UpdateNameState extends ConsumerState<UpdateName> {
  bool loading = false;
  String newName = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newName = ref.read(authProvider).userData["name"];
  }

  final formKey = GlobalKey<FormState>();
  bool showPassword = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text("Modification")),
            body: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Container(
                  width: size.width,
                  padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Modifiez Votre Nom",
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
                                      hintText: "Nom",
                                      hintStyle: TextStyle(
                                          color: const Color(0xFF282828)
                                              .withOpacity(0.3)),
                                      border: InputBorder.none,
                                    ),
                                    initialValue: newName,
                                    onChanged: (value) {
                                      newName = value;
                                    },
                                  ),
                                ),
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
                                      ? Text("Changez Nom")
                                      : CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                  onPressed: () async {
                                    if (newName ==
                                        ref
                                            .read(authProvider)
                                            .userData["name"]) {
                                      return;
                                    }
                                    if (formKey.currentState!.validate()) {
                                      setState(() {
                                        loading = true;
                                      });
                                      print({
                                        "token":
                                            ref.read(authProvider).getToken(),
                                        "name": newName,
                                        "id": ref
                                            .read(authProvider)
                                            .userData["id"]
                                      });
                                      var result = await Dio().post(
                                          "https://aqar-server.herokuapp.com/auth/updateUserName",
                                          data: {
                                            "token": ref
                                                .read(authProvider)
                                                .getToken(),
                                            "name": newName,
                                            "id": ref
                                                .read(authProvider)
                                                .userData["id"]
                                          });
                                      print(result.data);
                                      loading = false;
                                      Navigator.popAndPushNamed(context, "/");
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
