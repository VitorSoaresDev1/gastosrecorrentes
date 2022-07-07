import 'package:gastosrecorrentes/services/local/multi_language.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

setUpLocators() {
  locator.registerLazySingleton(() => MultiLanguage());
}
