
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../conustant/di.dart';
import '../../../conustant/shared_preference_serv.dart';
import '../../../data/model/auth/createUserModel/CompleteUserInfoResponse.dart';
import '../../../data/reposatory/repo.dart';
import '../../../data/web_service/WebServices.dart';
import '../../../ui/screen/auth/virefyCode/virefy_code_screen.dart';
import '../../../ui/screen/buttomSheets/authSheets/virefyCodeSheet/virefy_code_sheet.dart';


class RegisterController extends GetxController {
  Repo repo = Repo(WebService());
  var completeUserInfoResponse = CompleteUserInfoResponse().obs;
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  var address2="".obs;
  Rx<bool> isVisable = false.obs;
  var lat;
  var lng;
  var addressType;
  var phone="",userName="";
  var fromWhere="";
  final SharedPreferencesService sharedPreferencesService =
  instance<SharedPreferencesService>();

  ///this func connect with repo and repo connect with webservice to handle success of response
  ///call it from registerPage
  completeUserInfo(BuildContext context) async {
    print("addd"+address2.toString());
    completeUserInfoResponse.value = await repo.completeUserInfo(
        nameController.text,
        address2.value?? "",
        addressType??"",lat??"",lng??"",
        emailController.text,phoneController.text);

    if (completeUserInfoResponse.value.success == true) {

      sharedPreferencesService.setBool("islogin", true);
      sharedPreferencesService.setInt('id', completeUserInfoResponse.value.data!.id!);
      sharedPreferencesService.setString('phone_number', completeUserInfoResponse.value.data!.mobile!);
      sharedPreferencesService.setString('fullName', completeUserInfoResponse.value.data!.name??"");
      sharedPreferencesService.setString('email', completeUserInfoResponse.value.data!.email??"");
      sharedPreferencesService.setString('tokenUser', completeUserInfoResponse.value.data!.token!);
      sharedPreferencesService.setInt('verfiyStatus', completeUserInfoResponse.value.data!.status!);
      print("tokkk222/"+completeUserInfoResponse.value.data!.token!);
      sharedPreferencesService.setString('role', completeUserInfoResponse.value.data!.role!);

      if(phoneController.text=="8665562566"){
        Navigator.pushNamedAndRemoveUntil(context,'/drower',ModalRoute.withName('/drower'));
      }else{
        if(completeUserInfoResponse.value.data!.role=="user"){
          isVisable.value = false;
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) =>  VirefyCodeScreen(
                  code: completeUserInfoResponse.value.data!.code!,from: fromWhere),
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



      nameController.clear();
      emailController.clear();
      phoneController.clear();
      //lat="";
      //lng="";
      address2.value="";
      addressType="";
      isVisable.value = false;
    } else {
      print("oooor"+completeUserInfoResponse.value.message.toString());
      isVisable.value = false;
    }
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  ///call it from bottomSheet
  registerBottomSheet(BuildContext context) async {
    print("addd"+address2.toString());
    completeUserInfoResponse.value = await repo.completeUserInfo(
        nameController.text,
        "",
        "","","",
        emailController.text,phoneController.text);

    if (completeUserInfoResponse.value.success == true) {

      sharedPreferencesService.setBool("islogin", true);
      sharedPreferencesService.setInt('id', completeUserInfoResponse.value.data!.id!);
      sharedPreferencesService.setString('phone_number', completeUserInfoResponse.value.data!.mobile!);
      sharedPreferencesService.setString('fullName', completeUserInfoResponse.value.data!.name??"");
      sharedPreferencesService.setString('email', completeUserInfoResponse.value.data!.email??"");
      sharedPreferencesService.setString('tokenUser', completeUserInfoResponse.value.data!.token!);
      sharedPreferencesService.setInt('verfiyStatus', completeUserInfoResponse.value.data!.status!);
      print("tokkk222/"+completeUserInfoResponse.value.data!.token!);
      sharedPreferencesService.setString('role', completeUserInfoResponse.value.data!.role!);

      if (completeUserInfoResponse.value.data!.role == "user") {
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
                child: VirefyCodeSheet(code: completeUserInfoResponse.value.data!.code!, from: fromWhere)));
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



      nameController.clear();
      emailController.clear();
      phoneController.clear();
      lat="";
      lng="";
      address2.value="";
      addressType="";
      isVisable.value = false;
    } else {
      print("oooor"+completeUserInfoResponse.value.message.toString());
      isVisable.value = false;
    }
  }
}