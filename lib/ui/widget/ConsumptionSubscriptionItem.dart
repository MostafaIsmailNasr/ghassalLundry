import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../conustant/my_colors.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../data/model/homeModel/HomeResponse.dart';

class ConsumptionSubscriptionItem extends StatefulWidget{
  MySubscribtions? mySubscribtions;

  ConsumptionSubscriptionItem({required this.mySubscribtions});

  @override
  State<StatefulWidget> createState() {
    return _ConsumptionSubscriptionItem();
  }
}

class _ConsumptionSubscriptionItem extends State<ConsumptionSubscriptionItem>{
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  double pers=0.0;

  @override
  Widget build(BuildContext context) {
    pers=(((widget.mySubscribtions?.usedBaskets)!/(widget.mySubscribtions!.totalBaskets!.toInt()))*100)/100;
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 1.h),
      padding: EdgeInsetsDirectional.only(start: 2.h,end: 2.h,top: 1.5.h),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.all(
            color: MyColors.MainDisabledPrimary, width: 1.5,),
          color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("your_consumption".tr(),
                  style:  TextStyle(fontSize: 8.sp,
                      fontFamily: 'alexandria_regular',
                      fontWeight: FontWeight.w300,
                      color:MyColors.MainTrunks)),
              const Spacer(),
              Text("${"active_until".tr()} ${widget.mySubscribtions?.endDate??""}",
                  style:  TextStyle(fontSize: 8.sp,
                      fontFamily: 'alexandria_regular',
                      fontWeight: FontWeight.w300,
                      color:MyColors.MainTrunks)),
            ],
          ),
          SizedBox(height: 1.h,),
          Text(widget.mySubscribtions?.subscribtion?.basketTitle??"",
              style:  TextStyle(fontSize: 12.sp,
                  fontFamily: 'alexandria_bold',
                  fontWeight: FontWeight.w400,
                  color:MyColors.MainBulma)),
          SizedBox(height: 1.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${widget.mySubscribtions?.usedBaskets.toString()??""} ${'basket'.tr()}",
                  style:  TextStyle(fontSize: 12.sp,
                      fontFamily: 'alexandria_bold',
                      fontWeight: FontWeight.w500,
                      color:MyColors.MainPrimary)),
              const Spacer(),
              Text("${widget.mySubscribtions?.totalBaskets.toString()??""} ${'basket'.tr()}",
                  style:  TextStyle(fontSize: 12.sp,
                      fontFamily: 'alexandria_bold',
                      fontWeight: FontWeight.w500,
                      color:MyColors.MainPrimary)),
            ],
          ),
          SizedBox(height: 1.h,),
          Container(
            width: MediaQuery.of(context).size.width,
            child: LinearPercentIndicator(
                barRadius: const Radius.circular(50),
                lineHeight: 1.5.h,
                percent: pers,
              backgroundColor: MyColors.MainGoku,
                linearGradient: const LinearGradient(colors: [
                Color(0xFF00C1F3),
                Color(0xFFD8CEF4),
              ])//Colors.blue,
            ),
          ),
          SizedBox(height: 2.h,),
          Container(
            margin: EdgeInsetsDirectional.only(start: 1.h, end: 1.h,),
            width: double.infinity,
            height: 6.h,
            child: TextButton(
              style: flatButtonStyle,
              onPressed: () async {
                Navigator.pushNamed(context, '/home_basket_sub_screen',arguments: widget.mySubscribtions?.id);
              },
              child: Text(
                'request_basket'.tr(),
                style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'regular',
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 1.h,),
        ],
      ),
    );
  }

}