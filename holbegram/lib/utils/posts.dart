import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:holbegram/models/posts.dart';
import 'package:holbegram/providers/user_provider.dart';
import 'package:holbegram/screens/pages/methods/post_storage.dart';
import 'package:provider/provider.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('datePublished', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!.docs;

        return SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(8),
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(25),
            ),
            child: ListView.separated(
              itemBuilder: (context, index) {
                final document = snapshot.data!.docs[index];
                final itemData = document.data() as Map<String, dynamic>;
                final Post post = Post.fromJson(itemData);
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(post.profImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(itemData['username'] ?? ''),
                          Spacer(),
                          IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () async {
                              await PostStorage().deletePost(document.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Post Deleted"),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        child: Text('caption'),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 350,
                        height: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                            image: NetworkImage(post.postUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.heart_broken_rounded),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.messenger_outline),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.send),
                              )
                            ],
                          ),
                          IconButton(
                            onPressed: () async {
                              String res = await PostStorage().addToFavorite(
                                idPost: post.uid,
                                idUser: userProvider.user!.uid,
                              );
                              userProvider.refreshUser();
                              if (res == "OK") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Added to Favorites"),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.save),
                          ),
                        ],
                      ),
                      if (post.likes.isEmpty)
                        const SizedBox()
                      else
                        Text("${post.likes.length} Liked"),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: snapshot.data!.docs.length,
            ),
          ),
        );
      },
    );
  }
}
