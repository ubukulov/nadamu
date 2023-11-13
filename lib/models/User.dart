import 'package:flutter/material.dart';

class User {
  final int id;
  final String fullName;
  final String position;
  final String company;
  final String image;
  final int uuid;

  User({
    required this.id,
    required this.fullName,
    required this.position,
    required this.company,
    this.image = '/img/default-user-image.png',
    required this.uuid
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      position: json['position'],
      company: json['company'],
      image: json['image'],
      uuid: json['uuid'],
    );
  }
}