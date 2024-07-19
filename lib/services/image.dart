import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class PostService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String?> uploadImage(XFile imageFile, String childName) async {
    try {
      String fileName = path.basename(imageFile.path);
      Reference ref = _storage.ref().child('image/$childName/$fileName');
      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = ref.putData(await imageFile.readAsBytes());
      } else {
        uploadTask = ref.putFile(io.File(imageFile.path));
      }
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  static Future<XFile?> getImageFromDevice() async {
    try {
      final picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      return image;
    } catch (e) {
      print('Error getting image from device: $e');
      return null;
    }
  }

  static getPostList() {}
}

 