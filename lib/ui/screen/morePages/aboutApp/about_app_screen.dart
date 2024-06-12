import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../business/aboutUsController/AboutUsController.dart';
import '../../../../business/homeController/HomeController.dart';
import '../../../../conustant/my_colors.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:convert';
import 'dart:math' as math;

class AboutAppScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _AboutAppScreen();
  }
}

class _AboutAppScreen extends State<AboutAppScreen>{
  final aboutUsController = Get.put(AboutUsController());
  final homeController = Get.put(HomeController());
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
    aboutUsController.aboutUs();
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
          title: Text('about_ghassal'.tr(),
              style:  TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'alexandria_bold',
                  fontWeight: FontWeight.w500,
                  color: MyColors.MainBulma)),
        ),
      body:con? Obx(() => !aboutUsController.isLoading.value?
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin:  EdgeInsetsDirectional.only(end: 1.5.h,start: 1.5.h,bottom: 1.5.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h,),
              Center(child: SvgPicture.asset('assets/ghassal_logo.svg')),
              SizedBox(height: 5.h,),
              Text('about_ghassal2'.tr(),
                  style:  TextStyle(fontSize: 12.sp,
                      fontFamily: 'alexandria_bold',
                      fontWeight: FontWeight.w500,
                      color: MyColors.MainBulma)),
              SizedBox(height: 1.h,),
              Html(
                data: aboutUsController.aboutAsResponse.value.data!.content??"",
              ),
              SizedBox(height: 2.h),
              Text('contact_us3'.tr(),
                  style:  TextStyle(fontSize: 12.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w500,
                      color: MyColors.MainBulma)),
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: (){
                  var phone=//"+8254859587";
                  aboutUsController.socialResponse.value.data!.contactUs!.value![1].link.toString();
                  _makePhoneCall('tel:$phone');
                },
                child: Row(
                  children: [
                    SvgPicture.asset('assets/call_calling.svg',width: 3.h,height: 3.h),
                    SizedBox(width: 1.h),
                    Text(//"8254859587",
                        aboutUsController.socialResponse.value.data?.contactUs!.value![1].link.toString()??"",
                        style:  TextStyle(fontSize: 12.sp,
                            fontFamily: 'alexandria_medium',
                            fontWeight: FontWeight.w400,
                            color: MyColors.Dark)),
                  ],
                ),
              ),
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: (){
                  launchEmail(aboutUsController.socialResponse.value.data!.contactUs!.value![0].link.toString());
                },
                child: Row(
                  children: [
                    SvgPicture.asset('assets/sms_notification.svg',width: 3.h,height: 3.h,),
                    SizedBox(width: 1.h),
                    Text(aboutUsController.socialResponse.value.data?.contactUs!.value![0].link.toString()??"",
                        style:  TextStyle(fontSize: 12.sp,
                            fontFamily: 'alexandria_medium',
                            fontWeight: FontWeight.w400,
                            color: MyColors.Dark)),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: (){
                        var facebookUrl = //"https://www.facebook.com/";
                        aboutUsController.socialResponse.value.data?.socialMediaLinks!.value![4].link.toString();
                        _openUrl(facebookUrl!);
                      },
                      child: SvgPicture.asset('assets/snap.svg',width: 7.h,height: 7.h,)),
                  SizedBox(width: 1.h,),
                  GestureDetector(
                      onTap: (){
                        var facebookUrl = //"https://www.facebook.com/";
                        aboutUsController.socialResponse.value.data?.socialMediaLinks!.value![0].link.toString();
                        _openUrl(facebookUrl!);
                      },
                      child: SvgPicture.asset('assets/face.svg',width: 7.h,height: 7.h,)),
                  SizedBox(width: 1.h,),
                  GestureDetector(
                      onTap: (){
                        var instagramUrl =  aboutUsController.socialResponse.value.data?.socialMediaLinks!.value![1].link.toString();
                        //'https://www.instagram.com';
                        _openUrl(instagramUrl!);
                      },
                      child: SvgPicture.asset('assets/x.svg',width: 7.h,height: 7.h,)),
                  SizedBox(width: 1.h,),
                  GestureDetector(
                      onTap: (){
                        var twitterUrl = //"https://www.facebook.com/";
                        aboutUsController.socialResponse.value.data?.socialMediaLinks!.value![2].link.toString();
                        _openUrl(twitterUrl!);
                      },
                      child: SvgPicture.asset('assets/linkedin.svg',width: 7.h,height: 7.h,)),
                ],
              ),
              SizedBox(height: 1.h),
              Center(
                child: Text("الإصدار 2.23.10",
                    style:  TextStyle(fontSize: 8.sp,
                        fontFamily: 'alexandria_medium',
                        fontWeight: FontWeight.w400,
                        color: MyColors.MainTrunks)),
              ),
            ],
          ),
        ),
      )
          :const Center(child: CircularProgressIndicator(color: MyColors.MainPrimary),)):internet()

    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void launchEmail(String url) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: url,
    );

    if (await launchUrl(Uri.parse(emailLaunchUri.toString()))) {
    } else {
      throw Exception('Could not launch $emailLaunchUri');
    }
  }

  Future<void> _openUrl(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
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
                    aboutUsController.aboutUs();
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