import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone_app/pages/settings.dart';
import 'package:twitter_clone_app/providers/user_provider.dart';

class Home extends ConsumerWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
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
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text(currentUser.user.email),
          Text(currentUser.user.name),
        ],
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
    );
  }

}