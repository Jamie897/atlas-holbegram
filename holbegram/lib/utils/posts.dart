

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:holbegram/models/posts.dart';
import 'package:holbegram/providers/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../screens/pages/methods/post_storage.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
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
            margin: EdgeInsets.all(8),
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(25),
            ),
            child: ListView.separated(
                itemBuilder: ((context, index) {
                  final document = snapshot.data!.docs[index];
                  final itemData = document.data() as Map<String, dynamic>;
                  final Post post = Post.fromJson(itemData);
                  return Container(
                    padding: EdgeInsets.all(8.0),
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
                            SizedBox(
                              width: 10,
                            ),
                            Text(itemData['username']),
                            Spacer(),
                            IconButton(
                              icon: const Icon(Icons.more_horiz),
                              onPressed: () async {
                                await PostStorage().deletePost(post.postUrl);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Post Deleted"),
                                ));
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          child: Text(itemData['caption']),
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                                  icon: Icon(Icons.heart_broken_rounded),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.messenger_outline),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.send),
                                )
                              ],
                            ),
                            IconButton(
                              onPressed: () async {
                                String res = await PostStorage().addToFavorite(
                                    idPost: post.uid,
                                    idUser: userProvider.user!.uid);
                                userProvider.refreshUser();
                                if (res == "OK") {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(res),
                                  ));
                                }
                              },
                              icon: Icon(Icons.save),
                            ),
                          ],
                        ),
                        if (post.likes.length == 0)
                          SizedBox()
                        else
                          Text("${post.likes.length} Liked")
                      ],
                    ),
                  );
                }),
                separatorBuilder: ((context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                }),
                itemCount: data.length),
            // child: Column(
            //   children: data.map((post) {
            //     final postCaption = post['caption'];
            //     final postUrl = post['postUrl'];
            //     final profImage = post['profImage'];
            //     final username = post['username'];
            //     final postId = post['postId'];

            //     return Container(
            //       padding: EdgeInsets.all(8.0),
            //       child: Column(
            //         children: [
            //           Row(
            //             children: [
            //               Container(
            //                 width: 40,
            //                 height: 40,
            //                 decoration: BoxDecoration(
            //                   shape: BoxShape.circle,
            //                   image: DecorationImage(
            //                     image: NetworkImage(profImage),
            //                     fit: BoxFit.cover,
            //                   ),
            //                 ),
            //               ),
            //               SizedBox(
            //                 width: 10,
            //               ),
            //               Text(username),
            //               Spacer(),
            //               IconButton(
            //                 icon: const Icon(Icons.more_horiz),
            //                 onPressed: () async {
            //                   await PostStorage().deletePost(postId);
            //                   ScaffoldMessenger.of(context)
            //                       .showSnackBar(SnackBar(
            //                     content: Text("Post Deleted"),
            //                   ));
            //                 },
            //               ),
            //             ],
            //           ),
            //           SizedBox(
            //             child: Text(postCaption),
            //           ),
            //           SizedBox(
            //             height: 10,
            //           ),
            //           Container(
            //             width: 350,
            //             height: 350,
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(25),
            //               image: DecorationImage(
            //                 image: NetworkImage(postUrl),
            //                 fit: BoxFit.cover,
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     );
            //   }).toList(),
            // ),
          ),
        );
      },
    );
  }
}