//container에서 조합할 의존성 객체들 생산

class DataModule {
  //지연 초기화로 필요할때만 생산

  // DatabaseService? _databaseService; 
  // Future<DatabaseService> get databaseService async {
  //     if (_databaseService == null) {
  //         _databaseService = await DatabaseService.init(); 
  //     }
  //     return _databaseService!;
  // }
}
