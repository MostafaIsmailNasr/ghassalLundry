import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../business/auth/loginController/LoginController.dart';
import '../../../../conustant/my_colors.dart';

class LoginScreen extends StatefulWidget{
  var from;
  LoginScreen({required this.from});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen>{
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  final loginController = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    loginController.phoneController.clear();
    super.initState();
    loginController.fromWhere=widget.from;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,),
      body: Container(
        margin: EdgeInsetsDirectional.only(start: 2.h,end: 2.h),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customAppBar(),
                SizedBox(height: 10.h,),
                Center(child: SvgPicture.asset('assets/ghassal_logo.svg')),
                SizedBox(height: 5.h,),
                Text("phoneNumber".tr(),
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
                  child: phoneNumber(),
                ),
                SizedBox(height: 2.h,),
                Center(
                  child: Obx(() =>
                      Visibility(
                          visible: loginController.isVisable
                              .value,
                          child: const CircularProgressIndicator(color: MyColors.MainPrimary,)
                      )),
                ),
                SizedBox(height: 1.h,),
                SizedBox(
                  width: double.infinity,
                  height: 8.h,
                  child: TextButton(
                    style: flatButtonStyle,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // loginController.sharedPreferencesService.setString(
                        //     'phone_number', loginController.phoneController.text);
                        loginController.isVisable.value=true;
                        loginController.loginUse(context);

                      }
                    },
                    child: Text('login'.tr(),
                      style:  TextStyle(fontSize: 12.sp,
                          fontFamily: 'alexandria_bold',
                          fontWeight: FontWeight.w500,
                          color: Colors.white),),
                  ),
                ),
                SizedBox(height: 2.h,),
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/saperator.svg'),
                    // SizedBox(width: 1.h,),
                    Text('or_login_using'.tr(),
                        style:  TextStyle(fontSize: 8.sp,
                        fontFamily: 'alexandria_medium',
                        fontWeight: FontWeight.w300,
                        color: MyColors.MainTrunks)),
                    // SizedBox(width: 1.h,),
                    SvgPicture.asset('assets/saperator.svg'),
                  ],
                ),
                SizedBox(height: 1.5.h,),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsetsDirectional.all(2.h),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                border: Border.all(
                                  color: MyColors.MainGoku,
                                  width: 1.0,
                                ),
                                color: MyColors.MainGoku),
                            child: Center(
                              child: SvgPicture.asset('assets/google.svg'),
                            ),
                          ),
                          Text("google".tr(),
                              style:  TextStyle(fontSize: 8.sp,
                                  fontFamily: 'alexandria_medium',
                                  fontWeight: FontWeight.w400,
                                  color:MyColors.Dark2)),
                        ],
                      ),
                    ),
                    SizedBox(width: 1.h,),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsetsDirectional.all(2.h),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                border: Border.all(
                                  color: MyColors.MainGoku,
                                  width: 1.0,
                                ),
                                color: MyColors.MainGoku),
                            child: Center(
                              child: SvgPicture.asset('assets/apple.svg'),
                            ),
                          ),
                          Text("apple".tr(),
                              style:  TextStyle(fontSize: 8.sp,
                                  fontFamily: 'alexandria_medium',
                                  fontWeight: FontWeight.w400,
                                  color:MyColors.Dark2)),
                        ],
                      ),
                    ),
                  ],
                )*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customAppBar(){
    return Row(
      children: [
        Text("login".tr(),
            style:  TextStyle(fontSize: 18.sp,
                fontFamily: 'alexandria_bold',
                fontWeight: FontWeight.w600,
                color:MyColors.MainBulma)),
        const Spacer(),
        GestureDetector(
          onTap: ()async{
            await loginController.sharedPreferencesService.setBool("isLogin", false);
            Navigator.pushNamedAndRemoveUntil(context,'/drower',ModalRoute.withName('/drower'));
          },
          child: Text("skip".tr(),
              style:  TextStyle(fontSize: 12.sp,
                  fontFamily: 'alexandria_medium',
                  fontWeight: FontWeight.w300,
                  color:MyColors.MainBulma)),
        ),
      ],
    );
  }

  Widget phoneNumber (){
    return TextFormField(
      autovalidateMode:AutovalidateMode.onUserInteraction ,
      controller: loginController.phoneController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'please_enter_phone_number'.tr();
        }else if(!value.startsWith("05")){
          return 'phone_number_must_begin'.tr();
        }
        else if(value.length<10){
          return 'phone_number_must'.tr();
        }
        return null;
      },
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon:   Padding(
          padding: EdgeInsetsDirectional.fromSTEB(1.2.h,0,1.2.h,0),
          child: SvgPicture.asset("assets/smartphone.svg"),//Image(image: AssetImage('assets/ar.png',),width: 3.h,height: 3.h,)
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
        hintText: 'enter_phone'.tr(),
        hintStyle:  TextStyle(fontSize: 12.sp,
            fontFamily: 'alexandria_medium',
            fontWeight: FontWeight.w300,
            color: MyColors.MainBulma),
      ),
      style:  TextStyle(fontSize: 12.sp,
          fontFamily: 'alexandria_medium',
          fontWeight: FontWeight.w300,
          color: MyColors.MainBulma),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10)],
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

}