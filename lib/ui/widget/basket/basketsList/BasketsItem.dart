import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:sizer/sizer.dart';

import '../../../../business/ghassalBasketsController/GhassalBasketsController.dart';
import '../../../../conustant/my_colors.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../data/model/basketModel/BasketListResponse.dart';
import '../../../../data/model/selectedBasketModel/SelectedBasketModel.dart';

class BasketsItem extends StatefulWidget{
  bool is_selected;
  GestureTapCallback? onTap;
  Baskets? baskets;
  BasketsItem({required this.is_selected,required this.onTap,required this.baskets});

  @override
  State<StatefulWidget> createState() {
    return _BasketsItem();
  }
}

class _BasketsItem extends State<BasketsItem>{
  final ghassalBasketsController = Get.put(GhassalBasketsController());
  var counter=1;
  var itemBasketPrice=0;

  @override
  void initState() {
    super.initState();
    itemBasketPrice=widget.baskets?.priceWash??0;
  }
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
                Image.network(widget.baskets?.image??"",width: 10.h,height: 5.h,),
                SizedBox(height: 1.h,),
                Text("information_about_package".tr(),
                    style:  TextStyle(fontSize: 8.sp,
                        fontFamily: 'alexandria_regular',
                        fontWeight: FontWeight.w300,
                        color:MyColors.MainTrunks)),
                SizedBox(height: 1.h,),
                Text(widget.baskets?.title??"",
                    style:  TextStyle(fontSize: 10.sp,
                        fontFamily: 'alexandria_medium',
                        fontWeight: FontWeight.w500,
                        color:MyColors.MainTrunks)),
                SizedBox(height: 1.h,),
                Text(
                    ghassalBasketsController.isIroningSelected==true&&ghassalBasketsController.itemIroningId==1?
                    "${widget.baskets?.priceWash.toString()??"0"} ${'currency'.tr()}"
                        :"${widget.baskets?.priceIroning.toString()??"0"} ${'currency'.tr()}",
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
                  //calculatePlus();
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
              Text(ghassalBasketsController.getItemPrice(widget.baskets!.id!).toString(),
                  style:  TextStyle(fontSize: 14.sp,
                      fontFamily: 'alexandria_bold',
                      fontWeight: FontWeight.w700,
                      color:MyColors.counterColor)),
              SizedBox(width: 4.h,),
              GestureDetector(
                onTap: (){
                  setState(() {
                    //calculateMinus();
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
        ),
      ],
    );
  }
  
}