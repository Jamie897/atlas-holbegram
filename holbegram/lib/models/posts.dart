import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String caption;
  String uid;
  String username;
  List<String> likes;
  String postId;
  DateTime datePublished;
  String postUrl;
  String profImage;

  Post({
    required this.caption,
    required this.uid,
    required this.username,
    required this.likes,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
  });

  // Factory method to create a Post instance from a JSON object
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      caption: json['caption'] ?? '',
      uid: json['uid'] ?? '',
      username: json['username'] ?? '',
      likes: List<String>.from(json['likes'] ?? []),
      postId: json['postId'] ?? '',
      datePublished: (json['datePublished'] as Timestamp).toDate(),
      postUrl: json['postUrl'] ?? '',
      profImage: json['profImage'] ?? '',
    );
  }

  // Method to convert a Post instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'caption': caption,
      'uid': uid,
      'username': username,
      'likes': likes,
      'postId': postId,
      'datePublished': Timestamp.fromDate(datePublished),
      'postUrl': postUrl,
      'profImage': profImage,
    };
  }
}
