import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:image_picker/image_picker.dart';

final imageProvider =
    StateProvider<ImageController>((ref) => ImageController());

class ImageController {
  late ImagePicker picker;
  XFile? currentProfilePicture;
  ImageController() {
    picker = ImagePicker();
  }
}
