// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:social_media_clean/features/auth/domain/entities/user.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String token;
  final String? bio;
  final String? imageUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
    this.bio,
    this.imageUrl,
  });

  User toEntity() => User(
        id: id,
        email: email,
        name: name,
        token: token,
        bio: bio,
        imageUrl: imageUrl,
      );

  factory UserModel.fromEntity(User user) => UserModel(
        id: user.id,
        email: user.email,
        name: user.name,
        token: user.token,
        bio: user.bio,
        imageUrl: user.imageUrl,
      );

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? token,
    String? bio,
    String? imageUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
      bio: bio ?? this.bio,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'token': token,
      'bio': bio,
      'imageUrl': imageUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      token: map['token'] as String,
      bio: map['bio'] != null ? map['bio'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, token: $token, bio: $bio, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.name == name &&
        other.token == token &&
        other.bio == bio &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        token.hashCode ^
        bio.hashCode ^
        imageUrl.hashCode;
  }
}
