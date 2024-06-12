import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

import '../../../business/homeController/HomeController.dart';
import '../../../conustant/my_colors.dart';
import '../buttomSheets/selectPackageSheet/SelectPackageSheet.dart';
import '../orderMethod/order_method_screen.dart';
import 'home/homePopup/home_popUp_screen.dart';
import 'home/home_screen.dart';
import 'more/more_screen.dart';
import 'myOrders/my_orders_screen.dart';


class DrowerPage extends StatefulWidget{
  int? index;
  DrowerPage({this.index});
  @override
  State<StatefulWidget> createState() {
    return _DrowerPage();
  }
}

class _DrowerPage extends State<DrowerPage>{
  final PageStorageBucket bucket=PageStorageBucket();
  int currenttab = 0;
  Widget? currentScreen;
  final homeController = Get.put(HomeController());
  @override
  void initState() {
    super.initState();
    setState(() {
      currenttab=widget.index??currenttab;
      currentScreen=currenttab==2?HomeScreen(): HomeScreen();
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //
    //     Future.delayed(Duration(seconds: 3), () {
    //       if(homeController.popupList.isNotEmpty) {
    //         print("pppoppp");
    //         showDialog<bool>(
    //           context: context,
    //           builder: (_) => HomePopUpScreen(),
    //         );
    //       }
    //     });
    //
    // });

  }
  final List<Widget> screens=[
    HomeScreen(),
    MyOrdersScreen(),
    OrderMethodScreen("drower"),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageStorage(
        bucket: bucket,
        child: currentScreen!,
      ),
      bottomNavigationBar: BottomAppBar(
        height: 10.5.h,
        //notchMargin: 8.0,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        //shape: const CircularNotchedRectangle(),
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                   GestureDetector(
                      onTap: (){
                        setState(() {
                          currentScreen=HomeScreen();
                          currenttab=0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/home.svg',width: 4.h,height: 4.h,
                            color: currenttab==0?MyColors.MainPrimary:MyColors.MainPrimary,
                          ),
                          Text('home'.tr(),style: TextStyle(fontSize: 8.sp,
                              fontFamily: 'alexandria_bold',
                              fontWeight: FontWeight.w400,
                              color:  MyColors.MainPrimary)),
                        ],
                      ),
                    ),
                const SizedBox(width: 20,),
                   GestureDetector(
                      onTap: (){
                        setState(() {
                          currentScreen=MyOrdersScreen();
                          currenttab=1;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/orders.svg',width: 4.h,height: 4.h,
                            color: currenttab==1?MyColors.MainPrimary:MyColors.MainPrimary,
                          ),
                          Text('my_orders'.tr(),style: TextStyle(fontSize: 8.sp,
                              fontFamily: 'alexandria_bold',
                              fontWeight: FontWeight.w400,
                              color:  MyColors.MainPrimary)),
                        ],
                      ),
                    ),
                 //),
              ],),
            FloatingActionButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              onPressed: () {
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
                        child: SelectPackageSheet()));
              },
              backgroundColor: MyColors.MainPrimary,
              clipBehavior: Clip.antiAlias,
              child:  const Icon(Icons.add,color: Colors.white,),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                   GestureDetector(
                      onTap: (){
                        setState(() {
                          currentScreen=OrderMethodScreen("drower");
                          currenttab=2;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/routing.svg',width: 4.h,height: 4.h,
                            color: currenttab==2?MyColors.MainPrimary:MyColors.MainPrimary,
                          ),
                          Text('order_way'.tr(),style: TextStyle(fontSize: 8.sp,
                              fontFamily: 'alexandria_bold',
                              fontWeight: FontWeight.w400,
                              color:  MyColors.MainPrimary)),                          ],
                      ),
                    ),
                 //),
                SizedBox(width: 25,),
                /* Padding(
                   padding:  EdgeInsetsDirectional.only(start: 1.h,end: 2.h),
                   child: */
                   GestureDetector(
                      onTap: (){
                        setState(() {
                          currentScreen=MoreScreen();
                          currenttab=3;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/more.svg',width: 4.h,height:4.h,
                            color: currenttab==3?MyColors.MainPrimary:MyColors.MainPrimary,
                          ),
                          Text('more'.tr(), style:  TextStyle(fontSize: 8.sp,
                              fontFamily: 'alexandria_bold',
                              fontWeight: FontWeight.w400,
                              color:  MyColors.MainPrimary)),                         ],
                      ),
                    ),
                 //),
              ],
            )
          ],
        )//MyColors.BackGroundColor,
      ),
    );
  }

}