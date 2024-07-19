import 'package:dating_app/models/user.dart';
import 'package:dating_app/services/image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RegistrationService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _usersCollection =
      _database.collection('users');
  Future<void> registerUser({
    required String uid,
    required String fullName,
    required String address,
    required String phoneNumber,
    XFile? imageFile,
  }) async {
    try {
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await PostService.uploadImage(imageFile, 'foto_profile');
      }
      Map<String, dynamic> newUser = {
        'username': fullName,
        'phoneNumber': phoneNumber,
        'imageUrl': imageUrl,
      };
      await _usersCollection.doc(uid).set(newUser);
    } catch (e) {
      throw Exception('Gagal mendaftar: $e');
    }
  }

  static Future<void> updateUser(MyUser myUser) async {
    try {
      Map<String, dynamic> updatedUser = myUser.toDocument();
      await _usersCollection.doc(myUser.id).update(updatedUser);
    } catch (e) {
      throw Exception('Gagal memperbarui pengguna: $e');
    }
  }
}

class SignOutService {
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      var user = await getUser();
      print('Current user after sign out: $user');
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}

Future<String?> getUser() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  } else {
    return ('error');
  }
}
