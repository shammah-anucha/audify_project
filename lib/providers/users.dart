import 'dart:ffi';

import 'package:audio_book_app/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class Users with ChangeNotifier {
  final List<User> _users = [];

  List<User> get items {
    return [..._users];
  }

  User findById(Int? id) {
    return _users.firstWhere((user) => user.userId == id);
  }

  Future<void> updateUser(Int id, User newUser) async {
    final userIndex = _users.indexWhere((user) => user.userId == id);
    if (userIndex != -1) {
      final userId = _users[userIndex].userId;
      final url = Uri.parse('http://10.0.2.2:8000/api/v1/users/$userId');
      try {
        await http.put(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({
            'firstname': newUser.firstName,
            'lastname': newUser.lastName,
            'email': newUser.email,
            'dob': newUser.country,
            'phone': newUser.password,
          }),
        );
        _users[userIndex] = newUser;
        notifyListeners();
      } catch (error) {
        throw Exception('Failed to update user.');
      }
    } else {
      throw Exception('User not found');
    }
  }

  Future<void> deleteUser(Int id) async {
    final userIndex = _users.indexWhere((user) => user.userId == id);
    if (userIndex != -1) {
      final userId = _users[userIndex].userId;
      var existingUser = _users[userIndex];
      final url = Uri.parse('http://10.0.2.2:8000/api/v1/users/$userId');
      _users.removeAt(userIndex);
      notifyListeners();
      try {
        final response = await http.delete(url);
        if (response.statusCode >= 400) {
          _users.insert(userIndex, existingUser);
          notifyListeners();
          throw Exception('Could not delete user.');
        }
      } catch (error) {
        _users.insert(userIndex, existingUser);
        notifyListeners();
        throw Exception('Failed to delete user.');
      }
    } else {
      throw Exception('User not found');
    }
  }
}
