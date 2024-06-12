import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:sizer/sizer.dart';

import 'dart:math' as math;

import '../../../../business/faqsController/FaqsController.dart';
import '../../../../business/homeController/HomeController.dart';
import '../../../../conustant/my_colors.dart';
import '../../../widget/AnswerQuestionItem.dart';
import '../../../widget/QuestionsFaqs.dart';

class FaqsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FaqsScreen();
  }
}

class _FaqsScreen extends State<FaqsScreen>{
  var selectedFlage;
  var selectedFlageTime=0;
  final faqsController = Get.put(FaqsController());
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
    faqsController.getFaqs();
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
        title: Text('fAQS'.tr(),
            style:  TextStyle(
                fontSize: 12.sp,
                fontFamily: 'alexandria_bold',
                fontWeight: FontWeight.w500,
                color: MyColors.MainBulma)),
      ),
      body:con? Obx(() => !faqsController.isLoading.value ?
                Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsetsDirectional.only(start: 2.h, end: 2.h, top: 2.h),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'top_questions'.tr(),
                          style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'alexandria_medium',
                          fontWeight: FontWeight.w500,
                          color: MyColors.MainBulma,
                        ),
                     ),
                      SizedBox(height: 1.h),
                    ],
                  ),
                  QuestionsList(),
                  SizedBox(height: 2.h),
                  AnswerList(), // Wrap with Expanded instead of Flexible
            ],
          ),
        )
                  : const Center(child: CircularProgressIndicator(color: MyColors.MainPrimary)),):internet()

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
                    faqsController.getFaqs();
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

  Widget QuestionsList(){
    if(faqsController.faqList.isNotEmpty){
      return GridView.builder(
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: (2 / 1),
            crossAxisSpacing: 12,
            mainAxisSpacing: 8,
          ),
          itemCount: faqsController.faqList.length,
          itemBuilder: (context, int index) {
            return QuestionsFaqs(
                is_selected: selectedFlageTime==index,
                onTap: () {
                  setState(() {
                    selectedFlageTime=index;
                  });
                },
                allFaqs: faqsController.faqList[index]
            );
          });
    }else{
      return Container();
    }
  }

  Widget AnswerList() {
    if(faqsController.faqsResponse.value.data!.isNotEmpty){
      return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: faqsController.faqsResponse.value.data![selectedFlageTime].faqs!.length,
        itemBuilder: (context, i) {
          var faq = faqsController.faqsResponse.value.data![selectedFlageTime].faqs![i];
          return AnswerQuestionItem(
            question: faq.question,
            answer: faq.answer,
          );
        },
      );
    }else{
      return Container();
    }

  }
}



