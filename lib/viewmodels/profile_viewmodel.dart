import 'package:expense_tracker_frontend1/models/user/user.dart';
import 'package:expense_tracker_frontend1/services/api.dart';
import 'package:flutter/cupertino.dart';

class ProfileViewmodel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isError = false;
  bool get isError => _isError;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  User? _currentuser;
  User? get currentuser => _currentuser;

  Future<bool> getProfile() async {
    try {
      var response = await ApiService.get(url: "http://localhost:8000/profile");
      print(response);
      _isLoading = true;
      _isError = false;
      _errorMessage = "";
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
