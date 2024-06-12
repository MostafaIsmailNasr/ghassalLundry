import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:sizer/sizer.dart';

import '../../../../business/homeController/HomeController.dart';
import 'dart:math' as math;
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../business/myOrdersController/MyOrdersController.dart';
import '../../../../conustant/my_colors.dart';
import '../../../widget/MyOrdersItem.dart';
import '../../buttomSheets/ordersFilterSheet/orders_filter_buttom_sheet.dart';

class MyOrdersScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyOrdersScreen();
  }
}

class _MyOrdersScreen extends State<MyOrdersScreen>{
  final homeController = Get.put(HomeController());
  var isSelected=true;
  var itemId=1;
  var con=true;
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  final ButtonStyle flatButtonStyle2 = TextButton.styleFrom(
      backgroundColor: MyColors.MainGohan,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        side: BorderSide(color: MyColors.MainPrimary), // Add this line for border color
      ));
  final myOrdersController = Get.put(MyOrdersController());
  @override
  void initState() {
    check();
    myOrdersController.time.value="";
    myOrdersController.filterDate.value="";
    myOrdersController.orderType.value="";
    myOrdersController.codeController.text="";
    myOrdersController.orderStatus.value="";
    myOrdersController.getMyOrders(context,
        myOrdersController.orderStatus.value,
        myOrdersController.filterDate.value,
        myOrdersController.orderType.value,
        myOrdersController.codeController.text);
    super.initState();
  }

  Future<void> check()async{
    final hasInternet = await InternetConnectivity().hasInternetConnection;
    setState(() {
      con = hasInternet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
            'my_orders'.tr(),
            style:  TextStyle(
                fontSize: 12.sp,
                fontFamily: 'alexandria_bold',
                fontWeight: FontWeight.w500,
                color: MyColors.MainBulma)),
        actions: [
          GestureDetector(
              onTap: () {
                showModalBottomSheet<void>(
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    context: context,
                    backgroundColor: Colors.white,
                    builder: (BuildContext context) => Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: OrdersFilterButtomSheet()));
              },
            child: Padding(
              padding: EdgeInsets.only(left: 2.h,right: 2.h),
              child: SvgPicture.asset('assets/tuning2.svg'),
            ),
          ),
        ],
      ),
      body:con? homeController.sharedPreferencesService.getBool("islogin")==true?
      Obx(() => !myOrdersController.isLoading.value?
          Container(
        margin: EdgeInsetsDirectional.all(1.5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            status(),
            SizedBox(height: 1.h,),
            Expanded(child: myOrderList()),
          ],
        ),
      )
          :const Center(child: CircularProgressIndicator(color: MyColors.MainPrimary,),)) : pleaseLogin():internet()
    );
  }

  Widget status(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){
              setState(() {
                isSelected=true;
                itemId=1;
                myOrdersController.orderStatus.value="";
                myOrdersController.filterDate.value="";
                myOrdersController.orderType.value="";
                myOrdersController.codeController.text="";
                myOrdersController.getMyOrders(context,
                    myOrdersController.orderStatus.value,
                    myOrdersController.filterDate.value,
                    myOrdersController.orderType.value, myOrdersController.codeController.text);
              });
            },
            child: Container(
              padding: EdgeInsetsDirectional.only(top: 1.h,bottom: 1.h,start: 2.h,end: 2.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                    color:isSelected==true&&itemId==1?MyColors.MainPrimary: MyColors.MainBeerus,
                    width: 1.0,
                  ),
                  color:isSelected==true&&itemId==1?MyColors.MainPrimary: Colors.white),
              child: Center(
                child: Text("all".tr(),
                  style:  TextStyle(fontSize: 10.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w400,
                      color:isSelected==true&&itemId==1?Colors.white:MyColors.MainBeerus),),
              ),
            ),
          ),
          SizedBox(width: 1.h,),
          GestureDetector(
            onTap: (){
              setState(() {
                isSelected=true;
                itemId=2;
                myOrdersController.orderStatus.value="pending";
                myOrdersController.filterDate.value="";
                myOrdersController.orderType.value="";
                myOrdersController.codeController.text="";
                myOrdersController.getMyOrders(context,
                    myOrdersController.orderStatus.value,
                    myOrdersController.filterDate.value,
                    myOrdersController.orderType.value, myOrdersController.codeController.text);
              });
            },
            child: Container(
              padding: EdgeInsetsDirectional.only(top: 1.h,bottom: 1.h,start: 2.h,end: 2.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                    color:isSelected==true&&itemId==2?MyColors.MainPrimary: MyColors.MainBeerus,
                    width: 1.0,
                  ),
                  color:isSelected==true&&itemId==2?MyColors.MainPrimary: Colors.white),
              child: Center(
                child: Text("pending".tr(),
                  style:  TextStyle(fontSize: 10.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w400,
                      color:isSelected==true&&itemId==2?Colors.white:MyColors.MainBeerus),),
              ),
            ),
          ),
          SizedBox(width: 1.h,),
          GestureDetector(
            onTap: (){
              setState(() {
                isSelected=true;
                itemId=3;
                myOrdersController.orderStatus.value="accepted";
                myOrdersController.filterDate.value="";
                myOrdersController.orderType.value="";
                myOrdersController.codeController.text="";
                myOrdersController.getMyOrders(context,
                    myOrdersController.orderStatus.value,
                    myOrdersController.filterDate.value,
                    myOrdersController.orderType.value, myOrdersController.codeController.text);
              });
            },
            child: Container(
              padding: EdgeInsetsDirectional.only(top: 1.h,bottom: 1.h,start: 2.h,end: 2.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                    color:isSelected==true&&itemId==3?MyColors.MainPrimary: MyColors.MainBeerus,
                    width: 1.0,
                  ),
                  color:isSelected==true&&itemId==3?MyColors.MainPrimary: Colors.white),
              child: Center(
                child: Text("accepted".tr(),
                  style:  TextStyle(fontSize: 10.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w400,
                      color:isSelected==true&&itemId==3?Colors.white:MyColors.MainBeerus),),
              ),
            ),
          ),
          SizedBox(width: 1.h,),
          GestureDetector(
            onTap: (){
              setState(() {
                isSelected=true;
                itemId=4;
                myOrdersController.orderStatus.value="receipted";
                myOrdersController.filterDate.value="";
                myOrdersController.orderType.value="";
                myOrdersController.codeController.text="";
                myOrdersController.getMyOrders(context,
                    myOrdersController.orderStatus.value,
                    myOrdersController.filterDate.value,
                    myOrdersController.orderType.value, myOrdersController.codeController.text);
              });
            },
            child: Container(
              padding: EdgeInsetsDirectional.only(top: 1.h,bottom: 1.h,start: 2.h,end: 2.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                    color:isSelected==true&&itemId==4?MyColors.MainPrimary: MyColors.MainBeerus,
                    width: 1.0,
                  ),
                  color:isSelected==true&&itemId==4?MyColors.MainPrimary: Colors.white),
              child: Center(
                child: Text("receipted".tr(),
                  style:  TextStyle(fontSize: 10.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w400,
                      color:isSelected==true&&itemId==4?Colors.white:MyColors.MainBeerus),),
              ),
            ),
          ),
          SizedBox(width: 1.h,),
          GestureDetector(
            onTap: (){
              setState(() {
                isSelected=true;
                itemId=5;
                myOrdersController.orderStatus.value="in_progress";
                myOrdersController.filterDate.value="";
                myOrdersController.orderType.value="";
                myOrdersController.codeController.text="";
                myOrdersController.getMyOrders(context,
                    myOrdersController.orderStatus.value,
                    myOrdersController.filterDate.value,
                    myOrdersController.orderType.value, myOrdersController.codeController.text);
              });
            },
            child: Container(
              padding: EdgeInsetsDirectional.only(top: 1.h,bottom: 1.h,start: 2.h,end: 2.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                    color:isSelected==true&&itemId==5?MyColors.MainPrimary: MyColors.MainBeerus,
                    width: 1.0,
                  ),
                  color:isSelected==true&&itemId==5?MyColors.MainPrimary: Colors.white),
              child: Center(
                child: Text("in_progress".tr(),
                  style:  TextStyle(fontSize: 10.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w400,
                      color:isSelected==true&&itemId==5?Colors.white:MyColors.MainBeerus),),
              ),
            ),
          ),
          SizedBox(width: 1.h,),
          GestureDetector(
            onTap: (){
              setState(() {
                isSelected=true;
                itemId=6;
                myOrdersController.orderStatus.value="finished";
                myOrdersController.filterDate.value="";
                myOrdersController.orderType.value="";
                myOrdersController.codeController.text="";
                myOrdersController.getMyOrders(context,
                    myOrdersController.orderStatus.value,
                    myOrdersController.filterDate.value,
                    myOrdersController.orderType.value, myOrdersController.codeController.text);
              });
            },
            child: Container(
              padding: EdgeInsetsDirectional.only(top: 1.h,bottom: 1.h,start: 2.h,end: 2.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                    color: isSelected==true&&itemId==6?MyColors.MainPrimary:MyColors.MainBeerus,
                    width: 1.0,
                  ),
                  color: isSelected==true&&itemId==6?MyColors.MainPrimary:Colors.white),
              child: Center(
                child: Text("finished".tr(),
                  style:  TextStyle(fontSize: 10.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w400,
                      color:isSelected==true&&itemId==6?Colors.white:MyColors.MainBeerus),),
              ),
            ),
          ),
          SizedBox(width: 1.h,),
          GestureDetector(
            onTap: (){
              setState(() {
                isSelected=true;
                itemId=7;
                myOrdersController.orderStatus.value="delivery_in_progress";
                myOrdersController.filterDate.value="";
                myOrdersController.orderType.value="";
                myOrdersController.codeController.text="";
                myOrdersController.getMyOrders(context,
                    myOrdersController.orderStatus.value,
                    myOrdersController.filterDate.value,
                    myOrdersController.orderType.value, myOrdersController.codeController.text);
              });
            },
            child: Container(
              padding: EdgeInsetsDirectional.only(top: 1.h,bottom: 1.h,start: 2.h,end: 2.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                    color: isSelected==true&&itemId==7?MyColors.MainPrimary:MyColors.MainBeerus,
                    width: 1.0,
                  ),
                  color: isSelected==true&&itemId==7?MyColors.MainPrimary:Colors.white),
              child: Center(
                child: Text("delivery_in_progress".tr(),
                  style:  TextStyle(fontSize: 10.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w400,
                      color:isSelected==true&&itemId==7?Colors.white:MyColors.MainBeerus),),
              ),
            ),
          ),
          SizedBox(width: 1.h,),
          GestureDetector(
            onTap: (){
              setState(() {
                isSelected=true;
                itemId=8;
                myOrdersController.orderStatus.value="delivered";
                myOrdersController.filterDate.value="";
                myOrdersController.orderType.value="";
                myOrdersController.codeController.text="";
                myOrdersController.getMyOrders(context,
                    myOrdersController.orderStatus.value,
                    myOrdersController.filterDate.value,
                    myOrdersController.orderType.value, myOrdersController.codeController.text);
              });
            },
            child: Container(
              padding: EdgeInsetsDirectional.only(top: 1.h,bottom: 1.h,start: 2.h,end: 2.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                    color: isSelected==true&&itemId==8?MyColors.MainPrimary:MyColors.MainBeerus,
                    width: 1.0,
                  ),
                  color: isSelected==true&&itemId==8?MyColors.MainPrimary:Colors.white),
              child: Center(
                child: Text("delivered".tr(),
                  style:  TextStyle(fontSize: 10.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w400,
                      color:isSelected==true&&itemId==8?Colors.white:MyColors.MainBeerus),),
              ),
            ),
          ),
          SizedBox(width: 1.h,),
          GestureDetector(
            onTap: (){
              setState(() {
                isSelected=true;
                itemId=9;
                myOrdersController.orderStatus.value="cancelled";
                myOrdersController.filterDate.value="";
                myOrdersController.orderType.value="";
                myOrdersController.codeController.text="";
                myOrdersController.getMyOrders(context,
                    myOrdersController.orderStatus.value,
                    myOrdersController.filterDate.value,
                    myOrdersController.orderType.value, myOrdersController.codeController.text);
              });
            },
            child: Container(
              padding: EdgeInsetsDirectional.only(top: 1.h,bottom: 1.h,start: 2.h,end: 2.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                    color: isSelected==true&&itemId==9?MyColors.MainPrimary:MyColors.MainBeerus,
                    width: 1.0,
                  ),
                  color: isSelected==true&&itemId==9?MyColors.MainPrimary:Colors.white),
              child: Center(
                child: Text("cancelled".tr(),
                  style:  TextStyle(fontSize: 10.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w400,
                      color:isSelected==true&&itemId==9?Colors.white:MyColors.MainBeerus),),
              ),
            ),
          ),
          SizedBox(width: 1.h,),
          GestureDetector(
            onTap: (){
              setState(() {
                isSelected=true;
                itemId=10;
                myOrdersController.orderStatus.value="rejected";
                myOrdersController.filterDate.value="";
                myOrdersController.orderType.value="";
                myOrdersController.codeController.text="";
                myOrdersController.getMyOrders(context,
                    myOrdersController.orderStatus.value,
                    myOrdersController.filterDate.value,
                    myOrdersController.orderType.value, myOrdersController.codeController.text);
              });
            },
            child: Container(
              padding: EdgeInsetsDirectional.only(top: 1.h,bottom: 1.h,start: 2.h,end: 2.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                    color: isSelected==true&&itemId==10?MyColors.MainPrimary:MyColors.MainBeerus,
                    width: 1.0,
                  ),
                  color: isSelected==true&&itemId==10?MyColors.MainPrimary:Colors.white),
              child: Center(
                child: Text("rejected".tr(),
                  style:  TextStyle(fontSize: 10.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w400,
                      color:isSelected==true&&itemId==10?Colors.white:MyColors.MainBeerus),),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget myOrderList() {
    if(myOrdersController.myOrderList.isNotEmpty){
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: myOrdersController.myOrderList.length,
        itemBuilder: (context, int index) {
          return MyOrdersItem(
            status: "sub",
            myOrders: myOrdersController.myOrderList[index],
          );
        }
    );
    }else{
      return empty();
    }
  }

  Widget pleaseLogin(){
    return Container(
      color: MyColors.MainGoku,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsetsDirectional.only(top: 20.h,start: 1.h,end: 1.h),
      //margin: EdgeInsets.only(left: 1.5.h, right: 1.5.h, top: 1.5.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/no_orders.svg'),
            SizedBox(height: 1.h,),
            Text('There_are_no_orders'.tr(),
              style: TextStyle(fontSize: 14.sp,
                  fontFamily: 'alexandria_bold',
                  fontWeight: FontWeight.w600,
                  color: MyColors.MainTrunks),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h,),
            Text('laundry_requests'.tr(),
              style: TextStyle(fontSize: 10.sp,
                  fontFamily: 'alexandria_regular',
                  fontWeight: FontWeight.w300,
                  color: MyColors.MainTrunks),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.5.h,),
            Container(
              margin: EdgeInsetsDirectional.only(start: 1.h, end: 1.h,),
              width: double.infinity,
              height: 7.h,
              child: TextButton(
                style: flatButtonStyle,
                onPressed: () async {
                  Navigator.pushNamed(context, '/login_screen',arguments: "myOrders");
                },
                child: Text(
                  'login'.tr(),
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'regular',
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 1.5.h,),
            /*Container(
              margin: EdgeInsetsDirectional.only(start: 1.h, end: 1.h,),
              width: double.infinity,
              height: 7.h,
              child: TextButton(
                style: flatButtonStyle2,
                onPressed: () async {
                  Navigator.pushNamed(context, '/register_screen',arguments: "myOrder_register");
                },
                child: Text(
                  'signup'.tr(),
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'regular',
                      fontWeight: FontWeight.w500,
                      color:MyColors.MainPrimary),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Widget internet(){
    return Container(
      color: MyColors.MainGoku,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      //padding: EdgeInsetsDirectional.only(top: 20.h,start: 1.h,end: 1.h),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/no_internet.svg'),
              SizedBox(height: 1.h,),
              Text('without_internet_connection'.tr(),
                style: TextStyle(fontSize: 14.sp,
                    fontFamily: 'alexandria_bold',
                    fontWeight: FontWeight.w600,
                    color: MyColors.MainTrunks),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h,),
              Text('reconnecting'.tr(),
                style: TextStyle(fontSize: 10.sp,
                    fontFamily: 'alexandria_regular',
                    fontWeight: FontWeight.w300,
                    color: MyColors.MainTrunks),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.5.h,),
              Container(
                margin: EdgeInsetsDirectional.only(start: 1.h, end: 1.h,),
                width: double.infinity,
                height: 7.h,
                child: TextButton(
                  style: flatButtonStyle,
                  onPressed: () async {
                    await check();
                    print("jkjk"+homeController.currentAddress.toString());
                    myOrdersController.filterDate.value="";
                    myOrdersController.orderType.value="";
                    myOrdersController.codeController.text="";
                    myOrdersController.orderStatus.value="";
                    // ignore: use_build_context_synchronously
                    myOrdersController.getMyOrders(context,
                        myOrdersController.orderStatus.value,
                        myOrdersController.filterDate.value,
                        myOrdersController.orderType.value,
                        myOrdersController.codeController.text);
                  },
                  child: Text(
                    'update'.tr(),
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'regular',
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class empty extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.MainGoku,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsetsDirectional.only(top: 20.h),
      child: Center(
        child: Column(
          children: [
            SvgPicture.asset('assets/no_orders.svg'),
            SizedBox(height: 1.h,),
            Text('There_are_no_orders'.tr(),
              style: TextStyle(fontSize: 14.sp,
                  fontFamily: 'alexandria_bold',
                  fontWeight: FontWeight.w600,
                  color: MyColors.MainTrunks),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h,),
            Text('laundry_requests'.tr(),
              style: TextStyle(fontSize: 10.sp,
                  fontFamily: 'alexandria_regular',
                  fontWeight: FontWeight.w300,
                  color: MyColors.MainTrunks),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

}