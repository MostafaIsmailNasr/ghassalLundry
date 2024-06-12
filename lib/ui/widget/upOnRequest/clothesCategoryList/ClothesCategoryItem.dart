import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../conustant/my_colors.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../data/model/productModel/ProductResponse.dart';

class ClothesCategoryItem extends StatefulWidget{
  bool is_selected;
  GestureTapCallback? onTap;
  ProductCat productCat;

  ClothesCategoryItem({required this.is_selected,required this.onTap,required this.productCat});
  @override
  State<StatefulWidget> createState() {
    return _ClothesCategoryItem();
  }
}

class _ClothesCategoryItem extends State<ClothesCategoryItem>{
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 15.h,
        padding: EdgeInsetsDirectional.all(2.h),
        margin: EdgeInsetsDirectional.only(end: 1.h),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(
              color: widget.is_selected?MyColors.MainPrimary: MyColors.MainBeerus,
              width:widget.is_selected?2.0: 1.0,),
            color: widget.is_selected?MyColors.Back: MyColors.MainGoku),
        child: Center(
          child: Text(widget.productCat.name??"",
              style:  TextStyle(fontSize: 9.sp,
                  fontFamily: 'alexandria_medium',
                  fontWeight: FontWeight.w400,overflow: TextOverflow.ellipsis,
                  color:MyColors.MainZeno)),
        ),
      ),
    );
  }

}