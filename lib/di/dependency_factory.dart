import 'package:wemeet_client/Service/health_service.dart';

import 'container.dart';

//WorkerFactory로 부터 필요한 의존성 Type 목록을 받아 Container를 조립
class DependencyFactory {
  Container createContainer(List<Type> types) {
    final Map<Type, dynamic> services = {};

    for (var type in types) {
      switch (type) {
        case HealthDataService:
        services[type] = HealthDataService.inst;
        default:
          throw Exception('DependencyFactory Error: $type 타입의 서비스를 등록하는 방법을 모릅니다.');
      }
    }

    //의존성 Container 반환
    return Container(services);
  }
}
