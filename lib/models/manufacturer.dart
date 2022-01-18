import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:testapp/models/brand_model.dart';

class Manufacturer {
  final String guid;
  final String name;
  final String description;
  final int status;
  final List<BrandModel> models;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Manufacturer({
    required this.guid,
    required this.name,
    required this.description,
    required this.status,
    required this.models,
    this.createdAt,
    this.updatedAt,
  });

  Manufacturer copyWith({
    String? guid,
    String? name,
    String? description,
    int? status,
    List<BrandModel>? models,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Manufacturer(
      guid: guid ?? this.guid,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      models: models ?? this.models,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'guid': guid,
      'name': name,
      'description': description,
      'status': status,
      'models': models.map((x) => x.toMap()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Manufacturer.fromMap(Map<String, dynamic> map) {
    return Manufacturer(
      guid: map['guid'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      status: map['status']?.toInt() ?? 0,
      models: List<BrandModel>.from(
          map['models']?.map((x) => BrandModel.fromMap(x))),
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Manufacturer.fromJson(String source) =>
      Manufacturer.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Manufacturer(guid: $guid, name: $name, description: $description, status: $status, models: $models, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Manufacturer &&
        other.guid == guid &&
        other.name == name &&
        other.description == description &&
        other.status == status &&
        listEquals(other.models, models) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return guid.hashCode ^
        name.hashCode ^
        description.hashCode ^
        status.hashCode ^
        models.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
