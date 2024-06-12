import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:sizer/sizer.dart';

import '../../../../business/homeController/HomeController.dart';
import '../../../../conustant/my_colors.dart';
import 'dart:math' as math;

import '../../../../data/model/productModel/ProductResponse.dart';
import '../../../screen/buttomSheets/clothesButtomSheets/clothes_buttom_sheets.dart';

class ClothesItem extends StatefulWidget{
  Products products;
  var txt;

  ClothesItem({required this.products,required this.txt});

  @override
  State<StatefulWidget> createState() {
    return _ClothesItem();
  }
}

class _ClothesItem extends State<ClothesItem>{
  final homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        showModalBottomSheet<void>(
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            context: context,
            backgroundColor: Colors.white,
            builder: (BuildContext context) => Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: ClothesButtomSheets()));
      },
      child: Container(
        padding: EdgeInsetsDirectional.all(2.h),
        margin: EdgeInsetsDirectional.only(bottom: 1.h),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(
              color:  MyColors.MainGoku, width: 1.0,),
            color:  MyColors.MainGohan),
        child: Row(
          children: [
            SvgPicture.asset("assets/clothes2.svg"),
            SizedBox(width: 1.h,),
            SizedBox(
              width: 30.h,
              child: Text(widget.txt??"",
                  style:  TextStyle(fontSize: 12.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w300,
                      color:MyColors.MainTrunks),overflow: TextOverflow.ellipsis),
            ),
            const Spacer(),
            Transform.rotate(
                angle:homeController.lang=="en"? 180 *math.pi /180:0,
                child: SvgPicture.asset('assets/alt_arrow.svg',))
          ],
        ),
      ),
    );
  }

}