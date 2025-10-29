/// Container 의존성 집합 생성
class Container {
  final Map<Type, dynamic> _services;

  Container(this._services);

  T get<T>() {
    final service = _services[T];
    if (service == null || service is! T) {
      throw Exception(
        "Container: '$T' 타입의 의존성을 찾을 수 없거나 타입이 일치하지 않습니다. "
        "DependencyFactory의 createContainer에 Type을 추가했는지 확인하세요.",
      );
    }
    return service;
  }
}
