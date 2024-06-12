import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';

import '../../../../../business/auth/verifyController/VerifyController.dart';
import '../../../../../conustant/my_colors.dart';

class VirefyCodeSheet extends StatefulWidget {
  var code;
  var from;

  VirefyCodeSheet({required this.code, required this.from});

  @override
  State<StatefulWidget> createState() {
    return _VirefyCodeSheet();
  }
}

class _VirefyCodeSheet extends State<VirefyCodeSheet>
    with TickerProviderStateMixin {
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  TextEditingController verfiyCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final verifyController = Get.put(VerifyController());

  @override
  void initState() {
    verifyController.getphone();
    print(widget.code.toString());
    Fluttertoast.showToast(
      msg: widget.code.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
    );
    verifyController.fromWhere = widget.from;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(right: 1.5.h, left: 1.5.h, top: 1.h, bottom: 2.h),
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  "login".tr(),
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'alexandria_bold',
                      fontWeight: FontWeight.w600,
                      color: MyColors.MainBulma),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Center(
                    child: Image.asset(
                  "assets/verify.png",
                  height: 35.h,
                )),
                SizedBox(
                  height: 2.h,
                ),
                Center(
                  child: Text(
                    "phone_verification".tr(),
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'alexandria_bold',
                        fontWeight: FontWeight.w600,
                        color: MyColors.MainBulma),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Center(
                  child: Text(
                      'code_send'.tr() + verifyController.phone.toString(),
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'alexandria_medium',
                          fontWeight: FontWeight.w300,
                          color: MyColors.textColor)),
                ),
                SizedBox(
                  height: 1.h,
                ),
                PinCodeTextField(
                  appContext: context,
                  controller: verfiyCodeController,
                  length: 4, // Set the length of the PIN code
                  onChanged: (pin) {
                    setState(() {
                      verifyController.currentPin = pin;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please_enter_verify_code'.tr();
                    } else if (value.length < 4) {
                      return 'code_must'.tr();
                    }
                    return null;
                  },
                  // controller: verifyController.verfiyCodeController,
                  pinTheme: PinTheme(
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    activeFillColor: Colors.white,
                    activeColor: MyColors.MainBeerus,
                    inactiveColor: MyColors.MainBeerus,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(15.0),
                    fieldHeight: 8.h,
                    fieldWidth: 19.w,
                  ),
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.number,
                  textStyle: TextStyle(
                      fontSize: 14.sp,
                      color: MyColors.MainZeno,
                      fontWeight: FontWeight.w600,
                      fontFamily: "alexandria_bold"),
                  onCompleted: (pin) {
                    verifyController.verifyBottomSheet(
                        context, verifyController.currentPin);
                    verfiyCodeController.clear();
                  },
                ),
                SizedBox(
                  height: 2.h,
                ),
                Center(
                  child: Text('didnt_receive_code'.tr(),
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'alexandria_regular',
                          fontWeight: FontWeight.w300,
                          color: MyColors.MainTrunks)),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Center(
                  child: Obx(() => Visibility(
                      visible: verifyController.isVisable.value,
                      child: const CircularProgressIndicator(
                        color: MyColors.MainPrimary,
                      ))),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      verifyController.isVisable.value = true;
                      verifyController.resendCode(context);
                    },
                    child: Text('request_again'.tr(),
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'alexandria_regular',
                            fontWeight: FontWeight.w300,
                            color: MyColors.MainPrimary)),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 8.h,
                  child: TextButton(
                    style: flatButtonStyle,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        verifyController.verifyBottomSheet(
                            context, verifyController.currentPin);
                        verfiyCodeController.clear();
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
      ),
    );
  }
}
