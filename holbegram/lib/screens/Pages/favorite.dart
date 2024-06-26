import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:holbegram/models/post.dart';
import 'package:holbegram/utils/posts.dart';
import 'package:provider/provider.dart'; 
import 'package:holbegram/providers/user_provider.dart'

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final postStorage = PostStorage();

    // Function to save post to favorites
    void saveToFavorite(String postId) {
      // Implement your logic to save post to favorites
      // For example, add postId to user's saved list in Firestore
      userProvider.addSavedPost(postId); // Example method to add postId to saved list
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<Post> posts = snapshot.data!.docs.map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>)).toList();

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              Post post = posts[index];

              return GestureDetector(
                onTap: () {
                  // Handle tap on post item, navigate to details or other action
                },
                child: Card(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(post.postUrl, width: double.infinity, height: 200, fit: BoxFit.cover),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(post.username, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: Icon(Icons.bookmark),
                              onPressed: () {
                                saveToFavorite(post.postId); // Save post to favorites
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Post saved to favorites')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
