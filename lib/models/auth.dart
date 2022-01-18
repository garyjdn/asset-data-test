import 'package:flutter/foundation.dart';

class Auth {
  String token;
  int? expire;

  Auth({
    required this.token,
    this.expire,
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    assert(json['token'] != null);
    return Auth(
      token: json['token'],
      expire: json['refresh_token'],
    );
  }

  factory Auth.fromMap(Map<String, dynamic> map) {
    assert(map['token'] != null);
    return Auth(
      token: map['token'],
      expire: map['expire'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "token": token,
      "expire": expire,
    };
  }
}
