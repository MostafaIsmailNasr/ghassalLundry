import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../business/homeController/HomeController.dart';
import '../../../business/notificationController/NotificationController.dart';
import '../../../conustant/my_colors.dart';
import '../../widget/NotificationItem.dart';
import 'dart:math' as math;


class NotificationScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _NotificationScreen();
  }
}

class _NotificationScreen extends State<NotificationScreen> {
  final notificationController = Get.put(NotificationController());
  final homeController = Get.put(HomeController());
  var isSelected=true;
  int? itemId=1;
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  final ButtonStyle flatButtonStyle2 = TextButton.styleFrom(
      backgroundColor: MyColors.MainGohan,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      side: BorderSide(color: MyColors.MainPrimary), // Add this line for border color
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
    homeController.getData();
    notificationController.getNotificationData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: MyColors.BGColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Transform.rotate(
              angle:homeController.lang=="en"? 180 *math.pi /180:0,
              child: SvgPicture.asset('assets/back.svg',))),
          title: Text('notifications'.tr(),
              style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'alexandria_bold',
                  fontWeight: FontWeight.w500,
                  color: MyColors.MainBulma)),
        ),
        body:con? homeController.sharedPreferencesService.getBool('islogin') == true
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.only(left: 1.5.h, right: 1.5.h, top: 1.5.h),
                child: Obx(() => !notificationController.isLoading.value
                    ? NotificationList()
                    : const Center(
                        child: CircularProgressIndicator(
                        color: MyColors.MainPrimary,
                      ))),
              )
            : pleaseLogin():internet());
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
                    homeController.getData();
                    notificationController.getNotificationData();
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

  Widget notificationCategory(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: (){
            setState(() {
              isSelected=true;
              itemId=1;
            });
          },
          child: Container(
            padding: EdgeInsetsDirectional.all(1.h),
            margin: EdgeInsetsDirectional.only(end: 1.h),
            decoration:  BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                  color: isSelected==true && itemId==1?MyColors.MainPrimary: MyColors.MainBeerus ,
                  width: 1.0,),
                color: isSelected==true && itemId==1?MyColors.MainPrimary: Colors.white),
            child: Text('all'.tr(),
                style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: 'alexandria_medium',
                    fontWeight: FontWeight.w400,
                    color:isSelected==true && itemId==1? MyColors.MainGohan:MyColors.MainBeerus)),
          ),
        ),
        GestureDetector(
          onTap: (){
            setState(() {
              isSelected=true;
              itemId=2;
            });
          },
          child: Container(
            padding: EdgeInsetsDirectional.all(1.h),
            margin: EdgeInsetsDirectional.only(end: 1.h),
            decoration:  BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                  color: isSelected==true && itemId==2?MyColors.MainPrimary: MyColors.MainBeerus ,
                  width: 1.0,),
                color: isSelected==true && itemId==2?MyColors.MainPrimary: Colors.white),
            child: Text('unread'.tr(),
                style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: 'alexandria_medium',
                    fontWeight: FontWeight.w400,
                    color:isSelected==true && itemId==2? MyColors.MainGohan:MyColors.MainBeerus)),
          ),
        ),
        GestureDetector(
          onTap: (){
            setState(() {
              isSelected=true;
              itemId=3;
            });
          },
          child: Container(
            padding: EdgeInsetsDirectional.all(1.h),
            margin: EdgeInsetsDirectional.only(end: 1.h),
            decoration:  BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                  color: isSelected==true && itemId==3?MyColors.MainPrimary: MyColors.MainBeerus ,
                  width: 1.0,),
                color: isSelected==true && itemId==3?MyColors.MainPrimary: Colors.white),
            child: Text('readable'.tr(),
                style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: 'alexandria_medium',
                    fontWeight: FontWeight.w400,
                    color:isSelected==true && itemId==3? MyColors.MainGohan:MyColors.MainBeerus)),
          ),
        )
      ],
    );
  }

  Widget NotificationList() {
    if (notificationController.notificationList.isNotEmpty){
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        itemCount: //15,
        notificationController.notificationList.length,
        itemBuilder: (context, int index) {
          return NotificationItem(
               notification: notificationController.notificationList[index]
              );
        });
    } else{
      return empty();
    }
  }

  Widget pleaseLogin(){
    return Container(
      color: MyColors.MainGoku,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsetsDirectional.only(top: 20.h,start: 1.h,end: 1.h),
      //margin: EdgeInsets.only(left: 1.5.h, right: 1.5.h, top: 1.5.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/no_notifactions.svg'),
            SizedBox(height: 1.h,),
            Text('there_are_no_notification'.tr(),
              style: TextStyle(fontSize: 14.sp,
                  fontFamily: 'alexandria_bold',
                  fontWeight: FontWeight.w600,
                  color: MyColors.MainTrunks),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h,),
            Text('your_notifications_will_appear_here'.tr(),
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
                  Navigator.pushNamed(context, '/login_screen',arguments: "notification");
                },
                child: Text(
                  'login'.tr(),
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'regular',
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 1.5.h,),
            /*Container(
              margin: EdgeInsetsDirectional.only(start: 1.h, end: 1.h,),
              width: double.infinity,
              height: 7.h,
              child: TextButton(
                style: flatButtonStyle2,
                onPressed: () async {
                  Navigator.pushNamed(context, '/register_screen',arguments: "notific_register");
                },
                child: Text(
                  'signup'.tr(),
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'regular',
                      fontWeight: FontWeight.w500,
                      color:MyColors.MainPrimary),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}

class empty extends StatelessWidget{
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
            //Image(image: AssetImage('assets/offers_empty.png')),
            SvgPicture.asset('assets/no_notifactions.svg'),
            SizedBox(height: 1.h,),
            Text('there_are_no_notification'.tr(),
              style: TextStyle(fontSize: 14.sp,
                  fontFamily: 'alexandria_bold',
                  fontWeight: FontWeight.w600,
                  color: MyColors.MainTrunks),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h,),
            Text('your_notifications_will_appear_here'.tr(),
              style: TextStyle(fontSize: 10.sp,
                  fontFamily: 'alexandria_regular',
                  fontWeight: FontWeight.w300,
                  color: MyColors.MainTrunks),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

}
