class RdvModel {
  String email;
  String name;
  String phone;
  String userId;
  DateTime dateTime;
  RdvModel({
    required this.email,
    required this.name,
    required this.phone,
    required this.userId,
    required this.dateTime,
  });
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'userId': userId,
      'date': dateTime,
    };
  }

  factory RdvModel.fromJson(Map<String, dynamic> json) {
    return RdvModel(
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      userId: json['userId'],
      dateTime: json['date'],
    );
  }
}
