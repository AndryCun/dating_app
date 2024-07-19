import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io' as io;
import 'package:dating_app/models/post.dart';

class PostService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _postCollection =
      _database.collection('posting');
  static final CollectionReference _favoriteCollection =
      _database.collection('favorites');
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  static Future<void> addPost(Post post) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user is signed in");
    }

    Position position = await _getCurrentLocation();

    Map<String, dynamic> newPost = {
      'title': post.title,
      'description': post.description,
      'image_url': post.imageUrl,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
      'is_liked': post.isLiked,
      'uid': user.uid,
      'latitude': position.latitude,
      'longitude': position.longitude,
    };

    await _postCollection.add(newPost);
  }

  static Future<void> deletePost(String id) async {
    await _postCollection.doc(id).delete();
  }

  static Stream<List<Post>> getPostList() {
    return _postCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    });
  }

  static Future<void> updatePost(Post post) async {
    Map<String, dynamic> updatePost = post.toDocument();
    updatePost['updated_at'] = FieldValue.serverTimestamp();
    await _postCollection.doc(post.id).update(updatePost);
  }

  static Future<String?> uploadImage(XFile imageFile) async {
    try {
      String fileName = path.basename(imageFile.path);
      Reference ref = _storage.ref().child('image/$fileName');
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
      return null;
    }
  }

  static Stream<List<Post>> getFavoritePosts() {
    // Ganti 'favorites' dengan nama koleksi di Firestore tempat Anda menyimpan favorit post
    return _database
        .collection('favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Post.fromDocument(doc)).toList());
  }

  static Future<void> addToFavorites(Post post) async {
    // Menambahkan post ke koleksi favorit di Firestore
    await _database.collection('favorites').doc(post.id).set(post.toDocument());
  }

  static Future<void> removeFromFavorites(Post post) async {
    // Menghapus post dari koleksi favorit di Firestore
    await _database.collection('favorites').doc(post.id).delete();
  }
}
