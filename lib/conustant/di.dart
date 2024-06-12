import 'package:get_it/get_it.dart';
import 'package:ghassal_laundry/conustant/shared_preference_serv.dart';
import 'package:shared_preferences/shared_preferences.dart';


final instance = GetIt.instance;

///this method to handle take one instance from  SharedPreferencesService in all project
Future<void> setupDependencyInjection() async {
  final sharedPrefs = await SharedPreferences.getInstance();

  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  instance.registerLazySingleton<SharedPreferencesService>(
      () => SharedPreferencesService(instance()));
}
