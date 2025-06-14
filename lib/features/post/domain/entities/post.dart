base class Post {
  final String id;
  final String userId;
  final String username;
  final String text;
  final String imageUrl;
  final DateTime timestamp;

  const Post({
    required this.id,
    required this.userId,
    required this.username,
    required this.text,
    required this.imageUrl,
    required this.timestamp,
  });
}
