import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:ghassal_laundry/conustant/toast_class.dart';
import 'package:sizer/sizer.dart';

import '../../../../business/auth/registerController/RegisterController.dart';
import '../../../../business/homeController/HomeController.dart';
import '../../../../conustant/my_colors.dart';
import 'dart:math' as math;
import 'package:localize_and_translate/localize_and_translate.dart';

class CompleteRegisterScreen extends StatefulWidget{
  var from;

  CompleteRegisterScreen({required this.from});

  @override
  State<StatefulWidget> createState() {
    return _CompleteRegisterScreen();
  }
}

class _CompleteRegisterScreen extends State<CompleteRegisterScreen>{
  final homeController = Get.put(HomeController());
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  final _formKey = GlobalKey<FormState>();
  final registerController = Get.put(RegisterController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      registerController.address2.value = "";
      registerController.fromWhere = widget.from;
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
                angle:homeController.lang=="en"? 180 *math.pi /180:0,
                child: SvgPicture.asset('assets/back.svg',))),
        title: Text('complete_creating_the_account'.tr(),
            style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'alexandria_bold',
                fontWeight: FontWeight.w500,
                color: MyColors.MainBulma)),
      ),
      body: Container(
        margin: EdgeInsetsDirectional.only(start: 2.h,end: 2.h),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("delivery_location".tr(),
                  style:  TextStyle(fontSize: 10.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w500,
                      color:MyColors.MainBulma),),
                SizedBox(height: 1.h,),
                GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, "/location_screen",arguments: "fromCreateAccount");
                  },
                  child: Container(
                    padding: EdgeInsetsDirectional.all(2.h),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                          color: MyColors.MainGoku,
                          width: 1.0,
                        ),
                        color: MyColors.MainGoku),
                    child: location(),
                  ),
                ),
                SizedBox(height: 2.h,),
                Text('email_address'.tr(),
                    style:  TextStyle(fontSize: 10.sp,
                        fontFamily: 'alexandria_medium',
                        fontWeight: FontWeight.w500,
                        color:MyColors.MainBulma)),
                SizedBox(height: 1.h,),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                        color: MyColors.MainGoku,
                        width: 1.0,
                      ),
                      color: MyColors.MainGoku),
                  child: Email(),
                ),
                Padding(
                  padding:  EdgeInsets.only(top: 48.h),
                  child: Column(
                    children: [
                      Center(
                        child: Obx(() =>
                            Visibility(
                                visible: registerController.isVisable
                                    .value,
                                child: const CircularProgressIndicator(color: MyColors.MainPrimary,),
                            )),
                      ),
                      SizedBox(height: 1.h,),
                      SizedBox(
                        width: double.infinity,
                        height: 8.h,
                        child: TextButton(
                          style: flatButtonStyle,
                          onPressed: () async {
                            /*if (_formKey.currentState!.validate()) {

                              Navigator.pushNamed(context, '/virefy_code_screen');
                            }*/
                            if(registerController.address2.value!=""){
                              registerController.isVisable.value=true;
                              registerController.completeUserInfo(context);
                            }else{
                              ToastClass.showCustomToast(context, "please_select_address".tr(), "error");
                            }
                          },
                          child: Text('create_my_account'.tr(),
                            style:  TextStyle(fontSize: 12.sp,
                                fontFamily: 'alexandria_bold',
                                fontWeight: FontWeight.w500,
                                color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(top:  2.h),
                  child: GestureDetector(
                    onTap: ()async{
                      await registerController.sharedPreferencesService.setBool("isLogin", false);
                      // registerController.lat="";
                      // registerController.lng="";
                      registerController.address2.value="";
                      registerController.addressType="";
                      Navigator.pushNamedAndRemoveUntil(context,'/drower',ModalRoute.withName('/drower'));
                    },
                    child: Center(
                      child: Text('skip'.tr(),
                        style:  TextStyle(fontSize: 12.sp,
                            fontFamily: 'alexandria_bold',
                            fontWeight: FontWeight.w500,
                            color: MyColors.MainBulma),),
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

  Widget location(){
    return Row(
      children: [
        SvgPicture.asset('assets/location_add.svg',),
        SizedBox(width: 2.w,),
        SizedBox(
            width: 30.h,
            child:Obx(() =>registerController.address2.value!=""? Text(
              registerController.address2.value.toString(),
              style:  TextStyle(fontSize: 12.sp,
                fontFamily: 'alexandria_regular',
                fontWeight: FontWeight.w300,
                color: MyColors.MainBulma),maxLines: 2,)
                :Text('add_delivery_location'.tr(),
              style:TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'alexandria_regular',
                  fontWeight: FontWeight.w300,
                  color: MyColors.MainBulma),maxLines: 2,),
            )),
      ],
    );
  }

  Widget Email(){
    return TextFormField(
      autovalidateMode:AutovalidateMode.onUserInteraction ,
      controller: registerController.emailController,
      maxLines: 1,
      // validator: (value) {
      //   if (!value!.contains("@")&&!value!.contains(".")) {
      //     return 'please_enter_correct_email'.tr();
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        prefixIcon:   Padding(
            padding: EdgeInsetsDirectional.fromSTEB(1.2.h,0,1.2.h,0),
            child: SvgPicture.asset('assets/sms.svg',width: 3.h,height: 3.h,),
            // Image(image: AssetImage('assets/sms.png',),width: 3.h,height: 3.h,)
        ),
        errorBorder:  const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.red,style: BorderStyle.solid),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: MyColors.MainBeerus,style: BorderStyle.solid),
        ),fillColor: Colors.green,focusColor: Colors.green,
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(style: BorderStyle.solid,color: MyColors.MainBeerus,)
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.red,style: BorderStyle.solid),
        ) ,
        hintText: 'enter_your_email'.tr(),
        hintStyle:  TextStyle(fontSize: 12.sp,
            fontFamily: 'alexandria_regular',
            fontWeight: FontWeight.w300,
            color: MyColors.MainBulma),
      ),
      style:  TextStyle(fontSize: 12.sp,
          fontFamily: 'alexandria_regular',
          fontWeight: FontWeight.w300,
          color: MyColors.MainBulma),
    );
  }

}