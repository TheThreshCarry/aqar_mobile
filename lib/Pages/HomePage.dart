// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, avoid_print

import 'package:aqar_mobile/Controllers/AuthController.dart';
import 'package:aqar_mobile/Controllers/FilerProvider.dart';
import 'package:aqar_mobile/Controllers/PropertiesController.dart';
import 'package:aqar_mobile/Widgets/CategorySelecter.dart';
import 'package:aqar_mobile/Widgets/PropertyCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Container(
        height: size.height,
        width: size.width,
        margin: EdgeInsets.only(bottom: 60),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                      height: 72,
                      width: size.width * 0.8 - 40,
                      child: ref.read(authProvider).isLoggedIn
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome Back,",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  ref.read(authProvider).userData["name"],
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            )
                          : SizedBox()),
                  Container(
                    height: 60,
                    width: size.width * 0.2,
                    child: Center(
                        child: IconButton(
                      icon: Icon(Icons.notifications_none_rounded),
                      iconSize: 32,
                      onPressed: () {
                        Navigator.pushNamed(context, "/test");
                      },
                    )),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Find Your Home !",
                style: TextStyle(fontSize: 20),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFFABABAB), width: 1)),
                child: Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Center(
                            child: Icon(
                          Icons.search,
                          size: 30,
                        ))),
                    Expanded(
                        flex: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "Constantine, Algeria",
                                border: InputBorder.none),
                          ),
                        )),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        child: Center(
                          child: IconButton(
                            icon: Icon(Icons.filter_list_rounded),
                            iconSize: 36,
                            onPressed: () {
                              ref
                                  .watch(filterProvider.notifier)
                                  .switchFilterOn();
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Categories",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              CategorySelector(),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text("Best For You",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "See All",
                      style: TextStyle(fontSize: 18, color: Color(0xFFABABAB)),
                    ),
                  ),
                ],
              ),
              Container(
                height: 330,
                child: FutureBuilder(
                  future: ref.read(propertiesController).loadAllProperties(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ShaderMask(
                        shaderCallback: (Rect rect) {
                          return LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: const [
                              Colors.black,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black
                            ],
                            stops: const [
                              0.0,
                              0.03,
                              0.97,
                              1.0
                            ], // 10% purple, 80% transparent, 10% purple
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.dstOut,
                        child: Container(
                          height: 330,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: ref
                                  .read(propertiesController)
                                  .allProperties
                                  .length,
                              itemBuilder: (BuildContext context, int index) {
                                return PropertyCard(
                                    property: ref
                                        .read(propertiesController)
                                        .allProperties[index]);
                              }),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text("Trending",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "See All",
                      style: TextStyle(fontSize: 18, color: Color(0xFFABABAB)),
                    ),
                  ),
                ],
              ),
              Container(
                height: 300,
                child: FutureBuilder(
                  future: ref.read(propertiesController).loadViewedProperties(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ShaderMask(
                        shaderCallback: (Rect rect) {
                          return LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: const [
                              Colors.black,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black
                            ],
                            stops: const [
                              0.0,
                              0.03,
                              0.97,
                              1.0
                            ], // 10% purple, 80% transparent, 10% purple
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.dstOut,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.all(8),
                            itemCount: ref
                                .read(propertiesController)
                                .mostViewedProperties
                                .length,
                            itemBuilder: (BuildContext context, int index) {
                              return PropertyCard(
                                  property: ref
                                      .read(propertiesController)
                                      .mostViewedProperties[index]);
                            }),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text("Most Recent",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "See All",
                      style: TextStyle(fontSize: 18, color: Color(0xFFABABAB)),
                    ),
                  ),
                ],
              ),
              Container(
                height: 330,
                child: FutureBuilder(
                  future: ref.read(propertiesController).loadRecentProperties(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ShaderMask(
                        shaderCallback: (Rect rect) {
                          return LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: const [
                              Colors.black,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black
                            ],
                            stops: const [
                              0.0,
                              0.03,
                              0.97,
                              1.0
                            ], // 10% purple, 80% transparent, 10% purple
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.dstOut,
                        child: Container(
                          height: 330,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: ref
                                  .read(propertiesController)
                                  .recentProperties
                                  .length,
                              itemBuilder: (BuildContext context, int index) {
                                return PropertyCard(
                                    property: ref
                                        .read(propertiesController)
                                        .recentProperties[index]);
                              }),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
