import 'package:gastosrecorrentes/services/multi_language.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

setUpLocators() {
  locator.registerLazySingleton(() => MultiLanguage());
}
