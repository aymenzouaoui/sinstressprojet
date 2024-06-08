class Car {
  final String id;
  final String make;
  final String model;
  final int year;
  final String licensePlate;

  Car({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.licensePlate,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      make: json['make'],
      model: json['model'],
      year: json['year'],
      licensePlate: json['licensePlate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'year': year,
      'licensePlate': licensePlate,
    };
  }
}
