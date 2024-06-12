import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:sizer/sizer.dart';

import '../../../../business/ghassalSubscriptionController/GhassalSubscriptionController.dart';
import '../../../../conustant/my_colors.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../data/model/subscriptionsModel/SubscriptionsResponse.dart';

class SubscriptionItem extends StatefulWidget{
  bool is_selected;
  GestureTapCallback? onTap;
  Subscribtions subscribtions;

  SubscriptionItem({required this.is_selected,required this.onTap,required this.subscribtions});
  @override
  State<StatefulWidget> createState() {
    return _SubscriptionItem();
  }
}

class _SubscriptionItem extends State<SubscriptionItem>{
  final ghassalSubscriptionController = Get.put(GhassalSubscriptionController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: EdgeInsetsDirectional.only(end: 1.h,bottom: 1.h),
            padding: EdgeInsetsDirectional.all(1.5.h),
            height: 18.h,
            width: 15.h,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                  color: widget.is_selected?MyColors.MainPrimary: MyColors.MainGoku,
                  width:widget.is_selected?2.0: 1.0,),
                color: widget.is_selected?MyColors.Back: MyColors.MainGoku),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(widget.subscribtions.image??"",width: 5.h,height: 5.h,fit: BoxFit.fill),
                SizedBox(height: 1.h,),
                Text(widget.subscribtions.basketTitle??"",
                    style:  TextStyle(fontSize: 10.sp,
                        fontFamily: 'alexandria_medium',
                        fontWeight: FontWeight.w500,
                        color:MyColors.MainPrimary)),
              ],
            ),
          ),
        ),
        Visibility(
          visible: widget.is_selected,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                },
                child: Container(
                  padding: EdgeInsetsDirectional.only(start: 2.h,end: 2.h),
                  height: 5.h,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                        color: MyColors.MainPrimary, width: 1.0,),
                      color:  MyColors.MainPrimary),
                  child: const Center(
                    child: Icon(Icons.add,color: Colors.white,),
                  ),
                ),
              ),
              SizedBox(width: 4.h,),
              Text(ghassalSubscriptionController.getItemPrice(widget.subscribtions!.id!).toString(),
                  style:  TextStyle(fontSize: 14.sp,
                      fontFamily: 'alexandria_bold',
                      fontWeight: FontWeight.w700,
                      color:MyColors.counterColor)),
              SizedBox(width: 4.h,),
              GestureDetector(
                onTap: (){
                  setState(() {
                  });
                },
                child: Container(
                  padding: EdgeInsetsDirectional.only(start: 2.h,end: 2.h),
                  height: 5.h,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                        color: MyColors.MainGoku, width: 1.0,),
                      color:  MyColors.MainGoku),
                  child:  Center(
                    child: SvgPicture.asset("assets/mines.svg"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}