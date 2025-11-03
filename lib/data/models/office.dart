// lib/data/models/office.dart
import 'package:equatable/equatable.dart';

class Office extends Equatable {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  const Office({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  // ADD THIS FACTORY
  factory Office.fromJson(Map<String, dynamic> json) {
    return Office(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  List<Object?> get props => [id, name, latitude, longitude];
}