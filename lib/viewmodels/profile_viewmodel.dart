import 'package:expense_tracker_frontend1/constants/endpoints.dart';
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
      _isLoading = true;
      _isError = false;
      _errorMessage = "";

      var response = await ApiService.sendRequest(
        method: HttpMethod.GET,
        url: Endpoints.getProfile,
      );
      print(response);

      _isError = false;
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiError catch (err) {
      _isError = true;
      _errorMessage = err.message!;
      notifyListeners();

      return false;
    } catch (e) {
      _isError = true;
      _errorMessage = e.toString();
      notifyListeners();

      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
