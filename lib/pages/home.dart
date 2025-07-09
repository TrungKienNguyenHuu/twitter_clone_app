import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone_app/models/tweet.dart';
import 'package:twitter_clone_app/pages/create.dart';
import 'package:twitter_clone_app/pages/settings.dart';
import 'package:twitter_clone_app/providers/tweet_provider.dart';
import 'package:twitter_clone_app/providers/user_provider.dart';

class Home extends ConsumerWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey,
            height: 1.0,
          ),
        ),
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(currentUser.user.profilePictureUrl),
                                ),
                ),
            );
          }
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: ref.watch(feddProvider).when(
        data: (List<Tweet> tweets){
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              color: Colors.black,
            ),
            itemCount: tweets.length,
            itemBuilder: (context, count){
              return ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(tweets[count].profilePicture),
                ),
                title: Text(tweets[count].name, 
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(tweets[count].content, 
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              );
            }
          );
        },
        error: (error, stackTrace) => Center(
          child: Text("Error: $error"),
        ),

        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      
      drawer: Drawer(child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Image.network(currentUser.user.profilePictureUrl),
          ),
          ListTile(
            title: Text(
              currentUser.user.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          ListTile(
            title: Text("Settings"),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // Navigate to settings page
              Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (context) => Settings()
              ));
            },
          ),
          ListTile(
            title: Text("Sign Out"),
            onTap: () {
              FirebaseAuth.instance.signOut();
              ref.read(userProvider.notifier).logout();
            },
          ),
        ],
      )),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CreateTweet(),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

}