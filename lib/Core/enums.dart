enum AuthStatus {
  loggedIn, // 로그인 성공 -> 홈 화면으로
  notAllowed, // 허용 목록에 없음 -> 에러 메시지
  error, // 기타 실패
}