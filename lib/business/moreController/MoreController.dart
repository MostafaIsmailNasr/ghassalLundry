
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../conustant/di.dart';
import '../../conustant/shared_preference_serv.dart';
import '../../data/reposatory/repo.dart';
import '../../data/web_service/WebServices.dart';

class MoreController extends GetxController {
  Repo repo = Repo(WebService());
  final SharedPreferencesService sharedPreferencesService =
  instance<SharedPreferencesService>();
}