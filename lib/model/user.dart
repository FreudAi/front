class User {
  final String name;
  final String bustFile;
  final String email;
  final String address;
  final String phoneNumber;

  User({
    required this.name,
    required this.bustFile,
    required this.email,
    required this.address,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      bustFile: json['bust_file'],
      email: json['email'],
      address: json['address'],
      phoneNumber: json['phone_number'],
    );
  }
}