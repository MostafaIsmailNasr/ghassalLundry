
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../conustant/di.dart';
import '../../conustant/shared_preference_serv.dart';
import '../../data/model/homeModel/HomeResponse.dart';
import '../../data/reposatory/repo.dart';
import '../../data/web_service/WebServices.dart';
import '../../ui/screen/buttomNavigation/home/homePopup/home_popUp_screen.dart';

class HomeController extends GetxController {
  Repo repo = Repo(WebService());
  var homeResponse = HomeResponse().obs;
  var isLoading = false.obs;
  RxList<dynamic> popupList=[].obs;
  RxList<dynamic> sliderList=[].obs;
  var popUpImg= "".obs;
  RxList<dynamic> mySubscriptionsList=[].obs;

  final SharedPreferencesService sharedPreferencesService =
  instance<SharedPreferencesService>();
  var lang="";
  var isLogin;
  String currentAddress = '';
  late double lat=30.0622723;
  late double lng=31.3274007;
  var outOfZone="".obs;

  getData()async{
    lang=sharedPreferencesService.getString("lang");
    isLogin=sharedPreferencesService.getBool("isLogin");
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  /*getHomeData(String lat,String lng)async{
    isLoading.value=true;
    homeResponse.value = await repo.getHomeData(lat, lng);
    if(homeResponse.value.success==true){
      isLoading.value=false;
      popupList.value=homeResponse.value.data?.advertising as List;
      if(popupList.value.isNotEmpty) {
        popUpImg.value = homeResponse.value.data?.advertising?[0].image ?? "";
        Future.delayed(Duration(seconds: 3), () {
          if(popupList.isNotEmpty) {
            print("pppoppp");
            showDialog<bool>(
              context: context,
              builder: (_) => HomePopUpScreen(),
            );
          }
        });
      }
      print("imgjkio "+popUpImg.value.toString());
      sliderList.value=homeResponse.value.data?.sliders as List;
      mySubscriptionsList.value=homeResponse.value.data?.mySubscribtions??[] as List;
    }else{
      isLoading.value=false;
      outOfZone.value=homeResponse.value.message??"";
    }
    return homeResponse.value;
  }*/
  getHomeData(String lat, String lng,BuildContext context) async {
    isLoading.value = true;
    homeResponse.value = await repo.getHomeData(lat, lng);

    if (homeResponse.value.success == true) {
      isLoading.value = false;
      popupList.value = homeResponse.value.data?.advertising as List;
      // Check if popup should be shown
      bool hasShownPopup = sharedPreferencesService.getBool('hasShownPopup') ?? false;

      if (popupList.value.isNotEmpty && !hasShownPopup) {
        popUpImg.value = homeResponse.value.data?.advertising?[0].image ?? "";
        Future.delayed(Duration(seconds: 1), () {
          if (popupList.isNotEmpty) {
            print("pppoppp");
            showDialog<bool>(
              context: context,
              builder: (_) => HomePopUpScreen(),
            );

            // Save that the popup has been shown
            sharedPreferencesService.setBool('hasShownPopup', true);
          }
        });
      }

      print("imgjkio " + popUpImg.value.toString());
      sliderList.value = homeResponse.value.data?.sliders as List;
      mySubscriptionsList.value = homeResponse.value.data?.mySubscribtions ?? [] as List;
    } else {
      isLoading.value = false;
      outOfZone.value = homeResponse.value.message ?? "";
    }

    return homeResponse.value;
  }

}