// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  final String userId;
  final String profilePicture;
  final String name;
  final String content;
  final Timestamp timestamp;
  
  Tweet({
    required this.userId,
    required this.profilePicture,
    required this.name,
    required this.content,
    required this.timestamp,
  });

  Tweet copyWith({
    String? userId,
    String? profilePicture,
    String? name,
    String? content,
    Timestamp? timestamp,
  }) {
    return Tweet(
      userId: userId ?? this.userId,
      profilePicture: profilePicture ?? this.profilePicture,
      name: name ?? this.name,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'profilePicture': profilePicture,
      'name': name,
      'content': content,
      'timestamp': timestamp,
    };
  }

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      userId: map['userId'] as String,
      profilePicture: map['profilePicture'] as String,
      name: map['name'] as String,
      content: map['content'] as String,
      timestamp: map['timestamp'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Tweet.fromJson(String source) => Tweet.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Tweet(userId: $userId, profilePicture: $profilePicture, name: $name, content: $content, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant Tweet other) {
    if (identical(this, other)) return true;
  
    return 
      other.userId == userId &&
      other.profilePicture == profilePicture &&
      other.name == name &&
      other.content == content &&
      other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
      profilePicture.hashCode ^
      name.hashCode ^
      content.hashCode ^
      timestamp.hashCode;
  }
}
