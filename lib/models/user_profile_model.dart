class UserProfileModel {
  final String name;
  final String email;
  final String designation;
  final String city;

  UserProfileModel({
    required this.name,
    required this.email,
    required this.designation,
    required this.city,
  });

  // Method to convert the UserProfileModel to JSON for storing in SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'designation': designation,
      'city': city,
    };
  }

  // Method to create a UserProfileModel object from JSON
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name'],
      email: json['email'],
      designation: json['designation'],
      city: json['city'],
    );
  }
}
