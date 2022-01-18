import 'dart:convert';

import 'package:testapp/models/manufacturer.dart';

class BrandModel {
  final String guid;
  final String? manufacturerGuid;
  final Manufacturer? manufacturer;
  final String name;
  final DateTime? createdAt;

  BrandModel({
    required this.guid,
    this.manufacturerGuid,
    this.manufacturer,
    required this.name,
    this.createdAt,
  });

  BrandModel copyWith({
    String? guid,
    String? manufacturerGuid,
    Manufacturer? manufacturer,
    String? name,
    DateTime? createdAt,
  }) {
    return BrandModel(
      guid: guid ?? this.guid,
      manufacturerGuid: manufacturerGuid ?? this.manufacturerGuid,
      manufacturer: manufacturer ?? this.manufacturer,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'guid': guid,
      'manufacturer_guid': manufacturerGuid,
      'manufacturer': manufacturer?.toMap(),
      'name': name,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory BrandModel.fromMap(Map<String, dynamic> map) {
    return BrandModel(
      guid: map['guid'] ?? '',
      manufacturerGuid: map['manufacturer_guid'],
      manufacturer: map['manufacturer'] != null
          ? Manufacturer.fromMap(map['manufacturer'])
          : null,
      name: map['name'] ?? '',
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BrandModel.fromJson(String source) =>
      BrandModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BrandModel(guid: $guid, manufacturerGuid: $manufacturerGuid, manufacturer: $manufacturer, name: $name, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BrandModel &&
        other.guid == guid &&
        other.manufacturerGuid == manufacturerGuid &&
        other.manufacturer == manufacturer &&
        other.name == name &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return guid.hashCode ^
        manufacturerGuid.hashCode ^
        manufacturer.hashCode ^
        name.hashCode ^
        createdAt.hashCode;
  }
}
