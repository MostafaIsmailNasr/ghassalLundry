import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

import '../../../../business/homeController/HomeController.dart';
import '../../../../business/profileController/ProfileController.dart';
import '../../../../conustant/my_colors.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileScreen();
  }
}

class _ProfileScreen extends State<ProfileScreen> {
  final homeController = Get.put(HomeController());

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  final profileController = Get.put(ProfileController());

  @override
  void initState() {
    getUserDataFromLocal();
    super.initState();
  }

  getUserDataFromLocal() async {
    setState(() {
      profileController.name =
          profileController.sharedPreferencesService.getString("fullName") ??
              "";
      profileController.phone = profileController.sharedPreferencesService
              .getString("phone_number") ??
          "";
      print("phooo" + profileController.phone);
      profileController.email =
          profileController.sharedPreferencesService.getString("email") ?? "";
      profileController.nameController.text = profileController.name;
      profileController.phoneController.text = profileController.phone;
      profileController.emailController.text = profileController.email;
    });
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
                angle: homeController.lang == "en" ? 180 * math.pi / 180 : 0,
                child: SvgPicture.asset(
                  'assets/back.svg',
                ))),
        title: Text('profile'.tr(),
            style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'alexandria_bold',
                fontWeight: FontWeight.w500,
                color: MyColors.MainBulma)),
        actions: [
          // GestureDetector(
          //   onTap: (){
          //
          //   },
          //   child: Padding(
          //     padding: EdgeInsets.only(left: 2.h,right: 2.h),
          //     child: SvgPicture.asset('assets/menu.svg'),
          //   ),
          // ),
          PopupMenuButton(
            initialValue: 2,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(left: 2.h, right: 2.h),
              child: SvgPicture.asset('assets/menu.svg'),
            ),
            itemBuilder: (context) {
              return List.generate(1, (index) {
                return PopupMenuItem(
                  value: index,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset('assets/remove.svg'),
                      Text(
                        'delete_account'.tr(),
                        style: TextStyle(
                            fontSize: 10.sp,
                            fontFamily: 'regular',
                            fontWeight: FontWeight.w500,
                            color: Colors.red),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(context, "/login_screen",
                        ModalRoute.withName('/login_screen'),
                        arguments: "");
                  },
                );
              });
            },
          ),
        ],
      ),
      body: Obx(() => !profileController.isLoading.value
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsetsDirectional.only(
                  end: 1.5.h, start: 1.5.h, bottom: 1.5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "full_name".tr(),
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'alexandria_medium',
                        fontWeight: FontWeight.w300,
                        color: MyColors.MainBulma),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                          color: MyColors.MainGoku,
                          width: 1.0,
                        ),
                        color: MyColors.MainGoku),
                    child: name(),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text("phoneNumber".tr(),
                      style: TextStyle(
                          fontSize: 10.sp,
                          fontFamily: 'alexandria_medium',
                          fontWeight: FontWeight.w500,
                          color: MyColors.MainBulma)),
                  SizedBox(
                    height: 1.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                          color: MyColors.MainGoku,
                          width: 1.0,
                        ),
                        color: MyColors.MainGoku),
                    child: phoneNumber(),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text('email_address'.tr(),
                      style: TextStyle(
                          fontSize: 10.sp,
                          fontFamily: 'alexandria_medium',
                          fontWeight: FontWeight.w500,
                          color: MyColors.MainBulma)),
                  SizedBox(
                    height: 1.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                          color: MyColors.MainGoku,
                          width: 1.0,
                        ),
                        color: MyColors.MainGoku),
                    child: Email(),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: MyColors.MainPrimary,
              ),
            )),
      bottomNavigationBar: Container(
        margin: EdgeInsetsDirectional.only(start: 1.h, end: 1.h, bottom: 3.h),
        width: double.infinity,
        height: 12.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Center(
              child: Obx(() => Visibility(
                  visible: profileController.isVisabl.value,
                  child: const CircularProgressIndicator(
                    color: MyColors.MainPrimary,
                  ))),
            ),
            SizedBox(
              width: double.infinity,
              height: 7.h,
              child: TextButton(
                style: flatButtonStyle,
                onPressed: () async {
                  profileController.isVisabl.value = true;
                  profileController.profile(context);
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
    );
  }

  Widget name() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: profileController.nameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'please_enter_name'.tr();
        }
        return null;
      },
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(1.2.h, 0, 1.2.h, 0),
            child: SvgPicture.asset("assets/user.svg")),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.red, style: BorderStyle.solid),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide:
              BorderSide(color: MyColors.MainBeerus, style: BorderStyle.solid),
        ),
        fillColor: Colors.green,
        focusColor: Colors.green,
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: MyColors.MainBeerus,
            )),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.red, style: BorderStyle.solid),
        ),
        hintText: 'enter_name'.tr(),
        hintStyle: TextStyle(
            fontSize: 12.sp,
            fontFamily: 'alexandria_medium',
            fontWeight: FontWeight.w300,
            color: MyColors.MainBulma),
      ),
      style: TextStyle(
          fontSize: 12.sp,
          fontFamily: 'alexandria_medium',
          fontWeight: FontWeight.w300,
          color: MyColors.MainBulma),
      keyboardType: TextInputType.text,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  Widget phoneNumber() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: profileController.phoneController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'please_enter_phone_number'.tr();
        } else if (!value.startsWith("05")) {
          return 'phone_number_must_begin'.tr();
        } else if (value.length < 10) {
          return 'phone_number_must'.tr();
        }
        return null;
      },
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(1.2.h, 0, 1.2.h, 0),
          child: SvgPicture.asset(
              "assets/egypt.svg"), //Image(image: AssetImage('assets/ar.png',),width: 3.h,height: 3.h,)
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.red, style: BorderStyle.solid),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide:
              BorderSide(color: MyColors.MainBeerus, style: BorderStyle.solid),
        ),
        fillColor: Colors.green,
        focusColor: Colors.green,
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: MyColors.MainBeerus,
            )),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.red, style: BorderStyle.solid),
        ),
        hintText: 'enter_phone'.tr(),
        hintStyle: TextStyle(
            fontSize: 12.sp,
            fontFamily: 'alexandria_medium',
            fontWeight: FontWeight.w300,
            color: MyColors.MainBulma),
      ),
      style: TextStyle(
          fontSize: 12.sp,
          fontFamily: 'alexandria_medium',
          fontWeight: FontWeight.w300,
          color: MyColors.MainBulma),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10)
      ],
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  Widget Email() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: profileController.emailController,
      maxLines: 1,
      // validator: (value) {
      //   if (!value!.contains("@")&&!value!.contains(".")) {
      //     return 'please_enter_correct_email'.tr();
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(1.2.h, 0, 1.2.h, 0),
          child: SvgPicture.asset(
            'assets/sms.svg',
            width: 3.h,
            height: 3.h,
          ),
          // Image(image: AssetImage('assets/sms.png',),width: 3.h,height: 3.h,)
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.red, style: BorderStyle.solid),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide:
              BorderSide(color: MyColors.MainBeerus, style: BorderStyle.solid),
        ),
        fillColor: Colors.green,
        focusColor: Colors.green,
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: MyColors.MainBeerus,
            )),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.red, style: BorderStyle.solid),
        ),
        hintText: 'enter_your_email'.tr(),
        hintStyle: TextStyle(
            fontSize: 12.sp,
            fontFamily: 'alexandria_regular',
            fontWeight: FontWeight.w300,
            color: MyColors.MainBulma),
      ),
      style: TextStyle(
          fontSize: 12.sp,
          fontFamily: 'alexandria_regular',
          fontWeight: FontWeight.w300,
          color: MyColors.MainBulma),
    );
  }
}
