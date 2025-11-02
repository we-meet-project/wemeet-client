import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wemeet_client/Core/seviceRegister.dart';
import 'package:wemeet_client/Core/workerRegister.dart';
import 'package:wemeet_client/Manager/PermissionManager.dart'; //flutter 패키지

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('권한 요청 예제')),
        body: const PermissionDemoPage(),
      ),
    );
  }
}

class PermissionDemoPage extends StatefulWidget {
  const PermissionDemoPage({super.key});

  @override
  State<PermissionDemoPage> createState() => _PermissionDemoPageState();
}

class _PermissionDemoPageState extends State<PermissionDemoPage> {
  // 1. 위에서 만든 PermissionManager 인스턴스 생성
  final Permissionmanager _permissionManager = Permissionmanager();
  
  // 2. 화면에 표시할 현재 상태 메시지
  String _message = '아래 버튼을 눌러 권한을 요청하세요.';
  
  // 3. 로딩 상태 (권한 팝업이 떠 있을 때 중복 클릭 방지)
  bool _isLoading = false;

  // [핵심] 버튼을 눌렀을 때 실행될 비동기 함수
  void _handlePermissionRequest(String workerName) async {
    // 중복 요청 방지

    
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _message = "'$workerName'에 대한 권한 요청 중...";
    });

    // [await 호출]
    // 제공해주신 async 함수를 여기서 await로 호출합니다.
    // 권한 팝업이 뜨고 사용자가 선택할 때까지 여기서 기다립니다.
    final PermissionRequestStatus status =
        await _permissionManager.requestPermission(workerName);

    // [결과 처리]
    // await가 끝나고 반환된 status 값에 따라 UI를 갱신합니다.
    String resultMessage = '';
    switch (status) {
      case PermissionRequestStatus.granted:
        resultMessage = '모든 권한이 허용되었습니다!';
        break;
      case PermissionRequestStatus.denied:
        resultMessage = '권한이 거부되었습니다. 기능을 사용할 수 없습니다.';
        break;
      case PermissionRequestStatus.permanentlyDenied:
        resultMessage = '권한이 영구적으로 거부되었습니다. 앱 설정에서 직접 허용해야 합니다.';
        // (팁: 이 경우 openAppSettings()를 호출해주는 버튼을 보여주면 좋습니다)
        break;
      case PermissionRequestStatus.restricted:
        resultMessage = '권한이 (부모 제어 등에 의해) 제한되었습니다.';
        break;
    }

    setState(() {
      _message = resultMessage;
      _isLoading = false;
    });
  }
  
  // 앱 설정 화면을 여는 함수
  void _openAppSettings() {
    openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 1. 권한 요청 결과를 표시하는 텍스트
            Text(
              _message,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // 2. 로딩 중일 때 표시되는 인디케이터
            if (_isLoading)
              const CircularProgressIndicator()
            else
              const SizedBox(height: 38), // 인디케이터와 동일한 높이 유지

            const SizedBox(height: 30),

            // 3. '카메라' 작업 권한 요청 버튼
            ElevatedButton(
              // 로딩 중(팝업이 떠 있을 때)에는 버튼 비활성화
              onPressed: _isLoading 
                  ? null 
                  : () => _handlePermissionRequest(WorkerName.sleepReport),
              child: const Text('카메라/마이크 권한 요청'),
            ),
            const SizedBox(height: 10),

            // // 4. '저장공간' 작업 권한 요청 버튼
            // ElevatedButton(
            //   onPressed: _isLoading 
            //       ? null 
            //       : () => _handlePermissionRequest('storage_worker'),
            //   child: const Text('저장공간 권한 요청'),
            // ),
            //  const SizedBox(height: 10),

            // // 5. '위치' 작업 권한 요청 버튼
            //  ElevatedButton(
            //   onPressed: _isLoading 
            //       ? null 
            //       : () => _handlePermissionRequest('location_worker'),
            //   child: const Text('위치정보 권한 요청'),
            // ),
            
            const SizedBox(height: 40),
            
            // 6. (영구 거부 시) 사용자가 직접 설정을 열 수 있는 버튼
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              onPressed: _openAppSettings,
              child: const Text('앱 설정 열기'),
            ),
          ],
        ),
      ),
    );
  }
}