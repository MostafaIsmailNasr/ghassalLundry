
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';

import '../../conustant/di.dart';
import '../../conustant/my_colors.dart';
import '../../conustant/shared_preference_serv.dart';
import '../../conustant/toast_class.dart';
import '../../data/model/UpdateStatusModel/UpdateStatusResponse.dart';
import '../../data/model/addressModel/addressListModel/AddressListResponse.dart';
import '../../data/model/copunModel/CopunResponse.dart';
import '../../data/model/createOrderModel/CreateOrderResponse.dart';
import '../../data/model/preferencesModel/PreferencesResponse.dart';
import '../../data/model/productModel/ProductResponse.dart';
import '../../data/model/selectedSubscriptionModel/SelectedSubscriptionModel.dart';
import '../../data/model/urgentPriceModel/UrgentPriceResponse.dart';
import '../../data/reposatory/repo.dart';
import '../../data/web_service/WebServices.dart';
import '../auth/registerController/RegisterController.dart';

class GhassalUpOnRequestController extends GetxController {
  Repo repo = Repo(WebService());
  var addressListResponse = AddressListResponse().obs;
  var preferencesResponse = PreferencesResponse().obs;
  var productResponse = ProductResponse().obs;
  var couponResponse2 = copunResponse().obs;
  var createOrderResponse = CreateOrderResponse().obs;
  var updateStatusResponse = UpdateStatusResponse().obs;
  var urgentPriceResponse =UrgentPriceResponse().obs;

  RxList<dynamic> addressList=[].obs;
  RxList<dynamic> preferencesList=[].obs;
  RxList<dynamic> productCatList=[].obs;
  RxList<dynamic> productList=[].obs;
  List<Products> cartItem = [];
  List<int> itemPrices = [];
  RxMap<int, int> itemPrices2 = RxMap<int, int>();
  List<Preferences> preferencesItem = [];
  Rx<String> prefernceJson="".obs;
  Rx<String> productsJson="".obs;

  var homeStreetName="".obs,homeAddressId="";
  var workStreetName="".obs,workAddressId="";
  var addressType="";
  var orderType='normal'.obs;
  var payment="".obs;
  //taby//
  String status = 'idle';
  TabbySession? session;


  var isSelected=false;
  var isLoading = false.obs;
  var isLoading2 = false.obs;
  var isLoading3 = false.obs;
  var lights=false;
  Rx<bool> isVisable = false.obs;
  Rx<bool> isUrgent = false.obs;
  Rx<bool> isVisable2 = false.obs;

  int? itemId=0;
  var quantityList=0.obs;
  var discount=0.0.obs;
  var totalPrice=0.obs;
  var urgentPrice=0.obs;
  var deliveryCost=0.obs;
  var totalAfterDiscount=0.0.obs;
  var addressId="".obs;
  var urgentPriceTxt="".obs;
  var homeLat,homeLng,workLat,workLng;
  var CopunID;

  TextEditingController codeController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  final SharedPreferencesService sharedPreferencesService =
  instance<SharedPreferencesService>();
  final registerController = Get.put(RegisterController());

  void setItemPrice(int productId, int price) {
    itemPrices2[productId] = price;
  }
  int getItemPrice(int productId) {
    return itemPrices2[productId] ?? 0;
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  getAddressList(BuildContext context)async{
    isLoading.value=true;
    addressListResponse.value = await repo.getAddress();
    if(addressListResponse.value.success==true){
      isLoading.value=false;
      addressList.value=addressListResponse.value.data as List;
      if(addressListResponse.value.data!.isEmpty){

      }else{
        bool homeAddressFound = false;
        bool workAddressFound = false;
        if(addressList.isNotEmpty) {
          for (int i = 0; i < addressList.length; i++) {
            if (!homeAddressFound && addressListResponse.value.data?[i].type == 'home') {
              // Store the home address details
              homeStreetName.value =
                  addressListResponse.value.data?[i].streetName ?? "";
              homeAddressId = addressListResponse.value.data![i].id.toString();
              homeLat=addressListResponse.value.data![i].lat;
              homeLng=addressListResponse.value.data![i].lng;
              homeAddressFound = true;
            }
            if (!workAddressFound && addressListResponse.value.data?[i].type == 'work') {
              workStreetName.value =
                  addressListResponse.value.data?[i].streetName ?? "";
              print("ccccx " + workStreetName.value.toString());
              workAddressId = addressListResponse.value.data![i].id.toString();
              workLat=addressListResponse.value.data![i].lat;
              workLng=addressListResponse.value.data![i].lng;
              workAddressFound = true;
            }
            // Break the loop if both home and work addresses are found
            if (homeAddressFound && workAddressFound) {
              break;
            }
          }
        }
      }
    }
    await getPreferences(registerController.lat.toString(), registerController.lng.toString());
    await getUrgentPrice("address");
    return addressListResponse.value;
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  getPreferences(String lat,String lng)async{
    isLoading.value=true;
    preferencesResponse.value = await repo.getPreferences(lat, lng);
    if(preferencesResponse.value.success==true){
      isLoading.value=false;
      preferencesList.value=preferencesResponse.value.data?.preferences as List;
    }else{
      isLoading.value=false;
    }
    return preferencesResponse.value;
  }

  String convertPreferenceListToJson(List<Preferences> productsList) {
    List<Preferences3> productListJson = [];
    productsList.forEach((product) {
      productListJson.add(Preferences3(
        id:  product.id,
        price: product.price,
      ));
    });

    print("fg "+productListJson.toString());
    return jsonEncode(productListJson);
  }

  String convertProductListToJson(List<Products> productsList) {
    List<Map<String, dynamic>> productListJson = [];
    productsList.forEach((product) {
      productListJson.add({
        'product_id': product.id,
        'price': product.regularPrice ?? 0,
        'quantity': product.quantity,
        "wash_type": 0,
        'type': "products"
      });
    });
    return jsonEncode(productListJson);
  }

  int calculateTotalPrice() {
    var totalPrice1 = 0.obs;
    var total=0.obs;

    print("mvb "+cartItem.length.toString());

    for (int i=0;i<cartItem.length;i++) {
      totalPrice1.value += (cartItem[i].regularPrice??0)*(cartItem[i].quantity??0);
    }
    var prefprice=0;
    print("mvb2 "+preferencesItem.length.toString());
    if(preferencesItem!=[]){
      for(int j=0;j<preferencesItem.length;j++){
        print("mvb3 "+preferencesItem[j].price!.toString());
        prefprice += preferencesItem[j].price??0;
      }
    }
    total.value=totalPrice1.value+prefprice+urgentPrice.value+deliveryCost.value;
    print("jkhjhj"+total.toString());
    totalPrice.value=total.value;
    totalAfterDiscount.value=total.toDouble();
    print("jkhjhj2"+totalPrice.value.toString());
    return total.value;
  }

  /*int calculateTotalPrice() {
    var totalPrice1 = 0.obs;
    var total=0.obs;
    //setState(() {

    print("mvb "+cartItem.length.toString());

    for (int i=0;i<cartItem.length;i++) {
      var prefprice = 0;
      print("mvb2 " + preferencesItem.length.toString());
      if (preferencesItem != []) {
        for (int j = 0; j < preferencesItem.length; j++) {
          print("mvb3 " + preferencesItem[j].price!.toString());
          prefprice += preferencesItem[j].price ?? 0;
        }
      }
      totalPrice1.value += ((cartItem[i].regularPrice ?? 0) + prefprice) *
          (cartItem[i].quantity ?? 0);
    }
    total.value=totalPrice1.value+urgentPrice.value;
    print("jkhjhj"+total.toString());
    totalPrice.value=total.value;
    totalAfterDiscount.value=total.value.toDouble();
    //});
    return total.value;
  }*/

  ///this func connect with repo and repo connect with webservice to handle success of response
  getProductCat(String lat,String lng)async{
    isLoading2.value=true;
    productResponse.value = await repo.getProductCat(lat, lng);
    if(productResponse.value.success==true){
      isLoading2.value=false;
      productCatList.value=productResponse.value.data as List;
      // for(int i=0;i<productCatList.length;i++){
      //   productList.value=productResponse.value.data?[i].products as List;
      // }
    }else{
      isLoading2.value=false;
    }
    return productResponse.value;
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  validateCoupon(BuildContext context)async{
    isLoading3.value=true;
    couponResponse2.value = await repo.validateCoupon(codeController.text);
    if(couponResponse2.value.success==true){
      isVisable.value=false;
      isLoading3.value=false;
      CopunID=couponResponse2.value.data!.id;

      if(couponResponse2.value.data?.type=="fixed"
          &&(couponResponse2.value.data!.value!.toInt())<=totalPrice.value){
        discount.value=couponResponse2.value.data!.value!.toDouble();
        totalAfterDiscount.value=(totalPrice.value-discount.value) ;
        ToastClass.showCustomToast(context, "success".tr(), "sucess");
      }else if(couponResponse2.value.data?.type=="percentage"){
        discount.value=(totalPrice.value*((couponResponse2.value.data!.value!)/100)) ;
        totalAfterDiscount.value=(totalPrice.value-discount.value) ;
        ToastClass.showCustomToast(context, "success", "sucess");
      }
    }else{
      isVisable.value=false;
      codeController.clear();
      Fluttertoast.showToast(
          msg: couponResponse2.value.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
      );
    }
    return couponResponse2.value;
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  createOrder(
      BuildContext context,
      String deliveryDate,
      ) async {
    createOrderResponse.value = await repo.createOrderUpOnRequest(
      addressId.value,
      CopunID??0,
      orderType.value,
      deliveryDate,
      //payment.value=="payTaps"?"noon":payment.value,
      "noon",
      noteController.text,
      totalAfterDiscount.value.toString(),
      discount.value.toString(),
      totalPrice.value.toString(),
      productsJson.value,
      prefernceJson.value,
    );
    if (createOrderResponse.value.success == true) {
      isVisable.value=false;
     // await updateOrderStatus(context,"pending","");
      //onAlertButtonsPressed(context);
      if(payment.value=="cash") {
        CopunID = null;
        payment.value = "";
        isVisable2.value = false;
        codeController.clear();
        preferencesItem.clear();
        cartItem.clear();
        discount.value = 0.0;
        totalPrice.value = 0;
        deliveryCost.value = 0;
        urgentPrice.value = 0;
        itemPrices = [];
        quantityList.value = 0;
        itemPrices2.clear();
        noteController.clear();
        isSelected = false;
        addressType = "";
        itemId = -1;
        registerController.address2.value = "";
        totalAfterDiscount.value = 0.0;
        lights = false;
      }
      sharedPreferencesService.setInt("orderId",createOrderResponse.value.data!.id!);
    } else {
      isVisable.value=false;
      isVisable2.value=false;
      print(createOrderResponse.value.message);
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(createOrderResponse.value.message.toString()),
        ),
      );
    }
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  updateOrderStatus(BuildContext context,String Stu,String transactionId)async{
    //isLoading.value=true;
    updateStatusResponse.value = await repo.updateOrderStatus(createOrderResponse.value.data!.id!, Stu,transactionId,"");
    if(updateStatusResponse.value.success==true){
      //isLoading.value=false;
      if(payment.value=="tabby"){
        updatePaymentStatus(context,"paid","");
      }
      onAlertButtonsPressed(context);
    }else{
      isLoading.value=false;
      // ignore: use_build_context_synchronously
      Fluttertoast.showToast(
          msg: updateStatusResponse.value.message??"",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
      );
    }
    return updateStatusResponse.value;
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  updateOrderStatusPayTaps(BuildContext context,String Stu,String transactionId)async{
    updateStatusResponse.value = await repo.updateOrderStatus(createOrderResponse.value.data!.id!, Stu,transactionId,"");
    return updateStatusResponse.value;
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  updatePaymentStatus(BuildContext context,String Stu,String transaction_id)async{
    //isLoading.value=true;
    updateStatusResponse.value = await repo.updatePaymentStatus(createOrderResponse.value.data!.id!, Stu,transaction_id);
    if(updateStatusResponse.value.success==true){
    }else{
      isLoading.value=false;
      // ignore: use_build_context_synchronously
      Fluttertoast.showToast(
          msg: updateStatusResponse.value.message??"",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
      );
    }
    return updateStatusResponse.value;
  }

  onAlertButtonsPressed(context) {
    Alert(
      context: context,
      image: SvgPicture.asset('assets/success2.svg',),
      title: 'request_completed_successfully'.tr(),
      style:  AlertStyle(
          titleStyle:TextStyle(fontSize: 12.sp,
              fontFamily: 'alexandria_bold',
              fontWeight: FontWeight.w500,
              color: MyColors.MainBulma),
          descStyle: TextStyle(fontSize: 10.sp,
              fontFamily: 'alexandria_regular',
              fontWeight: FontWeight.w300,
              color: MyColors.MainTrunks)
      ),
      desc: 'the_order_was_made_successfully3'.tr(),
      buttons: [
        DialogButton(
          radius: BorderRadius.circular(15),
          height: 7.h,
          onPressed: ()  {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          color: MyColors.MainPrimary,
          child: Text('home'.tr(),
              style:  TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'regular',
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
        ),
      ],
    ).show();
  }

  onAlertButtonsFailer(context) {
    Alert(
      context: context,
      image: SvgPicture.asset('assets/error_solid.svg',),
      //title: 'basket_ordered'.tr(),
      style:  AlertStyle(
          titleStyle:TextStyle(fontSize: 12.sp,
              fontFamily: 'alexandria_bold',
              fontWeight: FontWeight.w500,
              color: MyColors.MainBulma),
          descStyle: TextStyle(fontSize: 10.sp,
              fontFamily: 'alexandria_regular',
              fontWeight: FontWeight.w300,
              color: MyColors.MainTrunks)
      ),
      desc: 'error_creating'.tr(),
      buttons: [
        DialogButton(
          radius: BorderRadius.circular(15),
          height: 7.h,
          onPressed: ()  {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          color: MyColors.MainPrimary,
          child: Text('home'.tr(),
              style:  TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'regular',
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
        ),
      ],
    ).show();
  }

  getUrgentPrice(String from)async{
    //isLoading.value=true;
    urgentPriceResponse.value = await repo.getUrgentPrice();
    if(urgentPriceResponse.value.success==true){
      //isLoading.value=false;
      isUrgent.value = false;
      if(from=="address"){
        urgentPrice.value=0;
        urgentPriceTxt.value=urgentPriceResponse.value.data?.urgentPrice?.value??"";
        calculateTotalPrice();
      }else{
        urgentPrice.value=int.parse(urgentPriceResponse.value.data!.urgentPrice!.value!);
        urgentPriceTxt.value=urgentPriceResponse.value.data?.urgentPrice?.value??"";
        calculateTotalPrice();
      }

    }
    return urgentPriceResponse.value;
  }
}