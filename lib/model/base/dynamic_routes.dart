import '../../enum/home_card_layout.dart';

class DynamicRoute {
  String target;
  HomeRouteType type;
  Map<String, dynamic> arguments;
  String message;
  DynamicRoute(this.target, this.type, this.arguments, this.message);

  DynamicRoute.fromMap(Map<String, dynamic> map) {
    this.target = map['target'];
    this.type = getHomeRouteTypeFromString(map['type']);
    this.arguments = map['args'];
    this.message = map['message'];
  }

  Map<String, dynamic> get values => {
        'target': this.target,
        'type': this.type,
        'args': this.arguments,
        'message': this.message
      };
}
