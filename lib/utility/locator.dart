import 'package:get_it/get_it.dart';
//import 'package:anne/service/firebase/push_notification_service.dart';
import 'package:anne/service/navigation/navigation_service.dart';

import 'api_provider.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
 // locator.registerLazySingleton(() => PushNotificationService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerFactory(() => ApiProvider());
}
