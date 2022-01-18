import 'dart:convert';

import '../../../helpers/cache.dart';

class SharedPreferencesWrapper {
  final String key;

  SharedPreferencesWrapper({required this.key});

  Future createData({required dynamic data, Duration? expiry}) async {
    Map cache = {};
    if (data is String || data is int) {
      cache['data'] = data;
    } else if (data is List) {
      cache['data'] = data.map((item) {
        if (item is String || item is int) {
          return item;
        } else {
          return item.toMap();
        }
      }).toList();
    } else {
      cache['data'] = data.toMap();
    }
    if (expiry != null) {
      cache['expiryDate'] = DateTime.now().add(expiry).toIso8601String();
    }
    final String encodedCache = json.encode(cache);
    await Cache.setCache(key: key, data: encodedCache);
  }

  Future readData() async {
    final String encodedCache = await Cache.getCache(key: key);
    final cache = json.decode(encodedCache);
    if (cache.containsKey('expiryDate')) {
      final expiryDate = DateTime.parse(cache['expiryDate']);
      if (expiryDate.isBefore(DateTime.now())) {
        return null;
      }
    }
    return cache['data'];
  }

  Future<bool> hasCache() async {
    if (await Cache.containsKey(key: key)) {
      // final String encodedCache = await Cache.getCache(key: key);
      // final cache = json.decode(encodedCache);
      // if(cache.containsKey('expiryDate')) {
      //   final expiryDate = DateTime.parse(cache['expiryDate']);
      //   if(expiryDate.isBefore(DateTime.now())) {
      //     return false;
      //   } else {
      //     return true;
      //   }
      // } else {
      //   return true;
      // }
      return true;
    } else {
      return false;
    }
  }

  Future<void> removeData() async {
    await Cache.removeCache(key: key);
  }
}
