import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../conustant/my_colors.dart';
import '../../data/model/orderDetailsModel/OrderDetailsResponse.dart';

class OrderItemPrefrences2 extends StatelessWidget{
  OrderItemPrefrences orderItemPrefrences;

  OrderItemPrefrences2({required this.orderItemPrefrences});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(orderItemPrefrences.prefrenceName??"",
            style:  TextStyle(
                fontSize: 10.sp,
                fontFamily: 'alexandria_regular',
                fontWeight: FontWeight.w400,
                color: MyColors.Dark4)),
        const Spacer(),
        Text(orderItemPrefrences.prefrencePrice.toString()??"",
            style:  TextStyle(
                fontSize: 8.sp,
                fontFamily: 'alexandria_medium',
                fontWeight: FontWeight.w400,
                color: MyColors.MainBulma)),
      ],
    );
  }

}