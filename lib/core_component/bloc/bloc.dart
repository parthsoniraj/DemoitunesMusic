import 'dart:async';

///parent class for all bloc components for mandatory dispose method.

abstract class Bloc<T> {
  T _t;
  final _streamController = StreamController<T>.broadcast();
  Stream<T> get stream => _streamController.stream;
  T get state => _t;

  void emit(T data) {
    _t = data;
    _streamController.sink.add(data);
  }

  void emitError(String error) {
    _streamController.sink.addError(error);
  }

  void dispose() {
    _streamController.close();
  }
}
