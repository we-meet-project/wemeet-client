import 'container.dart';

class DependencyFactory {
  Container createContainer(List<Type> required) {
    final Map<Type, dynamic> services = {};

    for (var type in required) {
      switch (type) {
        default:
          print("경고: DependencyFactory.createContainer에 '$type'의 제공 로직이 없습니다.");
      } //switch
    } //for
    return Container(services);
  } //createContainer
}
