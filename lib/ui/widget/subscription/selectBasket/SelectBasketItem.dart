import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import '../../../../conustant/my_colors.dart';

class SelectBasketItem extends StatefulWidget{
  bool is_selected;
  GestureTapCallback? onTap;

  SelectBasketItem({required this.is_selected,required this.onTap});
  @override
  State<StatefulWidget> createState() {
    return _SelectBasketItem();
  }
}

class _SelectBasketItem extends State<SelectBasketItem>{
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsetsDirectional.only(end: 1.h,bottom: 1.h),
        padding: EdgeInsetsDirectional.all(1.5.h),
        height: 18.h,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(
              color: widget.is_selected?MyColors.MainPrimary: MyColors.MainGoku,
              width:widget.is_selected?2.0: 1.0,),
            color: widget.is_selected?MyColors.Back: MyColors.MainGoku),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/medium.png'),
            SizedBox(width: 1.h,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("سلة متوسطة",
                    style:  TextStyle(fontSize: 10.sp,
                        fontFamily: 'alexandria_medium',
                        fontWeight: FontWeight.w500,
                        color:MyColors.MainTrunks)),
                SizedBox(height: 1.h,),
                Text("49 ريال",
                    style:  TextStyle(fontSize: 8.sp,
                        fontFamily: 'alexandria_regular',
                        fontWeight: FontWeight.w400,
                        color:MyColors.MainPrimary)),
              ],
            ),
          ],
        ),
      ),
    );
  }

}