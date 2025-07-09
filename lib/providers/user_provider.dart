import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod/riverpod.dart';
import 'package:twitter_clone_app/models/user.dart';

final userProvider = StateNotifierProvider<UserNotifier, LocalUser>((ref) {
  return UserNotifier();
});


class LocalUser{
  const LocalUser({
    required this.id,
    required this.user,
  }); 

  final String id;
  final FirebaseUser user;

  LocalUser copyWith({
    String? id,
    FirebaseUser? user,
  }) {
    return LocalUser(
      id: id ?? this.id,
      user: user ?? this.user,
    );
  }
}

class UserNotifier extends StateNotifier<LocalUser> {
  UserNotifier(): super(LocalUser(id: "error", user: FirebaseUser(email: "error", name: "error", profilePictureUrl: "error")));

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseStorage _fireStorage = FirebaseStorage.instance;

  Future<void> login(String email) async {
    QuerySnapshot response = await _fireStore.collection('users')
    .where('email', isEqualTo: email).get();

    state = LocalUser(id: response.docs[0].id, user: FirebaseUser.fromMap(response.docs[0].data() as Map<String, dynamic>));
  }

  Future<void> signUp(String email) async {
    DocumentReference  response = await _fireStore.collection('users').add(
      FirebaseUser(
        email: email, 
        name: 'No Name', 
        profilePictureUrl: 'https://gravatar.com/avatar/?d=mp'
      ).toMap(),
    );
  DocumentSnapshot snapshot = await response.get();
    state = LocalUser(id: response.id, user: FirebaseUser.fromMap(snapshot.data() as Map<String, dynamic>));
  }

  Future<void> updateUserName(String name) async{
    await _fireStore.collection("users").doc(state.id).update({
      "name": name,
    });
    state = state.copyWith(user: state.user.copyWith(name: name));
  }

  Future<void> updateUserProfilePicture(File image) async{
    Reference ref = _fireStorage.ref().child("users").child(state.id);
    TaskSnapshot snapshot = await ref.putFile(image);
    String imageUrl = await snapshot.ref.getDownloadURL();
    ref.putFile(image);
    await _fireStore.collection("users").doc(state.id).update({
      "profilePictureUrl": imageUrl,
    });
    state = state.copyWith(user: state.user.copyWith(profilePictureUrl: imageUrl));
  }

  void logout() {
    state = LocalUser(
      id: "error", 
      user: FirebaseUser(email: "error", name: "error", profilePictureUrl: "error"),
    );
  }
}


