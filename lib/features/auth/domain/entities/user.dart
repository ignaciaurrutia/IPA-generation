


class User {

  //final String id;
  final String email;
  //final String fullName;
  //final List<String> roles;
  final String token;
  final bool isAdmin;

  User({
    //required this.id,
    required this.email,
    //required this.fullName,
    //required this.roles,
    required this.token,
    required this.isAdmin
  });

  // bool get isAdmin {
  //   return roles.contains('admin');
  // }

}
