import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../conustant/my_colors.dart';
import '../../data/model/hoursModel/HoursResponse.dart';

class TimeDropItem extends StatelessWidget{
  bool is_selected;
  GestureTapCallback? onTap;
  Times hours;
  TimeDropItem({required this.is_selected,required this.onTap,required this.hours});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: Container(
        // margin: EdgeInsetsDirectional.only(end: 8,bottom: 8),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color:is_selected?MyColors.MainPrimary :MyColors.MainBeerus, width:is_selected?2.0:1.0,),
          color: is_selected?MyColors.timeBack: MyColors.MainGoku,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(hours.time??"",
              style: TextStyle(fontSize: 12.sp,
                  fontFamily: 'alexandria_medium',
                  decoration: hours.isAvailable==true?TextDecoration.none:TextDecoration.lineThrough,
                  fontWeight: FontWeight.w500,
                  color:is_selected?MyColors.MainPrimary: MyColors.MainTrunks),
            ),
            Text("${hours.from} to ${hours.to}",
              style: TextStyle(fontSize: 8.sp,
                  fontFamily: 'alexandria_regular',
                  decoration: hours.isAvailable==true?TextDecoration.none:TextDecoration.lineThrough,
                  fontWeight: FontWeight.w500,
                  color:is_selected?MyColors.timeBack3: MyColors.timeBack2),
            ),
          ],
        ),
      ),
    );
  }

}