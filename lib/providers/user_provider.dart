import 'package:cloud_firestore/cloud_firestore.dart';
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

  void logout() {
    state = LocalUser(
      id: "error", 
      user: FirebaseUser(email: "error", name: "error", profilePictureUrl: "error"),
    );
  }
}


