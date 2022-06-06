// ignore_for_file: prefer_const_constructors_in_immutables, file_names, prefer_const_constructors

import 'package:aqar_mobile/Controllers/LocationHandeler.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AllowLocation extends StatefulWidget {
  AllowLocation({Key? key}) : super(key: key);

  @override
  State<AllowLocation> createState() => _AllowLocationState();
}

class _AllowLocationState extends State<AllowLocation> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: screenSize.height,
          width: screenSize.width,
          padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: Column(
            children: [
              Container(
                height: 100,
                width: 100,
                child:
                    Image.asset("assets/Materials/Logo/Logo-[Main colour].png"),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 220.75,
                width: double.infinity,
                child: Image.asset("assets/Materials/Images/mapLooking.png"),
              ),
              SizedBox(
                height: 40.0,
              ),
              Text(
                "Find best homes near you",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Please allow app access to location to fun best homes near you",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: double.infinity,
                  height: 70,
                  child: TextButton(
                      onPressed: () async {
                        Position pos = await determinePosition();
                        print(pos);
                        Navigator.popAndPushNamed(context, "/home");
                      },
                      child: Text("Yes, Allow"))),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: double.infinity,
                  height: 70,
                  child: TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, "/home");
                    },
                    child: Text("Skip"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Theme.of(context).colorScheme.surface),
                      foregroundColor: MaterialStateColor.resolveWith(
                          (states) => Theme.of(context).colorScheme.primary),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
