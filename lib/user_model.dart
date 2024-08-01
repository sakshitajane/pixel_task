class User {
  final int id;
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final String country;
  final String image;
  final String cardType;

// initialize all fields
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.country,
    required this.image,
    required this.cardType,
  });

  //consturcter- create a User instance from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      age: json['age'],
      gender: json['gender'],
      country: json['address']['country'],
      image: json['image'],
      cardType: json['bank']['cardType'],
    );
  }
}
