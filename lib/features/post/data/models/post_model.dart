// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:social_media_clean/features/post/domain/entities/post.dart';

class PostModel {
  final String id;
  final String userId;
  final String username;
  final String text;
  final String imageUrl;
  final String? userProfileImageUrl;
  final DateTime timestamp;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.text,
    required this.imageUrl,
    this.userProfileImageUrl,
    required this.timestamp,
  });

  /// Converts this model to a [Post] entity.
  Post toEntity() {
    return Post(
      id: id,
      userId: userId,
      username: username,
      text: text,
      imageUrl: imageUrl,
      userProfileImageUrl: userProfileImageUrl,
      timestamp: timestamp,
    );
  }

  /// Factory constructor to create a [PostModel] from a [Post] entity.
  factory PostModel.fromEntity(Post post) {
    return PostModel(
      id: post.id,
      userId: post.userId,
      username: post.username,
      text: post.text,
      imageUrl: post.imageUrl,
      userProfileImageUrl: post.userProfileImageUrl,
      timestamp: post.timestamp,
    );
  }

  PostModel copyWith({
    String? id,
    String? userId,
    String? username,
    String? text,
    String? imageUrl,
    String? userProfileImageUrl,
    DateTime? timestamp,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      userProfileImageUrl: userProfileImageUrl ?? this.userProfileImageUrl,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'username': username,
      'text': text,
      'imageUrl': imageUrl,
      'userProfileImageUrl': userProfileImageUrl,
      'timestamp': timestamp,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      username: map['username'] as String,
      text: map['text'] as String,
      imageUrl: map['imageUrl'] as String,
      userProfileImageUrl: map['userProfileImageUrl'] != null
          ? map['userProfileImageUrl'] as String
          : null,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostModel(id: $id, userId: $userId, username: $username, text: $text, imageUrl: $imageUrl, userProfileImageUrl: $userProfileImageUrl, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant PostModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.username == username &&
        other.text == text &&
        other.imageUrl == imageUrl &&
        other.userProfileImageUrl == userProfileImageUrl &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        username.hashCode ^
        text.hashCode ^
        imageUrl.hashCode ^
        userProfileImageUrl.hashCode ^
        timestamp.hashCode;
  }
}
