import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final registerProvider =
    StateProvider<RegisterFormController>((ref) => RegisterFormController());

class RegisterFormController {
  late GlobalKey<FormState> formLastKey;
  late GlobalKey<FormState> formEmailKey;
  late GlobalKey<FormState> formPhoneKey;
  String? email;
  int? accountType;
  XFile? profileImage;
  String? country = "Algérie";
  DateTime? birthDay;
  String? password;
  String? passwordRewrite;
  String? firstName;
  String? lastName;
  int? phoneNumber;
  String? selectAccountTypeErrorText;
  String? selectImageErrorText;
  bool validatePassword() {
    if (password == null) {
      return false;
    } else {
      if (!(password!.length > 5) && password!.isNotEmpty) {
        return false;
      }
      return true;
    }
  }

  bool identicalPasswords() {
    if (password == passwordRewrite) return true;
    return false;
  }

  bool validateLastForm() {
    return formLastKey.currentState!.validate() &&
        profileImage != null &&
        birthDay != null;
  }

  bool validateEmailForm() {
    return formEmailKey.currentState!.validate();
  }

  bool validatePhoneForm() {
    if (accountType == null) {
      selectAccountTypeErrorText = "Please Select Account Type";
    }
    return formPhoneKey.currentState!.validate() && accountType != null;
  }

  Map toJson() => {
        'name': (firstName! + " " + lastName!),
        'email': email,
        'birthDay': birthDay?.toIso8601String(),
        'password': password,
        'profileImage': profileImage?.path,
        'accountType': accountType,
        'phoneNumber': phoneNumber,
      };
}
