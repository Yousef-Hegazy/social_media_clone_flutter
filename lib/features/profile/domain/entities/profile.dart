base class Profile {
  final String id;
  final String name;
  final String email;
  final String bio;
  final String? imageUrl;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    this.imageUrl,
  });
}
