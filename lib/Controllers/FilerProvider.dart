// ignore_for_file: file_names, prefer_const_constructors
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final filterProvider = StateNotifierProvider<FilterProvider, bool>((ref) {
  return FilterProvider();
});

class FilterProvider extends StateNotifier<bool> {
  FilterProvider() : super(false);

  void switchFilterOn() {
    state = !state;
  }

  void switchFilterTrue() {
    state = true;
  }

  void switchFilterFalse() {
    state = false;
  }
}
