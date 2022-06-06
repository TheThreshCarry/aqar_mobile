// ignore_for_file: prefer_function_declarations_over_variables, await_only_futures, prefer_const_constructors, invalid_use_of_protected_member, sized_box_for_whitespace
import 'package:aqar_mobile/Controllers/MiscController.dart';
import 'package:aqar_mobile/Controllers/ThemeController.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Controllers/AuthController.dart';
import '../Controllers/RegisterFormController.dart';

class RegisterSecond extends ConsumerStatefulWidget {
  RegisterSecond({Key? key}) : super(key: key);

  @override
  _RegisterSecondState createState() => _RegisterSecondState();
}

class _RegisterSecondState extends ConsumerState<RegisterSecond> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ref.read(registerProvider).formPhoneKey = formKey;
    return Form(
      key: ref.read(registerProvider).formPhoneKey,
      child: Container(
        height: size.height * 0.65,
        width: size.width,
        padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "I Am ...",
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 20),
          Text(
            "Select what type of account you want",
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      ref.watch(registerProvider).accountType = 0;
                      ref.read(registerProvider).selectAccountTypeErrorText =
                          null;
                    });
                  },
                  child: Container(
                    width: 150,
                    height: 200,
                    child: Column(children: [
                      Container(
                        height: 140,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: ref.watch(registerProvider).accountType == 0
                                ? Border.all(
                                    color: Color(0xFF48C75C).withOpacity(0.69),
                                    width: 3)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                  color: ref
                                              .watch(registerProvider)
                                              .accountType ==
                                          0
                                      ? Color(0xFF48C75C)
                                      : Colors.black.withOpacity(ref
                                                  .read(themeProvider.notifier)
                                                  .state ==
                                              ThemeController.darkTheme
                                          ? 0.69
                                          : 0.10),
                                  blurRadius: 10)
                            ]),
                        child: Image.asset(
                          "assets/Materials/Images/agency.png",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Agency",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: ref.watch(registerProvider).accountType == 0
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.primary),
                      )
                    ]),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      ref.watch(registerProvider).accountType = 1;
                      ref.read(registerProvider).selectAccountTypeErrorText =
                          null;
                    });
                  },
                  child: Container(
                    width: 150,
                    height: 200,
                    child: Column(children: [
                      Container(
                        height: 140,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: ref.watch(registerProvider).accountType == 1
                                ? Border.all(
                                    color: Color(0xFF48C75C).withOpacity(0.69),
                                    width: 3)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                  color: ref
                                              .watch(registerProvider)
                                              .accountType ==
                                          1
                                      ? Color(0xFF48C75C)
                                      : Colors.black.withOpacity(ref
                                                  .read(themeProvider.notifier)
                                                  .state ==
                                              ThemeController.darkTheme
                                          ? 0.69
                                          : 0.10),
                                  blurRadius: 10)
                            ]),
                        child: Image.asset(
                          "assets/Materials/Images/looking_for_building.png",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Client",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: ref.watch(registerProvider).accountType == 1
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.primary),
                      )
                    ]),
                  ),
                )
              ],
            ),
          ),
          Text(
            ref.read(registerProvider).selectAccountTypeErrorText ?? "",
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200]),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    width: double.infinity,
                    child: Row(children: [
                      Container(
                        height: 50,
                        width: 50,
                        child: Image.asset(ref
                            .read(generalProvider)
                            .getCountryImage(
                                ref.read(registerProvider).country ??
                                    "Algérie")),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          child: DropdownButton<String>(
                            underline: SizedBox.shrink(),
                            isExpanded: true,
                            value: ref.read(registerProvider).country,
                            icon: Icon(Icons.keyboard_arrow_down_rounded,
                                size: 24, color: Color(0xFF282828)),
                            style: TextStyle(color: Color(0xFF282828)),
                            onChanged: (String? newValue) {
                              setState(() {
                                ref.read(registerProvider).country = newValue!;
                              });
                            },
                            dropdownColor: Color(0xFFFAFAFA),
                            items: ref
                                .read(generalProvider)
                                .getCountryNames()
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    ]),
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    child: Row(children: [
                      Container(
                          height: 50,
                          width: 50,
                          child: Center(
                              child: Text(
                                  ref.read(generalProvider).getCountryPhone(
                                      ref.read(registerProvider).country ??
                                          "Algérie"),
                                  style: TextStyle(color: Color(0xFF282828))))),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.only(right: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "this field is neccessary";
                                }
                                if (value.length != 10) {
                                  return "invalid number";
                                }
                                return null;
                              },
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              decoration: InputDecoration(
                                  border: InputBorder.none, counterText: ""),
                              cursorColor:
                                  Theme.of(context).colorScheme.secondary,
                              style: TextStyle(color: Color(0xFF282828)),
                              onChanged: (value) {
                                ref.read(registerProvider).phoneNumber =
                                    int.parse(value);
                              },
                            )),
                      )
                    ]),
                  ),
                ],
              ))
        ]),
      ),
    );
  }
}
