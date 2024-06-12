import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:ghassal_laundry/ui/screen/buttomSheets/selectPackageSheet/SelectPackageSheet.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../../../business/homeController/HomeController.dart';
import '../../../business/orderMethodController/OrderMethodController.dart';
import '../../../conustant/my_colors.dart';
import '../buttomSheets/authSheets/auth/auth_buttom_sheet.dart';

class OrderMethodScreen extends StatefulWidget {
  var from;

  OrderMethodScreen(this.from);

  @override
  State<StatefulWidget> createState() {
    return _OrderMethodScreen();
  }
}

class _OrderMethodScreen extends State<OrderMethodScreen> {
  final homeController = Get.put(HomeController());
  late VideoPlayerController videoPlayerController;
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  final orderMethodController = Get.put(OrderMethodController());

  @override
  void initState() {
    super.initState();
    orderMethodController.getVideo().then((_) {
      Uri videoUri =
          Uri.parse(orderMethodController.videoResponse.value.image ?? "");
      videoPlayerController = VideoPlayerController.networkUrl(videoUri)
        ..initialize().then((value) {
          setState(() {
            videoPlayerController.play();
          });
        });
    });
  }

  /*VideoPlayerController.asset('assets/video/laundry.mp4')..initialize().then((value) {
      setState(() {
        videoPlayerController.play();
      });
    });*/
  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.from != "drower"
          ? AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Transform.rotate(
                      angle:
                          homeController.lang == "en" ? 180 * math.pi / 180 : 0,
                      child: SvgPicture.asset(
                        'assets/back.svg',
                      ))),
              title: Text('order_method'.tr(),
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'alexandria_bold',
                      fontWeight: FontWeight.w500,
                      color: MyColors.MainBulma)),
            )
          : AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: Text('order_method'.tr(),
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'alexandria_bold',
                      fontWeight: FontWeight.w500,
                      color: MyColors.MainBulma)),
            ),
      body: SafeArea(
        child: Obx(() => !orderMethodController.isLoading.value
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.only(left: 1.5.h, right: 1.5.h, top: 1.5.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      videoPlayerController.value.isInitialized
                          ? SizedBox(
                              width: double.infinity,
                              height: 25.h,
                              child: AspectRatio(
                                aspectRatio:
                                    videoPlayerController.value.aspectRatio,
                                child: VideoPlayer(videoPlayerController),
                              ))
                          : SizedBox(
                              height: 25.h,
                              child: const Center(
                                  child: CircularProgressIndicator())),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text('goodbye_cleaning'.tr(),
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'alexandria_bold',
                              fontWeight: FontWeight.w600,
                              color: MyColors.MainBulma)),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //SvgPicture.asset('assets/scroll.svg',height: 55.h,),
                          Image.asset("assets/scroll.png", height: 50.h),
                          SizedBox(
                            width: 1.5.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 2.h,
                              ),
                              Text('service_request'.tr(),
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily: 'alexandria_bold',
                                      fontWeight: FontWeight.w500,
                                      color: MyColors.MainBulma)),
                              SizedBox(
                                height: 1.h,
                              ),
                              SizedBox(
                                width: 37.h,
                                child: Text('simply_choose'.tr(),
                                    style: TextStyle(
                                        fontSize: 8.sp,
                                        fontFamily: 'alexandria_regular',
                                        fontWeight: FontWeight.w300,
                                        color: MyColors.MainTrunks)),
                              ),
                              homeController.lang == "ar"
                                  ? SizedBox(
                                      height: 7.h,
                                    )
                                  : SizedBox(
                                      height: 3.5.h,
                                    ),
                              Text('prepare_clothes'.tr(),
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily: 'alexandria_bold',
                                      fontWeight: FontWeight.w500,
                                      color: MyColors.MainBulma)),
                              SizedBox(
                                height: 1.h,
                              ),
                              SizedBox(
                                width: 37.h,
                                child: Text('have_clothes'.tr(),
                                    style: TextStyle(
                                        fontSize: 8.sp,
                                        fontFamily: 'alexandria_regular',
                                        fontWeight: FontWeight.w300,
                                        color: MyColors.MainTrunks)),
                              ),
                              homeController.lang == "ar"
                                  ? SizedBox(
                                      height: 5.h,
                                    )
                                  : SizedBox(
                                      height: 3.h,
                                    ),
                              Text('receiving_clothes'.tr(),
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily: 'alexandria_bold',
                                      fontWeight: FontWeight.w500,
                                      color: MyColors.MainBulma)),
                              SizedBox(
                                height: 1.h,
                              ),
                              SizedBox(
                                width: 37.h,
                                child: Text('washer_representative'.tr(),
                                    style: TextStyle(
                                        fontSize: 8.sp,
                                        fontFamily: 'alexandria_regular',
                                        fontWeight: FontWeight.w300,
                                        color: MyColors.MainTrunks)),
                              ),
                              homeController.lang == "ar"
                                  ? SizedBox(
                                      height: 4.h,
                                    )
                                  : SizedBox(
                                      height: 3.h,
                                    ),
                              Text('special_cleaning_trip'.tr(),
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily: 'alexandria_bold',
                                      fontWeight: FontWeight.w500,
                                      color: MyColors.MainBulma)),
                              SizedBox(
                                height: 1.h,
                              ),
                              SizedBox(
                                width: 37.h,
                                child: Text('clothes_transported'.tr(),
                                    style: TextStyle(
                                        fontSize: 8.sp,
                                        fontFamily: 'alexandria_regular',
                                        fontWeight: FontWeight.w300,
                                        color: MyColors.MainTrunks)),
                              ),
                              homeController.lang == "ar"
                                  ? SizedBox(
                                      height: 4.5.h,
                                    )
                                  : SizedBox(
                                      height: 2.h,
                                    ),
                              Text('hand_over_clean_clothes'.tr(),
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily: 'alexandria_bold',
                                      fontWeight: FontWeight.w500,
                                      color: MyColors.MainBulma)),
                              SizedBox(
                                height: 1.h,
                              ),
                              SizedBox(
                                width: 37.h,
                                child: Text('appointed_time'.tr(),
                                    style: TextStyle(
                                        fontSize: 8.sp,
                                        fontFamily: 'alexandria_regular',
                                        fontWeight: FontWeight.w300,
                                        color: MyColors.MainTrunks)),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                            ],
                          ),
                        ],
                      ),
                      widget.from == "drower"
                          ? SizedBox(
                              height: 9.h,
                            )
                          : SizedBox(
                              height: 2.h,
                            ),
                    ],
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                color: MyColors.MainPrimary,
              ))),
      ),
      bottomSheet: widget.from == "drower"
          ? Padding(
              padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 4.h),
              child: Container(
                width: double.infinity,
                height: 7.h,
                child: TextButton(
                  style: flatButtonStyle,
                  onPressed: () async {
                    if (orderMethodController.sharedPreferencesService
                            .getBool("islogin") ==
                        false) {
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
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: AuthButtomSheet(
                                from: "orderMethod",
                              )));
                    } else {
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
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: SelectPackageSheet()));
                    }
                  },
                  child: Text(
                    orderMethodController.sharedPreferencesService
                                .getBool("islogin") ==
                            false
                        ? 'login'.tr()
                        : 'confirm'.tr(),
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'regular',
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
            )
          : Container(
              height: 0.5.h,
            ),
      bottomNavigationBar: Container(
        margin: EdgeInsetsDirectional.only(start: 1.h, end: 1.h, bottom: 4.h),
        width: double.infinity,
        height: 7.h,
        child: TextButton(
          style: flatButtonStyle,
          onPressed: () async {
            if (orderMethodController.sharedPreferencesService
                    .getBool("islogin") ==
                false) {
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
                      child: AuthButtomSheet(
                        from: "orderMethod",
                      )));
            } else {
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
                      child: SelectPackageSheet()));
            }
          },
          child: Text(
            orderMethodController.sharedPreferencesService.getBool("islogin") ==
                    false
                ? 'login'.tr()
                : 'confirm'.tr(),
            style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'regular',
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
