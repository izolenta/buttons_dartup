import 'package:flutter_simple_dependency_injection/injector.dart';

T getInjected<T>() {
  return Injector.getInjector().get<T>();
}