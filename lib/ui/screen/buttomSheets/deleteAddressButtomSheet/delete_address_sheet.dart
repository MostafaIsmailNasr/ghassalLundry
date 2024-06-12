import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';
import '../../../../../conustant/my_colors.dart';
import '../../../../business/addressListController/AddressListController.dart';

class DeleteAddressSheet extends StatefulWidget{
  int id;

  DeleteAddressSheet({required this.id});

  @override
  State<StatefulWidget> createState() {
    return _DeleteAddressSheet();
  }
}

class _DeleteAddressSheet extends State<DeleteAddressSheet>{
  final addressListController=Get.put(AddressListController());
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
          Text('delete_location'.tr(),
            style: TextStyle(fontSize: 16.sp,
                fontFamily: 'alexandria_regular',
                fontWeight: FontWeight.w800,
                color: MyColors.MainBulma),
            textAlign: TextAlign.center,),
          const SizedBox(height: 10,),
          Text('are_you_sure_you_want_to_delete_location'.tr(),
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
                  onPressed: () => {
                    addressListController.deleteAddress(widget.id, context)
                  },
                  color: MyColors.MainPrimary,
                  child: Text('delete'.tr(), style:  TextStyle(fontSize: 12.sp,
                      fontFamily: 'alexandria_regular',
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
                ),
              ),
              Expanded(
                  child: DialogButton(
                    height: 7.h,
                    radius: BorderRadius.circular(15),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: MyColors.MainPrimary,
                    child: Text('cancel'.tr(), style:  TextStyle(fontSize: 12.sp,
                        fontFamily: 'alexandria_regular',
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),

                  )
              )
            ],
          ),
          SizedBox(height: 2.h,),
        ],
      ),
    );
  }

}