import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/database_helper.dart';
import 'package:flutter_application_1/models/user.dart';

class AuthProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  String get userRole => _user?.role ?? '';
  bool get isLoading => _isLoading;

  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      _user = await _dbHelper.getUser(email, password);
      
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Erreur de connexion: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    _user = null;
    notifyListeners();
  }
}

