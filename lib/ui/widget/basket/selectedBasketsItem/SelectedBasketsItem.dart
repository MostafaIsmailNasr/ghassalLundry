import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:ghassal_laundry/data/model/basketModel/BasketListResponse.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

import '../../../../business/homeController/HomeController.dart';
import '../../../../conustant/my_colors.dart';
import 'dart:math' as math;

import '../../../../data/model/selectedBasketModel/SelectedBasketModel.dart';
import '../../../screen/createOrder/ghassalBasketsScreens/selectedBasketScreen/selected_basket_screen.dart';

class SelectedBasketsItem extends StatefulWidget{
  Baskets? selectedBaskets;


  SelectedBasketsItem({required this.selectedBaskets});

  @override
  State<StatefulWidget> createState() {
    return _SelectedBasketsItem();
  }
}

class _SelectedBasketsItem extends State<SelectedBasketsItem>{
  final homeController = Get.put(HomeController());
  var name;

  @override
  void initState() {
    super.initState();
    setState(() {
      if(widget.selectedBaskets?.washType==0){
        name="washing_ironing".tr();
      }else{
        name="iron_only".tr();
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        //.pushNamed(context, "/selected_basket_screens",arguments: widget.selectedBaskets);
        Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
          return SelectedBasketScreen(selectedBaskets: widget.selectedBaskets!,);
        },));
      },
      child: Container(
        padding: EdgeInsetsDirectional.all(2.h),
        margin: EdgeInsetsDirectional.only(bottom: 1.h),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(
              color: MyColors.MainGoku, width: 1.0,),
            color:  MyColors.MainGohan),
        child: Row(
          children: [
            SvgPicture.asset("assets/cart1.svg"),
            SizedBox(width: 1.h,),
            Text(
                "${widget.selectedBaskets?.quantity.toString()??""} ${widget.selectedBaskets?.title.toString()??""} ${name??""}",
                style:  TextStyle(fontSize: 12.sp,
                    fontFamily: 'alexandria_medium',
                    fontWeight: FontWeight.w300,
                    color:MyColors.MainTrunks)),
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