import 'package:app/router.dart';
import 'package:app/screens/screens.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setUpDI() async {
  GetIt.I.registerSingleton(appRouter);
  GetIt.I.registerSingletonAsync<SharedPreferences>(
    SharedPreferences.getInstance,
  );
  await GetIt.I.isReady<SharedPreferences>();
  GetIt.I.registerSingleton<ValuesRepository>(ValuesRepository());
}
