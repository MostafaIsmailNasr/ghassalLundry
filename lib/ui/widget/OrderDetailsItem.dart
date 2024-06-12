import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:sizer/sizer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../business/orderDetailsController/OrderDetailsController.dart';
import '../../conustant/my_colors.dart';
import '../../data/model/orderDetailsModel/OrderDetailsResponse.dart';
import 'OrderItemPrefrences.dart';


class OrderDetailsItem extends StatelessWidget{
  OrderItems orderItems;
  final orderDetailsController = Get.put(OrderDetailsController());
  OrderDetailsItem({required this.orderItems});

  @override
  Widget build(BuildContext context) {
    double price=0;
    price= (orderItems.quantity)! * (double.parse(orderItems.price!));
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          orderItems.type!="subscribtions"?
          Container(): Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("subscription_name".tr(),
                  style:  TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'alexandria_regular',
                      fontWeight: FontWeight.w400,
                      color: MyColors.Dark4)),
              const Spacer(),
              Text(orderItems.subscribtionName??"",
                  style:  TextStyle(
                      fontSize: 8.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w400,
                      color: MyColors.MainBulma)),
            ],
          ),
          orderDetailsController.orderDetailsResponse.value.data!.subscriptionUsedBaskets!>1?Container():SizedBox(height: 1.h,),
          orderDetailsController.orderDetailsResponse.value.data!.subscriptionUsedBaskets!>1?Container():
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("${"service_type".tr()} (${orderItems.type})",
                  style:  TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'alexandria_regular',
                      fontWeight: FontWeight.w400,
                      color: MyColors.Dark4)),
              const Spacer(),
              Text("${orderItems.price.toString()} ${"currency".tr()}",
                  style:  TextStyle(
                      fontSize: 8.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w400,
                      color: MyColors.MainBulma)),
            ],
          ),
          orderDetailsController.orderDetailsResponse.value.data!.subscriptionUsedBaskets!>1?Container():SizedBox(height: 1.h,),
          orderItems.type=="products"?
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("${orderItems.productName} (${orderItems.quantity})",
                  style:  TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'alexandria_regular',
                      fontWeight: FontWeight.w400,
                      color: MyColors.Dark4)),
              const Spacer(),
              Text("$price ${"currency".tr()}",
                  style:  TextStyle(
                      fontSize: 8.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w400,
                      color: MyColors.MainBulma)),
            ],
          )
              : orderDetailsController.orderDetailsResponse.value.data!.subscriptionUsedBaskets!>1?Container(): Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("${"number_baskets".tr()} (${orderItems.quantity})",
                  style:  TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'alexandria_regular',
                      fontWeight: FontWeight.w400,
                      color: MyColors.Dark4)),
              const Spacer(),
              Text("$price ${"currency".tr()}",
                  style:  TextStyle(
                      fontSize: 8.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w400,
                      color: MyColors.MainBulma)),
            ],
          ),
          orderDetailsController.orderDetailsResponse.value.data!.subscriptionUsedBaskets!>1?Container():SizedBox(height: 1.h,),
          prefrences(),
          orderItems.type=="products"?Container():SizedBox(height: 1.h,),
          orderItems.type=="subscribtions"
          &&orderDetailsController.orderDetailsResponse.value.data!.subscriptionUsedBaskets==1?
          Text("${"basket_size".tr()} (${orderItems.subscribtionType??""})",
              style:  TextStyle(
                  fontSize: 10.sp,
                  fontFamily: 'alexandria_regular',
                  fontWeight: FontWeight.w400,
                  color: MyColors.Dark4)):Container(),
          orderItems.type=="baskets"? Text("${"basket_size".tr()} (${orderItems.basketSize??""})",
              style:  TextStyle(
                  fontSize: 10.sp,
                  fontFamily: 'alexandria_regular',
                  fontWeight: FontWeight.w400,
                  color: MyColors.Dark4)):Container(),
          orderItems.type=="products"?Container():SizedBox(height: 1.h,),
          orderItems.type=="products"?Container():Text(
              orderItems.washType=="0"?
              "washing_ironing".tr():"iron_only".tr(),
              style:  TextStyle(
                  fontSize: 10.sp,
                  fontFamily: 'alexandria_regular',
                  fontWeight: FontWeight.w400,
                  color: MyColors.Dark4)),
          SizedBox(height: 2.h,),
          SvgPicture.asset('assets/line4.svg'),
        ],
      ),
    );
  }

  Widget prefrences(){
    if(orderItems.orderItemPrefrences!.isNotEmpty) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: orderItems.orderItemPrefrences?.length,
          itemBuilder: (context, int index) {
            return OrderItemPrefrences2(
              orderItemPrefrences: orderItems.orderItemPrefrences![index],
            );
          }
      );
    }else{
      return Container();
    }
  }

}