import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../../business/auth/registerController/RegisterController.dart';
import '../../../../../conustant/my_colors.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../virefyCodeSheet/virefy_code_sheet.dart';

class RegisterButtomSheet extends StatefulWidget{
  var from;

  RegisterButtomSheet({required this.from});

  @override
  State<StatefulWidget> createState() {
    return _RegisterButtomSheet();
  }
}

class _RegisterButtomSheet extends State<RegisterButtomSheet>{
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
    registerController.phoneController.clear();
    registerController.nameController.clear();
    registerController.fromWhere=widget.from;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 1.5.h, left: 1.5.h, top: 1.h, bottom: 2.h),
      child: SingleChildScrollView(
        child: SizedBox(
          width:  MediaQuery.of(context).size.width,
          child: Form(
            key:_formKey ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomBar(),
                SizedBox(height: 2.h,),
                Text("phoneNumber".tr(),
                  style:  TextStyle(fontSize: 12.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w300,
                      color:MyColors.MainBulma),),
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
                SizedBox(height: 1.h,),
                Text("full_name".tr(),
                  style:  TextStyle(fontSize: 12.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w300,
                      color:MyColors.MainBulma),),
                SizedBox(height: 1.h,),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                        color: MyColors.MainGoku,
                        width: 1.0,
                      ),
                      color: MyColors.MainGoku),
                  child: name(),
                ),
                SizedBox(height: 2.h,),
                Center(
                  child: Obx(() =>
                      Visibility(
                          visible: registerController.isVisable
                              .value,
                          child: const CircularProgressIndicator(color: MyColors.MainPrimary,)
                      )),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 8.h,
                  child: TextButton(
                    style: flatButtonStyle,
                    onPressed: () async{
                      registerController.isVisable.value = true;
                      registerController.registerBottomSheet(context);
                    },
                    child: Text('registration'.tr(),
                      style:  TextStyle(fontSize: 12.sp,
                          fontFamily: 'alexandria_bold',
                          fontWeight: FontWeight.w500,
                          color: Colors.white),),
                  ),
                )
              ],
            ),
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
        Text("signup".tr(),
          style:  TextStyle(fontSize: 14.sp,
              fontFamily: 'alexandria_bold',
              fontWeight: FontWeight.w600,
              color:MyColors.MainBulma),),
        SizedBox(height: 1.h,),
        Row(
          children: [
            SvgPicture.asset('assets/info_circle.svg'),
            SizedBox(width: 1.h,),
            Expanded(
              child: Text("please_complete_account".tr(),
                style:  TextStyle(fontSize: 8.sp,
                    fontFamily: 'alexandria_regular',
                    fontWeight: FontWeight.w300,
                    color:MyColors.MainTrunks),),
            ),
          ],
        ),
        SizedBox(height: 1.h,),
      ],
    );
  }

  Widget phoneNumber (){
    return TextFormField(
      autovalidateMode:AutovalidateMode.onUserInteraction ,
      controller: registerController.phoneController,
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

  Widget name (){
    return TextFormField(
      autovalidateMode:AutovalidateMode.onUserInteraction ,
      controller: registerController.nameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'please_enter_name'.tr();
        }
        return null;
      },
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon:   Padding(
          padding: EdgeInsetsDirectional.fromSTEB(1.2.h,0,1.2.h,0),
          child: SvgPicture.asset("assets/user.svg")
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
        hintText: 'enter_name'.tr(),
        hintStyle:  TextStyle(fontSize: 12.sp,
            fontFamily: 'alexandria_medium',
            fontWeight: FontWeight.w300,
            color: MyColors.MainBulma),
      ),
      style:  TextStyle(fontSize: 12.sp,
          fontFamily: 'alexandria_medium',
          fontWeight: FontWeight.w300,
          color: MyColors.MainBulma),
      keyboardType: TextInputType.text,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

}