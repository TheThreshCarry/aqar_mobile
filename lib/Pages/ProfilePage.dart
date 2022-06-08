// ignore_for_file: prefer_const_constructors

import 'package:aqar_mobile/Controllers/AuthController.dart';
import 'package:aqar_mobile/Controllers/ThemeController.dart';
import 'package:aqar_mobile/Pages/NeedToSignUp.dart';
import 'package:aqar_mobile/Pages/UpdateName.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ref.read(authProvider).isLoggedIn
        ? Container(
            height: size.height,
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 300,
                  width: 300,
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Name is : " +
                            ref.read(authProvider).userData["name"]),
                        Text("Email is : " +
                            ref.read(authProvider).userData["email"]),
                        Text("Phone is : " +
                            ref.read(authProvider).userData["phone"]),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(900),
                          child: Image.network(
                            ref.read(authProvider).userData["image"],
                            height: 150,
                            width: 150,
                            fit: BoxFit.fill,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        )
                      ]),
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: 50,
                    width: 300,
                    child: TextButton(
                      child: Text("Changez De Nom"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateName()));
                      },
                    )),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: 50,
                    width: 300,
                    child: TextButton(
                      child: Text("Changez De Theme"),
                      onPressed: () async {
                        ref.read(themeProvider.notifier).switchTheme();
                      },
                    )),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: 50,
                    width: 300,
                    child: TextButton(
                      child: ref.read(authProvider).isLoading
                          ? CircularProgressIndicator()
                          : Text("Déconnexion"),
                      onPressed: () async {
                        setState(() {
                          ref.read(authProvider).isLoading = true;
                        });
                        await ref.read(authProvider).Logout();
                        setState(() {
                          ref.read(authProvider).isLoggedIn = false;
                          Navigator.popAndPushNamed(context, "/home");
                        });
                      },
                    )),
              ],
            ),
          )
        : NeedToSignUp();
  }
}
