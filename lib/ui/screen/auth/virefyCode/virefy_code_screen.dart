import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';

import '../../../../business/auth/verifyController/VerifyController.dart';
import '../../../../business/homeController/HomeController.dart';
import 'dart:math' as math;
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../conustant/my_colors.dart';

class VirefyCodeScreen extends StatefulWidget{
  var code;
  var from;
  VirefyCodeScreen({required this.code,required this.from});

  @override
  State<StatefulWidget> createState() {
    return _VirefyCodeScreen();
  }
}

class _VirefyCodeScreen extends State<VirefyCodeScreen>{
  final homeController = Get.put(HomeController());
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  TextEditingController verfiyCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final verifyController = Get.put(VerifyController());
  static const int _countTimerStatic = 60;
  int _countdown = _countTimerStatic; // Initial countdown time in seconds
  var timer;

  @override
  void initState() {
    super.initState();
    print(widget.code.toString());
    Fluttertoast.showToast(
      msg: widget.code.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
    );
    verifyController.getphone();
    startTimer();
    verifyController.fromWhere=widget.from;
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
        title: Text('login'.tr(),
            style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'alexandria_bold',
                fontWeight: FontWeight.w500,
                color: MyColors.MainBulma)),
      ),
      body: Container(
        margin: EdgeInsetsDirectional.only(start: 2.h,end: 2.h),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Center(child: Image.asset("assets/verify.png",height: 35.h,)),

                Center(child: SvgPicture.asset('assets/otp2.svg',height: 35.h),),
                SizedBox(height: 2.h,),
                Center(
                  child: Text("phone_verification".tr(),
                    style:  TextStyle(fontSize: 16.sp,
                        fontFamily: 'alexandria_bold',
                        fontWeight: FontWeight.w600,
                        color:MyColors.MainBulma),textAlign: TextAlign.center,),
                ),
                SizedBox(height: 1.h,),
                Center(
                  child: Text('code_send'.tr()+verifyController.phone.toString(),
                      style:  TextStyle(fontSize: 12.sp,
                          fontFamily: 'alexandria_medium',
                          fontWeight: FontWeight.w300,
                          color: MyColors.textColor)),
                ),
                SizedBox(height: 1.h,),
                PinCodeTextField(
                  autovalidateMode: AutovalidateMode.disabled,
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
                    }else if(value.length<4){
                      return 'code_must'.tr();
                    }
                    return null;
                  },
                  // controller: verifyController.verfiyCodeController,
                  pinTheme: PinTheme(
                    selectedFillColor:Colors.white,
                    inactiveFillColor: Colors.white,
                    activeFillColor: Colors.white,
                    activeColor:MyColors.MainBeerus,
                    inactiveColor: MyColors.MainBeerus,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(15.0),
                    fieldHeight: 8.h,
                    fieldWidth: 19.w,
                  ),
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.number,
                  textStyle:  TextStyle(
                      fontSize: 14.sp,
                      color: MyColors.MainZeno,
                      fontWeight: FontWeight.w600,
                      fontFamily: "alexandria_bold"),
                  onCompleted: (pin) {
                    verifyController.verify(context,verifyController.currentPin);
                    verfiyCodeController.clear();
                  },
                ),
                SizedBox(height: 2.h,),
                SizedBox(
                  width: double.infinity,
                  height: 8.h,
                  child: TextButton(
                    style: flatButtonStyle,
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        verifyController.verify(context,verifyController.currentPin);
                      }
                    },
                    child: Text('confirm'.tr(),
                      style:  TextStyle(fontSize: 12.sp,
                          fontFamily: 'alexandria_bold',
                          fontWeight: FontWeight.w500,
                          color: Colors.white),),
                  ),
                ),
                SizedBox(height: 2.h,),
                Center(
                  child: Visibility(
                    visible: _countdown!=0,
                    child: Text(timerText.toString(),
                        style:  TextStyle(fontSize: 12.sp,
                            fontFamily: 'alexandria_regular',
                            fontWeight: FontWeight.w300,
                            color: MyColors.Dark)),
                  ),
                ),
                SizedBox(height: 1.h,),
                Center(
                  child: Text('didnt_receive_code'.tr(),
                      style:  TextStyle(fontSize: 12.sp,
                          fontFamily: 'alexandria_regular',
                          fontWeight: FontWeight.w300,
                          color: MyColors.MainTrunks)),
                ),
                SizedBox(height: 1.h,),
                Center(
                  child: Obx(() =>
                      Visibility(
                          visible: verifyController.isVisable
                              .value,
                          child: const CircularProgressIndicator(color: MyColors.MainPrimary,)
                      )),
                ),
                SizedBox(height: 1.h,),
                Center(
                  child: Visibility(
                    visible: _countdown==0,
                    child: GestureDetector(
                      onTap: (){
                        if(_countdown==0) {
                          verifyController.isVisable.value = true;
                          verifyController.resendCode(context).then((_){
                            if (verifyController.resendCodeResponse.value.success == true) {
                              setState(() {
                                _countdown = _countTimerStatic;
                              });
                              startTimer();
                            }
                          });
                        }
                      },
                      child: Text('request_again'.tr(),
                          style:  TextStyle(fontSize: 12.sp,
                              fontFamily: 'alexandria_regular',
                              fontWeight: FontWeight.w300,
                              color: MyColors.MainPrimary)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
     timer = Timer.periodic(oneSec, (timer) {
      if (_countdown == 0) {
        timer.cancel(); // Cancel the timer when the countdown reaches 0
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  String get timerText {
    int minutes = _countdown ~/ 60;
    int seconds = _countdown % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

}