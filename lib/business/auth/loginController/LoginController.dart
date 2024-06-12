import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../conustant/di.dart';
import '../../../conustant/shared_preference_serv.dart';
import '../../../data/model/auth/loginModel/LoginResponse.dart';
import '../../../data/model/updateTokenModel/UpdateTokenResponse.dart';
import '../../../data/reposatory/repo.dart';
import '../../../data/web_service/WebServices.dart';
import '../../../ui/screen/auth/virefyCode/virefy_code_screen.dart';
import '../../../ui/screen/buttomSheets/authSheets/virefyCodeSheet/virefy_code_sheet.dart';


class LoginController extends GetxController {
  Repo repo = Repo(WebService());
  var loginResponse = LoginResponse().obs;
  var updateTokenResponse = UpdateTokenResponse().obs;
  var isLoading = false.obs;
  Rx<bool> isVisable = false.obs;
  bool isLogin = false;
  var token = "";
  var fromWhere="";
  TextEditingController phoneController = TextEditingController();
  final SharedPreferencesService sharedPreferencesService =
  instance<SharedPreferencesService>();

  // @override
  // void onInit() async {
  //   getToken();
  //   super.onInit();
  // }
  //
  // void getToken() async {
  //   token = (await FirebaseMessaging.instance.getToken())!;
  //   print("tokeen is " + token!);
  //   FirebaseMessaging.instance.onTokenRefresh
  //       .listen((fcmToken) {
  //     print(fcmToken);
  //   })
  //       .onError((err) {
  //     print("Error getting token");
  //   });
  // }

  ///this func connect with repo and repo connect with webservice to handle success of response
  ///call it in loginPage
  loginUse(BuildContext context) async {
    loginResponse.value = await repo.login(phoneController.text,"");
    if (loginResponse.value.success == true) {
      isLogin=true;
      sharedPreferencesService.setBool("islogin", isLogin);
      sharedPreferencesService.setInt('id', loginResponse.value.data!.id!);
      sharedPreferencesService.setString('phone_number', loginResponse.value.data!.mobile!);
      sharedPreferencesService.setString('picture', loginResponse.value.data!.avatar??"");
      sharedPreferencesService.setString('fullName', loginResponse.value.data!.name??"");
      sharedPreferencesService.setString('email', loginResponse.value.data!.email??"");
      sharedPreferencesService.setString('tokenUser', loginResponse.value.data!.token!);
      sharedPreferencesService.setInt('verfiyStatus', loginResponse.value.data!.status!);
      print("tokkk222/"+loginResponse.value.data!.token!);
      sharedPreferencesService.setString('role', loginResponse.value.data!.role!);
      await updateToken();
      if(phoneController.text=="8665562566"){
        Navigator.pushNamedAndRemoveUntil(context,'/drower',ModalRoute.withName('/drower'));
      }else{
        if(loginResponse.value.data!.role=="user"){
          isVisable.value = false;
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) =>  VirefyCodeScreen(
                  code: loginResponse.value.data!.code!,from: fromWhere),
            ),
          );
        }else{
          isVisable.value = false;
          ScaffoldMessenger.of(context!).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('data_isnt_for_driver'.tr()),
            ),
          );
        }
      }

      phoneController.clear();
      isVisable.value = false;
    } else {
      isVisable.value = false;
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(loginResponse.value.message!),
        ),
      );
    }
    //print("object222" + lang);
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  ///update token of firebase to send it to backend to handle push notification from his side
  updateToken() async {
    updateTokenResponse.value = (await repo.UpdateToken(token))!;
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  ///call it from bottomSheet
  loginInBottomSheet(BuildContext context) async {
    loginResponse.value = await repo.login(phoneController.text,"");
    if (loginResponse.value.success == true) {
      isLogin=true;
      sharedPreferencesService.setBool("islogin", isLogin);
      sharedPreferencesService.setInt('id', loginResponse.value.data!.id!);
      sharedPreferencesService.setString('phone_number', loginResponse.value.data!.mobile!);
      sharedPreferencesService.setString('picture', loginResponse.value.data!.avatar??"");
      sharedPreferencesService.setString('fullName', loginResponse.value.data!.name??"");
      sharedPreferencesService.setString('email', loginResponse.value.data!.email??"");
      sharedPreferencesService.setString('tokenUser', loginResponse.value.data!.token!);
      sharedPreferencesService.setInt('verfiyStatus', loginResponse.value.data!.status!);
      print("tokkk222/"+loginResponse.value.data!.token!);
      sharedPreferencesService.setString(
          'role', loginResponse.value.data!.role!);
      //await updateToken();
      if (loginResponse.value.data!.role == "user") {
        isVisable.value = false;
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
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
                child: VirefyCodeSheet(code: loginResponse.value.data!.code!, from: fromWhere)));
      } else {
        isVisable.value = false;
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('data_isnt_for_driver'.tr()),
          ),
        );
      }

      phoneController.clear();
      isVisable.value = false;
    } else {
      isVisable.value = false;
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(loginResponse.value.message??""),
        ),
      );
    }
    //print("object222" + lang);
  }
}