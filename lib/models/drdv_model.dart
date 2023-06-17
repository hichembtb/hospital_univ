class DrdvModel {
  String email;
  String name;
  String phone;
  String userId;
  DrdvModel({
    required this.email,
    required this.name,
    required this.phone,
    required this.userId,
  });
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'userId': userId,
    };
  }

  factory DrdvModel.fromJson(Map<String, dynamic> json) {
    return DrdvModel(
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      userId: json['userId'],
    );
  }
}
