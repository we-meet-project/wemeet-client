import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool isLoading = false;

  Future<void> signWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      //로그인 취소
      if (googleUser == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      //google 인증토큰
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      //FireBase AuthCredential
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await auth.signInWithCredential(credential);

      print("로그인 성공");
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar((SnackBar(content: Text('Google 로그인 오류 : $e'))));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('로그인')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              CircularProgressIndicator()
            else
              SizedBox(height: 10),
            // 3. Google 로그인 버튼 추가
            ElevatedButton(
              onPressed: signWithGoogle, // Google 로그인 함수 연결
              child: Text('Google로 로그인'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ));
  }
}
