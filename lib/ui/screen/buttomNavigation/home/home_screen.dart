import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:sizer/sizer.dart';

import '../../../../business/auth/registerController/RegisterController.dart';
import '../../../../business/homeController/HomeController.dart';
import '../../../../conustant/my_colors.dart';
import '../../../widget/ConsumptionSubscriptionItem.dart';
import 'homePopup/home_popUp_screen.dart';
import 'dart:math' as math;
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen>with TickerProviderStateMixin{
  int currentIndex = 0;
  double? progressValue;
  var con=true;
  late AnimationController animationController;
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  final homeController = Get.put(HomeController());
  final registerController = Get.put(RegisterController());

  @override
  void initState() {
    print("jkjk"+homeController.currentAddress.toString());
    check();
    animationController=AnimationController(
        vsync: this,duration: const Duration(seconds: 5),)..addListener(() {
          setState(() {

          });
    });
    animationController.repeat(reverse: true);
    homeController.getData();
    progressValue = 0.0;
    homeController.getHomeData(
        registerController.lat.toString(),registerController.lng.toString(),context);
    super.initState();
  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> check()async{
    final hasInternet = await InternetConnectivity().hasInternetConnection;
    setState(() {
      con = hasInternet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BGColor,
      body:con? Obx(() => !homeController.isLoading.value?
      SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsetsDirectional.only(top: 1.h,start: 1.h,end: 1.h),
            child: Column(
              children: [
                appCustomBar(),
                SizedBox(height: 3.h,),
                homeController.homeResponse.value.success==true?SizedBox(
                  child: Column(
                    children: [
                      dots(),
                      SizedBox(height: 2.h,),
                      orderWay(),
                      SizedBox(height: 2.h,),
                      consumptionSubscription(),
                      SizedBox(height: 2.h,),
                      categories()
                    ],
                  ),
                ):Container(margin: EdgeInsetsDirectional.only(top: 35.h),
                    child: Text(homeController.outOfZone.value,
                      style: TextStyle(color: MyColors.MainBulma,fontWeight: FontWeight.w600,fontSize: 16.sp),))

              ],
            ),
          ),
        ),
      )
          :const Center(child: CircularProgressIndicator(color: MyColors.MainPrimary,)))
          :Internet(),
    );
  }

  Widget appCustomBar(){
    return   Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("welcome".tr(),
                    style:  TextStyle(fontSize: 10.sp,
                    fontFamily: 'alexandria_medium',
                    fontWeight: FontWeight.w500,
                    color:MyColors.MainBulma)),
                Text(homeController.sharedPreferencesService.getString("fullName")??"",
                    style:  TextStyle(fontSize: 10.sp,
                        fontFamily: 'alexandria_medium',
                        fontWeight: FontWeight.w500,
                        color:MyColors.MainBulma)),
                Text(" 👋",
                    style:  TextStyle(fontSize: 14.sp,
                        fontFamily: 'alexandria_medium',
                        fontWeight: FontWeight.w500,
                        color:MyColors.MainBulma)),
              ],
            ),
            SizedBox(height: 1.h,),
            Row(
              children: [
                SvgPicture.asset('assets/location2.svg',width: 2.h,height: 2.h,),
                SizedBox(width: 2.w,),
                Obx(() => registerController.address2.value==""?
                SizedBox(
                  width: 17.h,
                  child: Text(homeController.currentAddress.toString(),
                      style:  TextStyle(fontSize: 8.sp,
                      fontFamily: 'alexandria_regular',
                      fontWeight: FontWeight.w300,
                      color:MyColors.MainTrunks)),
                )
                    :SizedBox(
                  width: 17.h,
                      child: Text(registerController.address2.value.toString(),
                      style:  TextStyle(fontSize: 8.sp,
                          fontFamily: 'alexandria_regular',
                          fontWeight: FontWeight.w300,
                          color:MyColors.MainTrunks)),
                    )),
                SizedBox(width: 1.w,),
                GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, "/location_screen",arguments: "UpOnRequest");
                  },
                  child: SizedBox(

                    child: Text('change_address'.tr(),
                        style:  TextStyle(fontSize: 10.sp,
                        fontFamily: 'alexandria_medium',
                        fontWeight: FontWeight.w400,
                        color:MyColors.MainPrimary)),
                  ),
                ),
              ],
            ),
          ],
        ),
         const Spacer(),
        GestureDetector(
          onTap: (){
             Navigator.pushNamed(context, '/notificatio_screen');
          },
          child: SvgPicture.asset("assets/notifi.svg",width: 3.h,height: 3.h), ),
        SizedBox(width: 1.h,)
      ],
    );
  }

  Widget dots(){
    if (homeController.sliderList.isEmpty) {
      // Display alternative design here
      return const Text('No sliders available');
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CarouselSlider.builder(
            itemCount: homeController.sliderList.length,
            itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: MyColors.MainPrimary,
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child:  Image(image:
                        NetworkImage(homeController.sliderList[itemIndex].image),fit: BoxFit.fill,)
                    )),
            options: CarouselOptions(
                height: 20.h,
                autoPlay: true,
                enlargeCenterPage: false,
                viewportFraction: 1.0,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
                onPageChanged: (int index, CarouselPageChangedReason reason) => {
                  setState(() => {currentIndex = index})
                }),
          ),
          DotsIndicator(
            dotsCount: homeController.sliderList.length,
            position: currentIndex.toDouble(),
            decorator: DotsDecorator(
              size:  Size.square(1.h),
              activeSize:  Size(2.h, 1.h),
              activeColor: MyColors.MainPrimary,
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          )
        ],

      );
    }
  }

  Widget orderWay(){
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, '/order_method_screen',arguments: "");
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(
              color: MyColors.MainGoku, width: 1.0,),
            color:  MyColors.MainGoku),
        padding: EdgeInsetsDirectional.all(1.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/checklist_minimalistic.svg'),
            SizedBox(width: 1.h,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("order_method".tr(),
                    style:  TextStyle(fontSize: 10.sp,
                        fontFamily: 'alexandria_bold',
                        fontWeight: FontWeight.w500,
                        color:MyColors.MainPrimary)),
                SizedBox(height: 1.h,),
                SizedBox(
                  width: 32.h,
                  child: Text("find_out_how".tr(),
                      style:  TextStyle(fontSize: 8.sp,
                          fontFamily: 'alexandria_regular',
                          fontWeight: FontWeight.w300,
                          color:MyColors.MainZeno)),
                ),
              ],
            ),
            const Spacer(),
          Transform.rotate(
              angle:homeController.lang=="en"? 180 *math.pi /180:0,
              child: SvgPicture.asset('assets/arrow.svg',)),
            //SvgPicture.asset('assets/arrow.svg'),

          ],
        ),
      ),
    );
  }

  Widget categories(){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, "/ghassal_baskets_screens");
                },
                child: Container(
                  height: 17.h,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(color: MyColors.MainGoku, width: 1.0,),
                      image: const DecorationImage(image: AssetImage('assets/img1.png'),fit: BoxFit.fill)),
                  child: Container(
                    padding: EdgeInsetsDirectional.all(1.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("ghassal".tr(),
                            style:  TextStyle(fontSize: 10.sp,
                                fontFamily: 'alexandria_regular',
                                fontWeight: FontWeight.w300,
                                color:MyColors.MainGohan),),
                        Text("baskets".tr(),
                            style:  TextStyle(fontSize: 16.sp,
                                fontFamily: 'alexandria_bold',
                                fontWeight: FontWeight.w600,
                                color:MyColors.MainGohan)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 1.h,),
            Expanded(
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/ghassal_upon_request_screens');
                },
                child: Container(
                  height: 17.h,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(color: MyColors.MainGoku, width: 1.0,),
                      image: const DecorationImage(image: AssetImage('assets/img2.png'),fit: BoxFit.fill)),
                  child: Container(
                    padding: EdgeInsetsDirectional.all(1.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("ghassal".tr(),
                          style:  TextStyle(fontSize: 10.sp,
                              fontFamily: 'alexandria_regular',
                              fontWeight: FontWeight.w300,
                              color:MyColors.MainGohan),),
                        Text("upon_request".tr(),
                            style:  TextStyle(fontSize: 16.sp,
                                fontFamily: 'alexandria_bold',
                                fontWeight: FontWeight.w600,
                                color:MyColors.MainGohan)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h,),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, "/ghassal_subscription_screens");
                },
                child: Container(
                  height: 17.h,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(color: MyColors.MainGoku, width: 1.0,),
                      image: const DecorationImage(image: AssetImage('assets/img3.png'),fit: BoxFit.fill)),
                  child: Container(
                    padding: EdgeInsetsDirectional.all(1.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("ghassal".tr(),
                          style:  TextStyle(fontSize: 10.sp,
                              fontFamily: 'alexandria_regular',
                              fontWeight: FontWeight.w300,
                              color:MyColors.MainGohan),),
                        Text("subscriptions".tr(),
                            style:  TextStyle(fontSize: 16.sp,
                                fontFamily: 'alexandria_bold',
                                fontWeight: FontWeight.w600,
                                color:MyColors.MainGohan)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 1.h,),
            Expanded(
              child: Container(
                height: 17.h,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(color: MyColors.MainGoku, width: 1.0,),
                    image: const DecorationImage(image: AssetImage('assets/img4.png'),fit: BoxFit.fill)),
                child: Container(
                  padding: EdgeInsetsDirectional.all(1.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("ghassal".tr(),
                        style:  TextStyle(fontSize: 10.sp,
                            fontFamily: 'alexandria_regular',
                            fontWeight: FontWeight.w300,
                            color:MyColors.MainGohan),),
                      Text("products".tr(),
                          style:  TextStyle(fontSize: 16.sp,
                              fontFamily: 'alexandria_bold',
                              fontWeight: FontWeight.w600,
                              color:MyColors.MainGohan)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h,),

      ],
    );
  }

  Widget consumptionSubscription(){
    if(homeController.mySubscriptionsList.isNotEmpty) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: homeController.mySubscriptionsList.length,
          itemBuilder: (context, int index) {
            return ConsumptionSubscriptionItem(
              mySubscribtions: homeController.mySubscriptionsList[index],
            );
          }
      );
    }else{
      return Container();
    }
  }

  Widget Internet(){
    return Container(
      color: MyColors.MainGoku,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsetsDirectional.only(top: 20.h,start: 1.h,end: 1.h),
      //margin: EdgeInsets.only(left: 1.5.h, right: 1.5.h, top: 1.5.h),
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
                    print("jkjk"+homeController.currentAddress.toString());
                    animationController=AnimationController(
                      vsync: this,duration: const Duration(seconds: 5),)..addListener(() {
                      setState(() {

                      });
                    });
                    animationController.repeat(reverse: true);
                    homeController.getData();
                    progressValue = 0.0;
                    homeController.getHomeData(
                        registerController.lat.toString(),registerController.lng.toString(),context);
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