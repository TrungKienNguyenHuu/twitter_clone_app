// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FirebaseUser {
  final String email;
  final String name;
  final String profilePictureUrl;

  const FirebaseUser({
    required this.email,
    required this.name,
    required this.profilePictureUrl,
  });
  

  FirebaseUser copyWith({
    String? email,
    String? name,
    String? profilePictureUrl,
  }) {
    return FirebaseUser(
      email: email ?? this.email, 
      name: name ?? this.name, 
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  factory FirebaseUser.fromMap(Map<String, dynamic> map) {
    return FirebaseUser(
      email: map['email'] as String, 
      name: map['name'] as String? ?? 'No Name', 
      profilePictureUrl: map['profilePictureUrl'] as String? ?? 'https://gravatar.com/avatar/?d=mp',
    );
  }

  String toJson() => json.encode(toMap());

  factory FirebaseUser.fromJson(String source) => FirebaseUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'FirebaseUser(email: $email)';

  @override
  bool operator ==(covariant FirebaseUser other) {
    if (identical(this, other)) return true;
  
    return 
      other.email == email;
  }

  @override
  int get hashCode => email.hashCode;
}

