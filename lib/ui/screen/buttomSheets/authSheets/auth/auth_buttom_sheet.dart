import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

import '../../../../../conustant/my_colors.dart';
import '../loginSheet/login_buttom_sheet.dart';

class AuthButtomSheet extends StatefulWidget {
  var from;

  AuthButtomSheet({required this.from});

  @override
  State<StatefulWidget> createState() {
    return _AuthButtomSheet();
  }
}

class _AuthButtomSheet extends State<AuthButtomSheet> {
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(right: 1.5.h, left: 1.5.h, top: 1.h, bottom: 2.h),
      child: SingleChildScrollView(
          child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomBar(),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              width: double.infinity,
              height: 8.h,
              child: TextButton(
                style: flatButtonStyle,
                onPressed: () {
                  Navigator.pop(context);
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
                          child: LoginButtomSheet(from: widget.from)));
                },
                child: Text(
                  'login'.tr(),
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'alexandria_bold',
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            /*SizedBox(
                  width: double.infinity,
                  height: 8.h,
                  child: TextButton(
                    style: flatButtonStyle,
                    onPressed: () {
                      Navigator.pop(context);
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
                              child: RegisterButtomSheet(from: widget.from,)));
                    },
                    child: Text('signup'.tr(),
                      style:  TextStyle(fontSize: 12.sp,
                          fontFamily: 'alexandria_bold',
                          fontWeight: FontWeight.w500,
                          color: Colors.white),),
                  ),
                )*/
          ],
        ),
      )),
    );
  }

  Widget CustomBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 3.h,
        ),
        Text(
          "login".tr(),
          style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'alexandria_bold',
              fontWeight: FontWeight.w600,
              color: MyColors.MainBulma),
        ),
        SizedBox(
          height: 1.h,
        ),
        Row(
          children: [
            SvgPicture.asset('assets/info_circle.svg'),
            SizedBox(
              width: 1.h,
            ),
            Text(
              "please_login".tr(),
              style: TextStyle(
                  fontSize: 8.sp,
                  fontFamily: 'alexandria_regular',
                  fontWeight: FontWeight.w300,
                  color: MyColors.MainTrunks),
            ),
          ],
        ),
        SizedBox(
          height: 1.h,
        ),
      ],
    );
  }
}
