import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wemeet_client/Core/Service/database_service.dart';
import 'package:wemeet_client/Core/Service/localprofile_service.dart';
import 'package:wemeet_client/Core/Worker/worker.dart';
import 'package:wemeet_client/Core/di/container.dart';
import 'package:wemeet_client/Core/di/dependency_factory.dart';
import 'package:wemeet_client/Core/enums.dart';

class Authworker implements IWorker {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final DataBaseService _dataBaseService;
  final LocalprofileService _localprofileService;

  Authworker({required Container container})
    : _dataBaseService = container.get<DataBaseService>(),
      _localprofileService = container.get<LocalprofileService>();

  @override
  Future<AuthStatus> run(Map<String, dynamic>? inputData) async {
    final String action = inputData?['action'] ?? 'login';

    switch (action) {
      case 'check':
        return await _check();
      case 'logout':
        return await _signOut();
      case 'login':
      default:
        return await _login();
    }
  }

  Future<AuthStatus> _check() async {
    try {
      final User? currentUser = _auth.currentUser;

      if (currentUser == null) return AuthStatus.loggedOut;

      final String? localGroupId = await _localprofileService.getUserId();

      if (localGroupId == null || localGroupId.isEmpty) {
        await _signOut();
        return AuthStatus.loggedOut;
      }

      return AuthStatus.loggedIn;
    } catch (e) {
      return AuthStatus.loggedOut;
    }
  }

  Future<AuthStatus> _login() async {
    final User? user = await _performGoogleSignIn();
    // 사용자가 팝업을 닫음, 이메일 없음
    if (user == null || user.email == null) return AuthStatus.error;

    final String email = user.email!;

    final String? groupId = await _dataBaseService.getGroupIdFromAllowList(
      email,
    );

    print("--- [Step 4] DB 조회 결과: $groupId ---");

    if (groupId == null) {
      print("AuthService: 허용되지 않은 이메일입니다. $email");
      await _signOut(); // 즉시 로그아웃 처리
      return AuthStatus.notAllowed;
    }

    print("AuthService: 허용된 사용자입니다. Group: $groupId");
    await _dataBaseService.saveUserProfile(user.uid, groupId);

    // 5. 로컬(SharedPreferences)에 저장
    await _localprofileService.saveUserProfile(
      userId: user.uid,
      email: email,
      groupId: groupId,
    );
    return AuthStatus.loggedIn; // 홈 화면으로
  }

  Future<User?> _performGoogleSignIn() async {
    try {
      print("  -> GoogleSignIn.signIn() 호출");
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // 사용자가 로그인 취소

      print("  -> Google Auth Token 요청 중...");
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print("  -> Credential 생성 중...");
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print("  -> Firebase signInWithCredential 호출...");
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      return userCredential.user;
    } catch (e) {
      print("_performGoogleSignIn Error: $e");
      return null;
    }
  }

  Future<AuthStatus> _signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await _localprofileService.clearOnLogout();

    return AuthStatus.loggedOut;
  }
}

Future<IWorker> createAuthWorker(DependencyFactory factory) async {
  final types = [DataBaseService, LocalprofileService];

  final container = factory.createContainer(types);
  return Authworker(container: container);
}
