import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../conustant/di.dart';
import '../../../conustant/shared_preference_serv.dart';
import '../../../data/model/auth/introModel/IntroResponse.dart';
import '../../../data/reposatory/repo.dart';
import '../../../data/web_service/WebServices.dart';
import '../loginController/LoginController.dart';

class IntroController extends GetxController {
  Repo repo = Repo(WebService());
  var introResponse = IntroResponse().obs;
  RxList<dynamic> introList=[].obs;
  var isLoading=false.obs;
  final SharedPreferencesService sharedPreferencesService =
  instance<SharedPreferencesService>();
  final loginController = Get.put(LoginController());

  @override
  void onInit() async {
    getToken();
    super.onInit();
  }

  ///this func to get token of firebase to use it in push notification
  void getToken() async {
    loginController.token = (await FirebaseMessaging.instance.getToken())!;
    print("tokeen is " + loginController.token!);
    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {
      print(fcmToken);
    })
        .onError((err) {
      print("Error getting token");
    });
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  getIntroData()async{
    //final SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoading.value=true;
    introResponse.value = await repo.getIntro();
    introList.value=introResponse.value.data??[] as List;
    isLoading.value=false;
    return introResponse.value;
  }
}