import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:sizer/sizer.dart';
import '../../../../business/homeController/HomeController.dart';
import '../../../../business/termsAndConditionController/TermsAndConditionController.dart';
import '../../../../conustant/my_colors.dart';
import 'dart:math' as math;

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionScreen> createState() =>
      _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  final termsAndConditionController = Get.put(TermsAndConditionController());
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
    termsAndConditionController.getTermsAndConditions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Transform.rotate(
                angle:homeController.lang=="en"? 180 *math.pi /180:0,
                child: SvgPicture.asset('assets/back.svg',))),
        title: Text('Terms_and_Conditions'.tr(),
            style:  TextStyle(
                fontSize: 12.sp,
                fontFamily: 'alexandria_bold',
                fontWeight: FontWeight.w500,
                color: MyColors.MainBulma)),
      ),
      body:con? Obx(() =>!termsAndConditionController.isLoading.value?
      Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 3.h,),
                        Center(child: SvgPicture.asset('assets/ghassal_logo.svg')),
                        SizedBox(height: 5.h,),
                        Padding(
                          padding:  EdgeInsets.only(left: 2.h,right: 2.h),
                          child: Text('terms_of_use_ghassal_service'.tr(),
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: 'alexandria_bold',
                                  fontWeight: FontWeight.w500,
                                  color: MyColors.MainBulma)),
                        ),
                        SizedBox(height: 1.h,),
                        Padding(
                          padding:  EdgeInsets.only(left: 2.h,right: 2.h),
                          child: Text('by_using_service'.tr(),
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  fontFamily: 'alexandria_regular',
                                  fontWeight: FontWeight.w300,
                                  color: MyColors.MainTrunks)),
                        ),
                        SizedBox(height: 1.h,),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsetsDirectional.only(end: 1.h,start: 1.h,top: 2.h),
                          height: 0.2.h,
                          color: MyColors.MainGoku,),
                        SizedBox(height: 2.h,),
                        //termList(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: kk(),
                        ),
                      ]))),
          SizedBox(
            height: 3.h,
          )
        ],
      )
          :const Center(child: CircularProgressIndicator(color: MyColors.MainPrimary),)):internet(),
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
                    termsAndConditionController.getTermsAndConditions();
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


  Widget kk(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Container(
        //   width: 1.h,
        //   height: 1.h,
        //   decoration: const BoxDecoration(
        //     color: MyColors.MainTrunks,
        //     shape: BoxShape.circle,
        //   ),
        //   margin:  EdgeInsets.only(right: 1.h),
        // ),
        Flexible(
          child: Html(
            data:termsAndConditionController.termsAndConditionsResponse.value.data!.content??"",
          ),
        ),
      ],
    );
  }
}
