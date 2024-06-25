import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String email;
  String username;
  String bio;
  String photoUrl;
  List<dynamic> followers;
  List<dynamic> following;
  List<dynamic> posts;
  List<dynamic> saved;
  String searchKey;

  User({
    required this.uid,
    required this.email,
    required this.username,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
    required this.posts,
    required this.saved,
    required this.searchKey,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>;
    return User(
      uid: snap.id,
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      bio: data['bio'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      followers: List<dynamic>.from(data['followers'] ?? []),
      following: List<dynamic>.from(data['following'] ?? []),
      posts: List<dynamic>.from(data['posts'] ?? []),
      saved: List<dynamic>.from(data['saved'] ?? []),
      searchKey: data['searchKey'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'bio': bio,
      'photoUrl': photoUrl,
      'followers': followers,
      'following': following,
      'posts': posts,
      'saved': saved,
      'searchKey': searchKey,
    };
  }
}
