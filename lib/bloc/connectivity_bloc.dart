import 'dart:async';

import 'package:connectivity/connectivity.dart';

class ConnectivityBloc {
  ConnectivityBloc._internal();

  static final ConnectivityBloc _instance = ConnectivityBloc._internal();

  static ConnectivityBloc get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController<ConnectivityResult> controller =
      StreamController<ConnectivityResult>.broadcast();

  Stream<ConnectivityResult> get connectionStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _add(result);
    connectivity.onConnectivityChanged.listen((result) {
      _add(result);
    });
  }

  void _add(ConnectivityResult result) {
    if (!controller.isClosed) controller.sink.add(result);
  }

  void dispose() => controller.close();
}
