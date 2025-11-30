import 'package:flutter/material.dart';
import 'package:wemeet_client/Core/Core/workerRegister.dart';
import 'package:wemeet_client/Core/Manager/workermanager.dart';
import 'package:wemeet_client/Core/enums.dart';

class LoginViewmodel with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final WorkerManager _workerManager;

  LoginViewmodel({required WorkerManager workermanager})
    : _workerManager = workermanager;

  Future<AuthStatus> login() async {
    if (_isLoading) return AuthStatus.error; // 중복 호출 방지

    _setLoading(true);

    try {
      final result = await _workerManager.executeTask(
        WorkerName.authentication,
        {'action': 'login'},
      );

      _setLoading(false);

      if (result is AuthStatus)
        return result;
      else
        return AuthStatus.error;
    } catch (e) {
      print("ViewModel Error: $e");
      _setLoading(false);
      return AuthStatus.error;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  void changeLoginType(int index) {
    if (_selectedTabIndex != index) {
      _selectedTabIndex = index;
      notifyListeners(); // UI 업데이트 알림
    }
  }
}
