
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
import '../../data/model/basketModel/BasketListResponse.dart';
import '../../data/model/copunModel/CopunResponse.dart';
import '../../data/model/createOrderModel/CreateOrderResponse.dart';
import '../../data/model/preferencesModel/PreferencesResponse.dart';
import '../../data/model/resubscribtionModel/ResubscribtionResponse.dart';
import '../../data/model/selectedBasketModel/SelectedBasketModel.dart';
import '../../data/model/selectedSubscriptionModel/SelectedSubscriptionModel.dart';
import '../../data/model/subscriptionsModel/SubscriptionsResponse.dart';
import '../../data/model/urgentPriceModel/UrgentPriceResponse.dart';
import '../../data/reposatory/repo.dart';
import '../../data/web_service/WebServices.dart';
import '../../ui/screen/buttomNavigation/drower.dart';
import '../auth/registerController/RegisterController.dart';
import '../homeController/HomeController.dart';

class GhassalSubscriptionController extends GetxController {
  Repo repo = Repo(WebService());
  var couponResponse2 = copunResponse().obs;
  var addressListResponse = AddressListResponse().obs;
  var preferencesResponse = PreferencesResponse().obs;
  var subscriptionsResponse = SubscriptionsResponse().obs;
  var createOrderResponse = CreateOrderResponse().obs;
  var updateStatusResponse = UpdateStatusResponse().obs;
  var resubscribtionResponse = ResubscribtionResponse().obs;
  var basketListResponse = BasketListResponse().obs;
  var urgentPriceResponse =UrgentPriceResponse().obs;

  RxList<dynamic> addressList=[].obs;
  RxList<dynamic> preferencesList=[].obs;
  RxList<dynamic> subscriptionList=[].obs;
  RxList<dynamic> basketList=[].obs;
  List<Subscribtions> subscriptionItem = [];
  List<Preferences> preferencesItem = [];
  List<Baskets> basketItem = [];
  RxList<dynamic> selectedProductList = [].obs;
  List<int> itemPrices = [];
  Rx<String> productsJson="".obs;
  Rx<String> prefernceJson="".obs;

  TextEditingController codeController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  final SharedPreferencesService sharedPreferencesService =
  instance<SharedPreferencesService>();

  var isLoading = false.obs;
  var isLoading2 = false.obs;
  Rx<bool> isVisable = false.obs;
  Rx<bool> isVisable2 = false.obs;
  Rx<bool> isVisableCustom = true.obs;
  var isSelected=false;
  var isSelectedBasket=false;
  var isSelectedAddress=false;
  var lights=false;
  var isIroningSelected=true.obs;
  RxMap<int, int> itemPrices2 = RxMap<int, int>();

  int? itemId=0;
  int? itemIdBasket=0;
  int? itemIdAddress=0;
  var subscriptionId=0.obs;
  var quantityList=0.obs;
  var itemIroningId=1.obs;
  var discount=0.0.obs;
  var totalPrice=0.obs;
  var totalAfterDiscount=0.0.obs;
  var totalReSubscriptionPrice=0.0.obs;
  var urgentPrice=0.obs;
  var deliveryCost=0.obs;

  var urgentPriceTxt="".obs;
  var addressType="";
  Rx<bool> isUrgent = false.obs;
  var payment="".obs;
  var orderType='normal'.obs;
  var moreSelected=false.obs;
  var homeStreetName="".obs,homeAddressId="";
  var workStreetName="".obs,workAddressId="";
  var homeLat;
  var workLat;
  var workLng;
  var homeLng;
  //taby//
  String status = 'idle';
  TabbySession? session;
  var addressId="".obs;
  var CopunID;
  var quantity=0.obs;
  final homeController = Get.put(HomeController());

  final registerController = Get.put(RegisterController());

  int getItemPrice(int productId) {
    return itemPrices2[productId] ?? 0;
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  getBasketsList(String lat, String lng)async{
    isLoading.value=true;
    basketListResponse.value = await repo.getBaskets(lat, lng);
    if(basketListResponse.value.success==true){
      isLoading.value=false;
      basketList.value=basketListResponse.value.data?.baskets as List;
      getPreferences(lat,lng);
    }
    return basketListResponse.value;
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  ///to get first home address and work address if exist in list
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
            if (!homeAddressFound &&
                addressListResponse.value.data?[i].type == 'home') {
              // Store the home address details
              homeStreetName.value =
                  addressListResponse.value.data?[i].streetName ?? "";
              homeAddressId = addressListResponse.value.data![i].id.toString();
              homeLat=  addressListResponse.value.data![i].lat;
              homeLng=  addressListResponse.value.data![i].lng;
              homeAddressFound = true;
            }
            if (!workAddressFound &&
                addressListResponse.value.data?[i].type == 'work') {
              workStreetName.value =
                  addressListResponse.value.data?[i].streetName ?? "";
              print("ccccx " + workStreetName.value.toString());
              workAddressId = addressListResponse.value.data![i].id.toString();
              workLat=  addressListResponse.value.data![i].lat;
              workLng=  addressListResponse.value.data![i].lng;
              workAddressFound = true;
            }
            // Break the loop if both home and work addresses are found
            if (homeAddressFound && workAddressFound) {
              break;
            }
          }
        }
      }
      await getSubscriptions(registerController.lat.toString(), registerController.lng.toString());
      await getUrgentPrice("address");
      await getUrgentPriceReSub("address");
    }
    return addressListResponse.value;
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  getSubscriptions(String lat,String lng)async{
    isLoading.value=true;
    subscriptionsResponse.value = await repo.getSubscriptions(lat, lng);
    if(subscriptionsResponse.value.success==true){
      isLoading.value=false;
      subscriptionList.value=subscriptionsResponse.value.data?.subscribtions as List;
      getPreferences( lat, lng);
    }else{
      isLoading.value=false;
    }
    return preferencesResponse.value;
  }

  ///this func connect with repo and repo connect with webservice to handle success of response
  getPreferences(String lat,String lng)async{
    isLoading.value=true;
    preferencesResponse.value = await repo.getPreferences(lat, lng);
    if(preferencesResponse.value.success==true){
      isLoading.value=false;
      preferencesList.value=preferencesResponse.value.data?.preferences as List;
    }
    return preferencesResponse.value;
  }

  ///this func to convert obj to json to put it in selected list to display it in first of screen
  String convertBasketListToJson(List<Subscribtions> productsList) {
    List<SelectedSubscriptionModel> productListJson = [];
    productsList.forEach((product) {
      productListJson.add(SelectedSubscriptionModel(
          subscribtionId:  product.id,
          subscribtionType: product.subscriptionType,
          price: product.price.toString(),//price.value,
          quantity: product.quantity,
          washType: product.washType,
          type: "subscribtions",
      ));
    });

    print("fg "+productListJson.toString());
    return jsonEncode(productListJson);
  }

  ///this func to convert obj to json to send it to api
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

  ///this func to calculateTotal price of sub
  int calculateTotalPrice() {
    var totalPrice1 = 0.obs;
    var total=0.obs;

    print("mvb "+subscriptionItem.length.toString());

    for (int i=0;i<subscriptionItem.length;i++) {
      totalPrice1.value += (subscriptionItem[i].price??0);
      quantity.value=(subscriptionItem[i].quantity!);
    }
    var prefprice=0;
    print("mvb2 "+preferencesItem.length.toString());
      if(preferencesItem!=[]){
        for(int j=0;j<preferencesItem.length;j++){
          print("mvb3 "+preferencesItem[j].price!.toString());
          prefprice += preferencesItem[j].price??0;
        }
      }
       total.value=((totalPrice1.value)*quantity.value)+prefprice+urgentPrice.value+deliveryCost.value;
    print("jkhjhj"+total.toString());
    totalPrice.value=total.value;
    totalAfterDiscount.value=total.toDouble();
    print("jkhjhj2"+totalPrice.value.toString());
    return total.value;
  }

  ///this func to calculateTotal price of custom basket of sub
  int calculateTotalBaskets() {
    var totalPrice1 = 0.obs;
    var total=0.obs;

    for (int i=0;i<basketItem.length;i++) {
      var prefprice=0;
      print("mvb2 "+basketItem[i].preferences2!.length.toString());
      if(basketItem[i].preferences2!=[]){
        for(int j=0;j<basketItem[i].preferences2!.length;j++){
          print("mvb3 "+basketItem[i].preferences2![j].price!.toString());
          prefprice += basketItem[i].preferences2![j].price!??0;
        }
      }

      if(basketItem[i].washType==0){
        totalPrice1.value += ((basketItem[i].priceWash??0)+prefprice) * (basketItem[i].quantity ?? 0);
      }else{
        totalPrice1.value += ((basketItem[i].priceIroning??0)+prefprice) * (basketItem[i].quantity ?? 0);
      }
    }
    print("jkhjhj"+totalPrice1.toString());
    total.value=totalPrice1.value+deliveryCost.value+urgentPrice.value;
    totalPrice.value=total.value;
    totalAfterDiscount.value=total.toDouble();
    return total.value;
  }

  ///this func to calculateTotal price of resub
  double calculateTotalReSubscription() {
    var total=0.0.obs;

    var prefprice=0.0;
    print("mvb2 "+preferencesItem.length.toString());
    if(preferencesItem!=[]){
      for(int j=0;j<preferencesItem.length;j++){
        print("mvb3 "+preferencesItem[j].price!.toString());
        prefprice += preferencesItem[j].price??0;
      }
    }
    total.value=prefprice+urgentPrice.value+deliveryCost.value;
    print("jkhjhj"+total.toString());
    totalReSubscriptionPrice.value=total.value;
    print("jkhjhj2"+totalReSubscriptionPrice.value.toString());
    return total.value;
  }

  ///this func to convert obj to json to send it to api resub
  String convertBasketSubToJson(List<Baskets> productsList) {
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
          type: "baskets",
          prefrences: product.preferences2
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
        ToastClass.showCustomToast(context, "success".tr(), "sucess");
      }else if(couponResponse2.value.data?.type=="percentage"){
        discount.value=(totalPrice.value*((couponResponse2.value.data!.value!)/100)) ;
        totalAfterDiscount.value=(totalPrice.value-discount.value) ;
        ToastClass.showCustomToast(context, "success", "sucess");
      }
    }else{
      isVisable.value=false;
      codeController.clear();
      // promocode.value="";
      Fluttertoast.showToast(
          msg: couponResponse2.value.message??"",
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
    createOrderResponse.value = await repo.createOrderSubscription(
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
      prefernceJson.value
    );
    if (createOrderResponse.value.success == true) {
      isVisable.value=false;
      //await updateOrderStatus(context,"pending","");
      //onAlertButtonsPressed(context);
      if(payment.value=="cash") {
        CopunID = null;
        isVisable2.value = false;
        codeController.clear();
        subscriptionItem.clear();
        discount.value = 0.0;
        totalPrice.value = 0;
        deliveryCost.value = 0;
        preferencesItem.clear();
        noteController.clear();
        isSelected = false;
        addressType = "";
        itemId = -1;
        prefernceJson.value = "";
        registerController.address2.value = "";
        totalAfterDiscount.value = 0.0;
        lights = false;
      }
      sharedPreferencesService.setInt(
          "orderId", createOrderResponse.value.data!.id!);
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
  updateOrderStatus(BuildContext context,String Stu,String transactionId,String reSub)async{
    if(reSub!="reSub") {
      updateStatusResponse.value = await repo.updateOrderStatus(
          createOrderResponse.value.data!.id!, Stu, transactionId,"");
      if (updateStatusResponse.value.success == true) {

        if (payment.value == "tabby") {
          updatePaymentStatus(context, "paid", "","");
        }
        onAlertButtonsPressed(context);

      } else {
        isLoading.value = false;
        Fluttertoast.showToast(
            msg: updateStatusResponse.value.message ?? "",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
        );
      }
    }else{
      updateStatusResponse.value = await repo.updateOrderStatus(
          resubscribtionResponse.value.data!.order!.id!, Stu, transactionId,"");
      if (updateStatusResponse.value.success == true) {
          if(payment.value=="tabby"){
            updatePaymentStatus(context,"paid","","reSub");
          }
          onAlertReSub(context);

      } else {
        isLoading.value = false;
        Fluttertoast.showToast(
            msg: updateStatusResponse.value.message ?? "",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
        );
      }
    }
    return updateStatusResponse.value;
  }

  updateOrderStatusPayTaps(BuildContext context,
      String Stu,
      String transactionId,
      String reSub,String userId)async{
    if(reSub!="reSub") {
      updateStatusResponse.value = await repo.updateOrderStatus(
          createOrderResponse.value.data!.id!, Stu, transactionId,userId);
    }else{
      updateStatusResponse.value = await repo.updateOrderStatus(
          resubscribtionResponse.value.data!.order!.id!, Stu, transactionId,userId);
    }
    return updateStatusResponse.value;
  }

  updatePaymentStatus(BuildContext context,String Stu,String transaction_id,String reSub)async{
    //isLoading.value=true;
    if(reSub!="reSub") {
      updateStatusResponse.value = await repo.updatePaymentStatus(
          createOrderResponse.value.data!.id!, Stu, transaction_id);
    }else{
      updateStatusResponse.value = await repo.updatePaymentStatus(
          resubscribtionResponse.value.data!.order!.id!, Stu, transaction_id);
    }
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

  onAlertButtonsPressed(context) {
    Alert(
      context: context,
      image: SvgPicture.asset('assets/success2.svg',),
      title: 'you_successfully_subscribed'.tr(),
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
      desc: "${'the_order_was_made_successfully2'.tr()}${quantity.value}${"basket_month".tr()}",
      buttons: [
        DialogButton(
          radius: BorderRadius.circular(15),
          height: 7.h,
          onPressed: ()  {
            Navigator.pop(context);
            Navigator.pop(context);
            homeController.getHomeData(registerController.lat.toString(), registerController.lng.toString(),context);
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
            homeController.getHomeData(registerController.lat.toString(), registerController.lng.toString(),context);
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

  onAlertReSub(context) {
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
      desc: "${"basket_ordered2".tr()} ${resubscribtionResponse.value.data?.usedBaskets.toString()??""} ${"baskets".tr()}",
      buttons: [
        DialogButton(
          radius: BorderRadius.circular(15),
          height: 7.h,
          onPressed: ()  {
            Navigator.pop(context);
            Navigator.pop(context);
            homeController.getHomeData(registerController.lat.toString(), registerController.lng.toString(),context);
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
  reSubscription(BuildContext context,
      String deliveryDate,int id)async{
    resubscribtionResponse.value = await repo.reSubscription(
        addressId.value,
        deliveryDate,
        noteController.text,
        prefernceJson.value,
        id,
        deliveryCost.value,
        orderType.value,totalReSubscriptionPrice.value.toString(),"noon"
    );
    if (resubscribtionResponse.value.success == true) {
      isVisable.value=false;
      isVisable2.value=false;
      //await updateOrderStatus(context,"pending","");
      preferencesItem.clear();
      noteController.clear();
      isSelected=false;
      addressType="";
      itemId=-1;
      prefernceJson.value="";
      registerController.address2.value="";
      lights=false;
      urgentPrice.value=0;
      deliveryCost.value=0;
     preferencesList.forEach((item) {
       item.isChecked = false;
     });
      sharedPreferencesService.setInt("orderId",resubscribtionResponse.value.data!.order!.id!);
    } else {
      isVisable.value=false;
      isVisable2.value=false;
      print(resubscribtionResponse.value.message);
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(resubscribtionResponse.value.message.toString()),
        ),
      );
    }
  }

  getUrgentPrice(String from)async{
    //isLoading.value=true;
    urgentPriceResponse.value = await repo.getUrgentPrice();
    if(urgentPriceResponse.value.success==true){
      //isLoading.value=false;
      isUrgent.value=false;
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

  getUrgentPriceReSub(String from)async{
    //isLoading.value=true;
    urgentPriceResponse.value = await repo.getUrgentPrice();
    if(urgentPriceResponse.value.success==true){
      //isLoading.value=false;
      isUrgent.value=false;
      if(from=="address"){
        urgentPrice.value=0;
        urgentPriceTxt.value=urgentPriceResponse.value.data?.urgentPrice?.value??"";
        calculateTotalReSubscription();
      }else{
        urgentPrice.value=int.parse(urgentPriceResponse.value.data!.urgentPrice!.value!);
        urgentPriceTxt.value=urgentPriceResponse.value.data?.urgentPrice?.value??"";
        calculateTotalReSubscription();
      }

    }
    return urgentPriceResponse.value;
  }



}