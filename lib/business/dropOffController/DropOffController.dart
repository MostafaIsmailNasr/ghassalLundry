import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';

import '../../conustant/di.dart';
import '../../conustant/my_colors.dart';
import '../../conustant/shared_preference_serv.dart';
import '../../conustant/toast_class.dart';
import '../../data/model/hoursModel/HoursResponse.dart';
import '../../data/model/pickupDateModel/PickupDateResponse.dart';
import '../../data/reposatory/repo.dart';
import '../../data/web_service/WebServices.dart';
import '../ghassalBasketsController/GhassalBasketsController.dart';
import '../ghassalSubscriptionController/GhassalSubscriptionController.dart';
import '../ghassalUpOnRequestController/GhassalUpOnRequestController.dart';

class DropOffController extends GetxController {
  Repo repo = Repo(WebService());
  var pickupDateResponse = PickupDateResponse().obs;
  var hoursResponse = HoursResponse().obs;
  var isLoading = false.obs;
  var isLoading2 = false.obs;
  RxList<dynamic> pickUpDateList = [].obs;
  RxList<dynamic> pickUpHoursList = [].obs;
  final SharedPreferencesService sharedPreferencesService =
  instance<SharedPreferencesService>();
  var basketDate="";
  var basketHours="";
  var basketHoursOrder="";
  var finalBasketTime="".obs;
  var finalBasketTimeOrder="".obs;
  var formattedDateBasket="";
  ///
  var subscriptionDate;
  var subscriptionHours;
  var subscriptionHoursOrder="";
  var finalsubscriptionTime="".obs;
  var finalSubscriptionOrder="".obs;
  var formattedDateSubscription="";
  ///
  var upOnRequestDate;
  var upOnRequestHours;
  var upOnRequestHoursOrder="";
  var finalupOnRequestTime="".obs;
  var finalUpOnRequestOrder="".obs;
  var formattedDateUpOnRequest="";
  ///
  var homeBasketSubDate;
  var homeBasketSubHours;
  var homeBasketSubOrder="";
  var finalHomeBasketSubOrder="".obs;
  var finalHomeBasketSubTime="".obs;
  var formattedDateHomeBasket="";



  final ghassalBasketsController = Get.put(GhassalBasketsController());
  final ghassalSubscriptionController = Get.put(GhassalSubscriptionController());
  final ghassalUpOnRequestController = Get.put(GhassalUpOnRequestController());
  var from="".obs;

  getPickUpDates(BuildContext context)async{
    isLoading.value=true;
    pickupDateResponse.value = await repo.getPickupDate();
    if(pickupDateResponse.value.success==true){
      isLoading.value=false;
      pickUpDateList.value=pickupDateResponse.value.data as List;

      if(from.value=="baskets") {
        basketDate =
            pickupDateResponse.value.data![0].date.toString().replaceAll("/", "-");
        print("jhhj $basketDate");
        final inputFormat = DateFormat('dd-MM-yyyy');
        DateTime date = inputFormat.parse(basketDate);
        formattedDateBasket = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
        print("bgd $formattedDateBasket");
        // ignore: use_build_context_synchronously
        getPickUpHoursDates2(formattedDateBasket.toString(),context);
      }
      else if(from.value=="subscription"){
        subscriptionDate =
            pickupDateResponse.value.data![0].date.toString().replaceAll(
                "/", "-");
        print("jhhj $subscriptionDate");
        final inputFormat = DateFormat('dd-MM-yyyy');
        DateTime date = inputFormat.parse(subscriptionDate);
        formattedDateSubscription = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
        print("bgd $formattedDateSubscription");
        // ignore: use_build_context_synchronously
        getPickUpHoursDates2(formattedDateSubscription.toString(),context);
      }
      else if(from.value=="homeBasketSub"){
        homeBasketSubDate =
            pickupDateResponse.value.data![0].date.toString().replaceAll(
                "/", "-");
        print("jhhj $homeBasketSubDate");
        final inputFormat = DateFormat('dd-MM-yyyy');
        DateTime date = inputFormat.parse(homeBasketSubDate);
        formattedDateHomeBasket = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
        print("bgd $formattedDateHomeBasket");
        // ignore: use_build_context_synchronously
        getPickUpHoursDates2(formattedDateHomeBasket.toString(),context);
      }
      else if(from.value=="upOnRequest"){
        upOnRequestDate =
            pickupDateResponse.value.data![0].date.toString().replaceAll(
                "/", "-");
        print("jhhj $upOnRequestDate");
        final inputFormat = DateFormat('dd-MM-yyyy');
        DateTime date = inputFormat.parse(upOnRequestDate);
        formattedDateUpOnRequest = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
        print("bgd $formattedDateUpOnRequest");
        // ignore: use_build_context_synchronously
        getPickUpHoursDates2(formattedDateUpOnRequest.toString(),context);
      }

    }
    return pickupDateResponse.value;
  }

  getPickUpHoursDates(BuildContext context)async{
    isLoading2.value=true;

    if(from.value=="baskets") {
      var time = basketDate.toString().replaceAll("/", "-");
      final inputFormat = DateFormat('yy-dd-mm');
      DateTime date = inputFormat.parse(time);
      formattedDateBasket = "${date.year}-0${date.month}-0${date.day}";
      print(formattedDateBasket);

      hoursResponse.value = await repo.getHours(
          formattedDateBasket, ghassalBasketsController.addressId.value, "delivery");
      if(hoursResponse.value.success==true){
        isLoading2.value=false;
        pickUpHoursList.value=hoursResponse.value.data?.times as List;
        ghassalBasketsController.deliveryCost.value=hoursResponse.value.data?.deliveryCost??0;
      }else{
        isLoading2.value=false;
        Fluttertoast.showToast(
            msg: hoursResponse.value.message??"",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
        );
      }
    }
    else if(from.value=="subscription"){
      var time = subscriptionDate.toString().replaceAll("/", "-");
      final inputFormat = DateFormat('yy-dd-mm');
      DateTime date = inputFormat.parse(time);
      formattedDateSubscription = "${date.year}-0${date.month}-0${date.day}";
      print(formattedDateSubscription);
      hoursResponse.value = await repo.getHours(
          formattedDateSubscription, ghassalBasketsController.addressId.value, "delivery");
      if(hoursResponse.value.success==true){
        isLoading2.value=false;
        pickUpHoursList.value=hoursResponse.value.data?.times as List;
        ghassalSubscriptionController.deliveryCost.value=hoursResponse.value.data?.deliveryCost??0;
      }else{
        isLoading2.value=false;
        Fluttertoast.showToast(
            msg: hoursResponse.value.message??"",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
        );
      }
    }
    else if(from.value=="homeBasketSub"){
      var time = homeBasketSubDate.toString().replaceAll("/", "-");
      print("jhhj " + time.toString());
      final inputFormat = DateFormat('yy-dd-mm');
      DateTime date = inputFormat.parse(time);
      formattedDateHomeBasket = "${date.year}-0${date.month}-0${date.day}";
      print(formattedDateHomeBasket);
      hoursResponse.value = await repo.getHours(
          formattedDateHomeBasket, ghassalBasketsController.addressId.value, "delivery");
      if(hoursResponse.value.success==true){
        isLoading2.value=false;
        pickUpHoursList.value=hoursResponse.value.data?.times as List;
        ghassalSubscriptionController.deliveryCost.value=hoursResponse.value.data?.deliveryCost??0;
      }else{
        isLoading2.value=false;
        Fluttertoast.showToast(
            msg: hoursResponse.value.message??"",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
        );
      }
    }
    else if(from.value=="upOnRequest"){
      var time = upOnRequestDate.toString().replaceAll("/", "-");
      print("jhhj " + time.toString());
      final inputFormat = DateFormat('yy-dd-mm');
      DateTime date = inputFormat.parse(time);
      formattedDateUpOnRequest = "${date.year}-0${date.month}-0${date.day}";
      print(formattedDateUpOnRequest);
      hoursResponse.value = await repo.getHours(
          formattedDateUpOnRequest, ghassalBasketsController.addressId.value, "delivery");
      if(hoursResponse.value.success==true){
        isLoading2.value=false;
        pickUpHoursList.value=hoursResponse.value.data?.times as List;
        ghassalUpOnRequestController.deliveryCost.value=hoursResponse.value.data?.deliveryCost??0;
      }else{
        isLoading2.value=false;
        Fluttertoast.showToast(
            msg: hoursResponse.value.message??"",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
        );
      }
    }
    return hoursResponse.value;
  }

  getPickUpHoursDates2(String PickDate2,BuildContext context)async{
    isLoading2.value=true;
    if(from.value=="baskets") {
      hoursResponse.value = await repo.getHours(
          PickDate2, ghassalBasketsController.addressId.value, "delivery");
      if(hoursResponse.value.success==true){
        isLoading2.value=false;
        pickUpHoursList.value=hoursResponse.value.data?.times as List;
        ghassalBasketsController.deliveryCost.value=hoursResponse.value.data?.deliveryCost??0;
      }else{
        isLoading2.value=false;
        Fluttertoast.showToast(
            msg: hoursResponse.value.message??"",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
        );
      }
    }
    else if(from.value=="subscription"){
      hoursResponse.value = await repo.getHours(
          PickDate2, ghassalSubscriptionController.addressId.value, "delivery");
      if(hoursResponse.value.success==true){
        isLoading2.value=false;
        pickUpHoursList.value=hoursResponse.value.data?.times as List;
        ghassalSubscriptionController.deliveryCost.value=hoursResponse.value.data?.deliveryCost??0;
      }else{
        isLoading2.value=false;
        Fluttertoast.showToast(
            msg: hoursResponse.value.message??"",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
        );
      }
    }
    else if(from.value=="homeBasketSub"){
      hoursResponse.value = await repo.getHours(
          PickDate2, ghassalSubscriptionController.addressId.value, "delivery");
      if(hoursResponse.value.success==true){
        isLoading2.value=false;
        pickUpHoursList.value=hoursResponse.value.data?.times as List;
        ghassalSubscriptionController.deliveryCost.value=hoursResponse.value.data?.deliveryCost??0;
      }else{
        isLoading2.value=false;
        Fluttertoast.showToast(
            msg: hoursResponse.value.message??"",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
        );
      }
    }
    else if(from.value=="upOnRequest"){
      hoursResponse.value = await repo.getHours(
          PickDate2, ghassalUpOnRequestController.addressId.value, "delivery");
      if(hoursResponse.value.success==true){
        isLoading2.value=false;
        pickUpHoursList.value=hoursResponse.value.data?.times as List;
        ghassalUpOnRequestController.deliveryCost.value=hoursResponse.value.data?.deliveryCost??0;
      }else{
        isLoading2.value=false;
        Fluttertoast.showToast(
            msg: hoursResponse.value.message??"",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
        );
      }
    }
    ///

    return hoursResponse.value;
  }
}