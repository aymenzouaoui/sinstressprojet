class Car {
  final String id;
  final String userId;
  final String make;
  final String model;
  final int year;
  final String licensePlate;
  final List<String> photos;

  Car({
    required this.id,
    required this.userId,
    required this.make,
    required this.model,
    required this.year,
    required this.licensePlate,
    required this.photos,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      userId: json['userId'],
      make: json['make'],
      model: json['model'],
      year: json['year'],
      licensePlate: json['licensePlate'],
      photos: List<String>.from(json['photos']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'make': make,
      'model': model,
      'year': year,
      'licensePlate': licensePlate,
      'photos': photos,
    };
  }
}
