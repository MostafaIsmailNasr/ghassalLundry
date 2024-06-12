import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../business/aboutUsController/AboutUsController.dart';
import '../../../../business/homeController/HomeController.dart';
import '../../../../business/moreController/MoreController.dart';
import '../../../../conustant/my_colors.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'dart:math' as math;

import '../../buttomSheets/logoutSheet/logout_buttom_sheet.dart';
import '../../morePages/chooseLanguageButtomSheet/choose_Language_dialog.dart';


class MoreScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MoreScreen();
  }
}

class _MoreScreen extends State<MoreScreen>{
  final moreController = Get.put(MoreController());
  final homeController = Get.put(HomeController());
  final aboutUsController = Get.put(AboutUsController());

  @override
  void initState() {
    aboutUsController.getSocialLinks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text('more'.tr(),
            style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'alexandria_bold',
                fontWeight: FontWeight.w500,
                color: MyColors.MainBulma)),
      ),
      body: moreController.sharedPreferencesService.getBool("islogin")==false?
      Container(
        margin: EdgeInsetsDirectional.only(top: 3.h,end: 2.h,start: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsetsDirectional.only(top: 3.h,end: 1.5.h,start: 1.5.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                    color: MyColors.MainGoku,
                    width: 1.0,
                  ),
                  color: MyColors.MainGoku),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, "/about_app_screen");
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/danger.svg'),
                        SizedBox(width: 1.5.h,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('about_ghassal'.tr(),
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontFamily: 'alexandria_medium',
                                    fontWeight: FontWeight.w500,
                                    color: MyColors.MainTrunks)),
                            Text('overview_information_about_application'.tr(),
                                style: TextStyle(
                                    fontSize: 8.sp,
                                    fontFamily: 'alexandria_regular',
                                    fontWeight: FontWeight.w300,
                                    color: MyColors.textColor)),
                          ],
                        ),
                        const Spacer(),
                        Transform.rotate(
                            angle:homeController.lang=="en"? 180 *math.pi /180:0,
                            child: SvgPicture.asset('assets/arrow_Left2.svg',)),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.5.h,),
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, '/faqs');
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/question.svg'),
                        SizedBox(width: 1.h,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('fAQS'.tr(),
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontFamily: 'alexandria_medium',
                                    fontWeight: FontWeight.w500,
                                    color: MyColors.MainTrunks)),
                            Text('The_most_common_questions_of_users'.tr(),
                                style: TextStyle(
                                    fontSize: 8.sp,
                                    fontFamily: 'alexandria_regular',
                                    fontWeight: FontWeight.w300,
                                    color: MyColors.textColor)),
                          ],
                        ),
                        const Spacer(),
                        Transform.rotate(
                            angle:homeController.lang=="en"? 180 *math.pi /180:0,
                            child: SvgPicture.asset('assets/arrow_Left2.svg',)),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.5.h,),
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, '/terms_and_condition_screen');
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/file_text.svg'),
                        SizedBox(width: 1.h,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Terms_and_Conditions'.tr(),
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontFamily: 'alexandria_medium',
                                    fontWeight: FontWeight.w500,
                                    color: MyColors.MainTrunks)),
                            Text('App_terms_and_conditions'.tr(),
                                style: TextStyle(
                                    fontSize: 8.sp,
                                    fontFamily: 'alexandria_regular',
                                    fontWeight: FontWeight.w300,
                                    color: MyColors.textColor)),
                          ],
                        ),
                        const Spacer(),
                        Transform.rotate(
                            angle:homeController.lang=="en"? 180 *math.pi /180:0,
                            child: SvgPicture.asset('assets/arrow_Left2.svg',)),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.5.h,),
                  InkWell(
                    onTap: (){
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
                              child: ChooseLanguageDialog()));
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/language.svg'),
                        SizedBox(width: 1.h,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('language'.tr(),
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontFamily: 'alexandria_medium',
                                    fontWeight: FontWeight.w500,
                                    color: MyColors.MainTrunks)),
                            Text('Choose_your_preferred_language'.tr(),
                                style: TextStyle(
                                    fontSize: 8.sp,
                                    fontFamily: 'alexandria_regular',
                                    fontWeight: FontWeight.w300,
                                    color: MyColors.textColor)),
                          ],
                        ),
                        const Spacer(),
                        Transform.rotate(
                            angle:homeController.lang=="en"? 180 *math.pi /180:0,
                            child: SvgPicture.asset('assets/arrow_Left2.svg',)),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.5.h,),
                ],
              ),
            ),
            SizedBox(height: 2.h,),
            Container(
              padding: EdgeInsetsDirectional.only(top: 3.h,end: 1.5.h,start: 1.5.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                    color: MyColors.MainGoku,
                    width: 1.0,
                  ),
                  color: MyColors.MainGoku),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/login_screen", ModalRoute.withName('/login_screen'),arguments: "");
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/logout.svg'),
                        SizedBox(width: 1.5.h,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('login'.tr(),
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontFamily: 'alexandria_medium',
                                    fontWeight: FontWeight.w500,
                                    color: MyColors.MainTrunks)),
                            Text('login_create_account'.tr(),
                                style: TextStyle(
                                    fontSize: 8.sp,
                                    fontFamily: 'alexandria_regular',
                                    fontWeight: FontWeight.w300,
                                    color: MyColors.textColor)),
                          ],
                        ),
                        const Spacer(),
                        Transform.rotate(
                            angle:homeController.lang=="en"? 180 *math.pi /180:0,
                            child: SvgPicture.asset('assets/arrow_Left2.svg',)),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.5.h,),
                ],
              ),
            )
          ],
        ),
      ) :
      Container(
        margin: EdgeInsetsDirectional.only(top: 1.h,end: 2.h,start: 2.h,bottom: 9.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsetsDirectional.only(top: 3.h,end: 1.5.h,start: 1.5.h),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                      color: MyColors.MainGoku,
                      width: 1.0,
                    ),
                    color: MyColors.MainGoku),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, "/profile_screen");
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/user_more.svg'),
                          SizedBox(width: 1.5.h,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('profile'.tr(),
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontFamily: 'alexandria_medium',
                                      fontWeight: FontWeight.w500,
                                      color: MyColors.MainBulma)),
                              Text('change_phone_number_account_details'.tr(),
                                  style: TextStyle(
                                      fontSize: 8.sp,
                                      fontFamily: 'alexandria_regular',
                                      fontWeight: FontWeight.w300,
                                      color: MyColors.MainTrunks)),
                            ],
                          ),
                          const Spacer(),
                          Transform.rotate(
                              angle:homeController.lang=="en"? 180 *math.pi /180:0,
                              child: SvgPicture.asset('assets/arrow_Left2.svg',)),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.5.h,),
                    InkWell(
                      onTap: (){
                         Navigator.pushNamed(context, "/my_location_screen");
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/point.svg'),
                          SizedBox(width: 1.5.h,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('location'.tr(),
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontFamily: 'alexandria_medium',
                                      fontWeight: FontWeight.w500,
                                      color: MyColors.MainBulma)),
                              Text('control_delivery_addresses'.tr(),
                                  style: TextStyle(
                                      fontSize: 8.sp,
                                      fontFamily: 'alexandria_regular',
                                      fontWeight: FontWeight.w300,
                                      color: MyColors.MainTrunks)),
                            ],
                          ),
                          const Spacer(),
                          Transform.rotate(
                              angle:homeController.lang=="en"? 180 *math.pi /180:0,
                              child: SvgPicture.asset('assets/arrow_Left2.svg',)),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.5.h,),
                    InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, "/about_app_screen");
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/danger.svg'),
                          SizedBox(width: 1.5.h,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('about_ghassal'.tr(),
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontFamily: 'alexandria_medium',
                                      fontWeight: FontWeight.w500,
                                      color: MyColors.MainBulma)),
                              Text('overview_information_about_application'.tr(),
                                  style: TextStyle(
                                      fontSize: 8.sp,
                                      fontFamily: 'alexandria_regular',
                                      fontWeight: FontWeight.w300,
                                      color: MyColors.MainTrunks)),
                            ],
                          ),
                          const Spacer(),
                          Transform.rotate(
                              angle:homeController.lang=="en"? 180 *math.pi /180:0,
                              child: SvgPicture.asset('assets/arrow_Left2.svg',)),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h,),
                  ],
                ),
              ),
              SizedBox(height: 2.h,),
              Container(
                padding: EdgeInsetsDirectional.only(top: 3.h,end: 1.5.h,start: 1.5.h),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                      color: MyColors.MainGoku,
                      width: 1.0,
                    ),
                    color: MyColors.MainGoku),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/faqs');
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/question.svg'),
                          SizedBox(width: 1.h,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('fAQS'.tr(),
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontFamily: 'alexandria_medium',
                                      fontWeight: FontWeight.w500,
                                      color: MyColors.MainBulma)),
                              Text('The_most_common_questions_of_users'.tr(),
                                  style: TextStyle(
                                      fontSize: 8.sp,
                                      fontFamily: 'alexandria_regular',
                                      fontWeight: FontWeight.w300,
                                      color: MyColors.MainTrunks)),
                            ],
                          ),
                          const Spacer(),
                          Transform.rotate(
                              angle:homeController.lang=="en"? 180 *math.pi /180:0,
                              child: SvgPicture.asset('assets/arrow_Left2.svg',)),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.5.h,),
                    InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/terms_and_condition_screen');
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/file_text.svg'),
                          SizedBox(width: 1.h,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Terms_and_Conditions'.tr(),
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontFamily: 'alexandria_medium',
                                      fontWeight: FontWeight.w500,
                                      color: MyColors.MainBulma)),
                              Text('App_terms_and_conditions'.tr(),
                                  style: TextStyle(
                                      fontSize: 8.sp,
                                      fontFamily: 'alexandria_regular',
                                      fontWeight: FontWeight.w300,
                                      color: MyColors.MainTrunks)),
                            ],
                          ),
                          const Spacer(),
                          Transform.rotate(
                              angle:homeController.lang=="en"? 180 *math.pi /180:0,
                              child: SvgPicture.asset('assets/arrow_Left2.svg',)),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.5.h,),
                    InkWell(
                      onTap: (){
                        whatsappClient();
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/dialog.svg'),
                          SizedBox(width: 1.h,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('direct_technical_support'.tr(),
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontFamily: 'alexandria_medium',
                                      fontWeight: FontWeight.w500,
                                      color: MyColors.MainBulma)),
                              Text('contact_us2'.tr(),
                                  style: TextStyle(
                                      fontSize: 8.sp,
                                      fontFamily: 'alexandria_regular',
                                      fontWeight: FontWeight.w300,
                                      color: MyColors.MainTrunks)),
                            ],
                          ),
                          const Spacer(),
                          Transform.rotate(
                              angle:homeController.lang=="en"? 180 *math.pi /180:0,
                              child: SvgPicture.asset('assets/arrow_Left2.svg',)),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.5.h,),
                    InkWell(
                      onTap: (){
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
                                child: ChooseLanguageDialog()));
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/language.svg'),
                          SizedBox(width: 1.h,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('language'.tr(),
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontFamily: 'alexandria_medium',
                                      fontWeight: FontWeight.w500,
                                      color: MyColors.MainBulma)),
                              Text('Choose_your_preferred_language'.tr(),
                                  style: TextStyle(
                                      fontSize: 8.sp,
                                      fontFamily: 'alexandria_regular',
                                      fontWeight: FontWeight.w300,
                                      color: MyColors.MainTrunks)),
                            ],
                          ),
                          const Spacer(),
                          Transform.rotate(
                              angle:homeController.lang=="en"? 180 *math.pi /180:0,
                              child: SvgPicture.asset('assets/arrow_Left2.svg',)),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.5.h,),
                  ],
                ),
              ),
              SizedBox(height: 2.h,),
              Container(
                padding: EdgeInsetsDirectional.only(top: 3.h,end: 1.5.h,start: 1.5.h),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                      color: MyColors.MainGoku,
                      width: 1.0,
                    ),
                    color: MyColors.MainGoku),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){
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
                                child: LogoutButtomSheet()));
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/login2.svg'),
                          SizedBox(width: 1.5.h,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('logout'.tr(),
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontFamily: 'alexandria_medium',
                                      fontWeight: FontWeight.w500,
                                      color: MyColors.SupportiveChichi)),
                              Text('logout_account'.tr(),
                                  style: TextStyle(
                                      fontSize: 8.sp,
                                      fontFamily: 'alexandria_regular',
                                      fontWeight: FontWeight.w300,
                                      color: MyColors.MainTrunks)),
                            ],
                          ),
                          const Spacer(),
                          Transform.rotate(
                              angle:homeController.lang=="en"? 180 *math.pi /180:0,
                              child: SvgPicture.asset('assets/arrow_Left2.svg',)),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.5.h,),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
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
                        var facebookUrl =
                            //"https://www.facebook.com/";
                        aboutUsController.socialResponse.value.data?.socialMediaLinks!.value![0].link.toString();
                        _openUrl(facebookUrl!);
                      },
                      child: SvgPicture.asset('assets/face.svg',width: 7.h,height: 7.h,)),
                  SizedBox(width: 1.h,),
                  GestureDetector(
                      onTap: (){
                        var instagramUrl = aboutUsController.socialResponse.value.data?.socialMediaLinks!.value![1].link.toString();
                            //'https://www.instagram.com';
                        _openUrl(instagramUrl!);
                      },
                      child: SvgPicture.asset('assets/x.svg',width: 7.h,height: 7.h,)),
                  SizedBox(width: 1.h,),
                  GestureDetector(
                      onTap: (){
                        var twitterUrl =
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
              SizedBox(height: 7.h),
            ],
          ),
        ),
      ),
    );
  }

  whatsappClient()async{
    var phone2= aboutUsController.socialResponse.value.data!.contactUs!.value![1].link.toString();
    var iosUrl = "https://wa.me/$phone2";
    var  url='https://api.whatsapp.com/send?phone=$phone2';
    if(Platform.isIOS){
      await launchUrl(Uri.parse(iosUrl));
    }
    else{
      await launch(url);
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

}