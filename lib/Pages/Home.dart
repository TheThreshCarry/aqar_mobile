// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'dart:developer';

import 'package:aqar_mobile/Controllers/FilerProvider.dart';
import 'package:aqar_mobile/Controllers/MiscController.dart';
import 'package:aqar_mobile/Controllers/PropertiesController.dart';
import 'package:aqar_mobile/Pages/FavoritePages.dart';
import 'package:aqar_mobile/Pages/HomePage.dart';
import 'package:aqar_mobile/Pages/MapPage.dart';
import 'package:aqar_mobile/Pages/MessagesPage.dart';
import 'package:aqar_mobile/Widgets/CategorySelecter.dart';
import 'package:aqar_mobile/Widgets/NavigationBar.dart';
import 'package:aqar_mobile/Pages/ProfilePage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_slider/flutter_multi_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';

class Home extends ConsumerStatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home>
    with SingleTickerProviderStateMixin {
  bool loading = false;
  @override
  void initState() {
    super.initState();
    ref.read(generalProvider).homePageController = TabController(
      length: 5,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool filterOn = ref.read(propertiesController).filterOn;
    MiniplayerController controller = MiniplayerController();
    ref.watch(filterProvider.notifier).addListener((state) {
      setState(() {
        filterOn = state;
      });
    });

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            child: Stack(children: [
              Container(
                  height: size.height,
                  width: size.width,
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      HomePage(),
                      FavoritePage(),
                      MapPage(),
                      MessagePage(),
                      ProfilePage()
                    ],
                    controller: ref.read(generalProvider).homePageController,
                  )),
              Positioned(bottom: 0, child: CustomNavigationBar()),
            ]),
          ),
          if (filterOn == true)
            Positioned(
              bottom: 0,
              width: size.width,
              child: Miniplayer(
                  minHeight: size.height * 0.75,
                  maxHeight: size.height * 0.75,
                  onDismissed: () {
                    print("dismissed");
                    ref.read(filterProvider.notifier).switchFilterFalse();
                  },
                  controller: controller,
                  builder: (height, perc) {
                    return ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              width: size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(children: [
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        ref
                                            .read(filterProvider.notifier)
                                            .switchFilterFalse();
                                      });
                                    },
                                    icon: Icon(Icons.close))
                              ]),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Price",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                    height: 100,
                                    width: size.width,
                                    child: Column(
                                      children: [
                                        Text(
                                            "Min: ${getPriceString(ref.read(propertiesController).priceRange[0])} Max: ${getPriceString(ref.read(propertiesController).priceRange[1])}"),
                                        MultiSlider(
                                            values: ref
                                                .read(propertiesController)
                                                .priceRange,
                                            max: 100000000000,
                                            min: 1000,
                                            onChanged: (values) => setState(
                                                  () {
                                                    ref
                                                        .read(
                                                            propertiesController)
                                                        .priceRange = values;
                                                  },
                                                )),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "Categories",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                    height: 70,
                                    width: size.width,
                                    padding: EdgeInsets.only(
                                        top: 15, right: 10, bottom: 15),
                                    child: Center(
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                    .read(propertiesController)
                                                    .setSelectedCategoriesAll();
                                              });
                                            },
                                            child: Container(
                                              height: 20,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ref
                                                        .read(
                                                            propertiesController)
                                                        .allCategoriesToggled
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Color(0xFFABABAB),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'All',
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                    .read(propertiesController)
                                                    .toggleCategory(0);
                                              });
                                            },
                                            child: Container(
                                              height: 20,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ref
                                                                .read(
                                                                    propertiesController)
                                                                .selectedCategories[
                                                            0] ==
                                                        true
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Color(0xFFABABAB),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Appartment',
                                                  //style: TextStyle(fontSize: 8),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                    .read(propertiesController)
                                                    .toggleCategory(1);
                                              });
                                            },
                                            child: Container(
                                              height: 20,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ref
                                                                .read(
                                                                    propertiesController)
                                                                .selectedCategories[
                                                            1] ==
                                                        true
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Color(0xFFABABAB),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Villa',
                                                  //style: TextStyle(fontSize: 8),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                    .read(propertiesController)
                                                    .toggleCategory(2);
                                              });
                                            },
                                            child: Container(
                                              height: 20,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ref
                                                                .read(
                                                                    propertiesController)
                                                                .selectedCategories[
                                                            2] ==
                                                        true
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Color(0xFFABABAB),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Office',
                                                  //style: TextStyle(fontSize: 8),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                    .read(propertiesController)
                                                    .toggleCategory(3);
                                              });
                                            },
                                            child: Container(
                                              height: 20,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ref
                                                                .read(
                                                                    propertiesController)
                                                                .selectedCategories[
                                                            3] ==
                                                        true
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Color(0xFFABABAB),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Studio',
                                                  //style: TextStyle(fontSize: 8),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Type",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                    height: 70,
                                    width: size.width,
                                    padding: EdgeInsets.only(
                                        top: 15, right: 10, bottom: 15),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                        .read(propertiesController)
                                                        .selectedType[0] =
                                                    !ref
                                                        .read(
                                                            propertiesController)
                                                        .selectedType[0];
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 150,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ref
                                                            .read(
                                                                propertiesController)
                                                            .selectedType[0] ==
                                                        true
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Color(0xFFABABAB),
                                              ),
                                              child: Center(
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
                                                        .selectedType[1] =
                                                    !ref
                                                        .read(
                                                            propertiesController)
                                                        .selectedType[1];
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 150,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ref
                                                            .read(
                                                                propertiesController)
                                                            .selectedType[1] ==
                                                        true
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Color(0xFFABABAB),
                                              ),
                                              child: Center(
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
                                  Text(
                                    "Rooms",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                    height: 70,
                                    width: size.width,
                                    padding: EdgeInsets.only(
                                        top: 15, right: 10, bottom: 15),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                            .read(
                                                                propertiesController)
                                                            .roomsSelected ==
                                                        -1
                                                    ? ref
                                                        .read(
                                                            propertiesController)
                                                        .roomsSelected = 0
                                                    : ref
                                                        .read(
                                                            propertiesController)
                                                        .roomsSelected = -1;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ref
                                                            .read(
                                                                propertiesController)
                                                            .roomsSelected ==
                                                        0
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Color(0xFFABABAB),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Any',
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                    .read(propertiesController)
                                                    .roomsSelected = 2;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ref
                                                                .read(
                                                                    propertiesController)
                                                                .roomsSelected ==
                                                            2 ||
                                                        ref
                                                                .read(
                                                                    propertiesController)
                                                                .roomsSelected ==
                                                            0
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Color(0xFFABABAB),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '2',
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                    .read(propertiesController)
                                                    .roomsSelected = 3;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ref
                                                                .read(
                                                                    propertiesController)
                                                                .roomsSelected ==
                                                            3 ||
                                                        ref
                                                                .read(
                                                                    propertiesController)
                                                                .roomsSelected ==
                                                            0
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Color(0xFFABABAB),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '3',
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                    .read(propertiesController)
                                                    .roomsSelected = 4;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ref
                                                                .read(
                                                                    propertiesController)
                                                                .roomsSelected ==
                                                            4 ||
                                                        ref
                                                                .read(
                                                                    propertiesController)
                                                                .roomsSelected ==
                                                            0
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Color(0xFFABABAB),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '4',
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                    .read(propertiesController)
                                                    .roomsSelected = 5;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ref
                                                                .read(
                                                                    propertiesController)
                                                                .roomsSelected ==
                                                            5 ||
                                                        ref
                                                                .read(
                                                                    propertiesController)
                                                                .roomsSelected ==
                                                            0
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Color(0xFFABABAB),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '4+',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Bathrooms",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                    height: 70,
                                    width: size.width,
                                    padding: EdgeInsets.only(
                                        top: 15, right: 10, bottom: 15),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                            .read(
                                                                propertiesController)
                                                            .bathRoomsSelected ==
                                                        -1
                                                    ? ref
                                                        .read(
                                                            propertiesController)
                                                        .bathRoomsSelected = 0
                                                    : ref
                                                        .read(
                                                            propertiesController)
                                                        .bathRoomsSelected = -1;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ref
                                                            .read(
                                                                propertiesController)
                                                            .bathRoomsSelected ==
                                                        0
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Color(0xFFABABAB),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Any',
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                    .read(propertiesController)
                                                    .bathRoomsSelected = 2;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ref
                                                                .read(
                                                                    propertiesController)
                                                                .bathRoomsSelected ==
                                                            2 ||
                                                        ref
                                                                .read(
                                                                    propertiesController)
                                                                .bathRoomsSelected ==
                                                            0
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Color(0xFFABABAB),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '2',
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                    .read(propertiesController)
                                                    .bathRoomsSelected = 3;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ref
                                                                .read(
                                                                    propertiesController)
                                                                .bathRoomsSelected ==
                                                            3 ||
                                                        ref
                                                                .read(
                                                                    propertiesController)
                                                                .bathRoomsSelected ==
                                                            0
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Color(0xFFABABAB),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '3',
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                    .read(propertiesController)
                                                    .bathRoomsSelected = 4;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ref
                                                                .read(
                                                                    propertiesController)
                                                                .bathRoomsSelected ==
                                                            4 ||
                                                        ref
                                                                .read(
                                                                    propertiesController)
                                                                .bathRoomsSelected ==
                                                            0
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Color(0xFFABABAB),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '4',
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                    .read(propertiesController)
                                                    .bathRoomsSelected = 5;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ref
                                                                .read(
                                                                    propertiesController)
                                                                .bathRoomsSelected ==
                                                            5 ||
                                                        ref
                                                                .read(
                                                                    propertiesController)
                                                                .bathRoomsSelected ==
                                                            0
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Color(0xFFABABAB),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '4+',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Area",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                    height: 70,
                                    width: size.width,
                                    padding: EdgeInsets.only(
                                        top: 15, right: 10, bottom: 15),
                                    child: Center(
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                            .read(
                                                                propertiesController)
                                                            .areaSelected ==
                                                        -1
                                                    ? ref
                                                        .read(
                                                            propertiesController)
                                                        .areaSelected = 0
                                                    : ref
                                                        .read(
                                                            propertiesController)
                                                        .areaSelected = -1;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ref
                                                            .read(
                                                                propertiesController)
                                                            .areaSelected ==
                                                        0
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Color(0xFFABABAB),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Any',
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                    .read(propertiesController)
                                                    .areaSelected = 200;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ref
                                                                .read(
                                                                    propertiesController)
                                                                .areaSelected ==
                                                            200 ||
                                                        ref
                                                                .read(
                                                                    propertiesController)
                                                                .areaSelected ==
                                                            0
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Color(0xFFABABAB),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '200',
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                    .read(propertiesController)
                                                    .areaSelected = 300;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ref
                                                                .read(
                                                                    propertiesController)
                                                                .areaSelected ==
                                                            300 ||
                                                        ref
                                                                .read(
                                                                    propertiesController)
                                                                .areaSelected ==
                                                            0
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Color(0xFFABABAB),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '300',
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                    .read(propertiesController)
                                                    .areaSelected = 400;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ref
                                                                .read(
                                                                    propertiesController)
                                                                .areaSelected ==
                                                            400 ||
                                                        ref
                                                                .read(
                                                                    propertiesController)
                                                                .areaSelected ==
                                                            0
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Color(0xFFABABAB),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '400',
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                    .read(propertiesController)
                                                    .areaSelected = 500;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ref
                                                                .read(
                                                                    propertiesController)
                                                                .areaSelected ==
                                                            500 ||
                                                        ref
                                                                .read(
                                                                    propertiesController)
                                                                .areaSelected ==
                                                            0
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Color(0xFFABABAB),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '400+',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 80,
                              width: size.width,
                              margin: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: TextButton(
                                      onPressed: () async {
                                        log(ref
                                            .read(propertiesController)
                                            .getFilters()
                                            .toString());
                                        if (!loading) {
                                          setState(() {
                                            loading = true;
                                          });
                                          var result = await Dio().post(
                                              "https://aqar-server.herokuapp.com/properties/filter",
                                              data: ref
                                                  .read(propertiesController)
                                                  .getFilters());
                                          setState(() {
                                            loading = false;
                                          });
                                        } else {
                                          print("it's loading");
                                        }
                                      },
                                      child: loading == false
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              child:
                                                  Text("Appliquez les filtres"))
                                          : CircularProgressIndicator()),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            )
          else
            SizedBox()
        ],
      ),
    );
  }
}
