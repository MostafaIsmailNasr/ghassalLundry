

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../conustant/di.dart';
import '../../conustant/my_colors.dart';
import '../../conustant/shared_preference_serv.dart';
import '../../conustant/toast_class.dart';
import '../../data/model/addressModel/deleteModel/DeleteResponse.dart';
import '../../data/model/orderDetailsModel/OrderDetailsResponse.dart';
import '../../data/model/rateOrderModel/RateOrderResponse.dart';
import '../../data/reposatory/repo.dart';
import '../../data/web_service/WebServices.dart';

class OrderDetailsController extends GetxController {
  Repo repo = Repo(WebService());
  var orderDetailsResponse = OrderDetailsResponse().obs;
  var deleteResponse = DeleteResponse().obs;
  var rateOrderResponse = RateOrderResponse().obs;
  var isLoading = false.obs;
  Rx<bool> isVisable = false.obs;
  double? orderRate = 0.0;
  double? ironingRate = 0.0;
  double? driverRate = 0.0;
  RxList<dynamic> myOrderList = [].obs;
  TextEditingController NotesController=TextEditingController();
  final SharedPreferencesService sharedPreferencesService =
  instance<SharedPreferencesService>();

  getOrderDetails(BuildContext context,String id)async{
    isLoading.value=true;
    orderDetailsResponse.value = await repo.getOrderDetails(id);
    if(orderDetailsResponse.value.success==true){
      isLoading.value=false;
      myOrderList.value=orderDetailsResponse.value.data?.orderItems as List;

    }else{
      isLoading.value=false;
      Fluttertoast.showToast(
          msg: orderDetailsResponse.value.message??"",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
      );
    }
    return orderDetailsResponse.value;
  }

  cancelOrder(BuildContext context,String id)async{
    isLoading.value=true;
    deleteResponse.value = await repo.deleteOrder(id);
    if(deleteResponse.value.success==true){
      isLoading.value=false;
      getOrderDetails(context,id);
      Fluttertoast.showToast(
          msg: deleteResponse.value.message??"",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
      );
    }else{
      isLoading.value=false;
      Fluttertoast.showToast(
          msg: deleteResponse.value.message??"",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
      );
    }
    return deleteResponse.value;
  }

  RateOrder(int orderId,BuildContext context)async{
    rateOrderResponse.value = await repo.rateOrder(
        orderId,
        NotesController.text,
        orderRate==0.0?"":orderRate.toString(),
        ironingRate==0.0?"":ironingRate.toString(),
        driverRate==0.0?"": driverRate.toString());
    if(rateOrderResponse.value.success==true){
      isVisable.value=false;
      Get.back();
      //getListOrders();
      NotesController.clear();
      orderRate=0.0;
      ironingRate=0.0;
      driverRate=0.0;
      //driverRate=0.0;
      return rateOrderResponse.value;
    } else {
      isVisable.value=false;
      //Get.back();
      Fluttertoast.showToast(
          msg: rateOrderResponse.value.message??"",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
      );
    }
    return rateOrderResponse.value;
  }
}