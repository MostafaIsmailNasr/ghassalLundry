
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../../../conustant/my_colors.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class MoreBasketsItem extends StatefulWidget{
  bool is_selected;
  GestureTapCallback? onTap;

  MoreBasketsItem({required this.is_selected,required this.onTap});

  @override
  State<StatefulWidget> createState() {
    return _MoreBasketsItem();
  }
}

class _MoreBasketsItem extends State<MoreBasketsItem>{
  var counter=1;
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
                Image.asset("assets/medium.png"),
                SizedBox(height: 1.h,),
                Text("information_about_package".tr(),
                    style:  TextStyle(fontSize: 8.sp,
                        fontFamily: 'alexandria_regular',
                        fontWeight: FontWeight.w300,
                        color:MyColors.MainTrunks)),
                SizedBox(height: 1.h,),
                Text("Medium basket",
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
          ),
        ),
        Visibility(
          visible: widget.is_selected,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  setState(() {
                    counter++;
                  });
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
              Text(counter.toString(),
                  style:  TextStyle(fontSize: 14.sp,
                      fontFamily: 'alexandria_bold',
                      fontWeight: FontWeight.w700,
                      color:MyColors.counterColor)),
              SizedBox(width: 4.h,),
              GestureDetector(
                onTap: (){
                  setState(() {
                    if(counter>1) {
                      counter--;
                    }
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
        )
      ],
    );
  }

}