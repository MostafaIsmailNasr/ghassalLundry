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
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:sizer/sizer.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';

import '../../../../business/addressListController/AddressListController.dart';
import '../../../../business/auth/registerController/RegisterController.dart';
import '../../../../business/dropOffController/DropOffController.dart';
import '../../../../business/ghassalUpOnRequestController/GhassalUpOnRequestController.dart';
import '../../../../business/homeController/HomeController.dart';
import '../../../../conustant/my_colors.dart';
import '../../../../conustant/toast_class.dart';
import '../../../../data/model/preferencesModel/PreferencesResponse.dart';
import '../../../widget/upOnRequest/clothesList/ClothesItem.dart';
import '../../buttomSheets/areYouSureButtom/are_you_sure_buttom.dart';
import '../../buttomSheets/authSheets/auth/auth_buttom_sheet.dart';
import '../../buttomSheets/choosePymentSheet/choose_pyment_sheet.dart';
import '../../buttomSheets/clothesButtomSheets/clothes_buttom_sheets.dart';
import 'dart:math' as math;
import '../../buttomSheets/dropDownTimeButtomSheet/drop_down_time_buttomSheet.dart';

class GhassalUpOnRequestScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GhassalUpOnRequestScreen();
  }
}

class _GhassalUpOnRequestScreen extends State<GhassalUpOnRequestScreen> {
  var selectedFlage = -1;
  var con = true;
  var selectedFlageBasket = 0;
  var isBasketVisible = false;
  final _formKey = GlobalKey<FormState>();
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  Preferences? preferences;

  final homeController = Get.put(HomeController());
  final dropOffController = Get.put(DropOffController());
  final ghassalUpOnRequestController = Get.put(GhassalUpOnRequestController());
  final registerController = Get.put(RegisterController());
  final addressListController = Get.put(AddressListController());

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
      //clearData();
      registerController.address2.value = "";
      dropOffController.upOnRequestHours = "";
      dropOffController.upOnRequestDate = "";
      dropOffController.finalupOnRequestTime.value = "";
      dropOffController.formattedDateUpOnRequest = "";
      dropOffController.finalUpOnRequestOrder.value = "";
      if (ghassalUpOnRequestController.sharedPreferencesService
              .getBool("islogin") ==
          true) {
        ghassalUpOnRequestController.getAddressList(context);
      } else {
        ghassalUpOnRequestController.isLoading.value = false;
        ghassalUpOnRequestController.homeAddressId = "";
        ghassalUpOnRequestController.homeStreetName.value = "";
        ghassalUpOnRequestController.workAddressId = "";
        ghassalUpOnRequestController.workStreetName.value = "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        clearData();
        return true;
      },
      child:con? Obx(() => !ghassalUpOnRequestController.isLoading.value?
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                clearData();
                Navigator.pop(context);
              },
              icon: Transform.rotate(
                  angle:homeController.lang=="en"? 180 *math.pi /180:0,
                  child: SvgPicture.asset('assets/back.svg',))),
          title: Text('ghassal_on_request'.tr(),
              style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'alexandria_bold',
                  fontWeight: FontWeight.w500,
                  color: MyColors.MainBulma)),
        ),
        body:ghassalUpOnRequestController.preferencesResponse.value.success==true?
        Container(
          margin: EdgeInsetsDirectional.only(start: 2.h,end: 2.h,top: 1.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("types_of_clothing".tr(),
                    style:  TextStyle(fontSize: 11.sp,
                        fontFamily: 'alexandria_bold',
                        fontWeight: FontWeight.w500,
                        color:MyColors.MainBulma)),
                SizedBox(height: 1.h,),
                clothes(),
                SizedBox(height: 1.h,),
                addProduct(),
                SizedBox(height: 1.h,),
                address(),
                SizedBox(height: 1.h,),
                receivingDate(),
                SizedBox(height: 1.h,),
                coupon(),
                SizedBox(height: 1.h,),
                // payment(),
                // SizedBox(height: 1.h,),
                preferencesList(),
                SizedBox(height: 1.h,),
                notes(),
                SizedBox(height: 3.h,),
              ],
            ),
          ),
        )
            :Center(
            child: Text(ghassalUpOnRequestController.preferencesResponse.value.message??"",
              style: TextStyle(color: MyColors.MainBulma,fontWeight: FontWeight.w600,fontSize: 16.sp),)),
        bottomNavigationBar:  Container(
            color: Colors.white,
            height: 9.h,
            child:
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Obx(() => Visibility(
                        visible: ghassalUpOnRequestController.isVisable2.value,
                        child: const CircularProgressIndicator(
                          color: MyColors.MainPrimary,
                        ),
                      )),
                      Obx(() => Visibility(
                        visible: !ghassalUpOnRequestController.isVisable2.value,
                        child: Container(
                          margin: EdgeInsetsDirectional.only(
                            start: 1.h,
                            end: 1.h,
                          ),
                          width: double.infinity,
                          height: 7.h,
                          child:  TextButton(
                            style: flatButtonStyle,
                            onPressed: () async {
                              // Perform your existing logic here
                              if (ghassalUpOnRequestController
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
                                        child: AuthButtomSheet(from: "upOn")));
                              } else {
                                validation();
                              }
                            },
                            child: Text(
                              'Confirmation'.tr(),
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
                SizedBox(width: 1.h,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("total".tr(),
                          style:  TextStyle(fontSize: 8.sp,
                              fontFamily: 'alexandria_medium',
                              fontWeight: FontWeight.w400,
                              color:MyColors.MainTrunks)),
                      Text("${ghassalUpOnRequestController.totalAfterDiscount.value} ${"currency".tr()}",
                          style:  TextStyle(fontSize: 14.sp,
                              fontFamily: 'alexandria_bold',
                              fontWeight: FontWeight.w400,
                              color:MyColors.MainZeno)),
                    ],
                  ),)
              ],)
        ),
      )
          :const Scaffold(body: Center(child: CircularProgressIndicator(color: MyColors.MainPrimary,)),)):internet(),
    );
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
                    dropOffController.upOnRequestHours="";
                    dropOffController.upOnRequestDate="";
                    dropOffController.finalupOnRequestTime.value="";
                    dropOffController.formattedDateUpOnRequest="";
                    dropOffController.finalUpOnRequestOrder.value="";
                    if(ghassalUpOnRequestController.sharedPreferencesService.getBool("islogin")==true) {
                      ghassalUpOnRequestController.getAddressList(context);
                    }else{
                      ghassalUpOnRequestController.isLoading.value=false;
                      ghassalUpOnRequestController.homeAddressId="";
                      ghassalUpOnRequestController.homeStreetName.value="";
                      ghassalUpOnRequestController.workAddressId="";
                      ghassalUpOnRequestController.workStreetName.value="";
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
                            ChoosePyment(from: "upon"),
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
                Text(ghassalUpOnRequestController.payment.value,
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

  Widget clothes() {
    var txt="";
    if (ghassalUpOnRequestController.cartItem.isNotEmpty) {
      for(int i=0;i<ghassalUpOnRequestController.cartItem.length;i++){
        txt+=ghassalUpOnRequestController.cartItem[i].name!+",";
      }
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: 1,
        itemBuilder: (context, int index) {
          return ClothesItem(
            txt: txt,
            products: ghassalUpOnRequestController.cartItem[index],
          );
        }
    );
    } else {

      return Container();
    }
  }

  Widget addProduct(){
    return GestureDetector(
      onTap: (){
        if (ghassalUpOnRequestController
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
                  child: AuthButtomSheet(from: "UponRequest")));
        }else {
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
                  child: ClothesButtomSheets()));
        }
      },
      child: Container(
        padding: EdgeInsetsDirectional.all(2.h),
        margin: EdgeInsetsDirectional.only(bottom: 1.h),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(
              color: MyColors.MainGoku, width: 1.0,),
            color:  MyColors.MainGohan),
        child: Row(
          children: [
            SvgPicture.asset("assets/clothes2.svg"),
            SizedBox(width: 1.h,),
            Text("add_product".tr(),
                style:  TextStyle(fontSize: 12.sp,
                    fontFamily: 'alexandria_regular',
                    fontWeight: FontWeight.w300,
                    color:MyColors.MainPrimary)),
          ],
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
            ghassalUpOnRequestController.addressList.isNotEmpty?
            Expanded(
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    // ghassalUpOnRequestController.preferencesList.forEach((item) {
                    //   item.isChecked = false;
                    // });
                    // clearData();
                    if (ghassalUpOnRequestController.cartItem.isNotEmpty) {
                      showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          backgroundColor:Colors.white,
                          builder: (BuildContext context)=> Padding(
                              padding: EdgeInsets.only( bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: AreYouSureButtom()
                          )
                      );
                    }
                    ghassalUpOnRequestController.isSelected=true;
                    ghassalUpOnRequestController.addressType="home";
                    ghassalUpOnRequestController.itemId=1;
                    dropOffController.upOnRequestHours="";
                    dropOffController.upOnRequestDate="";
                    dropOffController.finalupOnRequestTime.value="";
                    ghassalUpOnRequestController.addressId.value=ghassalUpOnRequestController.homeAddressId;
                    registerController.address2.value=ghassalUpOnRequestController.homeStreetName.value;
                    registerController.lat=ghassalUpOnRequestController.homeLat;
                    registerController.lng=ghassalUpOnRequestController.homeLng;
                  });
                },
                child: Container(
                  height: 6.h,
                  padding: EdgeInsetsDirectional.all(0.5.h),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                        color: ghassalUpOnRequestController.isSelected==true && ghassalUpOnRequestController.itemId==1?MyColors.MainPrimary: MyColors.MainDisabledPrimary ,
                        width: 1.0,),
                      color: ghassalUpOnRequestController.isSelected==true && ghassalUpOnRequestController.itemId==1?MyColors.MainGohan: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/home_smile.svg",color: ghassalUpOnRequestController.isSelected==true && ghassalUpOnRequestController.itemId==1?MyColors.MainPrimary: MyColors.MainDisabledPrimary,),
                      SizedBox(width: 1.h,),
                      Text("home2".tr(),
                          style:  TextStyle(fontSize: 8.sp,
                              fontFamily: 'alexandria_medium',
                              fontWeight: FontWeight.w400,
                              color:ghassalUpOnRequestController.isSelected==true && ghassalUpOnRequestController.itemId==1?MyColors.MainPrimary: MyColors.MainDisabledPrimary)),
                    ],
                  ),
                ),
              ),
            ):Container(width: 0.h,),
            ghassalUpOnRequestController.addressList.isNotEmpty?
            SizedBox(width: 1.h,):SizedBox(width: 0.h,),
            ghassalUpOnRequestController.addressList.isNotEmpty?
            Expanded(
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    // ghassalUpOnRequestController.preferencesList.forEach((item) {
                    //   item.isChecked = false;
                    // });
                    // clearData();
                    if (ghassalUpOnRequestController.cartItem.isNotEmpty) {
                      showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          backgroundColor:Colors.white,
                          builder: (BuildContext context)=> Padding(
                              padding: EdgeInsets.only( bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: AreYouSureButtom()
                          )
                      );
                    }
                    ghassalUpOnRequestController.isSelected=true;
                    ghassalUpOnRequestController.addressType="office";
                    ghassalUpOnRequestController.itemId=2;
                    dropOffController.upOnRequestHours="";
                    dropOffController.upOnRequestDate="";
                    dropOffController.finalupOnRequestTime.value="";
                    ghassalUpOnRequestController.addressId.value=ghassalUpOnRequestController.workAddressId;
                    registerController.address2.value=ghassalUpOnRequestController.workStreetName.value;
                    registerController.lat=ghassalUpOnRequestController.workLat;
                    registerController.lng=ghassalUpOnRequestController.workLng;
                  });
                },
                child: Container(
                  height: 6.h,
                  padding: EdgeInsetsDirectional.all(0.5.h),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                        color: ghassalUpOnRequestController.isSelected==true && ghassalUpOnRequestController.itemId==2?MyColors.MainPrimary: MyColors.MainDisabledPrimary,
                        width: 1.0,),
                      color:  ghassalUpOnRequestController.isSelected==true && ghassalUpOnRequestController.itemId==2?MyColors.MainGohan: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/buildings.svg",color: ghassalUpOnRequestController.isSelected==true && ghassalUpOnRequestController.itemId==2?MyColors.MainPrimary: MyColors.MainDisabledPrimary),
                      SizedBox(width: 1.h,),
                      Text("office".tr(),
                          style:  TextStyle(fontSize: 8.sp,
                              fontFamily: 'alexandria_medium',
                              fontWeight: FontWeight.w400,
                              color:ghassalUpOnRequestController.isSelected==true && ghassalUpOnRequestController.itemId==2?MyColors.MainPrimary: MyColors.MainDisabledPrimary)),
                    ],
                  ),
                ),
              ),
            ):Container(width: 0.h,),
            ghassalUpOnRequestController.addressList.isNotEmpty?
            SizedBox(width: 1.h,):SizedBox(width: 0.h,),
            ghassalUpOnRequestController.addressList.isNotEmpty?
            Expanded(
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    // ghassalUpOnRequestController.preferencesList.forEach((item) {
                    //   item.isChecked = false;
                    // });
                    // clearData();
                    if (ghassalUpOnRequestController.cartItem.isNotEmpty) {
                      showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          backgroundColor:Colors.white,
                          builder: (BuildContext context)=> Padding(
                              padding: EdgeInsets.only( bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: AreYouSureButtom()
                          )
                      );
                    }
                    ghassalUpOnRequestController.isSelected=true;
                    ghassalUpOnRequestController.addressType="another_address";
                    ghassalUpOnRequestController.itemId=3;
                    dropOffController.upOnRequestHours="";
                    dropOffController.upOnRequestDate="";
                    dropOffController.finalupOnRequestTime.value="";
                    if (ghassalUpOnRequestController
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
                              child: AuthButtomSheet(from: "upon")));
                    }else {
                      Navigator.pushNamed(context, "/location_screen",
                          arguments: "listAddress");
                      //ghassalUpOnRequestController.addressId.value=addressListController.addressId.value;
                    }
                  });
                },
                child: Container(
                  height: 6.h,
                  padding: EdgeInsetsDirectional.all(0.5.h),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                        color: ghassalUpOnRequestController.isSelected==true && ghassalUpOnRequestController.itemId==3?MyColors.MainPrimary: MyColors.MainDisabledPrimary,
                        width: 1.0,),
                      color:  ghassalUpOnRequestController.isSelected==true && ghassalUpOnRequestController.itemId==3?MyColors.MainGohan: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/map0.svg",color: ghassalUpOnRequestController.isSelected==true && ghassalUpOnRequestController.itemId==3?MyColors.MainPrimary: MyColors.MainDisabledPrimary,),
                      SizedBox(width: 1.h,),
                      Expanded(
                        child: Text("another_address".tr(),
                            style:  TextStyle(fontSize: 8.sp,
                                fontFamily: 'alexandria_medium',
                                fontWeight: FontWeight.w400,
                                color:ghassalUpOnRequestController.isSelected==true && ghassalUpOnRequestController.itemId==3?MyColors.MainPrimary: MyColors.MainDisabledPrimary)),
                      ),
                    ],
                  ),
                ),
              ),
            )
                : GestureDetector(
              onTap: () {
                setState(() {
                 // clearData();
                  // ghassalUpOnRequestController.preferencesList.forEach((item) {
                  //   item.isChecked = false;
                  // });
                  // ghassalUpOnRequestController.isSelected = true;
                  if (ghassalUpOnRequestController.cartItem.isNotEmpty) {
                    showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        backgroundColor:Colors.white,
                        builder: (BuildContext context)=> Padding(
                            padding: EdgeInsets.only( bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: AreYouSureButtom()
                        )
                    );
                  }
                  ghassalUpOnRequestController.addressType =
                  "another_address";
                  ghassalUpOnRequestController.itemId = 3;
                  dropOffController.upOnRequestHours="";
                  dropOffController.upOnRequestDate="";
                  dropOffController.finalupOnRequestTime.value="";
                  if (ghassalUpOnRequestController
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
                            child: AuthButtomSheet(from: "upon")));
                  }else {
                    Navigator.pushNamed(context, "/location_screen",
                        arguments: "listAddress");
                    //ghassalUpOnRequestController.addressId.value=addressListController.addressId.value;
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
                      ghassalUpOnRequestController.isSelected == true &&
                          ghassalUpOnRequestController.itemId == 3
                          ? MyColors.MainPrimary: MyColors.MainDisabledPrimary,
                      width: 1.0,
                    ),
                    color: ghassalUpOnRequestController.isSelected == true &&
                        ghassalUpOnRequestController.itemId == 3
                        ? MyColors.MainGohan
                        : Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/map0.svg",
                      color:
                      ghassalUpOnRequestController.isSelected == true &&
                          ghassalUpOnRequestController.itemId == 3
                          ? MyColors.MainPrimary: MyColors.MainDisabledPrimary,
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
                              color: ghassalUpOnRequestController
                                  .isSelected ==
                                  true &&
                                  ghassalUpOnRequestController.itemId == 3
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
            if(registerController.address2.value!=""){
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
                              dropDownTimeButtomSheet(
                                from: "upOnRequest",),
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
            padding: EdgeInsetsDirectional.all(1.h),
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
                  child:Obx(() => dropOffController.finalupOnRequestTime.value!=""?
                  Text(dropOffController.finalupOnRequestTime.value,
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
                        child: Text("${ghassalUpOnRequestController.urgentPriceTxt.value} ${"currency".tr()}",
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
                      visible: ghassalUpOnRequestController.isUrgent.value,
                      child: const CircularProgressIndicator(
                        color: MyColors.MainPrimary,
                      ))),
                  Obx(
                        () => ghassalUpOnRequestController.isUrgent.value == true
                        ? Container():
                  CupertinoSwitch(
                      value: ghassalUpOnRequestController.lights,
                      activeColor: MyColors.MainPrimary,
                      onChanged: (bool value){
                        setState(() {
                          ghassalUpOnRequestController.lights=value;
                          if(value==true){
                            ghassalUpOnRequestController.orderType.value="urgent";
                            ghassalUpOnRequestController.isUrgent.value = true;
                            ghassalUpOnRequestController.getUrgentPrice("");
                            ghassalUpOnRequestController.calculateTotalPrice();
                          }else{
                            ghassalUpOnRequestController.orderType.value="normal";
                            ghassalUpOnRequestController.urgentPrice.value=0;
                            ghassalUpOnRequestController.calculateTotalPrice();

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

  Widget coupon(){
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("discount_code".tr(),
              style:  TextStyle(fontSize: 11.sp,
                  fontFamily: 'alexandria_bold',
                  fontWeight: FontWeight.w500,
                  color:MyColors.MainBulma)),
          SizedBox(height: 1.h,),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Obx(() => Visibility(
                        visible: ghassalUpOnRequestController.isVisable.value,
                        child: const CircularProgressIndicator(
                          color: MyColors.MainPrimary,
                        ))),
                    Obx(
                          () => ghassalUpOnRequestController.isVisable.value == true
                          ? Container()
                          : Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 7.h,
                          child: TextButton(
                            style: flatButtonStyle,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ghassalUpOnRequestController.isVisable.value =
                                true;
                                ghassalUpOnRequestController
                                    .validateCoupon(context);
                              }
                            },
                            child: Text(
                              'use'.tr(),
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: 'alexandria_extraBold',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: 1.h,),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                        color: MyColors.MainGoku,
                        width: 1.0,
                      ),
                      color: MyColors.MainGoku),
                  child: TextFormField(
                    autovalidateMode:AutovalidateMode.onUserInteraction ,
                    controller: ghassalUpOnRequestController.codeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_code'.tr();
                      }
                      return null;
                    },
                    maxLines: 1,
                    decoration: const InputDecoration(
                      errorBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(color: Colors.red,style: BorderStyle.solid),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(color: MyColors.MainBeerus,style: BorderStyle.solid),
                      ),fillColor: Colors.green,focusColor: Colors.green,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(style: BorderStyle.solid,color: MyColors.MainBeerus,)
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(color: Colors.red,style: BorderStyle.solid),
                      ) ,
                    ),
                    style:  TextStyle(fontSize: 11.sp,
                        fontFamily: 'alexandria_regular',
                        fontWeight: FontWeight.w300,
                        color: MyColors.MainTrunks),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget preferencesList() {
    if (ghassalUpOnRequestController.preferencesList.isNotEmpty) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: ghassalUpOnRequestController.preferencesList.length,
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
                  Image.network(ghassalUpOnRequestController.preferencesList[index].image??"",
                    width: 6.h,height: 6.h,fit: BoxFit.fill,),
                  SizedBox(width: 1.h,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ghassalUpOnRequestController.preferencesList[index].name??"",
                          style:  TextStyle(fontSize: 12.sp,
                              fontFamily: 'alexandria_medium',
                              fontWeight: FontWeight.w300,
                              color:MyColors.MainBulma)),
                      SizedBox(height: 1.h,),
                      Text(ghassalUpOnRequestController.preferencesList[index].description??"",
                          style:  TextStyle(fontSize: 8.sp,
                              fontFamily: 'alexandria_regular',
                              fontWeight: FontWeight.w300,
                              color:MyColors.MainTrunks)),
                      SizedBox(height: 1.h,),
                      Text("${ghassalUpOnRequestController.preferencesList[index].price.toString()??""} ${'currency'.tr()}",
                          style:  TextStyle(fontSize: 8.sp,
                              fontFamily: 'alexandria_regular',
                              fontWeight: FontWeight.w400,
                              color:MyColors.MainPrimary)),
                    ],
                  ),
                  const Spacer(),
                  Checkbox(
                    checkColor: Colors.white,
                    value: ghassalUpOnRequestController.preferencesList[index].isChecked,
                    activeColor: MyColors.MainPrimary,
                    onChanged: (bool? isChecked) {
                      setState(() {
                        preferences=ghassalUpOnRequestController.preferencesList[index];
                        ghassalUpOnRequestController.preferencesList[index].isChecked = isChecked!;
                        if (isChecked == true) {
                          // Create a new Preferences object and add it to preferencesItem
                          final item = ghassalUpOnRequestController.preferencesList[index];
                          final id = item.id;
                          final price = item.price;
                          final newPreference = Preferences(id: id, price: price);
                          ghassalUpOnRequestController.preferencesItem.add(newPreference);
                        } else {
                          // Remove the Preferences object from preferencesItem
                          final id = ghassalUpOnRequestController.preferencesList[index].id;
                          ghassalUpOnRequestController.preferencesItem.removeWhere((item) => item.id == id);
                        }
                        ghassalUpOnRequestController.calculateTotalPrice();
                        ghassalUpOnRequestController.prefernceJson.value = ghassalUpOnRequestController.convertPreferenceListToJson(ghassalUpOnRequestController.preferencesItem);
                        print("Updated JSON2: " + ghassalUpOnRequestController.prefernceJson.value);
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
          child: TextFormField(maxLines: 4,
            autovalidateMode:AutovalidateMode.onUserInteraction ,
            controller: ghassalUpOnRequestController.noteController,
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
    dropOffController.upOnRequestHours="";
    dropOffController.upOnRequestDate="";
    dropOffController.finalupOnRequestTime.value="";
    ghassalUpOnRequestController.codeController.clear();
    ghassalUpOnRequestController.noteController.clear();
    ghassalUpOnRequestController.isSelected=false;
    ghassalUpOnRequestController.addressType="";
    ghassalUpOnRequestController.itemId=-1;
    // registerController.address2.value="";
    ghassalUpOnRequestController.prefernceJson.value="";
    ghassalUpOnRequestController.productsJson.value="";
    ghassalUpOnRequestController.cartItem.clear();
    ghassalUpOnRequestController.preferencesItem.clear();
    ghassalUpOnRequestController.itemPrices.clear();
    ghassalUpOnRequestController.itemPrices2.clear();
    ghassalUpOnRequestController.totalPrice.value=0;
    ghassalUpOnRequestController.totalAfterDiscount.value=0.0;
    ghassalUpOnRequestController.lights=false;
    ghassalUpOnRequestController.urgentPrice.value=0;
    ghassalUpOnRequestController.deliveryCost.value=0;
    ghassalUpOnRequestController.payment.value="";
  }

  ////////////////tabby/////////////////////////////
  void _setStatus(String newStatus) {
    setState(() {
      ghassalUpOnRequestController.status = newStatus;
    });
  }

  Future<void> createSession() async {
    try {
      _setStatus('pending');
      final s = await TabbySDK().createSession(TabbyCheckoutPayload(
        merchantCode: 'SAR',
        payment: Payment(
          amount: ghassalUpOnRequestController.totalAfterDiscount.value.toString(),
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
        ghassalUpOnRequestController.session = s;
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
      webUrl: ghassalUpOnRequestController.session!.availableProducts.installments!.webUrl,
      onResult: (WebViewResult resultCode) {
        print("nammmmmme "+resultCode.name);
        if(resultCode.name=="CAPTURED"||resultCode.name=="authorized"){
          ghassalUpOnRequestController.updateOrderStatus(context, "pending","");
        }else {
          ghassalUpOnRequestController.isVisable2.value=false;
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
            ghassalUpOnRequestController.totalAfterDiscount.toString()),
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
    FlutterPaytabsBridge.startCardPayment(generateConfig(), (event) {
      setState(() {
        if (event["status"] == "success") {
          var transactionDetails = event["data"];
          print(transactionDetails);
          if (transactionDetails["isSuccess"]) {
            ghassalUpOnRequestController.updateOrderStatusPayTaps(context, "pending", "");
            ghassalUpOnRequestController.updatePaymentStatus(context,
                "paid", transactionDetails["transactionReference"])
                .then((_) {
              if (ghassalUpOnRequestController.updateStatusResponse.value.success ==
                  true) {
                clearData();
                ghassalUpOnRequestController.onAlertButtonsPressed(context);
              }
            });
            if (transactionDetails["isPending"]) {
              print("transaction pending");
            }
          } else {
            ghassalUpOnRequestController.updatePaymentStatus(context, "unpaid",
                transactionDetails["transactionReference"])
                .then((_) {
              if (ghassalUpOnRequestController.updateStatusResponse.value.success ==
                  true) {
                clearData();
                ghassalUpOnRequestController.onAlertButtonsPressed(context);
              }
            });
          }
        } else if (event["status"] == "error") {
          ghassalUpOnRequestController.isVisable2.value = false;
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
      });
    });
  }

  void validation(){
    if(ghassalUpOnRequestController.addressId==null||registerController.address2.value==""){
      Fluttertoast.showToast(
          msg: "please_select_address".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
      );
    }else if(dropOffController.finalupOnRequestTime.value==""){
      Fluttertoast.showToast(
          msg: "please_select_date_and_time_first".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
      );
    }else if(ghassalUpOnRequestController.cartItem.isEmpty){
      Fluttertoast.showToast(
          msg: "please_select_basket_first".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
      );
    }
    // else if(ghassalUpOnRequestController.payment.value==""){
    //   ToastClass.showCustomToast(context, "please_choose_payment".tr(), "error");
    // }
    else{
      // ghassalUpOnRequestController.isVisable2.value=true;
      // if(ghassalUpOnRequestController.payment.value=="tabby"){
      //   ghassalUpOnRequestController.createOrder(context, dropOffController.finalUpOnRequestOrder.value.toString()).then((_){
      //     if(ghassalUpOnRequestController.createOrderResponse.value.success==true){
      //       createSession();
      //     }
      //   });
      // }
      // else if(ghassalUpOnRequestController.payment.value=="cash"){
      //   ghassalUpOnRequestController.isVisable2.value=true;
      //   ghassalUpOnRequestController.createOrder(context, dropOffController.finalUpOnRequestOrder.value.toString()).then((_){
      //     if(ghassalUpOnRequestController.createOrderResponse.value.success==true){
      //       ghassalUpOnRequestController.updateOrderStatus(context,"pending","");
      //     }
      //   });
      // }
       //if (ghassalUpOnRequestController.payment.value == "payTaps") {
        ghassalUpOnRequestController.isVisable2.value = true;
        ghassalUpOnRequestController
            .createOrder(context, dropOffController.finalUpOnRequestOrder.value)
            .then((_) {
          if (ghassalUpOnRequestController.createOrderResponse.value.success ==
              true) {
            payPressed();
            ghassalUpOnRequestController.isVisable2.value = false;
            // ghassalUpOnRequestController.updateOrderStatusPayTaps(context, "pending", "").then((_) {
            //   if (ghassalUpOnRequestController.updateStatusResponse.value.success == true) {
            //     ghassalUpOnRequestController.isVisable2.value = false;
            //     payPressed();
            //   } else {
            //     ghassalUpOnRequestController.isVisable2.value = false;
            //     ToastClass.showCustomToast(
            //         context,
            //         ghassalUpOnRequestController
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

}