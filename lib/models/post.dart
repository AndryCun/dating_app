import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? id;
  final String title;
  final String description;
  final String? imageUrl;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  bool isLiked;
  bool isFavorite;
  String? uid;
  double? latitude;
  double? longitude;

  Post({
    this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    this.isLiked = false,
    this.isFavorite = false,
    this.uid,
    this.latitude,
    this.longitude,
  });

  Post copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    bool? isLiked,
    bool? isFavorite,
    String? uid,
    double? latitude,
    double? longitude,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLiked: isLiked ?? this.isLiked,
      isFavorite: isFavorite ?? this.isFavorite,
      uid: uid ?? this.uid,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory Post.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return Post(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['image_url'] ?? '',
      createdAt: data['created_at'] as Timestamp?,
      updatedAt: data['updated_at'] as Timestamp?,
      isLiked: data['is_liked'] ?? false,
      isFavorite: data['is_favorite'] ?? false,
      uid: data['uid'] ?? '',
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_liked': isLiked,
      'is_favorite': isFavorite,
      'uid': uid,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
