import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:sizer/sizer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../business/homeController/HomeController.dart';
import '../../../../conustant/my_colors.dart';

class LogoutButtomSheet extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _LogoutButtomSheet();
  }
}

class _LogoutButtomSheet extends State<LogoutButtomSheet>{
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        side: BorderSide(color: MyColors.MainGoku)
      ));
  final homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 1.h,left: 1.h,top: 1.h,bottom: 2.h),
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomBar(),
              SizedBox(
                width: double.infinity,
                height: 8.h,
                child: TextButton(
                  style: flatButtonStyle,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("cancel".tr(),
                    style:  TextStyle(fontSize: 12.sp,
                        fontFamily: 'alexandria_bold',
                        fontWeight: FontWeight.w500,
                        color:MyColors.MainTrunks),),
                ),
              ),
              SizedBox(height: 2.h,),
              SizedBox(
                width: double.infinity,
                height: 8.h,
                child: TextButton(
                  style: flatButtonStyle,
                  onPressed: () async{
                    await homeController.sharedPreferencesService.setBool('islogin',false);
                    await homeController.sharedPreferencesService.clear();
                    homeController.sharedPreferencesService.setString("lang", translator.currentLanguage.toString());
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/login_screen", ModalRoute.withName('/login_screen'),arguments: "");
                  },
                  child: Text("logout".tr(),
                    style:  TextStyle(fontSize: 12.sp,
                        fontFamily: 'alexandria_bold',
                        fontWeight: FontWeight.w500,
                        color:MyColors.SupportiveChichi),),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget CustomBar(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 3.h,),
        Text("definitely_logout".tr(),
          style:  TextStyle(fontSize: 14.sp,
              fontFamily: 'alexandria_bold',
              fontWeight: FontWeight.w600,
              color:MyColors.MainBulma),),
        SizedBox(height: 1.h,),
        Row(
          children: [
            SvgPicture.asset('assets/info_circle.svg'),
            SizedBox(width: 1.h,),
            Text("do_want_logout".tr(),
              style:  TextStyle(fontSize: 8.sp,
                  fontFamily: 'alexandria_regular',
                  fontWeight: FontWeight.w300,
                  color:MyColors.MainTrunks),),
          ],
        ),
        SizedBox(height: 1.h,),
      ],
    );
  }

}