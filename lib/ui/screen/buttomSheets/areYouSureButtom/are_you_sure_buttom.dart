import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';

import '../../../../business/auth/registerController/RegisterController.dart';
import '../../../../business/dropOffController/DropOffController.dart';
import '../../../../business/ghassalUpOnRequestController/GhassalUpOnRequestController.dart';
import '../../../../conustant/my_colors.dart';

class AreYouSureButtom extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _AreYouSureButtom();
  }
}

class _AreYouSureButtom extends State<AreYouSureButtom>{
  final dropOffController = Get.put(DropOffController());
  final ghassalUpOnRequestController = Get.put(GhassalUpOnRequestController());
  final registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: SvgPicture.asset('assets/delete2.svg',width: 70,height: 70,),
          ),
          const SizedBox(height: 10,),
          Text('change_address'.tr(),
            style: TextStyle(fontSize: 16.sp,
                fontFamily: 'alexandria_regular',
                fontWeight: FontWeight.w800,
                color: MyColors.MainBulma),
            textAlign: TextAlign.center,),
          const SizedBox(height: 10,),
          Text('are_you_sure_you_want_to_change_location'.tr(),
            style: TextStyle(fontSize: 10.sp,
                fontFamily: 'alexandria_regular',
                fontWeight: FontWeight.w400,
                color: MyColors.MainTrunks),
            textAlign: TextAlign.center,),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: DialogButton(
                  radius: BorderRadius.circular(15),
                  height: 7.h,
                  onPressed: () {
                    clearData();
                    Navigator.pop(context);
                  },
                  color: MyColors.MainPrimary,
                  child: Text('delete'.tr(), style:  TextStyle(fontSize: 12.sp,
                      fontFamily: 'alexandria_regular',
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
                ),
              )
            ],
          ),
          SizedBox(height: 2.h,),
        ],
      ),
    );
  }

  clearData(){
    dropOffController.upOnRequestHours="";
    dropOffController.upOnRequestDate="";
    dropOffController.finalupOnRequestTime.value="";
    ghassalUpOnRequestController.codeController.clear();
    ghassalUpOnRequestController.noteController.clear();
    ghassalUpOnRequestController.isSelected=false;
    ghassalUpOnRequestController.addressType="";
    ghassalUpOnRequestController.itemId=-1;
    // registerController.address2.value="";
    ghassalUpOnRequestController.prefernceJson.value="";
    ghassalUpOnRequestController.productsJson.value="";
    ghassalUpOnRequestController.cartItem.clear();
    ghassalUpOnRequestController.preferencesItem.clear();
    ghassalUpOnRequestController.itemPrices.clear();
    ghassalUpOnRequestController.itemPrices2.clear();
    ghassalUpOnRequestController.totalPrice.value=0;
    ghassalUpOnRequestController.totalAfterDiscount.value=0.0;
    ghassalUpOnRequestController.lights=false;
    ghassalUpOnRequestController.urgentPrice.value=0;
    ghassalUpOnRequestController.deliveryCost.value=0;
    ghassalUpOnRequestController.payment.value="";
  }

}