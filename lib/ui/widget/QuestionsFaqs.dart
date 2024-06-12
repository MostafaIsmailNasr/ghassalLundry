import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../conustant/my_colors.dart';
import '../../data/model/FaqsModel/FaqsResponse.dart';

class QuestionsFaqs extends StatelessWidget{
  bool is_selected;
  GestureTapCallback? onTap;
  AllFaqs allFaqs;

  QuestionsFaqs({required this.is_selected,required this.onTap,required this.allFaqs});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:is_selected?MyColors.MainPrimary: MyColors.Dark3,
              width: 1,
            ),
            color:is_selected? MyColors.MainPrimary:Colors.white
        ),
        child:  Padding(
          padding: EdgeInsets.all(1.h),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(//"الدفع",
                allFaqs.name??"",
              style: TextStyle(
                  fontSize: 10.sp,
                fontFamily: 'alexandria_regular',
                fontWeight: FontWeight.w400,
                color:is_selected? Colors.white:MyColors.Dark4),textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }

}