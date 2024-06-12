
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

import '../../../../business/auth/introController/IntroController.dart';
import '../../../../conustant/my_colors.dart';

class IntoSliderScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IntoSliderScreenState();
  }
}

class _IntoSliderScreenState extends State<IntoSliderScreen> {
  List<ContentConfig> slides = [];
  final introController = Get.put(IntroController());

  @override
  void initState() {
    super.initState();
    introController.getIntroData().then((response) {
      // if (response.statusCode == 200) {
      setState(() {
        introController.introList.forEach((intro) {
          slides.add(
            ContentConfig(
              title: intro.title!,
              description: intro.content!,
              pathImage: intro.image!,
            ),
          );
        });
      });
      // } else {
      //   // Handle error
      // }
    });
  }

  List<Widget> generateListCustomTabs() {
    return slides.map((slide) {
      return Container(
        margin: const EdgeInsetsDirectional.only(start: 20, end: 20),
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 3.h),
            //SvgPicture.asset(slide.pathImage!,width: MediaQuery.of(context).size.width,height: 50.h,),
            Image.network(
              slide.pathImage!,
              width: MediaQuery.of(context).size.width,
              //height: 60.h,
              //fit: BoxFit.fill,
            ),
            SizedBox(height: 2.h),
            Center(
              child: Text(
                slide.title!,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'alexandria_extraBold',
                  fontWeight: FontWeight.w600,
                  color: MyColors.MainBulma,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              slide.description!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'alexandria_regular',
                fontWeight: FontWeight.w300,
                color: MyColors.MainTrunks,),
            ),
          ],
        ),
      );
    }).toList();
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      backgroundColor: MaterialStateProperty.all<Color>(MyColors.MainPrimary),
      foregroundColor: MaterialStateProperty.all<Color>(MyColors.MainPrimary),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (slides.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: Container(
        color:Colors.white,
        margin: EdgeInsetsDirectional.only(start: 1.h, end: 1.h),
        child: IntroSlider(
          key: UniqueKey(),
          listContentConfig: slides,
          renderSkipBtn: Text(
            'skip'.tr(),
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: 'alexandria_regular',
              fontWeight: FontWeight.w300,
              color: MyColors.MainTrunks,
            ),
          ),
          renderNextBtn:Container(
              padding: EdgeInsetsDirectional.all(1.h),
              child: SvgPicture.asset("assets/arrow_right.svg")),
          nextButtonStyle: myButtonStyle(),
          renderDoneBtn: Container(
              padding: EdgeInsetsDirectional.all(1.h),
              child: SvgPicture.asset("assets/arrow_right.svg")),
          onDonePress: onDonePress,
          doneButtonStyle: myButtonStyle(),
          indicatorConfig: IndicatorConfig(
            sizeIndicator: 1.2.h,
            colorActiveIndicator: MyColors.MainPrimary,
            colorIndicator: MyColors.MainPrimary,
            typeIndicatorAnimation: TypeIndicatorAnimation.sizeTransition,
          ),
          listCustomTabs: generateListCustomTabs(),
          scrollPhysics: BouncingScrollPhysics(),
          backgroundColorAllTabs: Colors.white,
        ),
      ),
    );
  }

  void onDonePress() async{
   //await introController.sharedPreferencesService.setBool("isLogin", false);
    Navigator.pushNamedAndRemoveUntil(context,'/drower',ModalRoute.withName('/drower'));
  }
}
