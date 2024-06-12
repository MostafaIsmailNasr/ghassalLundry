import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

import '../../../../conustant/my_colors.dart';
import '../../../../conustant/toast_class.dart';

class SelectPackageSheet extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _SelectPackageSheet();
  }
}

class _SelectPackageSheet extends State<SelectPackageSheet>{
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  var isSelected=true;
  int? itemId=1;
  var type="";

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
               orderType(),
              SizedBox(width: 1.h,),
              Visibility(
                visible: isSelected,
                child: text(),),
              SizedBox(height: 2.h,),
              SizedBox(
                width: double.infinity,
                height: 8.h,
                child: TextButton(
                  style: flatButtonStyle,
                  onPressed: () {
                    setState(() {
                      if(isSelected==true&&itemId==1){
                        Navigator.pushNamed(context, '/ghassal_baskets_screens');

                      }else if(isSelected==true&&itemId==2){
                        Navigator.pushNamed(context, '/ghassal_subscription_screens');
                      }else if(isSelected==true&&itemId==3){
                        Navigator.pushNamed(context, '/ghassal_upon_request_screens');
                      }
                      else{
                        Fluttertoast.showToast(
                            msg: 'please_choose_order_type'.tr(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
                        );
                      }
                    });

                  },
                  child: btnText(),
                ),
              ),
              SizedBox(height: 2.h,),
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
        Text("select_package".tr(),
          style:  TextStyle(fontSize: 14.sp,
              fontFamily: 'alexandria_bold',
              fontWeight: FontWeight.w600,
              color:MyColors.MainBulma),),
        SizedBox(height: 1.h,),
        Row(
          children: [
            SvgPicture.asset('assets/info_circle.svg'),
            SizedBox(width: 1.h,),
            Text("choose_from".tr(),
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

  Widget orderType(){
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: (){
              setState(() {
                isSelected=true;
                type="baskets";
                itemId=1;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 12.h,
              padding:  EdgeInsetsDirectional.all(1.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color:isSelected==true && itemId==1?MyColors.MainPrimary: MyColors.MainGoku, width: 2.0,),
                  color: isSelected==true && itemId==1?MyColors.MainPrimary:Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/check.svg'),
                  Center(child: SvgPicture.asset('assets/cart5.svg',color: isSelected==true && itemId==1?Colors.white:MyColors.MainPrimary,)),
                  SizedBox(height: 1.h,),
                  Center(
                    child: Text('baskets'.tr(),
                      style:  TextStyle(fontSize: 10.sp,
                          fontFamily: 'alexandria_medium',
                          fontWeight: FontWeight.w500,
                          color: isSelected==true && itemId==1?Colors.white:MyColors.MainPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 1.h,),
        Expanded(
          child: GestureDetector(
            onTap: (){
              setState(() {
                isSelected=true;
                type="subscriptions";
                itemId=2;
              });

            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 12.h,
              padding:  EdgeInsetsDirectional.all(1.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color:isSelected==true && itemId==2?MyColors.MainPrimary: MyColors.MainGoku, width: 2.0,),
                  color: isSelected==true && itemId==2?MyColors.MainPrimary:Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/check.svg'),
                  Center(child: SvgPicture.asset('assets/crown.svg',color: isSelected==true && itemId==2?Colors.white:MyColors.MainPrimary,)),
                  SizedBox(height: 1.h,),
                  Center(
                    child: Text('subscriptions'.tr(),
                      style:  TextStyle(fontSize: 10.sp,
                          fontFamily: 'alexandria_medium',
                          fontWeight: FontWeight.w500,
                          color:isSelected==true && itemId==2?Colors.white: MyColors.MainPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 1.h,),
        Expanded(
          child: GestureDetector(
            onTap: (){
              setState(() {
                isSelected=true;
                type="upon_request";
                itemId=3;
              });

            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 12.h,
              padding:  EdgeInsetsDirectional.all(1.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color:isSelected==true && itemId==3?MyColors.MainPrimary: MyColors.MainGoku, width: 2.0,),
                  color: isSelected==true && itemId==3?MyColors.MainPrimary:Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/check.svg'),
                  Center(child: SvgPicture.asset('assets/t_shirt.svg',color: isSelected==true && itemId==3?Colors.white:MyColors.MainPrimary,)),
                  SizedBox(height: 1.h,),
                  Center(
                    child: Text('upon_request'.tr(),
                      style:  TextStyle(fontSize: 10.sp,
                          fontFamily: 'alexandria_medium',
                          fontWeight: FontWeight.w500,
                          color:isSelected==true && itemId==3?Colors.white: MyColors.MainPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget text(){
    if(isSelected==true&&itemId==1){
      return Column(
        children: [
          SizedBox(height: 2.h,),
          Text('choose_basket'.tr(),
            style:  TextStyle(fontSize: 12.sp,
                fontFamily: 'alexandria_medium',
                fontWeight: FontWeight.w300,
                color: MyColors.MainTrunks),
          ),
        ],
      );
    }else if(isSelected==true&&itemId==2){
      return Column(
        children: [
          SizedBox(height: 2.h,),
          Text('subscribe_monthly'.tr(),
            style:  TextStyle(fontSize: 12.sp,
                fontFamily: 'alexandria_medium',
                fontWeight: FontWeight.w300,
                color: MyColors.MainTrunks),
          ),
        ],
      );
    }
    else if(isSelected==true&&itemId==3){
      return Column(
        children: [
          SizedBox(height: 2.h,),
          Text('select'.tr(),
            style:  TextStyle(fontSize: 12.sp,
                fontFamily: 'alexandria_medium',
                fontWeight: FontWeight.w300,
                color: MyColors.MainTrunks),
          ),
        ],
      );
    }else{
      return Container();
    }
  }

  Widget btnText(){
    if(isSelected==true&&itemId==1){
      return Text('request'.tr(),
        style:  TextStyle(fontSize: 12.sp,
            fontFamily: 'alexandria_bold',
            fontWeight: FontWeight.w500,
            color: Colors.white),);
    }else if(isSelected==true&&itemId==2){
      return Text('subscription'.tr(),
        style:  TextStyle(fontSize: 12.sp,
            fontFamily: 'alexandria_bold',
            fontWeight: FontWeight.w500,
            color: Colors.white),);
    }
    else if(isSelected==true&&itemId==3){
      return Text('request'.tr(),
        style:  TextStyle(fontSize: 12.sp,
            fontFamily: 'alexandria_bold',
            fontWeight: FontWeight.w500,
            color: Colors.white),);
    }else{
      return  Text('request'.tr(),
        style:  TextStyle(fontSize: 12.sp,
            fontFamily: 'alexandria_bold',
            fontWeight: FontWeight.w500,
            color: Colors.white),);
    }
  }
}