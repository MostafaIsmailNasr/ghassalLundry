import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ghassal_laundry/conustant/toast_class.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../conustant/di.dart';
import '../../../conustant/my_colors.dart';
import '../../../conustant/shared_preference_serv.dart';
import '../../../data/model/auth/verifyModel/VerifyCodeResponse.dart';
import '../../../data/model/auth/verifyModel/resendModel/ResendCodeResponse.dart';
import '../../../data/reposatory/repo.dart';
import '../../../data/web_service/WebServices.dart';
import '../../../ui/screen/buttomNavigation/drower.dart';
import '../../../ui/screen/buttomSheets/authSheets/registerSheet/register_buttom_sheet.dart';
import '../../../ui/screen/notification/notification_screen.dart';



class VerifyController extends GetxController {
  Repo repo = Repo(WebService());
  var verifyCodeResponse = VerifyCodeResponse().obs;
  var resendCodeResponse = ResendCodeResponse().obs;
  var isLoading = false.obs;
  Rx<bool> isVisable = false.obs;
  final SharedPreferencesService sharedPreferencesService =
  instance<SharedPreferencesService>();
  var fromWhere="";
  var phone;
  var currentPin="";

  getphone() async {
    phone = sharedPreferencesService.getString("phone_number");
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  ///call it from verifyPage
  verify(BuildContext context,String currentPin) async {
    verifyCodeResponse.value = await repo.verifyCode(currentPin);
    if (verifyCodeResponse.value.success == true) {
      // ignore: use_build_context_synchronously
      navigator(context);
      currentPin="";
    } else {
      currentPin="";
      // ignore: use_build_context_synchronously
      /*ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(verifyCodeResponse.value.message.toString()),
        ),
      );*/
      Fluttertoast.showToast(
          msg: verifyCodeResponse.value.message.toString()??"",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
      );
    }
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  ///calling it from bottomSheet
  verifyBottomSheet(BuildContext context,String currentPin) async {
    verifyCodeResponse.value = await repo.verifyCode(currentPin);
    if (verifyCodeResponse.value.success == true) {
      // ignore: use_build_context_synchronously
      navigator(context);
      currentPin="";
    } else {
      currentPin="";
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(verifyCodeResponse.value.message.toString()),
        ),
      );
    }
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  resendCode(BuildContext context) async {
    resendCodeResponse.value = await repo.resendCode();
    if (resendCodeResponse.value.success == true) {
      Fluttertoast.showToast(
        msg: resendCodeResponse.value.data!.code!.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
      );
      // verfiyCodeController.clear();
      isVisable.value = false;
    } else {
      print(verifyCodeResponse.value.message);
      isVisable.value = false;
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(verifyCodeResponse.value.message.toString()),
        ),
      );
    }
  }

  ///this func to handle if he come from different pages to back on it
  void navigator(BuildContext context){
    // if(sharedPreferencesService.getInt("verfiyStatus")==1){
      if(fromWhere=="notification"){
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>  NotificationScreen(),
          ),
        );
      }
      else if(fromWhere==""){
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>  DrowerPage(index: 0),
          ),(route) => false,
        );
      }
      else if(fromWhere=="notific_register"){
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>  NotificationScreen(),
          ),
        );
      }
      else if(fromWhere=="notific_register2"){
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>  NotificationScreen(),
          ),
        );
      }
      else if(fromWhere=="basket"||fromWhere=="subscription"
          ||fromWhere=="upOn"||fromWhere=="orderMethod"){
        Navigator.pop(context);
      }
      else if(fromWhere=="myOrders"){
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        Navigator.pop(context);
      }
      else if(fromWhere=="myOrder_register"){
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      }
      else if(fromWhere=="myOrder_register2"){
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      }

    /*else{
      // ignore: use_build_context_synchronously
     // ToastClass.showCustomToast(context, 'this_account_doesnt_exist'.tr(), "error");
      if(fromWhere==""){
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(
            context, '/register_screen', arguments: "");
      }
      else if(fromWhere=="basket"||fromWhere=="subscription"
          ||fromWhere=="upOn"||fromWhere=="orderMethod"){
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        showModalBottomSheet<void>(
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            context: context,
            backgroundColor: Colors.white,
            builder: (BuildContext context) => Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: RegisterButtomSheet(from: fromWhere)));
      }
      else if(fromWhere=="myOrders"){
        Navigator.pushNamed(
            context, '/register_screen', arguments: "myOrder_register2");
      }
      else {
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(
            context, '/register_screen', arguments: "notific_register2");
      }
    }*/
  }

}