import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkApms.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTokeniseType.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';

import '../../../../business/auth/registerController/RegisterController.dart';
import '../../../../business/dropOffController/DropOffController.dart';
import '../../../../business/ghassalSubscriptionController/GhassalSubscriptionController.dart';
import '../../../../business/homeController/HomeController.dart';
import '../../../../conustant/my_colors.dart';
import '../../../../conustant/toast_class.dart';
import '../../../../data/model/preferencesModel/PreferencesResponse.dart';
import '../../buttomNavigation/drower.dart';
import '../../buttomSheets/authSheets/auth/auth_buttom_sheet.dart';
import '../../buttomSheets/choosePymentSheet/choose_pyment_sheet.dart';
import '../../buttomSheets/dropDownTimeButtomSheet/drop_down_time_buttomSheet.dart';

class HomeBasketSubScreen extends StatefulWidget{
  int userId;

  HomeBasketSubScreen({required this.userId});

  @override
  State<StatefulWidget> createState() {
    return _HomeBasketSubScreen();
  }
}

class _HomeBasketSubScreen extends State<HomeBasketSubScreen>{
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  final homeController = Get.put(HomeController());
  final registerController = Get.put(RegisterController());
  final dropOffController = Get.put(DropOffController());
  final ghassalSubscriptionController = Get.put(GhassalSubscriptionController());
  Preferences? preferences;
  var con=true;

  Future<void> check()async{
    final hasInternet = await InternetConnectivity().hasInternetConnection;
    setState(() {
      con = hasInternet;
    });
  }

  @override
  void initState() {
    super.initState();
    check();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      clearData();
      ghassalSubscriptionController.isIroningSelected.value=true;
      ghassalSubscriptionController.itemIroningId.value=1;
      ghassalSubscriptionController.isSelectedBasket=true;
      ghassalSubscriptionController.itemIdBasket=1;
      if(ghassalSubscriptionController.sharedPreferencesService.getBool("islogin")==true) {
        ghassalSubscriptionController.getAddressList(context);
      }else{
        ghassalSubscriptionController.isLoading.value=false;
        ghassalSubscriptionController.homeAddressId="";
        ghassalSubscriptionController.homeStreetName.value="";
        ghassalSubscriptionController.workAddressId="";
        ghassalSubscriptionController.workStreetName.value="";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return con? Obx(() => !ghassalSubscriptionController.isLoading.value?
    Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Transform.rotate(
                angle:homeController.lang=="en"? 180 *math.pi /180:0,
                child: SvgPicture.asset('assets/back.svg',))),
        title: Text('subscription_package'.tr(),
            style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'alexandria_bold',
                fontWeight: FontWeight.w500,
                color: MyColors.MainBulma)),
      ),
      body: Container(
        margin: EdgeInsetsDirectional.only(start: 2.h,end: 2.h,top: 1.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              address(),
              SizedBox(height: 2.h,),
              receivingDate(),
              SizedBox(height: 1.h,),
              // payment(),
              // SizedBox(height: 1.h,),
              Text("preferences".tr(),
                  style:  TextStyle(fontSize: 10.sp,
                      fontFamily: 'alexandria_bold',
                      fontWeight: FontWeight.w500,
                      color:MyColors.MainBulma)),
              SizedBox(height: 1.h,),
              preferencesList(),
              SizedBox(height: 1.h,),
              notes(),
              SizedBox(height: 2.h,),
            ],
          ),
        ),
      ),
      bottomNavigationBar:  Container(
        color: Colors.white,
        height: 13.h,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 1.h,right: 1.h,top: 1.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("total".tr(),
                      style:  TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'alexandria_regular',
                          fontWeight: FontWeight.w600,
                          color: MyColors.Dark4)),
                  const Spacer(),
                  Text("${ghassalSubscriptionController.totalReSubscriptionPrice.value??"0"} ${"currency".tr()}",
                      style:  TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'alexandria_medium',
                          fontWeight: FontWeight.w600,
                          color: MyColors.MainBulma)),
                ],
              ),
            ),
            SizedBox(height: 1.h,),
            Obx(() => Visibility(
              visible: ghassalSubscriptionController.isVisable2.value,
              child: const CircularProgressIndicator(
                color: MyColors.MainPrimary,
              ),
            )),
            Obx(() => Visibility(
              visible: !ghassalSubscriptionController.isVisable2.value,
              child: Container(
                margin: EdgeInsetsDirectional.only(
                    start: 1.h,
                    end: 1.h,
                    top: 1.h
                ),
                width: double.infinity,
                height: 7.h,
                child:  TextButton(
                  style: flatButtonStyle,
                  onPressed: () async {
                    validation();
                  },
                  child: Text(
                    'request'.tr(),
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'regular',
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),

      /*Container(
          color: Colors.white,
          height: 9.h,
          child:
          Container(
            margin: EdgeInsetsDirectional.only(start: 1.h, end: 1.h,bottom: 1.h),
            width: double.infinity,
            height: 7.h,
            child: TextButton(
              style: flatButtonStyle,
              onPressed: () async {
                validation();
              },
              child: Text(
                'request'.tr(),
                style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'regular',
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          )
      ),*/
    ):
    const Scaffold(body: Center(child: CircularProgressIndicator(color: MyColors.MainPrimary,))),)
        :Scaffold(body: internet(),);
  }

  Widget internet(){
    return Container(
      color: MyColors.MainGoku,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      //padding: EdgeInsetsDirectional.only(top: 20.h,start: 1.h,end: 1.h),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/no_internet.svg'),
              SizedBox(height: 1.h,),
              Text('without_internet_connection'.tr(),
                style: TextStyle(fontSize: 14.sp,
                    fontFamily: 'alexandria_bold',
                    fontWeight: FontWeight.w600,
                    color: MyColors.MainTrunks),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h,),
              Text('reconnecting'.tr(),
                style: TextStyle(fontSize: 10.sp,
                    fontFamily: 'alexandria_regular',
                    fontWeight: FontWeight.w300,
                    color: MyColors.MainTrunks),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.5.h,),
              Container(
                margin: EdgeInsetsDirectional.only(start: 1.h, end: 1.h,),
                width: double.infinity,
                height: 7.h,
                child: TextButton(
                  style: flatButtonStyle,
                  onPressed: () async {
                    await check();
                    clearData();
                    ghassalSubscriptionController.isIroningSelected.value=true;
                    ghassalSubscriptionController.itemIroningId.value=1;
                    ghassalSubscriptionController.isSelectedBasket=true;
                    ghassalSubscriptionController.itemIdBasket=1;
                    if(ghassalSubscriptionController.sharedPreferencesService.getBool("islogin")==true) {
                      ghassalSubscriptionController.getAddressList(context);
                    }else{
                      ghassalSubscriptionController.isLoading.value=false;
                      ghassalSubscriptionController.homeAddressId="";
                      ghassalSubscriptionController.homeStreetName.value="";
                      ghassalSubscriptionController.workAddressId="";
                      ghassalSubscriptionController.workStreetName.value="";
                    }
                  },
                  child: Text(
                    'update'.tr(),
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'regular',
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget address(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("receiving_address".tr(),
            style:  TextStyle(fontSize: 11.sp,
                fontFamily: 'alexandria_bold',
                fontWeight: FontWeight.w500,
                color:MyColors.MainBulma)),
        SizedBox(height: 1.h,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ghassalSubscriptionController.addressList.isNotEmpty?
            Expanded(
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    ghassalSubscriptionController.preferencesList.forEach((item) {
                      item.isChecked = false;
                    });
                    clearData();
                    ghassalSubscriptionController.isSelected=true;
                    ghassalSubscriptionController.addressType="home";
                    ghassalSubscriptionController.itemId=1;
                    ghassalSubscriptionController.addressId.value=ghassalSubscriptionController.homeAddressId;
                    registerController.address2.value=ghassalSubscriptionController.homeStreetName.value;
                  });
                },
                child: Container(
                  height: 6.h,
                  padding: EdgeInsetsDirectional.all(0.5.h),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                        color: ghassalSubscriptionController.isSelected==true && ghassalSubscriptionController.itemId==1?MyColors.MainPrimary: MyColors.MainDisabledPrimary ,
                        width: 1.0,),
                      color: ghassalSubscriptionController.isSelected==true && ghassalSubscriptionController.itemId==1?MyColors.timeBack: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/home_smile.svg",color: ghassalSubscriptionController.isSelected==true && ghassalSubscriptionController.itemId==1?MyColors.MainPrimary: MyColors.MainDisabledPrimary,),
                      SizedBox(width: 1.h,),
                      Text("home2".tr(),
                          style:  TextStyle(fontSize: 8.sp,
                              fontFamily: 'alexandria_medium',
                              fontWeight: FontWeight.w400,
                              color:ghassalSubscriptionController.isSelected==true && ghassalSubscriptionController.itemId==1?MyColors.MainPrimary: MyColors.MainDisabledPrimary)),
                    ],
                  ),
                ),
              ),
            ):Container(width: 0.h,),
            ghassalSubscriptionController.addressList.isNotEmpty?
            SizedBox(width: 1.h,):SizedBox(width: 0.h,),
            ghassalSubscriptionController.addressList.isNotEmpty?
            Expanded(
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    ghassalSubscriptionController.preferencesList.forEach((item) {
                      item.isChecked = false;
                    });
                    clearData();
                    ghassalSubscriptionController.isSelected=true;
                    ghassalSubscriptionController.addressType="office";
                    ghassalSubscriptionController.itemId=2;
                    ghassalSubscriptionController.addressId.value=ghassalSubscriptionController.workAddressId;
                    registerController.address2.value=ghassalSubscriptionController.workStreetName.value;
                  });
                },
                child: Container(
                  height: 6.h,
                  padding: EdgeInsetsDirectional.all(0.5.h),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                        color: ghassalSubscriptionController.isSelected==true && ghassalSubscriptionController.itemId==2?MyColors.MainPrimary: MyColors.MainDisabledPrimary,
                        width: 1.0,),
                      color:  ghassalSubscriptionController.isSelected==true && ghassalSubscriptionController.itemId==2?MyColors.timeBack: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/buildings.svg",color: ghassalSubscriptionController.isSelected==true && ghassalSubscriptionController.itemId==2?MyColors.MainPrimary: MyColors.MainDisabledPrimary),
                      SizedBox(width: 1.h,),
                      Text("office".tr(),
                          style:  TextStyle(fontSize: 8.sp,
                              fontFamily: 'alexandria_medium',
                              fontWeight: FontWeight.w400,
                              color:ghassalSubscriptionController.isSelected==true && ghassalSubscriptionController.itemId==2?MyColors.MainPrimary: MyColors.MainDisabledPrimary)),
                    ],
                  ),
                ),
              ),
            ):Container(width: 0.h,),
            ghassalSubscriptionController.addressList.isNotEmpty?
            SizedBox(width: 1.h,):SizedBox(width: 0.h,),
            ghassalSubscriptionController.addressList.isNotEmpty?
            Expanded(
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    ghassalSubscriptionController.preferencesList.forEach((item) {
                      item.isChecked = false;
                    });
                    clearData();
                    ghassalSubscriptionController.isSelected=true;
                    ghassalSubscriptionController.addressType="another_address";
                    ghassalSubscriptionController.itemId=3;
                    if (ghassalSubscriptionController
                        .sharedPreferencesService
                        .getBool("islogin") ==
                        false) {
                      showModalBottomSheet<void>(
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20)),
                          ),
                          context: context,
                          backgroundColor: Colors.white,
                          builder: (BuildContext context) => Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context)
                                      .viewInsets
                                      .bottom),
                              child: AuthButtomSheet(from: "subscription")));
                    }else {
                      Navigator.pushNamed(context, "/location_screen",
                          arguments: "listAddress");
                    }
                  });
                },
                child: Container(
                  height: 6.h,
                  padding: EdgeInsetsDirectional.all(0.5.h),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                        color: ghassalSubscriptionController.isSelected==true && ghassalSubscriptionController.itemId==3?MyColors.MainPrimary: MyColors.MainDisabledPrimary,
                        width: 1.0,),
                      color:  ghassalSubscriptionController.isSelected==true && ghassalSubscriptionController.itemId==3?MyColors.timeBack: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/map0.svg",color: ghassalSubscriptionController.isSelected==true && ghassalSubscriptionController.itemId==3?MyColors.MainPrimary: MyColors.MainDisabledPrimary,),
                      SizedBox(width: 1.h,),
                      Expanded(
                        child: Text("another_address".tr(),
                            style:  TextStyle(fontSize: 8.sp,
                                fontFamily: 'alexandria_medium',
                                fontWeight: FontWeight.w400,
                                color:ghassalSubscriptionController.isSelected==true && ghassalSubscriptionController.itemId==3?MyColors.MainPrimary: MyColors.MainDisabledPrimary)),
                      ),
                    ],
                  ),
                ),
              ),
            )
                : GestureDetector(
              onTap: () {
                setState(() {
                  ghassalSubscriptionController.preferencesList.forEach((item) {
                    item.isChecked = false;
                  });
                  clearData();
                  ghassalSubscriptionController.isSelected = true;
                  ghassalSubscriptionController.addressType =
                  "another_address";
                  ghassalSubscriptionController.itemId = 3;
                  if (ghassalSubscriptionController
                      .sharedPreferencesService
                      .getBool("islogin") ==
                      false) {
                    showModalBottomSheet<void>(
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20)),
                        ),
                        context: context,
                        backgroundColor: Colors.white,
                        builder: (BuildContext context) => Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context)
                                    .viewInsets
                                    .bottom),
                            child: AuthButtomSheet(from: "subscription")));
                  }else {
                    Navigator.pushNamed(context, "/location_screen",
                        arguments: "listAddress");
                  }
                });
              },
              child: Container(
                height: 6.h,
                width: 15.h,
                padding: EdgeInsetsDirectional.all(0.5.h),
                decoration: BoxDecoration(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                      color:
                      ghassalSubscriptionController.isSelected == true &&
                          ghassalSubscriptionController.itemId == 3
                          ? MyColors.MainPrimary: MyColors.MainDisabledPrimary,
                      width: 1.0,
                    ),
                    color: ghassalSubscriptionController.isSelected == true &&
                        ghassalSubscriptionController.itemId == 3
                        ? MyColors.timeBack: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/map0.svg",
                      color:
                      ghassalSubscriptionController.isSelected == true &&
                          ghassalSubscriptionController.itemId == 3
                          ? MyColors.MainPrimary
                          : MyColors.MainSecondary,
                    ),
                    SizedBox(
                      width: 1.h,
                    ),
                    Expanded(
                      child: Text("another_address".tr(),
                          style: TextStyle(
                              fontSize: 8.sp,
                              fontFamily: 'alexandria_medium',
                              fontWeight: FontWeight.w400,
                              color: ghassalSubscriptionController
                                  .isSelected ==
                                  true &&
                                  ghassalSubscriptionController.itemId == 3
                                  ? MyColors.MainPrimary: MyColors.MainDisabledPrimary)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h,),
        Row(
          children: [
            SvgPicture.asset('assets/location2.svg',width: 2.h,height: 2.h,),
            SizedBox(width: 2.w,),
            SizedBox(
                width: 30.h,
                child:Obx(() =>registerController.address2.value!=""? Text(
                  registerController.address2.value.toString(),
                  style:  TextStyle(fontSize: 8.sp,
                      fontFamily: 'alexandria_regular',
                      fontWeight: FontWeight.w300,
                      color:MyColors.MainTrunks),maxLines: 2,)
                    :Text('add_delivery_location'.tr(),
                  style:TextStyle(fontSize: 8.sp,
                      fontFamily: 'alexandria_regular',
                      fontWeight: FontWeight.w300,
                      color:MyColors.MainTrunks),maxLines: 2,),
                )),

          ],
        ),
      ],
    );
  }

  Widget receivingDate(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("receiving_date".tr(),
            style:  TextStyle(fontSize: 11.sp,
                fontFamily: 'alexandria_bold',
                fontWeight: FontWeight.w500,
                color:MyColors.MainBulma)),
        SizedBox(height: 1.h,),
        GestureDetector(
          onTap: (){
            if (registerController.address2.value != "") {
              showModalBottomSheet<void>(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  context: context,
                  backgroundColor: Colors.white,
                  builder: (BuildContext context) => Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          dropDownTimeButtomSheet(
                            from: "homeBasketSub",
                          ),
                        ],
                      )));
            }else{
              Fluttertoast.showToast(
                  msg: "please_select_address".tr(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
              );
            }
          },
          child: Container(
            padding: EdgeInsetsDirectional.all(1.5.h),
            margin: EdgeInsetsDirectional.only(bottom: 1.h),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                  color:MyColors.MainGoku, width: 1,),
                color:  Colors.white),
            child: Row(
              children: [
                SvgPicture.asset("assets/calendar.svg"),
                SizedBox(width: 1.h,),
                SizedBox(
                  width: 32.h,
                  child:Obx(() => dropOffController.finalHomeBasketSubTime.value!=""?
                  Text(dropOffController.finalHomeBasketSubTime.value,
                      style:  TextStyle(fontSize: 12.sp,
                          fontFamily: 'alexandria_regular',
                          fontWeight: FontWeight.w300,
                          color:MyColors.MainTrunks))
                      : Text('select_date'.tr(),
                      style:  TextStyle(fontSize: 12.sp,
                          fontFamily: 'alexandria_regular',
                          fontWeight: FontWeight.w300,
                          color:MyColors.MainTrunks))),
                ),
                const Spacer(),
                Transform.rotate(
                    angle:homeController.lang=="en"? 180 *math.pi /180:0,
                    child: SvgPicture.asset('assets/alt_arrow.svg',))
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsetsDirectional.all(1.5.h),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              border: Border.all(
                color: MyColors.MainGoku, width: 1.0,),
              color:  MyColors.MainGoku),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset("assets/truck.svg"),
                      SizedBox(width: 1.h,),
                      Text("express_access_service".tr(),
                          style:  TextStyle(fontSize: 12.sp,
                              fontFamily: 'alexandria_medium',
                              fontWeight: FontWeight.w300,
                              color:MyColors.MainBulma)),

                      Container(
                        padding: EdgeInsetsDirectional.all(0.5.h),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                            border: Border.all(
                              color: MyColors.MainBeerus, width: 1.0,),
                            color:  MyColors.MainBeerus),
                        child: Text("${ghassalSubscriptionController.urgentPriceTxt.value} ${"currency".tr()}",
                            style:  TextStyle(fontSize: 6.sp,
                                fontFamily: 'alexandria_regular',
                                fontWeight: FontWeight.w400,
                                color:MyColors.MainTrunks)),
                      )
                    ],
                  ),
                  SizedBox(height: 1.h,),
                  SizedBox(
                    width: 30.h,
                    child: Text("representative".tr(),
                        style:  TextStyle(fontSize: 8.sp,
                            fontFamily: 'alexandria_regular',
                            fontWeight: FontWeight.w300,
                            color:MyColors.MainTrunks)),
                  ),
                ],
              ),

              Row(
                children: [
                  Obx(() => Visibility(
                      visible: ghassalSubscriptionController.isUrgent.value,
                      child: const CircularProgressIndicator(
                        color: MyColors.MainPrimary,
                      ))),
                  Obx(
                        () => ghassalSubscriptionController.isUrgent.value == true
                        ? Container():
                  CupertinoSwitch(
                      value: ghassalSubscriptionController.lights,
                      activeColor: MyColors.MainPrimary,
                      onChanged: (bool value){
                        setState(() {
                          ghassalSubscriptionController.lights=value;
                          if(value==true){
                            ghassalSubscriptionController.orderType.value="urgent";
                            ghassalSubscriptionController.isUrgent.value=true;
                            ghassalSubscriptionController.getUrgentPriceReSub("");
                            ghassalSubscriptionController.calculateTotalReSubscription();
                          }else{
                            ghassalSubscriptionController.orderType.value="normal";
                            ghassalSubscriptionController.urgentPrice.value=0;
                            ghassalSubscriptionController.calculateTotalReSubscription();
                          }
                        });
                      })),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget preferencesList() {
    if (ghassalSubscriptionController.preferencesList.isNotEmpty) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: ghassalSubscriptionController.preferencesList.length,
          itemBuilder: (context, int index) {
            return Container(
              padding: EdgeInsetsDirectional.all(1.5.h),
              margin: EdgeInsetsDirectional.only(bottom: 1.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                      color: MyColors.MainGoku,
                      width: 2.0),
                  color:  Colors.white),
              child: Row(
                children: [
                  //SvgPicture.asset('assets/leaf.svg'),
                  Image.network(ghassalSubscriptionController.preferencesList[index].image??"",
                    width: 6.h,height: 6.h,fit: BoxFit.fill,),
                  SizedBox(width: 1.h,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ghassalSubscriptionController.preferencesList[index].name??"",
                          style:  TextStyle(fontSize: 12.sp,
                              fontFamily: 'alexandria_medium',
                              fontWeight: FontWeight.w300,
                              color:MyColors.MainBulma)),
                      SizedBox(height: 1.h,),
                      Text(ghassalSubscriptionController.preferencesList[index].description??"",
                          style:  TextStyle(fontSize: 8.sp,
                              fontFamily: 'alexandria_regular',
                              fontWeight: FontWeight.w300,
                              color:MyColors.MainTrunks)),
                      SizedBox(height: 1.h,),
                      Text("${ghassalSubscriptionController.preferencesList[index].price.toString()??""} ${'currency'.tr()}",
                          style:  TextStyle(fontSize: 8.sp,
                              fontFamily: 'alexandria_regular',
                              fontWeight: FontWeight.w400,
                              color:MyColors.MainPrimary)),
                    ],
                  ),
                  const Spacer(),
                  Checkbox(
                    checkColor: Colors.white,
                    value: ghassalSubscriptionController.preferencesList[index].isChecked,
                    activeColor: MyColors.MainPrimary,
                    onChanged: (bool? isChecked) {
                      setState(() {
                        preferences=ghassalSubscriptionController.preferencesList[index];
                        ghassalSubscriptionController.preferencesList[index].isChecked = isChecked!;

                        if (isChecked == true) {
                          // Create a new Preferences object and add it to preferencesItem
                          final item = ghassalSubscriptionController.preferencesList[index];
                          final id = item.id;
                          final price = item.price;
                          final newPreference = Preferences(id: id, price: price);
                          ghassalSubscriptionController.preferencesItem.add(newPreference);
                        } else {
                          // Remove the Preferences object from preferencesItem
                          final id = ghassalSubscriptionController.preferencesList[index].id;
                          ghassalSubscriptionController.preferencesItem.removeWhere((item) => item.id == id);
                        }
                        ghassalSubscriptionController.calculateTotalReSubscription();

                        ghassalSubscriptionController.prefernceJson.value = ghassalSubscriptionController.convertPreferenceListToJson(ghassalSubscriptionController.preferencesItem);
                        print("Updated JSON2: " + ghassalSubscriptionController.prefernceJson.value);
                      });
                    },

                  ),
                ],
              ),
            );
          }
      );
    } else {
      return Container();
    }
  }

  Widget notes(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("notes".tr(),
            style:  TextStyle(fontSize: 11.sp,
                fontFamily: 'alexandria_bold',
                fontWeight: FontWeight.w500,
                color:MyColors.MainBulma)),
        SizedBox(height: 1.h,),
        Container(
          height: 15.h,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              border: Border.all(
                color: MyColors.MainGoku,
                width: 1.0,
              ),
              color:Colors.white),
          child: TextFormField(
            maxLines: 4,
            autovalidateMode:AutovalidateMode.onUserInteraction ,
            controller: ghassalSubscriptionController.noteController,
            decoration:   InputDecoration(
              errorBorder:  const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: Colors.red,style: BorderStyle.solid),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: MyColors.MainGoku,style: BorderStyle.solid),
              ),
              focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(style: BorderStyle.solid,color: MyColors.MainGoku,)
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: Colors.red,style: BorderStyle.solid),
              ) ,
              hintText: 'write'.tr(),
              hintStyle: TextStyle(fontSize: 12.sp,
                  fontFamily: 'lexend_regular',
                  fontWeight: FontWeight.w400,
                  color: MyColors.MainTrunks),
            ),
            style:  TextStyle(fontSize: 12.sp,
                fontFamily: 'alexandria_regular',
                fontWeight: FontWeight.w400,
                color: MyColors.MainZeno),
          ),
        )
      ],
    );
  }

  clearData(){
    dropOffController.homeBasketSubHours="";
    dropOffController.homeBasketSubDate="";
    dropOffController.finalHomeBasketSubTime.value="";
    ghassalSubscriptionController.noteController.clear();
    ghassalSubscriptionController.isSelectedAddress=false;
    ghassalSubscriptionController.addressType="";
    ghassalSubscriptionController.itemIdAddress=-1;
    ghassalSubscriptionController.isSelected=false;
    ghassalSubscriptionController.itemId=-1;
    registerController.address2.value="";
    ghassalSubscriptionController.preferencesItem.clear();
    ghassalSubscriptionController.lights=false;
    ghassalSubscriptionController.orderType.value="normal";
    ghassalSubscriptionController.urgentPrice.value=0;
    ghassalSubscriptionController.deliveryCost.value=0;
    ghassalSubscriptionController.totalReSubscriptionPrice.value=0.0;
    ghassalSubscriptionController.payment.value="";
  }

  Widget payment(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("payment_methods".tr(),
            style:  TextStyle(fontSize: 11.sp,
                fontFamily: 'alexandria_bold',
                fontWeight: FontWeight.w500,
                color:MyColors.MainBulma)),
        SizedBox(height: 1.h,),
        GestureDetector(
          onTap: (){
            showModalBottomSheet<void>(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                context: context,
                backgroundColor: Colors.white,
                builder: (BuildContext context) =>
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery
                                .of(context)
                                .viewInsets
                                .bottom),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ChoosePyment(from: "sub"),
                          ],
                        )));
          },
          child: Container(
            padding: EdgeInsetsDirectional.all(1.5.h),
            margin: EdgeInsetsDirectional.only(bottom: 1.h),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                  color: MyColors.MainGoku, width: 1,),
                color:  Colors.white),
            child: Row(
              children: [
                //SvgPicture.asset("assets/mastercard.svg"),
                //SizedBox(width: 1.h,),
                Text("choose_payment_method".tr(),
                    style:  TextStyle(fontSize: 12.sp,
                        fontFamily: 'alexandria_regular',
                        fontWeight: FontWeight.w400,
                        color:MyColors.MainTrunks)),
                const Spacer(),
                Text(ghassalSubscriptionController.payment.value,
                    style:  TextStyle(fontSize: 10.sp,
                        fontFamily: 'alexandria_medium',
                        fontWeight: FontWeight.w500,
                        color:MyColors.MainSecondary)),
              ],
            ),
          ),
        ),
      ],
    );
  }



  void validation(){
    if(ghassalSubscriptionController.addressId==null||registerController.address2.value==""){
      Fluttertoast.showToast(
          msg: "please_select_address".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
      );
    }else if(dropOffController.finalHomeBasketSubTime.value==""){
      Fluttertoast.showToast(
          msg: "please_select_date_and_time_first".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
      );
    }
    // else if(ghassalSubscriptionController.payment.value==""){
    //   ToastClass.showCustomToast(context, "please_choose_payment".tr(), "error");
    // }
    else{
      /*ghassalSubscriptionController.isVisable2.value=true;
      if(ghassalSubscriptionController.payment.value=="tabby"){
        ghassalSubscriptionController.reSubscription(context,
            dropOffController.finalHomeBasketSubOrder.value.toString(),widget.userId).then((_){
          if(ghassalSubscriptionController.resubscribtionResponse.value.success==true){
            createSession();
          }
        });
      }
      else if(ghassalSubscriptionController.payment.value=="cash"){
        ghassalSubscriptionController.isVisable2.value=true;
        ghassalSubscriptionController.reSubscription(context,
            dropOffController.finalHomeBasketSubOrder.value.toString(),widget.userId).then((_){
          if(ghassalSubscriptionController.resubscribtionResponse.value.success==true){
            ghassalSubscriptionController.updateOrderStatus(context,"pending","","reSub");
          }
        });
      }*/
      //else if (ghassalSubscriptionController.payment.value == "payTaps") {
        ghassalSubscriptionController.isVisable2.value = true;
        ghassalSubscriptionController
            .reSubscription(context, dropOffController.finalHomeBasketSubOrder.value,widget.userId)
            .then((_) {
          if (ghassalSubscriptionController.resubscribtionResponse.value.success ==
              true) {
            payPressed();
            ghassalSubscriptionController.isVisable2.value = false;
            // ghassalSubscriptionController.updateOrderStatusPayTaps(context, "pending", "","reSub").then((_) {
            //   if (ghassalSubscriptionController.updateStatusResponse.value.success == true) {
            //     ghassalSubscriptionController.isVisable2.value = false;
            //     payPressed();
            //   } else {
            //     ghassalSubscriptionController.isVisable2.value = false;
            //     ToastClass.showCustomToast(
            //         context,
            //         ghassalSubscriptionController
            //             .updateStatusResponse.value.message ??
            //             "",
            //         "error");
            //   }
            // });
          }
        });
      //}

    }
  }

  ////////////////tabby/////////////////////////////
  void _setStatus(String newStatus) {
    setState(() {
      ghassalSubscriptionController.status = newStatus;
    });
  }

  Future<void> createSession() async {
    try {
      _setStatus('pending');
      final s = await TabbySDK().createSession(TabbyCheckoutPayload(
        merchantCode: 'SAR',
        payment: Payment(
          amount: ghassalSubscriptionController.totalReSubscriptionPrice.value.toString(),
          currency: Currency.sar,
          buyer: Buyer(
            email: '',
            phone: '',
            name: '',
            dob: '2019-08-24',
          ),
          buyerHistory: BuyerHistory(
            loyaltyLevel: 0,
            registeredSince: '2019-08-24T14:15:22Z',
            wishlistCount: 0,
          ),
          shippingAddress: const ShippingAddress(
            city: 'string',
            address: 'string',
            zip: 'string',
          ),
          order: Order(referenceId: 'id123', items: [
            OrderItem(
              title: 'Jersey',
              description: 'Jersey',
              quantity: 1,
              unitPrice: '10.00',
              referenceId: 'uuid',
              productUrl: 'http://example.com',
              category: 'clothes',
            )
          ]),
          orderHistory: [
            OrderHistoryItem(
              purchasedAt: '2019-08-24T14:15:22Z',
              amount: '10.00',
              paymentMethod: OrderHistoryItemPaymentMethod.card,
              status: OrderHistoryItemStatus.newOne,
            )
          ],
        ),
        lang: Lang.ar,
      ));

      debugPrint('Session id: ${s.sessionId}');

      setState(() {
        ghassalSubscriptionController.session = s;
      });
      _setStatus('created');
      openInAppBrowser();
    } catch (e, s) {
      printError(e, s);
      _setStatus('error');
    }
  }

  void openInAppBrowser() {
    TabbyWebView.showWebView(
      context: context,
      webUrl: ghassalSubscriptionController.session!.availableProducts.installments!.webUrl,
      onResult: (WebViewResult resultCode) {
        print("nammmmmme "+resultCode.name);
        if(resultCode.name=="CAPTURED"||resultCode.name=="authorized"){
          ghassalSubscriptionController.updateOrderStatus(context, "pending","","reSub");
        }else {
          ghassalSubscriptionController.isVisable2.value=false;
          clearData();
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: resultCode.name,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,backgroundColor: Colors.red
          );
        }
      },
    );
  }
////////////////////////////////////////////////////

/////////payTaps//////
  PaymentSdkConfigurationDetails generateConfig() {
    var billingDetails = BillingDetails(
      // (ghassalBasketsController.sharedPreferencesService.getString("fullName")==null
      //     ||ghassalBasketsController.sharedPreferencesService.getString("fullName")=="null"
      //     ||ghassalBasketsController.sharedPreferencesService.getString("fullName")=="")?
      // "ghassal":ghassalBasketsController.sharedPreferencesService.getString("fullName"),
      // (ghassalBasketsController.sharedPreferencesService.getString("email")==null
      //     ||ghassalBasketsController.sharedPreferencesService.getString("email")=="null"
      //     ||ghassalBasketsController.sharedPreferencesService.getString("email")=="")?
      // "ghassal@gmail.com":ghassalBasketsController.sharedPreferencesService.getString("email"),
        "ghassal app",
        "ghassal@gmail.com",
        "+97311111111",
        "address",
        "ae",
        "Dubai",
        "Dubai",
        "12345"
    );
    var shippingDetails = ShippingDetails(
        "ghassal app",
        "ghassal@gmail.com",
        "+97311111111",
        // ghassalBasketsController.sharedPreferencesService.getString("fullName")??"trio",
        // ghassalBasketsController.sharedPreferencesService.getString("email")??"trio@gmail",
        // ghassalBasketsController.sharedPreferencesService.getString("phone_number")??"+97311111111",
        "address",
        "ae",
        "Dubai",
        "Dubai",
        "12345");
    List<PaymentSdkAPms> apms = [];
    apms.add(PaymentSdkAPms.AMAN);
    final configuration = PaymentSdkConfigurationDetails(
        profileId: "110736",
        serverKey: "S6JNJ2T9H9-JJGRK6ML9G-2TNNTTLMNL",
        clientKey: "C6KMRB-6N2Q66-TRKGNB-7BGPB2",
        cartId: "12433",
        cartDescription: "Flowers",
        merchantName: "Flowers Store",
        screentTitle: "Pay with Card",
        amount: double.parse(
            ghassalSubscriptionController.totalReSubscriptionPrice.toString()),
        showBillingInfo: false,
        forceShippingInfo: false,
        currencyCode: "SAR",
        merchantCountryCode: "SA",
        billingDetails: billingDetails,
        shippingDetails: shippingDetails,
        alternativePaymentMethods: apms,
        linkBillingNameWithCardHolderName: true);
    configuration.tokeniseType = PaymentSdkTokeniseType.MERCHANT_MANDATORY;
    return configuration;
  }

  Future<void> payPressed() async {
    FlutterPaytabsBridge.startCardPayment(generateConfig(), (event) async{
      //setState(() {
        if (event["status"] == "success") {
          var transactionDetails = event["data"];
          print(transactionDetails);
          if (transactionDetails["isSuccess"]) {
            await ghassalSubscriptionController.updateOrderStatusPayTaps(context, "pending", "","reSub",widget.userId.toString());
            ghassalSubscriptionController.updatePaymentStatus(context, "paid",
                transactionDetails["transactionReference"],"reSub").then((_) {
              if (ghassalSubscriptionController.updateStatusResponse.value.success ==
                  true) {
                clearData();
                ghassalSubscriptionController.onAlertReSub(context);
              }
            });
            if (transactionDetails["isPending"]) {
              print("transaction pending");
            }
          } else {
            ghassalSubscriptionController.updatePaymentStatus(context, "unpaid",
                transactionDetails["transactionReference"],"reSub")
                .then((_) {
              if (ghassalSubscriptionController.updateStatusResponse.value.success ==
                  true) {
                clearData();
                ghassalSubscriptionController.onAlertButtonsPressed(context);
              }
            });
          }
        } else if (event["status"] == "error") {
          ghassalSubscriptionController.isVisable2.value = false;
          Fluttertoast.showToast(
              msg: "Error in Transaction",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red);
          // Handle error here.
        } else if (event["status"] == "event") {
          print("eventttttttt");
          // Handle events here.
        }
     // });
    });
  }

}