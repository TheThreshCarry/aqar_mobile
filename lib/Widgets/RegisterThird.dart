import 'dart:io';

import 'package:aqar_mobile/Controllers/ImagePickerController.dart';
import 'package:aqar_mobile/Controllers/RegisterFormController.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../Controllers/AuthController.dart';

class RegisterThird extends ConsumerStatefulWidget {
  RegisterThird({Key? key}) : super(key: key);

  @override
  _RegisterThirdState createState() => _RegisterThirdState();
}

class _RegisterThirdState extends ConsumerState<RegisterThird> {
  final ImagePicker _picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  bool showPassword = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ref.read(registerProvider).formLastKey = formKey;
    return Form(
      key: ref.read(registerProvider).formLastKey,
      child: Container(
        height: size.height * 0.65,
        width: size.width,
        padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Finish Up",
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 20),
          Text(
            "Enter your information to finish signing up",
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
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
                            hintText: "First Name",
                            hintStyle: TextStyle(
                                color:
                                    const Color(0xFF282828).withOpacity(0.3)),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            ref.watch(registerProvider).firstName = value;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
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
                            hintText: "Last Name",
                            hintStyle: TextStyle(
                                color:
                                    const Color(0xFF282828).withOpacity(0.3)),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            ref.watch(registerProvider).lastName = value;
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(1900, 3, 5),
                        maxTime: DateTime.now(), onChanged: (date) {
                      print('change $date');
                      setState(() {
                        ref.read(registerProvider).birthDay = date;
                      });
                    }, onConfirm: (date) {
                      print('confirm $date');
                      setState(() {
                        ref.read(registerProvider).birthDay = date;
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.fr);
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFF4F4F4)),
                    child: Row(
                      children: [
                        Text(
                            ref.read(registerProvider).birthDay == null
                                ? "Birthday"
                                : ref
                                    .read(registerProvider)
                                    .birthDay!
                                    .toIso8601String()
                                    .substring(0, 10),
                            style: const TextStyle(
                              color: Color(0xFF282828),
                            )),
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
                Icon(
                  Icons.lock_outline,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    cursorColor: Theme.of(context).colorScheme.secondary,
                    obscureText: showPassword,
                    style: const TextStyle(color: Color(0xFF282828)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter some text";
                      }
                      if (ref.read(registerProvider).validatePassword()) {
                        return "passwords must be 5 characters long";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "***********",
                        hintStyle: TextStyle(
                            color: const Color(0xFF282828).withOpacity(0.3)),
                        border: InputBorder.none,
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.error,
                              width: 2.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(showPassword
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye),
                          color: Color(0xFF282828),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        )),
                    onChanged: (value) {
                      ref.read(registerProvider).password = value;
                    },
                  ),
                ),
              ],
            ),
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
                Icon(
                  Icons.lock_reset_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    cursorColor: Theme.of(context).colorScheme.secondary,
                    obscureText: showPassword,
                    style: const TextStyle(color: Color(0xFF282828)),
                    //autovalidateMode: AutovalidateMode.always,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter some text";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "***********",
                        hintStyle: TextStyle(
                            color: const Color(0xFF282828).withOpacity(0.3)),
                        border: InputBorder.none,
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.error,
                              width: 2.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(showPassword
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye),
                          color: Color(0xFF282828),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        )),
                    onChanged: (value) {
                      ref.read(registerProvider).passwordRewrite = value;
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () async {
              ref.read(registerProvider).profileImage =
                  await _picker.pickImage(source: ImageSource.gallery);
              setState(() {
                print("got image");
              });
            },
            child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)),
                child: ref.read(registerProvider).profileImage == null
                    ? const Icon(
                        Icons.image,
                        size: 70,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(ref.read(registerProvider).profileImage!.path),
                          fit: BoxFit.cover,
                        ),
                      )),
          )
        ]),
      ),
    );
  }
}
