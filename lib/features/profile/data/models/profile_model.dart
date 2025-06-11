// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:social_media_clean/features/profile/domain/entities/profile.dart';

class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String bio;
  final String? imageUrl;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    this.imageUrl,
  });

  Profile toEntity() {
    return Profile(
      id: id,
      name: name,
      email: email,
      bio: bio,
      imageUrl: imageUrl,
    );
  }

  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      id: profile.id,
      name: profile.name,
      email: profile.email,
      bio: profile.bio,
    );
  }

  ProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? bio,
    String? imageUrl,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'bio': bio,
      'imageUrl': imageUrl,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      bio: map['bio'] as String,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProfileModel(id: $id, name: $name, email: $email, bio: $bio, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(covariant ProfileModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.bio == bio &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        bio.hashCode ^
        imageUrl.hashCode;
  }
}
