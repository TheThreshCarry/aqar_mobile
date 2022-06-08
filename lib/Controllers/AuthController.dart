// ignore_for_file: file_names, avoid_print, non_constant_identifier_names, prefer_const_constructors

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final authProvider = StateProvider<AuthController>((ref) => AuthController());

class AuthController {
  SharedPreferences? prefs;
  bool isLoggedIn = false;
  bool isLoading = false;
  Position? userPosition;
  List<dynamic> usersConversations = [];

  Map<String, dynamic> userData = {
    "name": null,
    "image" : null,
    "email": null,
    "phone": null
  };

  void setUserData(dynamic data){
    userData["name"] = data["name"] ?? "";
    userData["image"] = data["imageurl"] ?? "";
    userData["phone"] = data["phone"] ?? "";
    userData["email"] = data["email"] ?? "";
    userData["id"] = data["id"] ?? "";
    userData["user_type"] = data["user_type"] ?? "";
  }

  Future<SharedPreferences?> setupPrefs() async {
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  String? verifyToken() {
    String? method = prefs?.getString("signInMethod");
    String? methodToken;
    switch (method) {
      case "Email":
        String? token = prefs?.getString("token");
        if (token != null) {
          methodToken = token;
        }
        break;
      case "Google":
        String? token = prefs?.getString("googleId");
        if (token != null) {
          methodToken = token;
        }
       
        break;
      default:
        break;
    }
    return methodToken;
  }

  Future<GoogleSignInAccount?> googleSignIn() async {
    var google = GoogleSignIn();
    isLoading = true;
    GoogleSignInAccount? data = await google.signIn().catchError((e){print(e)});
    GoogleSignInAuthentication authHeaders = await data!.authentication;
    var response = await Dio().post(
          'https://aqar-server.herokuapp.com/auth/loginGoogleUser',
          data: {"tokenId": authHeaders.idToken});
         
          await prefs
          ?.setString("token", response.toString())
          .then((value) => isLoading = false);
      if (response.statusCode == 200) {
        isLoggedIn = true;
        var userDataResponse = await Dio().get(
          'https://aqar-server.herokuapp.com/auth/getUserData',
          queryParameters: {"token": prefs?.get("token")});
        Map<String, dynamic> jsonMap = json.decode(userDataResponse.toString());
        setUserData(jsonMap);
      }
    return data;
  }
  Future<List<dynamic>> getMessagesOfConversation(String id)async {
    var results = await Dio().get("http://aqar-server.herokuapp.com/messages/messages/?id=$id");
    return results.data;
  }
  Future<bool> getUserData() async {
        var userDataResponse = await Dio().get(
          'https://aqar-server.herokuapp.com/auth/getUserData',
          queryParameters: {"token": prefs?.getString("token")});
        Map<String, dynamic> jsonMap = json.decode(userDataResponse.toString());
        setUserData(jsonMap);
        isLoggedIn = true;
        return true;
  }
  String getToken(){
    return prefs?.getString("token") ?? "";
  }
  Future<List<dynamic>> getConversations() async {
    if(userData["id"] == null){
      return [];
    }
    var results = await Dio().get('https://aqar-server.herokuapp.com/messages/conversations/?id=${userData["id"]}');
    usersConversations = results.data;
    return results.data;
  }
  Future<dynamic> Login(String email, String password) async {
    try {
      print("Logging In");
      isLoading = true;
      var response = await Dio().post(
          'https://aqar-server.herokuapp.com/auth/loginUser',
          data: {"email": email, "password": password});
      await prefs
          ?.setString("token", response.toString())
          .then((value) => isLoading = false);
      if (response.statusCode == 200) {
        isLoggedIn = true;
        var userDataResponse = await Dio().get(
          'https://aqar-server.herokuapp.com/auth/getUserData',
          queryParameters: {"token": prefs?.get("token")});
        Map<String, dynamic> jsonMap = json.decode(userDataResponse.toString());
        setUserData(jsonMap);
      }
      return response;
    } catch (e) {
   
      return e;
    }
  }
  Future<dynamic> registerUser(Map<dynamic,dynamic> form, FirebaseStorage instance) async {
      print("Registering User : " + form["name"]);
       isLoading = true;
      var uuid= Uuid();
      String profileImageID = uuid.v4();
      final profileImageRef = instance.ref().child("profileImages/"+profileImageID);
      await profileImageRef.putFile(File(form["profileImage"]));
      String profileImageURL = await profileImageRef.getDownloadURL();
      print(profileImageURL);
      var response = await Dio().post(
          'https://aqar-server.herokuapp.com/auth/registerUser',
          data: {'name': form['name'],
          'email': form['email'],
          'imageUrl': profileImageURL,
          'phone': form['phoneNumber'],
          'password': form["password"],
          'user_type': form['accountType'] == 0 ? 'a': 'c'});
          await prefs
          ?.setString("token", response.toString())
          .then((value) => isLoading = false);
      if (response.statusCode == 200) {
        isLoggedIn = true;
      }
      return response;
    
  }

  Future<dynamic> Logout() async {
    try {
      print("Logging Out");
      isLoading = true;
        String? token = this.prefs!.getString("token");
        prefs?.remove('signInMethod');
        prefs?.remove('token');
        var response = await Dio().post(
            'https://aqar-server.herokuapp.com/auth/logout',
            data: {"token": token});
        await prefs!.remove("token").then((value) => isLoading = false);
        return response;
      
    } catch (e) {
      return e;
    }
  }

  bool loggedIn() {
    isLoggedIn = false;
    String? token = prefs!.getString("token");
        if (token != null) {
          isLoggedIn = true;
        }
    return isLoggedIn;
  }

  Future<dynamic> TestLoggedData() async {
    try {
      String? token = this.prefs!.getString("token");
      var response = await Dio().get(
          'https://aqar-server.herokuapp.com/auth/getPrivateData',
          queryParameters: {"token": token});
      return response.data;
    } catch (e) {
      return e;
    }
  }
}
