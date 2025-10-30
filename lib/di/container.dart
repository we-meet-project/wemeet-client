/// Container 의존성 집합 생성
class Container {
  //의존성 Type을 키로 저장
  final Map<Type, dynamic> _services = {};

  //생성자를 통해 의존성 컨테이너 저장
  Container(Map<Type, dynamic> service) {
    _services.addAll(service);
  }
  
  //의존성 컨테이너에서 의존성을 꺼내는 메소드
  T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw Exception(
          'Container Error: $T 타입의 의존성이 등록되지 않음. DependencyFactory의 createContainer에 추가했는지 확인하세요.');
    }
    return service as T;
  }
}
