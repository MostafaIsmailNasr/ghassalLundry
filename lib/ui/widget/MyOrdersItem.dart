import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../conustant/my_colors.dart';
import '../../data/model/myOrdersModel/MyOrdersRespons.dart';
import '../screen/orderDetails/order_details_screen.dart';

class MyOrdersItem extends StatefulWidget{
  var status;
  MyOrders myOrders;
  MyOrdersItem({required this.status,required this.myOrders});
  @override
  State<StatefulWidget> createState() {
    return _MyOrdersItem();
  }

}

class _MyOrdersItem extends State<MyOrdersItem>{
  var isvisable=false;
  var isvisable2=true;
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        //Navigator.pushNamed(context, '/order_details_screen',arguments: widget.myOrders.orderNumber2);
        Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
          return OrderDetailsScreen(code: widget.myOrders.orderNumber,id: widget.myOrders.id,);
        },));
      },
      child: Container(
        margin:  EdgeInsetsDirectional.only(bottom: 1.h),
        decoration:  BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: MyColors.MainGoku,
            border: Border.all(color: MyColors.MainGoku)),
        child: Padding(
          padding:  EdgeInsets.all(1.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("order_no".tr(),
                    style:  TextStyle(fontSize: 12.sp,
                        fontFamily: 'alexandria_medium',
                        fontWeight: FontWeight.w500,
                        color:MyColors.Dark),),
                  SizedBox(width: 1.h,),
                  Text(widget.myOrders.orderNumber??"",
                    style:  TextStyle(fontSize: 12.sp,
                        fontFamily: 'alexandria_medium',
                        fontWeight: FontWeight.w500,
                        color:MyColors.Dark),),
                  const Spacer(),
                  Container(
                    decoration:  BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        color: MyColors.MainPrimary,
                        border: Border.all(color: MyColors.MainPrimary)),
                    padding: EdgeInsetsDirectional.only(top: 1.h,bottom: 1.h,start: 2.h,end: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        images(),
                        SizedBox(width: 1.h,),
                        Text(widget.myOrders.orderItems![0].type??"",
                          style:  TextStyle(fontSize: 10.sp,
                              fontFamily: 'alexandria_regular',
                              fontWeight: FontWeight.w300,
                              color:Colors.white),),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 1.h,),
              Visibility(visible: isvisable2,child: dots()),
              SizedBox(height: 1.h,),
              GestureDetector(
                onTap: (){
                  setState(() {
                    isvisable=true;
                    isvisable2=false;
                  });
                },
                child: Visibility(
                  visible: isvisable2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("view_details".tr(),
                        style:  TextStyle(fontSize: 10.sp,
                            fontFamily: 'alexandria_medium',
                            fontWeight: FontWeight.w400,
                            color:MyColors.MainSecondary),),
                      SizedBox(width: 1.h,),
                      SvgPicture.asset('assets/down.svg'),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: isvisable,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset('assets/order_map.svg'),
                        SizedBox(width: 1.h,),
                        SizedBox(
                          width: 35.h,
                          child: Text(widget.myOrders.addressName??"",
                            style:  TextStyle(fontSize: 10.sp,
                                fontFamily: 'alexandria_regular',
                                fontWeight: FontWeight.w300,
                                color:MyColors.Dark4),),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset('assets/dollar.svg'),
                        SizedBox(width: 1.h,),
                        Text("${"total_price".tr()} ${widget.myOrders.totalAfterDiscount.toString()??""} ${"currency".tr()}",
                          style:  TextStyle(fontSize: 10.sp,
                              fontFamily: 'alexandria_regular',
                              fontWeight: FontWeight.w300,
                              color:MyColors.Dark4),),
                      ],
                    ),
                    SizedBox(height: 1.h,),
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset('assets/mastercard2.svg'),
                        SizedBox(width: 1.h,),
                        Text("•••• •••• •••• •••• 4679",
                          style:  TextStyle(fontSize: 10.sp,
                              fontFamily: 'alexandria_regular',
                              fontWeight: FontWeight.w400,
                              color:MyColors.Dark4),),
                      ],
                    ),
                    SizedBox(height: 1.h,),*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("received_date".tr(),
                                style:  TextStyle(fontSize: 10.sp,
                                    fontFamily: 'alexandria_regular',
                                    fontWeight: FontWeight.w300,
                                    color:MyColors.textColor),),
                              SizedBox(height: 1.h,),
                              Text(widget.myOrders.receivedDate??"",
                                style:  TextStyle(fontSize: 10.sp,
                                    fontFamily: 'alexandria_regular',
                                    fontWeight: FontWeight.w300,
                                    color:MyColors.Dark4),),
                            ],
                          ),
                        ),
                        //SizedBox(width: 8.h,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("delivery_date".tr(),
                                style:  TextStyle(fontSize: 10.sp,
                                    fontFamily: 'alexandria_regular',
                                    fontWeight: FontWeight.w300,
                                    color:MyColors.textColor),),
                              SizedBox(height: 1.h,),
                              Text(widget.myOrders.deliveryDate??"",
                                style:  TextStyle(fontSize: 10.sp,
                                    fontFamily: 'alexandria_regular',
                                    fontWeight: FontWeight.w300,
                                    color:MyColors.Dark4),),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h,),
                    Text("notes".tr(),
                      style:  TextStyle(fontSize: 10.sp,
                          fontFamily: 'alexandria_regular',
                          fontWeight: FontWeight.w300,
                          color:MyColors.textColor),),
                    SizedBox(height: 1.h,),
                    Text(widget.myOrders.notes??"",
                      style:  TextStyle(fontSize: 10.sp,
                          fontFamily: 'alexandria_regular',
                          fontWeight: FontWeight.w300,
                          color:MyColors.Dark4),),
                    SizedBox(height: 2.h,),
                    Text("order_status".tr(),
                      style:  TextStyle(fontSize: 10.sp,
                          fontFamily: 'alexandria_regular',
                          fontWeight: FontWeight.w300,
                          color:MyColors.textColor),),
                    SizedBox(height: 1.h,),
                    dots(),
                    SizedBox(height: 1.h,),
                    SvgPicture.asset('assets/rectangle.svg'),
                    SizedBox(height: 1.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("${"rating".tr()} ${widget.myOrders.orderRating.toString()??"0"}",
                          style:  TextStyle(fontSize: 12.sp,
                              fontFamily: 'alexandria_regular',
                              fontWeight: FontWeight.w300,
                              color:MyColors.MainTrunks),),
                        SizedBox(width: 1.h,),
                        SvgPicture.asset('assets/star.svg'),
                        const Spacer(),
                        Container(
                          padding: EdgeInsetsDirectional.only(start: 2.h,end: 2.h,top: 1.h,bottom: 1.h),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              color: MyColors.MainPrimary,
                              border: Border.all(color: MyColors.MainPrimary)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/restart.svg'),
                              SizedBox(width: 1.h,),
                              Text("reorder".tr(),
                                style:  TextStyle(fontSize: 8.sp,
                                    fontFamily: 'alexandria_regular',
                                    fontWeight: FontWeight.w300,
                                    color:Colors.white),),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 1.h,),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isvisable=false;
                          isvisable2=true;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("close_details".tr(),
                            style:  TextStyle(fontSize: 10.sp,
                                fontFamily: 'alexandria_medium',
                                fontWeight: FontWeight.w400,
                                color:MyColors.MainSecondary),),
                          SizedBox(width: 1.h,),
                          SvgPicture.asset('assets/up.svg'),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  Widget images(){
    if(widget.myOrders.orderItems!=null||widget.myOrders.orderItems!.isNotEmpty) {
      if (widget.myOrders.orderItems?[0].type == "sub") {
        return SvgPicture.asset('assets/order_type1.svg');
      } else if (widget.myOrders.orderItems?[0].type == "baskets") {
        return SvgPicture.asset('assets/order_type2.svg');
      } else if (widget.myOrders.orderItems?[0].type == "upon") {
        return SvgPicture.asset('assets/order_type3.svg');
      } else {
        return SvgPicture.asset('assets/order_type1.svg');
      }
    }else{
      return SvgPicture.asset('assets/order_type1.svg');
    }
  }

  Widget dots(){
    if(widget.myOrders.status=="status"){
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/dots.svg'),
          SizedBox(width: 1.h,),
          Text(widget.myOrders.statusLang??"",
            style:  TextStyle(fontSize: 10.sp,
                fontFamily: 'alexandria_medium',
                fontWeight: FontWeight.w400,
                color:MyColors.MainPrimary),),
        ],
      );
    }else if(widget.myOrders.status=="baskets"){
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/dots.svg'),
          SizedBox(width: 1.h,),
          Text("مكتمل",
            style:  TextStyle(fontSize: 10.sp,
                fontFamily: 'alexandria_medium',
                fontWeight: FontWeight.w400,
                color:MyColors.MainPrimary),),
        ],
      );
    }else if(widget.myOrders.status=="upon"){
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/dots.svg'),
          SizedBox(width: 1.h,),
          Text("مكتمل",
            style:  TextStyle(fontSize: 10.sp,
                fontFamily: 'alexandria_medium',
                fontWeight: FontWeight.w400,
                color:MyColors.MainPrimary),),
        ],
      );
    }else{
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/dots.svg'),
          SizedBox(width: 1.h,),
          Text(widget.myOrders.statusLang??"",
            style:  TextStyle(fontSize: 10.sp,
                fontFamily: 'alexandria_medium',
                fontWeight: FontWeight.w400,
                color:MyColors.MainPrimary),),
        ],
      );
    }
  }

}