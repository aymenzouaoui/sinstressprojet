import 'car.dart';

typedef void NotificationCallback(String message);

class Sinistre {
  final String id;
  final String userId;
  final String description;
  String status;
  final String location;
  final List<String> photos;
  final DateTime dateReported;
  final Car car;

  NotificationCallback? onStatusChange;

  Sinistre({
    required this.id,
    required this.userId,
    required this.description,
    required this.status,
    required this.location,
    required this.photos,
    required this.dateReported,
    required this.car,
    this.onStatusChange,
  });

  factory Sinistre.fromJson(Map<String, dynamic> json) {
    return Sinistre(
      id: json['id'],
      userId: json['userId'],
      description: json['description'],
      status: json['status'],
      location: json['location'],
      photos: List<String>.from(json['photos']),
      dateReported: DateTime.parse(json['dateReported']),
      car: Car.fromJson(json['car']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'description': description,
      'status': status,
      'location': location,
      'photos': photos,
      'dateReported': dateReported.toIso8601String(),
      'car': car.toJson(),
    };
  }

  void updateStatus(String newStatus) {
    if (status != newStatus) {
      status = newStatus;
      onStatusChange?.call('Status updated to $newStatus for sinistre ID: $id');
    }
  }
}
