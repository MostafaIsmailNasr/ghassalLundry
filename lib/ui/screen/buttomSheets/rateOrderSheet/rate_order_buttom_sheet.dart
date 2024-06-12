import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../business/orderDetailsController/OrderDetailsController.dart';
import '../../../../conustant/my_colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../conustant/toast_class.dart';


class RateOrderButtomSheet extends StatefulWidget{
  var id;
  var code;

  RateOrderButtomSheet({required this.id,required this.code});

  @override
  State<StatefulWidget> createState() {
    return _RateOrderButtomSheet();
  }
}

class _RateOrderButtomSheet extends State<RateOrderButtomSheet>{
  TextEditingController noteController = TextEditingController();
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  final ButtonStyle flatButtonStyle2 = TextButton.styleFrom(
      backgroundColor: MyColors.MainGoku,
      shape:  const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        side: BorderSide(color: MyColors.MainBeerus)
      ));
  final orderDetailsController = Get.put(OrderDetailsController());

  @override
  void initState() {
    orderDetailsController.driverRate=0.0;
    orderDetailsController.ironingRate=0.0;
    orderDetailsController.orderRate=0.0;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 1.h,left: 1.h,top: 1.h,bottom: 2.h),
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3.h,),
              Text("${"order_no".tr()} ${widget.code}",
                style:  TextStyle(fontSize: 10.sp,
                    fontFamily: 'alexandria_medium',
                    fontWeight: FontWeight.w400,
                    color:MyColors.MainTrunks),),
              SizedBox(height: 1.h,),
              Text("opinion_helps_improve_ghassal_service".tr(),
                style:  TextStyle(fontSize: 14.sp,
                    fontFamily: 'alexandria_bold',
                    fontWeight: FontWeight.w600,
                    color:MyColors.MainBulma),),
              SizedBox(height: 1.h,),
              Row(
                children: [
                  SvgPicture.asset('assets/info_circle.svg'),
                  SizedBox(width: 1.h,),
                  Text("opinion_rating_help_improve_ghassal_service".tr(),
                    style:  TextStyle(fontSize: 8.sp,
                        fontFamily: 'alexandria_regular',
                        fontWeight: FontWeight.w300,
                        color:MyColors.MainTrunks),),
                ],
              ),
              SizedBox(height: 1.h,),
              Text("laundry".tr(),
                style:  TextStyle(fontSize: 10.sp,
                    fontFamily: 'alexandria_bold',
                    fontWeight: FontWeight.w600,
                    color:MyColors.MainTrunks),),
              SizedBox(height: 1.h,),
              Center(
                child: RatingBar(
                  initialRating: orderDetailsController.orderRate!,
                  direction: Axis.horizontal,
                  itemSize: 50,
                  minRating: 1,
                  allowHalfRating: true,
                  itemCount: 5,
                  ratingWidget: RatingWidget(
                    full: SvgPicture.asset('assets/fill.svg'),
                    half: SvgPicture.asset('assets/fill.svg'),
                    empty: SvgPicture.asset('assets/star_rating.svg'),
                  ),
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  onRatingUpdate: (rating) {
                    log(rating.toString());
                    orderDetailsController.orderRate=rating;
                  },
                ),
              ),
              SizedBox(height: 1.h,),
              Text("ironing".tr(),
                style:  TextStyle(fontSize: 10.sp,
                    fontFamily: 'alexandria_bold',
                    fontWeight: FontWeight.w600,
                    color:MyColors.MainTrunks),),
              SizedBox(height: 1.h,),
              Center(
                child: RatingBar(
                  initialRating: orderDetailsController.ironingRate!,
                  direction: Axis.horizontal,
                  itemSize: 50,
                  minRating: 1,
                  allowHalfRating: true,
                  itemCount: 5,
                  ratingWidget: RatingWidget(
                    full: SvgPicture.asset('assets/fill.svg'),
                    half: SvgPicture.asset('assets/fill.svg'),
                    empty: SvgPicture.asset('assets/star_rating.svg'),
                  ),
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  onRatingUpdate: (rating) {
                    log(rating.toString());
                    orderDetailsController.ironingRate=rating;
                  },
                ),
              ),
              SizedBox(height: 1.h,),
              Text("driver".tr(),
                style:  TextStyle(fontSize: 10.sp,
                    fontFamily: 'alexandria_bold',
                    fontWeight: FontWeight.w600,
                    color:MyColors.MainTrunks),),
              SizedBox(height: 1.h,),
              Center(
                child: RatingBar(
                  initialRating: orderDetailsController.driverRate!,
                  direction: Axis.horizontal,
                  itemSize: 50,
                  minRating: 1,
                  allowHalfRating: true,
                  itemCount: 5,
                  ratingWidget: RatingWidget(
                    full: SvgPicture.asset('assets/fill.svg'),
                    half: SvgPicture.asset('assets/fill.svg'),
                    empty: SvgPicture.asset('assets/star_rating.svg'),
                  ),
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  onRatingUpdate: (rating) {
                    log(rating.toString());
                    orderDetailsController.driverRate=rating;
                  },
                ),
              ),
              SizedBox(height: 1.h,),

              SizedBox(height: 1.h,),
              Text("opinion_really_important".tr(),
                style:  TextStyle(fontSize: 12.sp,
                    fontFamily: 'alexandria_medium',
                    fontWeight: FontWeight.w300,
                    color:MyColors.MainBulma),),
              SizedBox(height: 1.h,),
              notes(),
              SizedBox(height: 1.h,),
              Center(
                child: Obx(() =>
                    Visibility(
                        visible: orderDetailsController.isVisable
                            .value,
                        child: const CircularProgressIndicator(color: MyColors.MainPrimary,)
                    )),
              ),
              SizedBox(
                width: double.infinity,
                height: 8.h,
                child: TextButton(
                  style: flatButtonStyle,
                  onPressed: () {
                    if(orderDetailsController.orderRate==0.0
                    &&orderDetailsController.ironingRate==0.0
                        &&orderDetailsController.driverRate==0.0){
                      Fluttertoast.showToast(
                          msg: "Please Enter Rate",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
                      );
                    }else{
                      orderDetailsController.isVisable.value=true;
                      orderDetailsController.RateOrder(widget.id,context);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/Star3.svg'),
                      SizedBox(width: 1.h,),
                      Text('send'.tr(),
                        style:  TextStyle(fontSize: 12.sp,
                            fontFamily: 'alexandria_medium',
                            fontWeight: FontWeight.w300,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 1.h,),
              SizedBox(
                width: double.infinity,
                height: 8.h,
                child: TextButton(
                  style: flatButtonStyle2,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child:  Text('skip'.tr(),
                    style:  TextStyle(fontSize: 12.sp,
                        fontFamily: 'alexandria_medium',
                        fontWeight: FontWeight.w300,
                        color: MyColors.MainTrunks),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget notes(){
    return Container(
      height: 15.h,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.all(
            color: MyColors.MainGoku,
            width: 1.0,
          ),
          color:Colors.white),
      child: TextFormField(
        maxLines: 4,
        autovalidateMode:AutovalidateMode.onUserInteraction ,
        controller: orderDetailsController.NotesController,
        decoration:   InputDecoration(
          errorBorder:  const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: Colors.red,style: BorderStyle.solid),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: MyColors.MainGoku,style: BorderStyle.solid),
          ),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(style: BorderStyle.solid,color: MyColors.MainGoku,)
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: Colors.red,style: BorderStyle.solid),
          ) ,
          hintText: 'write_opinion_here'.tr(),
          hintStyle: TextStyle(fontSize: 10.sp,
              fontFamily: 'lexend_regular',
              fontWeight: FontWeight.w300,
              color: MyColors.Dark4),
        ),
        style:  TextStyle(fontSize: 10.sp,
            fontFamily: 'alexandria_regular',
            fontWeight: FontWeight.w300,
            color: MyColors.Dark4),
      ),
    );
  }

}