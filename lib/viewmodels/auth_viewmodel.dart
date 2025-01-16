
import 'package:expense_tracker_frontend1/services/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthViewmodel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isError = false;
  bool get isError => _isError;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _isError = false;
      _errorMessage = "";
      notifyListeners();

      await Future.delayed(const Duration(seconds: 2));
      var response =
          await ApiService.post(url: "http://localhost:8000/auth/login", body: {
        "email": email,
        "password": password,
      });

      String? token = (response?['access_token']);

      const storage = FlutterSecureStorage();
      await storage.write(key: "token", value: token);

      // api call to login endpoint with email and password

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      print(e);
      _isError = true;
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();

      return false;
    }
  }
}
