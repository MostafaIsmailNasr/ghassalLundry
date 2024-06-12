import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

import '../../../../business/homeController/HomeController.dart';
import '../../../../conustant/di.dart';
import '../../../../conustant/my_colors.dart';
import '../../../../conustant/shared_preference_serv.dart';
import '../../../../conustant/toast_class.dart';

class ChooseLanguageDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChooseLanguageDialog();
  }
}

class _ChooseLanguageDialog extends State<ChooseLanguageDialog> {
  var isSelected = false;
  int? itemId = 0;
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  final homeController = Get.put(HomeController());
  final SharedPreferencesService sharedPreferencesService =
      instance<SharedPreferencesService>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 2.h, left: 2.h, top: 1.h, bottom: 1.h),
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomBar(),
              InkWell(
                onTap: () {
                  setState(() {
                    isSelected = true;
                    itemId = 1;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 8.h,
                  margin: EdgeInsetsDirectional.only(start: 1.h, end: 1.h),
                  padding: EdgeInsets.all(1.h),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                        color: isSelected == true && itemId == 1
                            ? MyColors.MainSecondary
                            : MyColors.MainBeerus,
                        width: 1.0,
                      ),
                      color: isSelected == true && itemId == 1
                          ? MyColors.timeBack
                          : MyColors.MainGoku),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/egypt.svg'),
                      //Image.asset('assets/egypt.png',width: 3.h,),
                      SizedBox(
                        width: 1.h,
                      ),
                      Text(
                        'arabic'.tr(),
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'alexandria_regular',
                            fontWeight: FontWeight.w300,
                            color: MyColors.Dark),
                      ),
                      const Spacer(),
                      isSelected == true && itemId == 1
                          ? SvgPicture.asset('assets/radio_selected.svg')
                          : SvgPicture.asset(
                              'assets/radio_button.svg',
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isSelected = true;
                    itemId = 2;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 8.h,
                  margin: EdgeInsetsDirectional.only(start: 1.h, end: 1.h),
                  padding: EdgeInsets.all(1.h),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                        color: isSelected == true && itemId == 2
                            ? MyColors.MainSecondary
                            : MyColors.MainBeerus,
                        width: 1.0,
                      ),
                      color: isSelected == true && itemId == 2
                          ? MyColors.timeBack
                          : MyColors.MainGoku),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/english.svg'),
                      //Image.asset('assets/english.png',width: 3.h,),
                      SizedBox(
                        width: 1.h,
                      ),
                      Text(
                        'english'.tr(),
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'alexandria_regular',
                            fontWeight: FontWeight.w300,
                            color: MyColors.Dark),
                      ),
                      const Spacer(),
                      isSelected == true && itemId == 2
                          ? SvgPicture.asset('assets/radio_selected.svg')
                          : SvgPicture.asset(
                              'assets/radio_button.svg',
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 8.h,
                margin: EdgeInsetsDirectional.only(bottom: 2.h),
                child: TextButton(
                  style: flatButtonStyle,
                  onPressed: () async {
                    if (isSelected == true && itemId == 1) {
                      homeController.lang = 'ar';
                      sharedPreferencesService.setString(
                          "lang", homeController.lang);
                      translator.setNewLanguage(
                        context,
                        newLanguage: homeController.lang,
                        remember: true,
                      );
                      Phoenix.rebirth(context);
                      Navigator.pop(context);
                    } else if (isSelected == true && itemId == 2) {
                      homeController.lang = 'en';
                      sharedPreferencesService.setString(
                          "lang", homeController.lang);
                      translator.setNewLanguage(
                        context,
                        newLanguage: homeController.lang,
                        remember: true,
                      );
                      Phoenix.rebirth(context);
                      Navigator.pop(context);
                    } else {
                      Fluttertoast.showToast(
                          msg: 'please_choose_language'.tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
                      );
                    }
                  },
                  child: Text(
                    'confirm'.tr(),
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'alexandria_bold',
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget CustomBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 3.h,
        ),
        Text(
          'choose_language'.tr(),
          style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'alexandria_bold',
              fontWeight: FontWeight.w600,
              color: MyColors.MainBulma),
        ),
        SizedBox(
          height: 1.h,
        ),
        Row(
          children: [
            SvgPicture.asset('assets/info_circle.svg'),
            SizedBox(
              width: 1.h,
            ),
            Text(
              "choose_preferred_language".tr(),
              style: TextStyle(
                  fontSize: 8.sp,
                  fontFamily: 'alexandria_regular',
                  fontWeight: FontWeight.w300,
                  color: MyColors.MainTrunks),
            ),
          ],
        ),
        SizedBox(
          height: 1.h,
        ),
      ],
    );
  }
}
