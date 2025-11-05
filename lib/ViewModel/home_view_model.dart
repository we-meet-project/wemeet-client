import 'package:flutter/material.dart';
import 'package:wemeet_client/Core/workerPermissionRegister.dart';
import 'package:wemeet_client/Core/workerRegister.dart';
import 'package:wemeet_client/Manager/PermissionManager.dart';
import 'package:wemeet_client/Manager/workermanager.dart';
import 'package:wemeet_client/di/dependency_factory.dart';

enum ViewState { idle, loading, success, error }

class HomeViewModel extends ChangeNotifier {
  final Permissionmanager _permissionmanager;
  final WorkerManager _workerManager;

  HomeViewModel({
    required Permissionmanager permissionManager,
    required DependencyFactory factory,
  }) : _permissionmanager = permissionManager,
       _workerManager = WorkerManager(factory: factory);

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  String _message = '';
  String get message => _message;

  void _setState(ViewState newState, [String msg = '']) {
    _state = newState;
    _message = msg;
    notifyListeners();
  }

  Future<void> run() async {
    _setState(ViewState.loading);

    final Map<String, dynamic> inputData = {
      'id': 201,
      'title': '알람보내기 테스트',
      'body': "Main Isolate에서 호출함",
      'payload': '포그라운드 작업 (ID: 2)에서 보낸 데이터입니다.',
    };

    try {
      final PermissionRequestStatus status = await _permissionmanager
          .requestPermission(WorkerName.notification);

      if (status == PermissionRequestStatus.granted) {
        bool result = await _workerManager.executeTask(
          WorkerName.notification,
          inputData,
        );
        if (result) {
          _setState(ViewState.success, 'Success!');
        } else {
          _setState(ViewState.error, 'Fail..');
        }
      } else {
        _setState(ViewState.error, 'Permission Denied');
      }
    } catch (e) {
      _setState(ViewState.error, 'invoke error : $e');
    }
  }
}
