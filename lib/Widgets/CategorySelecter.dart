// ignore_for_file: prefer_const_constructors

import 'package:aqar_mobile/Controllers/PropertiesController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategorySelector extends ConsumerStatefulWidget {
  CategorySelector({Key? key}) : super(key: key);

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends ConsumerState<CategorySelector> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 70,
      width: size.width,
      padding: EdgeInsets.only(top: 15, right: 10, bottom: 15),
      child: Center(
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  ref.read(propertiesController).setSelectedCategoriesAll();
                });
              },
              child: Container(
                height: 20,
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ref.read(propertiesController).allCategoriesToggled
                      ? Theme.of(context).colorScheme.secondary
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
                  ref.read(propertiesController).toggleCategory(0);
                });
              },
              child: Container(
                height: 20,
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ref.read(propertiesController).selectedCategories[0] ==
                          true
                      ? Theme.of(context).colorScheme.secondary
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
                  ref.read(propertiesController).toggleCategory(1);
                });
              },
              child: Container(
                height: 20,
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ref.read(propertiesController).selectedCategories[1] ==
                          true
                      ? Theme.of(context).colorScheme.secondary
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
                  ref.read(propertiesController).toggleCategory(2);
                });
              },
              child: Container(
                height: 20,
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ref.read(propertiesController).selectedCategories[2] ==
                          true
                      ? Theme.of(context).colorScheme.secondary
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
                  ref.read(propertiesController).toggleCategory(3);
                });
              },
              child: Container(
                height: 20,
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ref.read(propertiesController).selectedCategories[3] ==
                          true
                      ? Theme.of(context).colorScheme.secondary
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
    );
  }
}
