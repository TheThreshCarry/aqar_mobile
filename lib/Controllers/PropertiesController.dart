// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final propertiesController =
    StateProvider<PropertiesController>((ref) => PropertiesController());

class PropertiesController {
  List<Map<String, dynamic>> allProperties = [];
  List<Map<String, dynamic>> recentProperties = [];
  List<Map<String, dynamic>> mostViewedProperties = [];
  List<Map<String, dynamic>> filteredProperties = [];
  List<Map<String, dynamic>> favoriteProperties = [];
  List<Map<String, dynamic>> surroundingProperties = [];
  Map<String, dynamic>? selectedProperty;
  Map<String, dynamic>? selectedPropertyOwner;
  bool filterOn = false;

  Future<bool> loadAllProperties() async {
    allProperties.clear();

    var results = await Dio()
        .get('https://aqar-server.herokuapp.com/properties/getThumbnails');
    List<dynamic> data = results.data;

    for (var element in data) {
      if (checkForDuplicate(element, allProperties)) break;
      allProperties.add(element);
      // Map<String, dynamic> jsonMap = json.decode(userDataResponse.toString());
    }
    return true;
  }

  Future<bool> loadRecentProperties() async {
    recentProperties.clear();

    var results = await Dio()
        .get('https://aqar-server.herokuapp.com/properties/getLatest');
    List<dynamic> data = results.data;

    for (var element in data) {
      if (checkForDuplicate(element, recentProperties)) break;
      recentProperties.add(element);
      // Map<String, dynamic> jsonMap = json.decode(userDataResponse.toString());
    }
    return true;
  }

  Future<bool> loadViewedProperties() async {
    mostViewedProperties.clear();

    var results = await Dio()
        .get('https://aqar-server.herokuapp.com/properties/getMostViewed');
    List<dynamic> data = results.data;

    for (var element in data) {
      if (checkForDuplicate(element, mostViewedProperties)) break;
      mostViewedProperties.add(element);
      // Map<String, dynamic> jsonMap = json.decode(userDataResponse.toString());
    }
    return true;
  }

  Future<bool> loadSurroundingProperties(Position userPos) async {
    surroundingProperties.clear();

    var results = await Dio()
        .post('https://aqar-server.herokuapp.com/properties/filter', data: {
      "lat": userPos.latitude,
      "long": userPos.longitude,
      "distance_lower_than": 50
    });
    List<dynamic> data = results.data;
    for (var element in data) {
      surroundingProperties.add(element);
      // Map<String, dynamic> jsonMap = json.decode(userDataResponse.toString());
    }
    return true;
  }

  Future<bool> getPropertyById(String id, String? userId) async {
    bool isFavorited = false;
    var results =
        await Dio().get("https://aqar-server.herokuapp.com/properties/$id");
    if (userId != null) {
      var isFavoritedRequest = await Dio().get(
          "https://aqar-server.herokuapp.com/properties/favorites/$userId/$id");
      isFavorited = isFavoritedRequest.data;
    }
    dynamic data = results.data;
    print("results $results");
    if (data["images"] == null) {
      data["images"] = [
        "https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Grey_Square.svg/800px-Grey_Square.svg.png"
      ];
    }
    if (data != null) {
      selectedProperty = data;
      return isFavorited;
    }
    return isFavorited;
  }

  Future<bool> deleteFavorite(String propertyId, String userId) async {
    try {
      var result = await Dio().delete(
          "https://aqar-server.herokuapp.com/properties/favorites/${userId}/${propertyId}");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getOwnerData() async {
    try {
      var result = await Dio().get(
          "https://aqar-server.herokuapp.com/auth/data/${selectedProperty?["owner"]}");
      selectedPropertyOwner = result.data;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<dynamic> getFavorites(String userId) async {
    try {
      favoriteProperties.clear();
      var result = await Dio().get(
          "https://aqar-server.herokuapp.com/properties/favorites/$userId");
      for (var element in result.data) {
        if (checkForDuplicate(element, favoriteProperties)) break;

        var property = await Dio().get(
            "https://aqar-server.herokuapp.com/properties/${element["property_id"]}");
        favoriteProperties.add(property.data);
      }
      return result.data;
    } catch (e) {
      return e;
    }
  }

  Future<bool> addFavorite(
      String propertyId, String userId, String userToken) async {
    try {
      var result = await Dio().post(
          "https://aqar-server.herokuapp.com/properties/favorites",
          data: {"user": userId, "property": propertyId, "token": userToken});
      return true;
    } catch (e) {
      return false;
    }
  }

  bool checkForDuplicate(dynamic elem, List<dynamic> array) {
    for (var element in array) {
      if (element["id"] == elem["id"]) {
        return true;
      }
    }
    return false;
  }

  final List<String> CATEGORIES = ["Appartment", "Vila", "Office", "Studio"];
  List<bool> selectedCategories = [false, false, false, false];
  List<bool> selectedType = [false, false];
  int roomsSelected = -1;
  int bathRoomsSelected = -1;
  int areaSelected = -1;
  bool allCategoriesToggled = false;
  List<double> priceRange = [1000, 1500];

  void toggleCategory(int index) {
    selectedCategories[index] = !selectedCategories[index];
    if (selectedCategories.every((element) => element == true)) {
      allCategoriesToggled = true;
    } else {
      allCategoriesToggled = false;
    }
  }

  void setSelectedCategoriesAll() {
    if (allCategoriesToggled) {
      selectedCategories.asMap().forEach((index, value) {
        selectedCategories[index] = false;
      });
      allCategoriesToggled = false;
    } else {
      selectedCategories.asMap().forEach((index, value) {
        selectedCategories[index] = true;
      });
      allCategoriesToggled = true;
    }
  }

  Map<String, dynamic> getFilters() {
    return {
      "price_greater_than": priceRange[0],
      "price_lower_than": priceRange[1],
      "rooms": roomsSelected == -1 ? null : roomsSelected,
      "bathRooms": bathRoomsSelected == -1 ? null : bathRoomsSelected,
      "area": areaSelected == -1 ? null : areaSelected,
    };
  }
}
