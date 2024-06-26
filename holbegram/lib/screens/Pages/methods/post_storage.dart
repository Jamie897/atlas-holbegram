import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:holbegram/screens/auth/methods/user_storage.dart';

class PostStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserStorage _userStorage = UserStorage();

  Future<String> uploadPost(String caption, String uid, String username, String profImage, Uint8List image) async {
    try {
      String imageUrl = await _userStorage.uploadImageToStorage(image); // Assuming this method exists in UserStorage
      await _firestore.collection('posts').add({
        'caption': caption,
        'uid': uid,
        'username': username,
        'profImage': profImage,
        'postUrl': imageUrl,
        'datePublished': DateTime.now(),
        'likes': [], // Assuming initial likes is empty list
      });
      return 'Ok';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print('Error deleting post: $e');
    }
  }
}
