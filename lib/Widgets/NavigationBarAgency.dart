// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_constructors_in_immutables

import 'package:aqar_mobile/Controllers/MiscController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomNavigationBarAgency extends ConsumerStatefulWidget {
  CustomNavigationBarAgency({Key? key}) : super(key: key);

  @override
  _CustomNavigationBarAgencyState createState() =>
      _CustomNavigationBarAgencyState();
}

class _CustomNavigationBarAgencyState
    extends ConsumerState<CustomNavigationBarAgency> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 200,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                  color: Color(0xFF181818),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              height: 100,
              width: size.width,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: ref
                                      .read(generalProvider)
                                      .homePageController
                                      ?.index ==
                                  0
                              ? Border(
                                  top:
                                      BorderSide(color: Colors.green, width: 3))
                              : Border()),
                      height: 100,
                      child: IconButton(
                        iconSize: 40,
                        icon: Icon(Icons.home),
                        color: ref
                                    .read(generalProvider)
                                    .homePageController
                                    ?.index ==
                                0
                            ? Color(0xFFFFFFFF)
                            : Color(0xFFC7C7C7),
                        onPressed: () {
                          setState(() {
                            ref
                                .read(generalProvider)
                                .homePageController
                                ?.animateTo(0);
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: ref
                                      .read(generalProvider)
                                      .homePageController
                                      ?.index ==
                                  1
                              ? Border(
                                  top:
                                      BorderSide(color: Colors.green, width: 3))
                              : Border()),
                      height: 100,
                      child: IconButton(
                        iconSize: 40,
                        icon: Icon(Icons.edit),
                        color: ref
                                    .read(generalProvider)
                                    .homePageController
                                    ?.index ==
                                1
                            ? Color(0xFFFFFFFF)
                            : Color(0xFFC7C7C7),
                        onPressed: () {
                          setState(() {
                            ref
                                .read(generalProvider)
                                .homePageController
                                ?.animateTo(1);
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 100,
                      margin: EdgeInsets.symmetric(horizontal: 60.0),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: ref
                                      .read(generalProvider)
                                      .homePageController
                                      ?.index ==
                                  3
                              ? Border(
                                  top:
                                      BorderSide(color: Colors.green, width: 3))
                              : Border()),
                      height: 100,
                      child: IconButton(
                        iconSize: 40,
                        icon: Icon(Icons.message_outlined),
                        color: ref
                                    .read(generalProvider)
                                    .homePageController
                                    ?.index ==
                                3
                            ? Color(0xFFFFFFFF)
                            : Color(0xFFC7C7C7),
                        onPressed: () {
                          setState(() {
                            ref
                                .read(generalProvider)
                                .homePageController
                                ?.animateTo(3);
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: ref
                                      .read(generalProvider)
                                      .homePageController
                                      ?.index ==
                                  4
                              ? Border(
                                  top:
                                      BorderSide(color: Colors.green, width: 3))
                              : Border()),
                      height: 100,
                      child: IconButton(
                        iconSize: 40,
                        icon: Icon(Icons.person),
                        color: ref
                                    .read(generalProvider)
                                    .homePageController
                                    ?.index ==
                                4
                            ? Color(0xFFFFFFFF)
                            : Color(0xFFC7C7C7),
                        onPressed: () {
                          setState(() {
                            ref
                                .read(generalProvider)
                                .homePageController
                                ?.animateTo(4);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            child: Container(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(900),
                        border: ref
                                    .read(generalProvider)
                                    .homePageController
                                    ?.index ==
                                2
                            ? Border.all(color: Colors.white, width: 4)
                            : Border(),
                        color: Colors.green),
                    height: 80,
                    width: 80,
                    child: Center(
                      child: IconButton(
                        iconSize: 40,
                        icon: Icon(Icons.crop_square),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            ref
                                .read(generalProvider)
                                .homePageController
                                ?.animateTo(2);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
