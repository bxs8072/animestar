import 'dart:async';

class HomeScreenBloc {
  StreamController<int> controller = StreamController<int>.broadcast();
  Stream<int> get stream => controller.stream.asBroadcastStream();

  get dispose => controller.close();

  update({int index}) => controller.sink.add(index);
}
