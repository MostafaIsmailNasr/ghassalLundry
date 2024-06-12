
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../conustant/di.dart';
import '../../conustant/my_colors.dart';
import '../../conustant/shared_preference_serv.dart';
import '../../conustant/toast_class.dart';
import '../../data/model/myOrdersModel/MyOrdersRespons.dart';
import '../../data/reposatory/repo.dart';
import '../../data/web_service/WebServices.dart';

class MyOrdersController extends GetxController {
  Repo repo = Repo(WebService());
  var myOrdersRespons = MyOrdersRespons().obs;
  var isLoading = false.obs;
  RxList<dynamic> myOrderList = [].obs;
  var filterDate="today".obs;
  var  time="".obs;
  var orderType="baskets".obs;
  var orderStatus="".obs;
  TextEditingController codeController = TextEditingController();
  final SharedPreferencesService sharedPreferencesService =
  instance<SharedPreferencesService>();

  ///this func connect with repo and repo connect with webservice to handle success of response
  getMyOrders(BuildContext context,
      String status,String date,String type,String id)async{
    isLoading.value=true;
    myOrdersRespons.value = await repo.getMyOrders(status,date,type,id);
    if(myOrdersRespons.value.success==true){
      isLoading.value=false;
      myOrderList.value=myOrdersRespons.value.data as List;

    }else{
      isLoading.value=false;
      Fluttertoast.showToast(
          msg: myOrdersRespons.value.message??"",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
      );
    }
    return myOrdersRespons.value;
  }
}