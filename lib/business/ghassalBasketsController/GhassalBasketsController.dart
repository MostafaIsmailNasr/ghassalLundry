
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ghassal_laundry/business/dropOffController/DropOffController.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';

import '../../conustant/di.dart';
import '../../conustant/my_colors.dart';
import '../../conustant/shared_preference_serv.dart';
import '../../conustant/toast_class.dart';
import '../../data/model/UpdateStatusModel/UpdateStatusResponse.dart';
import '../../data/model/addressModel/addressListModel/AddressListResponse.dart';
import '../../data/model/basketModel/BasketListResponse.dart';
import '../../data/model/copunModel/CopunResponse.dart';
import '../../data/model/createOrderModel/CreateOrderResponse.dart';
import '../../data/model/preferencesModel/PreferencesResponse.dart';
import '../../data/model/selectedBasketModel/SelectedBasketModel.dart';
import '../../data/model/socialModel/SocialResponse.dart';
import '../../data/model/urgentPriceModel/UrgentPriceResponse.dart';
import '../../data/reposatory/repo.dart';
import '../../data/web_service/WebServices.dart';
import '../auth/registerController/RegisterController.dart';

class GhassalBasketsController extends GetxController {
  Repo repo = Repo(WebService());
  var basketListResponse = BasketListResponse().obs;
  var preferencesResponse = PreferencesResponse().obs;
  var addressListResponse = AddressListResponse().obs;
  var couponResponse2 = copunResponse().obs;
  var createOrderResponse = CreateOrderResponse().obs;
  var updateStatusResponse = UpdateStatusResponse().obs;
  var urgentPriceResponse =UrgentPriceResponse().obs;

  var isLoading = false.obs;
  var isLoading2 = false.obs;
  Rx<bool> isVisable = false.obs;
  Rx<bool> isUrgent = false.obs;
  Rx<bool> isVisable2 = false.obs;
  var isSelected=false;
  var isIroningSelected=true.obs;
  var lights=false;

  RxList<dynamic> basketList=[].obs;
  RxList<dynamic> preferencesList=[].obs;
  RxList<dynamic> addressList=[].obs;
  RxList<dynamic> selectedProductList = [].obs;
  List<Baskets> basketItem = [];
  List<Baskets> basketItemSelected = [];
  List<Preferences> preferencesItem = [];
  List<int> itemPrices = [];
  List<int> qulList = [];
  RxMap<int, int> itemPrices2 = RxMap<int, int>();
  Rx<String> productsJson="".obs;
  Rx<String> productsJson2="".obs;
  Rx<String> prefersJson="".obs;

  TextEditingController codeController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  final SharedPreferencesService sharedPreferencesService =
  instance<SharedPreferencesService>();

  var quantityList=0.obs;
  var discount=0.0.obs;
  int? itemId=0;
  var deliveryCost=0.obs;
  var itemIroningId=1.obs;
  var totalPrice=0.obs;
  var totalAfterDiscount=0.0.obs;
  var urgentPrice=0.obs;

  var urgentPriceTxt="".obs;
  var addressType="";
  var orderType='normal'.obs;
  //taby//
  String status = 'idle';
  TabbySession? session;
  var payment="".obs;
  var homeStreetName="".obs,homeAddressId="";
  var homeLat;
  var workLat;
  var workLng;
  var homeLng;
  var workStreetName="".obs,workAddressId="";
  var CopunID;
  var selectedBaskets;
  var addressId="".obs;

  final registerController = Get.put(RegisterController());
  //final dropOffController = Get.put(DropOffController());


  int getItemPrice(int productId) {
    return itemPrices2[productId] ?? 0;
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  ///call it in select basket screen
  getBasketsList(String lat, String lng)async{
    isLoading.value=true;
    basketListResponse.value = await repo.getBaskets(lat, lng);
    if(basketListResponse.value.success==true){
      isLoading.value=false;
      basketList.value=basketListResponse.value.data?.baskets as List;
      getPreferences(lat,lng);
    }else{
      isLoading.value=false;
    }
    return basketListResponse.value;
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  ///call it in selected basket screen to make basket selected
  getBasketsSelectedList(String lat, String lng)async{
    isLoading.value=true;
    basketListResponse.value = await repo.getBaskets(lat, lng);
    if(basketListResponse.value.success==true){
      isLoading.value=false;
      basketList.value=basketListResponse.value.data?.baskets as List;
      qulList = List.filled(basketList.length, 0);
      for(int i=0;i<basketList.length;i++){
        if(basketList[i].id==selectedBaskets.id){
          qulList[i]=selectedBaskets.quantity!;
          break;
        }
      }
      //getPreferences(lat,lng);
    }
    return basketListResponse.value;
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  getPreferences(String lat,String lng)async{
    isLoading.value=true;
    preferencesResponse.value = await repo.getPreferences(lat, lng);
    if(preferencesResponse.value.success==true){
      isLoading.value=false;
      preferencesList.value=preferencesResponse.value.data?.preferences as List;
      // for(int i=0;i<preferencesList.length;i++){
      //   int uniqueId = DateTime.now().millisecondsSinceEpoch;
      //   preferencesList[i].unIq=uniqueId;
      // }
    }
    return preferencesResponse.value;
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  ///to get first home address and work address if exist in list
  getAddressList(BuildContext context)async{
    isLoading.value=true;
    addressListResponse.value = await repo.getAddress();
    if(addressListResponse.value.success==true){
      isLoading.value=false;
      await getUrgentPrice("address");
      addressList.value=addressListResponse.value.data as List;
      if(addressListResponse.value.data!.isEmpty){

      }else{
        bool homeAddressFound = false;
        bool workAddressFound = false;
        if(addressList.isNotEmpty) {
          for (int i = 0; i < addressList.length; i++) {
            if (!homeAddressFound &&
                addressListResponse.value.data?[i].type == 'home') {
              // Store the home address details
              homeStreetName.value =
                  addressListResponse.value.data?[i].streetName ?? "";
              homeAddressId = addressListResponse.value.data![i].id.toString();
              homeLat=addressListResponse.value.data![i].lat;
              homeLng=addressListResponse.value.data![i].lng;
              homeAddressFound = true;
            }
            if (!workAddressFound &&
                addressListResponse.value.data?[i].type == 'work') {
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
    return addressListResponse.value;
  }

  ///this func to convert obj to json to put it in selected list to display it in first of screen
  String convertBasketListToJson(List<Baskets> productsList) {
    List<SelectedBasketsModel> productListJson = [];
    List<SelectedBasketsModel2> productListJson2 = [];
    productsList.forEach((product) {

      productListJson.add(SelectedBasketsModel(
        basketId: product.id,
        price: isIroningSelected == true && itemIroningId == 1
            ? product.priceWash ?? 0
            : product.priceIroning ?? 0,
        quantity: product.quantity,
        washType: product.washType,
        //isIroningSelected == true && itemIroningId == 1 ? 0 : 1,
        type: "baskets",
        prefrences: product.preferences2//preferencesList,
      ));

      productListJson2.add(SelectedBasketsModel2(
        basketId: product.id,
        price: isIroningSelected.value == true && itemIroningId.value == 1
            ? product.priceWash ?? 0
            : product.priceIroning ?? 0,
        quantity: product.quantity,
        washType: isIroningSelected.value == true && itemIroningId.value == 1 ? 0 : 1,
        type: "baskets",
        prefrences: product.preferences2,//preferencesList,
        name: product.title
      ));
    });

    print("fg "+productListJson2.toString());
    selectedProductList.value=productListJson2;
    return jsonEncode(productListJson);
  }

  ///this func to convert obj to json to send it to api
  String convertBasketListToJson2(List<Baskets> productsList) {
    List<SelectedBasketsModel> productListJson = [];
    List<SelectedBasketsModel2> productListJson2 = [];
    productsList.forEach((product) {

      productListJson2.add(SelectedBasketsModel2(
          basketId: product.id,
          price:
          product.washType == 0
              ? product.priceWash ?? 0
              : product.priceIroning ?? 0,
          quantity: product.quantity,
          washType: product.washType,
          type: "baskets",
          prefrences: product.preferences2, //preferencesList,
      ));

    });

    print("fg "+jsonEncode(productListJson2).toString());
    //selectedProductList.value=productListJson2;
    return jsonEncode(productListJson2);
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  validateCoupon(BuildContext context)async{
    isLoading2.value=true;
    couponResponse2.value = await repo.validateCoupon(codeController.text);
    if(couponResponse2.value.success==true){
      isVisable.value=false;
      isLoading2.value=false;
      CopunID=couponResponse2.value.data!.id;

      if(couponResponse2.value.data?.type=="fixed"
          &&(couponResponse2.value.data!.value!.toInt())<=totalPrice.value){
        discount.value=couponResponse2.value.data!.value!.toDouble();
        totalAfterDiscount.value=(totalPrice.value-discount.value) ;
        Fluttertoast.showToast(
            msg:  "success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,backgroundColor: Colors.green
        );
      }else if(couponResponse2.value.data?.type=="percentage"){
        discount.value=(totalPrice.value*((couponResponse2.value.data!.value!)/100)) ;
        totalAfterDiscount.value=(totalPrice.value-discount.value) ;
        Fluttertoast.showToast(
            msg:  "success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,backgroundColor: Colors.green
        );

      }
    }else{
      isVisable.value=false;
      codeController.clear();
      // promocode.value="";
      Fluttertoast.showToast(
          msg:  couponResponse2.value.message??"",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
      );
    }
    return couponResponse2.value;
  }

  ///this func to calculate total price of basket
  int calculateTotalPrice() {
    var totalPrice1 = 0.obs;
    var total=0.obs;
    //setState(() {

    print("mvb "+basketItemSelected.length.toString());

      for (int i=0;i<basketItemSelected.length;i++) {
        var prefprice=0;
        print("mvb2 "+basketItemSelected[i].preferences2!.length.toString());
        if(basketItemSelected[i].preferences2!=[]){
          for(int j=0;j<basketItemSelected[i].preferences2!.length;j++){
            print("mvb3 "+basketItemSelected[i].preferences2![j].price!.toString());
            prefprice += basketItemSelected[i].preferences2![j].price!??0;
          }
        }

        if(basketItemSelected[i].washType==0){
          totalPrice1.value += ((basketItemSelected[i].priceWash??0)+prefprice) * (basketItemSelected[i].quantity ?? 0);
        }else{
          totalPrice1.value += ((basketItemSelected[i].priceIroning??0)+prefprice) * (basketItemSelected[i].quantity ?? 0);
        }
      }
      print("jkhjhj"+totalPrice1.toString());
       total.value=totalPrice1.value+deliveryCost.value+urgentPrice.value;
      totalPrice.value=total.value;
      totalAfterDiscount.value=total.toDouble();
    //});
    return total.value;
  }


  ///this func connect with repo and repo connect with webservice to handle success of response
  createOrder(
      BuildContext context,
      String deliveryDate,
      ) async {
    createOrderResponse.value = await repo.createOrderBasket(
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
      productsJson2.value,
    );
    if (createOrderResponse.value.success == true) {
      isVisable.value=false;
      if(payment.value=="cash") {
        CopunID = null;
        codeController.clear();
        basketItem.clear();
        discount.value = 0.0;
        totalPrice.value = 0;
        itemPrices = [];
        quantityList.value = 0;
        deliveryCost.value = 0;
        itemPrices2.clear();
        isVisable2.value = false;
        basketItemSelected.clear();
        noteController.clear();
        isSelected = false;
        addressType = "";
        itemId = -1;
        registerController.address2.value = "";
        totalAfterDiscount.value = 0.0;
        lights = false;
        selectedProductList.clear();
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

  onAlertButtonsPressed(context) {
    Alert(
      context: context,
      image: SvgPicture.asset('assets/success2.svg',),
      title: 'basket_ordered'.tr(),
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
      desc: 'the_order_was_made_successfully'.tr(),
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

  ///this func connect with repo and repo connect with webservice to handle success of response
  ///this func call in success of payment only to convert status to pending to make order visable to client
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
      Fluttertoast.showToast(
          msg: updateStatusResponse.value.message??"",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
      );
    }
    return updateStatusResponse.value;
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