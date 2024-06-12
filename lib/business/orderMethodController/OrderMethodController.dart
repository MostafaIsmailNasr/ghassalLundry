
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../conustant/di.dart';
import '../../conustant/shared_preference_serv.dart';
import '../../data/model/videoModel/VideoResponse.dart';
import '../../data/reposatory/repo.dart';
import '../../data/web_service/WebServices.dart';

class OrderMethodController extends GetxController {
  Repo repo = Repo(WebService());
  var videoResponse = VideoResponse().obs;
  var isLoading = false.obs;
  final SharedPreferencesService sharedPreferencesService =
  instance<SharedPreferencesService>();

  getVideo()async{
    isLoading.value=true;
    videoResponse.value = await repo.getVideo();
      isLoading.value=false;
    return videoResponse.value;
  }
}