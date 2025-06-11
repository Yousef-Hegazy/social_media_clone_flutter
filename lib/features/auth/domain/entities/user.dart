base class User {
  final String id;
  final String email;
  final String name;
  final String token;
  final String? bio;
  final String? imageUrl;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
    this.bio,
    this.imageUrl,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? token,
    String? bio,
    String? imageUrl,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
      bio: bio ?? this.bio,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
