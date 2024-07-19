
import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String? id;
  final String username;
  final String phoneNumber;
  String? imageUrl;

  MyUser({
    this.id,
    required this.username,
    required this.phoneNumber,
    this.imageUrl
  });

  factory MyUser.fromDocument(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MyUser(
      id: doc.id,
      username: data['username'],
      phoneNumber: data['phoneNumber'],
      imageUrl: data['imageUrl']


    );
  }
  Map<String, dynamic> toDocument(){
    return{
      'username' : username,
      'phoneNumber' : phoneNumber,
      'imageUrl' : imageUrl,
    
    };
  }
}