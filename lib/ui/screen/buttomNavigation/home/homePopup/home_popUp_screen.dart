import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../../business/auth/registerController/RegisterController.dart';
import '../../../../../business/homeController/HomeController.dart';
import '../../../../../conustant/my_colors.dart';

class HomePopUpScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomePopUpScreen();
  }
}

class _HomePopUpScreen extends State<HomePopUpScreen>{
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Obx(() => !homeController.isLoading.value?
            GestureDetector(
              onTap: (){
                if(homeController.homeResponse.value.data?.advertising?[0].clickAction=="basket"){
                  Navigator.pushNamed(context, '/ghassal_baskets_screens');
                }else if(homeController.homeResponse.value.data?.advertising?[0].clickAction=="subscription"){
                  Navigator.pushNamed(context, '/ghassal_subscription_screens');
                }else if(homeController.homeResponse.value.data?.advertising?[0].clickAction=="product"){
                  Navigator.pushNamed(context, '/ghassal_upon_request_screens');
                }
              },
              child: Container(
                height: 50.h,
                width: 42.h,
                decoration:  BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    image: DecorationImage(image: NetworkImage((homeController.popUpImg.value)??""),fit: BoxFit.fill)),
              ),
            )
                :SizedBox(height: 50.h, width: 42.h,)),
            Positioned(
                top: 15,
                //left: 15,
                child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Padding(
                        padding: EdgeInsetsDirectional.only(start: 1.5.h,end: 1.5.h),
                        child: SvgPicture.asset('assets/close.svg',))))
          ],
        ),
      ),
    );
  }

}