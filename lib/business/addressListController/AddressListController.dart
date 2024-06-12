
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../conustant/di.dart';
import '../../conustant/my_colors.dart';
import '../../conustant/shared_preference_serv.dart';
import '../../conustant/toast_class.dart';
import '../../data/model/addressModel/addAddressModel/AddAddressResponse.dart';
import '../../data/model/addressModel/addressListModel/AddressListResponse.dart';
import '../../data/model/addressModel/deleteModel/DeleteResponse.dart';
import '../../data/model/addressModel/editAddressModel/EditAddressResponse.dart';
import '../../data/reposatory/repo.dart';
import '../../data/web_service/WebServices.dart';
import '../auth/registerController/RegisterController.dart';
import '../ghassalBasketsController/GhassalBasketsController.dart';
import '../ghassalSubscriptionController/GhassalSubscriptionController.dart';
import '../ghassalUpOnRequestController/GhassalUpOnRequestController.dart';

class AddressListController extends GetxController {
  Repo repo = Repo(WebService());
  var addressListResponse = AddressListResponse().obs;
  var deleteResponse = DeleteResponse().obs;
  var addAddressResponse = AddAddressResponse().obs;
  var editAddressResponse = EditAddressResponse().obs;
  var isLoading = false.obs;
  Rx<bool> isVisable = false.obs;
  RxList<dynamic> addressList=[].obs;
  final SharedPreferencesService sharedPreferencesService =
  instance<SharedPreferencesService>();
  var userName;
  var type;
  var typeEdit;
  var addressId="".obs;
  final registerController = Get.put(RegisterController());
  final ghassalSubscriptionController = Get.put(GhassalSubscriptionController());
  final ghassalBasketsController = Get.put(GhassalBasketsController());
  final ghassalUpOnRequestController = Get.put(GhassalUpOnRequestController());

  ///this func connect with repo and repo connect with webservice to handle success of response
  getAddressList()async{
    isLoading.value=true;
    addressListResponse.value = await repo.getAddress();
    if(addressListResponse.value.success==true){
      isLoading.value=false;
      addressList.value=addressListResponse.value.data as List;
      for(int i=0;i<addressList.length;i++){
      }

    }
    return addressListResponse.value;
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  deleteAddress(int id,BuildContext context)async{
    isLoading.value=true;
    deleteResponse.value=await repo.deleteAddress(id);
    if(deleteResponse.value.success==true){
      isLoading.value=false;
      Get.back();
      getAddressList();
      return deleteResponse.value;
    }else {
      isLoading.value=false;
      Get.back();
      Fluttertoast.showToast(
          msg: deleteResponse.value.message??"",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
      );

    }
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  addAddress(BuildContext context,String lat,String lng,String address,String type) async {
    addAddressResponse.value = await repo.addAddress(address,lat,lng,type);
    if (addAddressResponse.value.success == true) {
      isVisable.value = false;
      addressId.value=addAddressResponse.value.data!.id!.toString();
      ghassalSubscriptionController.addressId.value=addressId.value.toString();
      ghassalBasketsController.addressId.value=addressId.value;
      ghassalUpOnRequestController.addressId.value=addressId.value;
      print("klklklkld "+addressId.value.toString());
      await getAddressList();
      Navigator.pop(context);
    } else {
      isVisable.value = false;
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(addAddressResponse.value.message!),
        ),
      );
    }
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  editAddress(BuildContext context,String lat,String lng,String address,int id,String typeEd) async {
    editAddressResponse.value = await repo.editAddress(address,lat,lng,typeEd,id);
    if (editAddressResponse.value.success == true) {
      isVisable.value = false;
      Navigator.pop(context);
      getAddressList();
    } else {
      isVisable.value = false;
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(editAddressResponse.value.message!),
        ),
      );
    }
  }
}