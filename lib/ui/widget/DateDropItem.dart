import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../conustant/my_colors.dart';
import '../../data/model/pickupDateModel/PickupDateResponse.dart';



class DateDropItem extends StatelessWidget {
  bool is_selected;
  GestureTapCallback? onTap;
  PickUp? dropOffDates;

  DateDropItem({required this.is_selected,required this.onTap,required this.dropOffDates});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 7.h,
        padding: EdgeInsets.all(1.h),
        margin: EdgeInsetsDirectional.only(end: 1.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: is_selected?MyColors.MainPrimary: MyColors.MainGohan, width: 1.0,),
          color:is_selected?MyColors.MainPrimary: MyColors.MainGoku,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(dropOffDates?.dayInLetters??"",
              //"الثلاثاء",
              style:  TextStyle(fontSize: 6.sp,
                  fontFamily: 'alexandria_regular',
                  fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis,
                  color:is_selected?Colors.white: MyColors.MainTrunks),
            ),
            SizedBox(height: 1.h,),
            Container(
              padding: EdgeInsetsDirectional.only(top: 1.h,bottom: 1.h,),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: MyColors.MainPrimary, width: 1.0,),
                color:is_selected?Colors.white: MyColors.MainGoku,
              ),
              child: Center(
                child: Text(dropOffDates?.day.toString()??"",
                  //"13",
                  style:  TextStyle(fontSize: 6.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w700,
                      color:is_selected?MyColors.MainPrimary: MyColors.MainTrunks),
                ),
              ),
            ),
            SizedBox(height: 1.h,),
          ],
        ),
      ),
    );
  }


}