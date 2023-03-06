import 'package:rxdart/rxdart.dart';

extension Bell<T> on Subject<T> {

  void wellAdd(T data) {
    if (isClosed) return;
    add(data);
  }

}
