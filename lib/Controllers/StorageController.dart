import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

final storageProvider =
    StateProvider<StorageController>((ref) => StorageController());

class StorageController {
  FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
}
