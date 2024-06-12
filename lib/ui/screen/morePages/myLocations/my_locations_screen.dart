import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'dart:math' as math;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:sizer/sizer.dart';

import '../../../../business/addressListController/AddressListController.dart';
import '../../../../business/homeController/HomeController.dart';
import '../../../../conustant/my_colors.dart';
import '../../../widget/MyAddressItem.dart';

class MyLocationsScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyLocationsScreen();
  }
}

class _MyLocationsScreen extends State<MyLocationsScreen>{
  final homeController = Get.put(HomeController());
  final addressListController = Get.put(AddressListController());
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  var con=true;

  Future<void> check()async{
    final hasInternet = await InternetConnectivity().hasInternetConnection;
    setState(() {
      con = hasInternet;
    });
  }

  @override
  void initState() {
    check();
    addressListController.getAddressList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text('location'.tr(),
            style:  TextStyle(
                fontSize: 12.sp,
                fontFamily: 'alexandria_bold',
                fontWeight: FontWeight.w500,
                color: MyColors.MainBulma)),
      ),
      body:con? Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin:  EdgeInsetsDirectional.only(end: 1.5.h,start: 1.5.h,bottom: 1.5.h),
        child:Obx(() => !addressListController.isLoading.value? SingleChildScrollView(
          child:   Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addressList(),
            ],
          ),
        ):
            const Center(child: CircularProgressIndicator(color: MyColors.MainPrimary,),)),
      ):internet()
      ,
    );
  }


  Widget addressList() {
    if(addressListController.addressList.isNotEmpty){
      return SingleChildScrollView(
        child: Column(
            children: [
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: addressListController.addressList.length,
                itemBuilder: (context, int index) {
                  return MyAddressItem(
                    address: addressListController.addressList[index],
                  );
                }
        ),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, "/location_screen",arguments: "listAddress");
                },
                child: Container(
                  padding: EdgeInsetsDirectional.all(2.h),
                  decoration:  BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: Colors.white,
                      border: Border.all(color: MyColors.MainGoku)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset('assets/point_add.svg'),
                      SizedBox(width: 1.h,),
                      Text("add_new_location".tr(),
                        style:  TextStyle(fontSize: 10.sp,
                            fontFamily: 'alexandria_medium',
                            fontWeight: FontWeight.w400,
                            color:MyColors.MainPrimary),),
                    ],
                  ),
                ),
              )
            ],
          ),
      );
    }else{
      return empty();
    }
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
                    addressListController.getAddressList();
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

}

class empty extends StatelessWidget{
  final ButtonStyle flatButtonStyle2 = TextButton.styleFrom(
      backgroundColor: MyColors.MainGohan,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        side: BorderSide(color: MyColors.MainPrimary), // Add this line for border color
      ));
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.MainGoku,
      height: MediaQuery.of(context).size.height,
      //margin: EdgeInsets.only(top: 15.h),
      padding: EdgeInsetsDirectional.only(top: 20.h),
      child: Center(
        child: Column(
          children: [
            SvgPicture.asset('assets/no_location.svg'),
            SizedBox(height: 1.h,),
            Text('no_address_added'.tr(),
              style: TextStyle(fontSize: 14.sp,
                  fontFamily: 'alexandria_bold',
                  fontWeight: FontWeight.w600,
                  color: MyColors.MainTrunks),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h,),
            Text('add_sites_appear_here'.tr(),
              style: TextStyle(fontSize: 10.sp,
                  fontFamily: 'alexandria_regular',
                  fontWeight: FontWeight.w300,
                  color: MyColors.MainTrunks),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h,),
            Container(
              margin: EdgeInsetsDirectional.only(start: 1.h, end: 1.h,),
              width: double.infinity,
              height: 7.h,
              child: TextButton(
                style: flatButtonStyle2,
                onPressed: () async {
                  Navigator.pushNamed(context, "/location_screen",arguments: "listAddress");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/add3.svg'),
                    Text(
                      'add_location'.tr(),
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'regular',
                          fontWeight: FontWeight.w500,
                          color: MyColors.MainPrimary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}