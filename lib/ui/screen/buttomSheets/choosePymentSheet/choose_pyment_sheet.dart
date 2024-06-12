import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

import '../../../../business/ghassalBasketsController/GhassalBasketsController.dart';
import '../../../../business/ghassalSubscriptionController/GhassalSubscriptionController.dart';
import '../../../../business/ghassalUpOnRequestController/GhassalUpOnRequestController.dart';
import '../../../../conustant/my_colors.dart';
import '../../../../conustant/toast_class.dart';

class ChoosePyment extends StatefulWidget{
  var from;

  ChoosePyment({required this.from});

  @override
  State<StatefulWidget> createState() {
    return _ChoosePyment();
  }
}

class _ChoosePyment extends State<ChoosePyment>{
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ));
  final ghassalBasketsController = Get.put(GhassalBasketsController());
  final ghassalSubscriptionController = Get.put(GhassalSubscriptionController());
  final ghassalUpOnRequestController = Get.put(GhassalUpOnRequestController());
  var isSelected=false;
  int? itemId=0;
  var payment="";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(right: 2.h,left: 2.h,top: 1.h,bottom: 1.h),
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomBar(),
              InkWell(
                onTap: (){
                  setState(() {
                    isSelected=true;
                    itemId=1;
                    if(widget.from=="basket"){
                      ghassalBasketsController.payment.value="cash";
                    }else if(widget.from=="sub"){
                      ghassalSubscriptionController.payment.value="cash";
                    }else if(widget.from=="upon"){
                      ghassalUpOnRequestController.payment.value="cash";
                    }
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 7.h,
                  margin:  EdgeInsetsDirectional.only(start: 1.h,end: 1.h),
                  padding:  EdgeInsets.all(1.h),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/cach.svg',width: 6.h,height: 6.h,),
                      SizedBox(width: 1.h,),
                      Text('cash_on_delivery'.tr(),
                        style:  TextStyle(fontSize: 12.sp,
                            fontFamily: 'alexandria_regular',
                            fontWeight: FontWeight.w400,
                            color: MyColors.MainTrunks),),
                      const Spacer(),
                      isSelected==true && itemId==1?SvgPicture.asset('assets/radio_selected.svg'):SvgPicture.asset('assets/radio_button.svg',),
                    ],
                  ),
                ),
              ),
              Container(
                  margin:  EdgeInsetsDirectional.only(start: 1.h,end: 1.h),
                  child: SvgPicture.asset('assets/separator.svg')),
              SizedBox(height: 0.2.h,),
              InkWell(
                onTap: (){
                  setState(() {
                    isSelected=true;
                    itemId=2;
                    if(widget.from=="basket"){
                      ghassalBasketsController.payment.value="tabby";
                    }else if(widget.from=="sub"){
                      ghassalSubscriptionController.payment.value="tabby";
                    }else if(widget.from=="upon"){
                      ghassalUpOnRequestController.payment.value="tabby";
                    }
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 7.h,
                  margin:  EdgeInsetsDirectional.only(start: 1.h,end: 1.h),
                  padding:  EdgeInsets.all(1.h),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/tabby.svg',width: 6.h,height: 6.h,),
                      SizedBox(width: 1.h,),
                      Text('credit_card'.tr(),
                        style: TextStyle(fontSize: 12.sp,
                            fontFamily: 'alexandria_regular',
                            fontWeight: FontWeight.w400,
                            color: MyColors.MainTrunks),),
                      const Spacer(),
                      isSelected==true && itemId==2?SvgPicture.asset('assets/radio_selected.svg'):SvgPicture.asset('assets/radio_button.svg',),
                    ],
                  ),
                ),
              ),
              Container(
                  margin:  EdgeInsetsDirectional.only(start: 1.h,end: 1.h),
                  child: SvgPicture.asset('assets/separator.svg')),
              SizedBox(height: 0.2.h,),
              InkWell(
                onTap: (){
                  setState(() {
                    isSelected=true;
                    itemId=3;
                    if(widget.from=="basket"){
                      ghassalBasketsController.payment.value="payTaps";
                    }else if(widget.from=="sub"){
                      ghassalSubscriptionController.payment.value="payTaps";
                    }else if(widget.from=="upon"){
                      ghassalUpOnRequestController.payment.value="payTaps";
                    }
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 7.h,
                  margin:  EdgeInsetsDirectional.only(start: 1.h,end: 1.h),
                  padding:  EdgeInsets.all(1.h),
                  child: Row(
                    children: [
                      Container(
                          margin: EdgeInsetsDirectional.only(start: 1.5.h),
                          child: Image.network("https://eyacleanproksa.com/assets/images/card.png",width: 20.h,)),
                      // SvgPicture.asset('assets/noon.svg',width: 6.h,height: 6.h,),
                      // SizedBox(width: 1.h,),
                      // Text('wallet'.tr(),
                      //   style: TextStyle(fontSize: 12.sp,
                      //       fontFamily: 'lexend_regular',
                      //       fontWeight: FontWeight.w400,
                      //       color: MyColors.Dark2),),
                      const Spacer(),
                      isSelected==true && itemId==3?SvgPicture.asset('assets/radio_selected.svg'):SvgPicture.asset('assets/radio_button.svg',),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h,),
              Container(
                margin: EdgeInsets.only(left: 2.h, right: 2.h),
                width: double.infinity,
                height: 8.h,
                child: TextButton(
                  style: flatButtonStyle,
                  onPressed: () {
                    if(isSelected!=false){
                      Navigator.pop(context);
                    }else{
                      ToastClass.showCustomToast(context, 'please_choose_payment'.tr(), 'error');
                    }
                  },
                  child: Text('confirm'.tr(),
                    style: TextStyle(fontSize: 12.sp,
                        fontFamily: 'alexandria_bold',
                        fontWeight: FontWeight.w700,
                        color: Colors.white),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget CustomBar(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 3.h,),
        SizedBox(
          height: 4.h,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Text('payment_method'.tr(),
                style:  TextStyle(fontSize: 12.sp,
                    fontFamily: 'alexandria_bold',
                    fontWeight: FontWeight.w700,
                    color: MyColors.MainBulma),
              ),
              const Spacer(),
              IconButton(iconSize: 3.h,
                  icon: Icon(Icons.close),
                  color: MyColors.Dark3,
                  onPressed:(){
                    ghassalBasketsController.payment.value="";
                    Navigator.pop(context);
                  }
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h,),
      ],
    );
  }
}