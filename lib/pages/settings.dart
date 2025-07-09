import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone_app/providers/user_provider.dart';

class Settings extends ConsumerStatefulWidget{
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    LocalUser createUser = ref.watch(userProvider);
    _nameController.text = createUser.user.name;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => () async {
                final ImagePicker picker = ImagePicker();
                final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery, requestFullMetadata: false);

                if (pickedImage != null) {
                  ref
                  .read(userProvider.notifier)
                  .updateUserProfilePicture(File(pickedImage.path));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No image selected"))
                  );
                }
              },
              child:  CircleAvatar(
              radius: 100,
              foregroundImage: NetworkImage(createUser.user.profilePictureUrl),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text("Tap Image to change profile picture"),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Enter Your Name",
                border: OutlineInputBorder(),
              ),
            ),
            TextButton(
              onPressed: () => {ref.read(userProvider.notifier).updateUserName(_nameController.text)}, 
              child: const Text(
                "Update",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            )
          ]
        ),
      )
    );
  }
}