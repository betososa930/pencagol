class UserModel {
  final String id;
  final String name;
  final String email;
  final int points;
  final String avatar;
  final bool isAdmin;
  final List<String> groups;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.points,
    required this.avatar,
    this.isAdmin = false,
    this.groups = const [],
  });

  String get initials {
    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}
