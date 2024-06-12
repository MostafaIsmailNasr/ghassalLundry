import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'dart:math' as math;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'package:timelines/timelines.dart';
import '../../../business/homeController/HomeController.dart';
import '../../../business/orderDetailsController/OrderDetailsController.dart';
import '../../../conustant/my_colors.dart';
import '../../widget/OrderDetailsItem.dart';
import '../buttomSheets/rateOrderSheet/rate_order_buttom_sheet.dart';

class OrderDetailsScreen extends StatefulWidget{
  var code;
  var id;

  OrderDetailsScreen({required this.code,required this.id});

  @override
  State<StatefulWidget> createState() {
    return _OrderDetailsScreen();
  }
}

class _OrderDetailsScreen extends State<OrderDetailsScreen>{
  final homeController = Get.put(HomeController());
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  var _processes = [];
  var completeColor = Color(0xff5F489D);
  var inProgressColor = Color(0xff867ca1);
  var todoColor = Color(0xffd1d2d7);
  int _processIndex = 2;
  final orderDetailsController = Get.put(OrderDetailsController());
  var productPref=[];


  @override
  void initState() {
    super.initState();
    orderDetailsController.getOrderDetails(context, widget.id.toString()).then((_){
      setState(() {
        productPref=orderDetailsController.orderDetailsResponse.value.data!.prefrences??[];
      });

    });
  }

  Color getColor(int index) {
    // Get the current status from orderDetailsController
    String? currentStatus = orderDetailsController.orderDetailsResponse.value.data?.statusLang;


    // Check if current status exists in the _processes list
    int? statusIndex;
    if (currentStatus != null && _processes.contains(currentStatus)) {
      statusIndex = _processes.indexOf(currentStatus);
    }

    // Determine the color based on the logic provided
    if (statusIndex != null) {
      if (index == statusIndex) {
        return inProgressColor; // Current status is selected
      } else if (index < statusIndex) {
        return completeColor; // Before the current status
      }else {
        return todoColor;
      }
    }
    else {
      return todoColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    _processes = [
      'pending'.tr(),
      'accepted'.tr(),
      'receipted'.tr(),
      'in_progress'.tr(),
      'finished'.tr(),
      'delivery_in_progress'.tr(),
      'delivered'.tr(),
      'cancelled'.tr(),
      'rejected'.tr(),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Transform.rotate(
                angle:homeController.lang=="en"? 180 *math.pi /180:0,
                child: SvgPicture.asset('assets/back.svg',))),
        title: Text(widget.code,
            style:  TextStyle(
                fontSize: 12.sp,
                fontFamily: 'alexandria_bold',
                fontWeight: FontWeight.w500,
                color: MyColors.MainBulma)),
        actions: [
          PopupMenuButton(
            initialValue: 2,color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(left: 2.h,right: 2.h),
              child: SvgPicture.asset('assets/menu.svg'),
            ),
            itemBuilder: (context) {
              return List.generate(1, (index) {
                return PopupMenuItem(
                  value: index,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset('assets/remove.svg'),
                      Text(
                        'cancel_order'.tr(),
                        style: TextStyle(
                            fontSize: 10.sp,
                            fontFamily: 'regular',
                            fontWeight: FontWeight.w500,
                            color: Colors.red),
                      )
                    ],
                  ),
                  onTap: (){
                    print("kjkj");
                    orderDetailsController.cancelOrder(context, widget.id.toString());
                    // showModalBottomSheet<void>(
                    //     isScrollControlled: true,
                    //     shape: const RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    //     ),
                    //     context: context,
                    //     backgroundColor: Colors.white,
                    //     builder: (BuildContext context) => Padding(
                    //         padding: EdgeInsets.only(
                    //             bottom: MediaQuery.of(context).viewInsets.bottom),
                    //         child: RateOrderButtomSheet()));
                  },
                );
              });
            },
          ),
        ],
      ),
      body:Obx(() => !orderDetailsController.isLoading.value?
        SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              orderStatus(),
              SizedBox(height: 2.5.h,),
              Container(
                margin:  EdgeInsetsDirectional.only(end: 1.5.h,start: 1.5.h,),
                padding: EdgeInsetsDirectional.all(2.h),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                      color: MyColors.MainGoku, width: 1.0,),
                    color:  MyColors.MainGoku),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('address'.tr(),
                        style:  TextStyle(
                            fontSize: 10.sp,
                            fontFamily: 'alexandria_medium',
                            fontWeight: FontWeight.w500,
                            color: MyColors.MainBulma)),
                    SizedBox(height: 1.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset('assets/order_map.svg'),
                        SizedBox(width: 1.h,),
                        Expanded(
                          child: Text(orderDetailsController.orderDetailsResponse.value.data?.addressName??"",
                              style:  TextStyle(
                                  fontSize: 10.sp,
                                  fontFamily: 'alexandria_regular',
                                  fontWeight: FontWeight.w300,
                                  color: MyColors.Dark4)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              /*SizedBox(height: 1.h,),
              Container(
                margin:  EdgeInsetsDirectional.only(end: 1.5.h,start: 1.5.h,),
                padding: EdgeInsetsDirectional.all(2.h),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                      color: MyColors.MainGoku, width: 1.0,),
                    color:  MyColors.MainGoku),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('payment_details'.tr(),
                        style:  TextStyle(
                            fontSize: 10.sp,
                            fontFamily: 'alexandria_medium',
                            fontWeight: FontWeight.w500,
                            color: MyColors.MainBulma)),
                    SizedBox(height: 1.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset('assets/mastercard.svg'),
                        SizedBox(width: 1.h,),
                        Text("•••• •••• •••• •••• 4679",
                            style:  TextStyle(
                                fontSize: 10.sp,
                                fontFamily: 'alexandria_regular',
                                fontWeight: FontWeight.w400,
                                color: MyColors.Dark4)),
                      ],
                    )
                  ],
                ),
              ),*/
              SizedBox(height: 1.h,),
              Container(
                margin:  EdgeInsetsDirectional.only(end: 1.5.h,start: 1.5.h,),
                padding: EdgeInsetsDirectional.all(2.h),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                      color: MyColors.MainGoku, width: 1.0,),
                    color:  MyColors.MainGoku),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('discount_code'.tr(),
                        style:  TextStyle(
                            fontSize: 10.sp,
                            fontFamily: 'alexandria_medium',
                            fontWeight: FontWeight.w500,
                            color: MyColors.MainBulma)),
                    const Spacer(),
                    Text(orderDetailsController.orderDetailsResponse.value.data?.couponCode ?? "-",
                        style:  TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'alexandria_regular',
                            fontWeight: FontWeight.w300,
                            color: MyColors.MainBulma)),
                  ],
                ),
              ),
              SizedBox(height: 1.h,),
              Container(
                margin:  EdgeInsetsDirectional.only(end: 1.5.h,start: 1.5.h,),
                padding: EdgeInsetsDirectional.all(2.h),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                      color: MyColors.MainGoku, width: 1.0,),
                    color:  MyColors.MainGoku),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('date'.tr(),
                        style:  TextStyle(
                            fontSize: 10.sp,
                            fontFamily: 'alexandria_medium',
                            fontWeight: FontWeight.w500,
                            color: MyColors.MainBulma)),
                    SizedBox(height: 1.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("received_date".tr(),
                                style:  TextStyle(
                                    fontSize: 10.sp,
                                    fontFamily: 'alexandria_regular',
                                    fontWeight: FontWeight.w300,
                                    color: MyColors.textColor)),
                            SizedBox(height: 1.h,),
                            Text(orderDetailsController.orderDetailsResponse.value.data?.receivedDate??"",
                                style:  TextStyle(
                                    fontSize: 10.sp,
                                    fontFamily: 'alexandria_regular',
                                    fontWeight: FontWeight.w300,
                                    color: MyColors.Dark4)),
                          ],
                        ),
                        SizedBox(width: 5.h,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("delivery_date".tr(),
                                style:  TextStyle(
                                    fontSize: 10.sp,
                                    fontFamily: 'alexandria_regular',
                                    fontWeight: FontWeight.w300,
                                    color: MyColors.textColor)),
                            SizedBox(height: 1.h,),
                            Text(orderDetailsController.orderDetailsResponse.value.data?.deliveryDate??"",
                                style:  TextStyle(
                                    fontSize: 10.sp,
                                    fontFamily: 'alexandria_regular',
                                    fontWeight: FontWeight.w300,
                                    color: MyColors.Dark4)),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 1.h,),
              orderDetails(),
              SizedBox(height: 1.h,),
              Container(
                margin:  EdgeInsetsDirectional.only(end: 1.5.h,start: 1.5.h,),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsetsDirectional.all(2.h),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                      color: MyColors.MainGoku, width: 1.0,),
                    color:  MyColors.MainGoku),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('your_note'.tr(),
                        style:  TextStyle(
                            fontSize: 10.sp,
                            fontFamily: 'alexandria_medium',
                            fontWeight: FontWeight.w500,
                            color: MyColors.MainBulma)),
                    SizedBox(height: 1.h,),
                    Text(orderDetailsController.orderDetailsResponse.value.data?.notes??"",
                        style:  TextStyle(
                            fontSize: 10.sp,
                            fontFamily: 'alexandria_regular',
                            fontWeight: FontWeight.w300,
                            color: MyColors.MainTrunks)),
                  ],
                ),
              ),
              SizedBox(height: 2.h,),
              orderDetailsController.orderDetailsResponse.value.data?.status=="delivered"?
              Container(
                margin:  EdgeInsetsDirectional.only(end: 1.5.h,start: 1.5.h,bottom: 1.h),
                width: double.infinity,
                height: 8.h,
                child: TextButton(
                  style: flatButtonStyle,
                  onPressed: () {
                    showModalBottomSheet<void>(
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20)),
                        ),
                        context: context,
                        backgroundColor: Colors.white,
                        builder: (BuildContext context) => Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context)
                                    .viewInsets
                                    .bottom),
                            child: RateOrderButtomSheet(id: orderDetailsController.orderDetailsResponse.value.data?.id,code: widget.code)));
                  },
                  child: Text('rate'.tr(),
                    style:  TextStyle(fontSize: 12.sp,
                        fontFamily: 'alexandria_medium',
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ),
                ),
              )
                  :Container(),
            ],
          ),
        ),
      )
          :const Center(child: CircularProgressIndicator(color: MyColors.MainPrimary,))),
    );
  }

  Widget orderStatus(){
    return SizedBox(
      height: 12.h,
      child: Timeline.tileBuilder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        theme: TimelineThemeData(
          direction: Axis.horizontal,
          connectorTheme: ConnectorThemeData(
            space:2.h,
            thickness: 3.0,
          ),
        ),
        builder: TimelineTileBuilder.connected(
          connectionDirection: ConnectionDirection.before,
          itemExtentBuilder: (_, __) =>
          MediaQuery.of(context).size.width /5,
          contentsBuilder: (context, index) {
            return Padding(
              padding:  EdgeInsets.only(top: 1.h),
              child: Text(
                _processes[index],
                style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: 'alexandria_regular',
                    fontWeight: FontWeight.w400,
                    color: getColor(index)
                ),
              ),
            );
          },
         /* indicatorBuilder: (_, index) {
            var color;
            var child;
            if (index >= _processIndex) {
              color = inProgressColor;
              child = Padding(
                padding:  EdgeInsets.all(1.2.h),
                child: Text("0${index+1}",
                    style: TextStyle(
                        fontSize: 11.sp,
                        fontFamily: 'alexandria_medium',
                        fontWeight: FontWeight.w500,
                        color: todoColor))
              );
            }
            else if (index < _processIndex) {
              color = completeColor;
              child = Icon(
                Icons.check,
                color: Colors.white,
                size: 3.h,
              );
            } else {
              color = todoColor;
            }

            if (index <= _processIndex) {
              return Row(
                children: [
                  SizedBox(width: 0.2.h,),
                  DotIndicator(
                    size: 5.h,
                    color: color,
                    child: child,
                  ),
                  SizedBox(width: 0.2.h,),
                ],
              );
            } else {
              return Row(
                children: [
                  SizedBox(width: 0.2.h,),
                  DotIndicator(
                    size: 5.h,
                    color: color,
                    child: child,
                  ),
                  SizedBox(width: 0.2.h,),
                ],
              );
            }
          },*/
          indicatorBuilder: (_, index) {
            // Get the current status from orderDetailsController
            String? currentStatus = orderDetailsController.orderDetailsResponse.value.data?.statusLang;

            // Check if the current status exists in the _processes list and determine its index
            int? statusIndex;
            if (currentStatus != null && _processes.contains(currentStatus)) {
              statusIndex = _processes.indexOf(currentStatus);
            }

            // Determine the color and child widget based on the logic provided
            var color;
            var child;
            if (index >= (statusIndex ?? _processIndex)) {
              color = inProgressColor;
              child = Padding(
                padding: EdgeInsets.all(1.2.h),
                child: Text(
                  "0${index + 1}",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: 'alexandria_medium',
                    fontWeight: FontWeight.w500,
                    color: todoColor,
                  ),
                ),
              );
            } else if (index < (statusIndex ?? _processIndex)) {
              color = completeColor;
              child = Icon(
                Icons.check,
                color: Colors.white,
                size: 3.h,
              );
            } else {
              color = todoColor;
              child = Padding(
                padding: EdgeInsets.all(1.2.h),
                child: Text(
                  "0${index + 1}",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: 'alexandria_medium',
                    fontWeight: FontWeight.w500,
                    color: todoColor,
                  ),
                ),
              );
            }

            // Return the indicator with the determined color and child widget
            return Row(
              children: [
                SizedBox(width: 0.2.h),
                DotIndicator(
                  size: 5.h,
                  color: color,
                  child: child,
                ),
                SizedBox(width: 0.2.h),
              ],
            );
          },
          /*connectorBuilder: (_, index, type) {
            if (index > 0) {
              if (index == _processIndex) {
                final prevColor = getColor(index - 1);
                final color = getColor(index);
                List<Color> gradientColors;
                if (type == ConnectorType.start) {
                  gradientColors = [Color.lerp(prevColor, color, 0.5)!, color];
                } else {
                  gradientColors = [
                    prevColor,
                    Color.lerp(prevColor, color, 0.5)!
                  ];
                }
                return DecoratedLineConnector(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                    ),
                  ),
                );
              } else {
                return SolidLineConnector(
                  color: getColor(index),
                );
              }
            } else {
              return null;
            }
          },*/
          connectorBuilder: (_, index, type) {
            // Get the current status from orderDetailsController
            String? currentStatus = orderDetailsController.orderDetailsResponse.value.data?.statusLang;

            // Check if the current status exists in the _processes list and determine its index
            int? statusIndex;
            if (currentStatus != null && _processes.contains(currentStatus)) {
              statusIndex = _processes.indexOf(currentStatus);
            }

            // Determine whether to use SolidLineConnector or DecoratedLineConnector based on index and process index
            if (index > 0) {
              if (index == (statusIndex ?? _processIndex)) {
                // Get colors for the connectors
                final prevColor = getColor(index - 1);
                final color = getColor(index);

                // Determine gradient colors
                List<Color> gradientColors;
                if (type == ConnectorType.start) {
                  gradientColors = [Color.lerp(prevColor, color, 0.5)!, color];
                } else {
                  gradientColors = [
                    prevColor,
                    Color.lerp(prevColor, color, 0.5)!
                  ];
                }

                // Return DecoratedLineConnector with the determined gradient colors
                return DecoratedLineConnector(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                    ),
                  ),
                );
              } else {
                // Return SolidLineConnector with the color determined by the getColor function
                return SolidLineConnector(
                  color: getColor(index),
                );
              }
            } else {
              return null;
            }
          },
          itemCount: _processes.length,
        ),
      ),
    );
  }

  Widget orderDetails(){
    return Container(
      margin:  EdgeInsetsDirectional.only(end: 1.5.h,start: 1.5.h,),
      padding: EdgeInsetsDirectional.all(2.h),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.all(
            color: MyColors.MainGoku, width: 1.0,),
          color:  MyColors.MainGoku),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('order_details'.tr(),
              style:  TextStyle(
                  fontSize: 10.sp,
                  fontFamily: 'alexandria_medium',
                  fontWeight: FontWeight.w500,
                  color: MyColors.MainBulma)),
          SizedBox(height: 1.h,),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: orderDetailsController.myOrderList.length,
              itemBuilder: (context, int index) {
                return OrderDetailsItem(
                  orderItems:  orderDetailsController.myOrderList[index],
                );
              }
          ),
          SizedBox(height: 1.h,),
          productPref.isNotEmpty?
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: productPref.length,
              itemBuilder: (context, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(productPref[index].prefrenceName??"",
                        style:  TextStyle(
                            fontSize: 10.sp,
                            fontFamily: 'alexandria_regular',
                            fontWeight: FontWeight.w400,
                            color: MyColors.Dark4)),
                    const Spacer(),
                    Text(productPref[index].prefrencePrice.toString()??"",
                        style:  TextStyle(
                            fontSize: 8.sp,
                            fontFamily: 'alexandria_medium',
                            fontWeight: FontWeight.w400,
                            color: MyColors.MainBulma)),
                  ],
                );
              }
          )
              :Container(),
          SizedBox(height: 1.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("${"quick_access".tr()} (${orderDetailsController.orderDetailsResponse.value.data?.typeLang})",
                  style:  TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'alexandria_regular',
                      fontWeight: FontWeight.w400,
                      color: MyColors.Dark4)),
              const Spacer(),
              Text(
                  orderDetailsController.orderDetailsResponse.value.data?.type=="normal"?
                  "0 ${"currency".tr()}":"6 ${"currency".tr()}",
                  style:  TextStyle(
                      fontSize: 8.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w400,
                      color: MyColors.MainBulma)),
            ],
          ),
          SizedBox(height: 1.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("delivery_cost".tr() ,
                  style:  TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'alexandria_regular',
                      fontWeight: FontWeight.w400,
                      color: MyColors.Dark4)),
              const Spacer(),
              Text(
                  "${orderDetailsController.orderDetailsResponse.value.data?.deliveryCost} ${"currency".tr()}",
                  style:  TextStyle(
                      fontSize: 8.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w400,
                      color: MyColors.MainBulma)),
            ],
          ),
          SizedBox(height: 1.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("discount".tr() ,
                  style:  TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'alexandria_regular',
                      fontWeight: FontWeight.w400,
                      color: MyColors.Dark4)),
              const Spacer(),
              Text(
                  "${orderDetailsController.orderDetailsResponse.value.data?.discount} ${"currency".tr()}",
                  style:  TextStyle(
                      fontSize: 8.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w400,
                      color: MyColors.MainBulma)),
            ],
          ),
          SizedBox(height: 2.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("total".tr(),
                  style:  TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'alexandria_regular',
                      fontWeight: FontWeight.w400,
                      color: MyColors.Dark4)),
              const Spacer(),
              Text("${orderDetailsController.orderDetailsResponse.value.data?.totalAfterDiscount??"0"} ${"currency".tr()}",
                  style:  TextStyle(
                      fontSize: 8.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w400,
                      color: MyColors.MainBulma)),
            ],
          ),
        ],
      ),
    );
  }

}