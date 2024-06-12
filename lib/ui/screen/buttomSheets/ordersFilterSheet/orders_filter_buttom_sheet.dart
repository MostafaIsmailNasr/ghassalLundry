import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

import '../../../../business/myOrdersController/MyOrdersController.dart';
import '../../../../conustant/my_colors.dart';

class OrdersFilterButtomSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OrdersFilterButtomSheet();
  }
}

class _OrdersFilterButtomSheet extends State<OrdersFilterButtomSheet> {
  var isSelected = false;
  var itemId = 0;

  var isSelected2 = false;
  var itemId2 = 0;
  var type = "";

  final _formKey = GlobalKey<FormState>();
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));

  DateTime? selectedDateTime;
  final myOrdersController = Get.put(MyOrdersController());

  @override
  void initState() {
    selectedData();
    super.initState();
  }

  selectedData() {
    if (myOrdersController.filterDate.value == "today") {
      isSelected = true;
      itemId = 1;
    } else if (myOrdersController.filterDate.value == "tommorow") {
      isSelected = true;
      itemId = 2;
    }
    if (myOrdersController.time.value == "times") {
      isSelected = true;
      itemId = 3;
    }
    if (myOrdersController.orderType.value == "subscriptions") {
      isSelected2 = true;
      itemId2 = 2;
    } else if (myOrdersController.orderType.value == "upon_request") {
      isSelected2 = true;
      itemId2 = 3;
    } else if (myOrdersController.orderType.value == "baskets") {
      isSelected2 = true;
      itemId2 = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 1.h, left: 1.h, top: 1.h, bottom: 2.h),
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomBar(),
              Text(
                "date".tr(),
                style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'alexandria_medium',
                    fontWeight: FontWeight.w300,
                    color: MyColors.MainBulma),
              ),
              SizedBox(
                height: 1.h,
              ),
              date(),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "order_type".tr(),
                style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'alexandria_medium',
                    fontWeight: FontWeight.w300,
                    color: MyColors.MainBulma),
              ),
              SizedBox(
                height: 1.h,
              ),
              orderType(),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "order_code".tr(),
                style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'alexandria_medium',
                    fontWeight: FontWeight.w300,
                    color: MyColors.MainBulma),
              ),
              SizedBox(
                height: 1.h,
              ),
              orderCode(),
              SizedBox(
                height: 1.h,
              ),
              Container(
                margin: EdgeInsetsDirectional.only(
                  start: 1.h,
                  end: 1.h,
                ),
                width: double.infinity,
                height: 7.h,
                child: TextButton(
                  style: flatButtonStyle,
                  onPressed: () async {
                    if (myOrdersController.filterDate.value != "" ||
                        myOrdersController.orderType.value != "" ||
                        myOrdersController.codeController.text != "") {
                      myOrdersController.getMyOrders(
                          context,
                          myOrdersController.orderStatus.value,
                          myOrdersController.filterDate.value,
                          myOrdersController.orderType.value,
                          myOrdersController.codeController.text);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'search'.tr(),
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

  Widget CustomBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 3.h,
        ),
        Text(
          "filter_requests".tr(),
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
              "specify_search".tr(),
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

  Widget date() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isSelected = true;
                itemId = 1;
                myOrdersController.filterDate.value = "today";
                myOrdersController.time.value = "";
              });
            },
            child: Container(
              height: 6.h,
              padding: EdgeInsetsDirectional.all(1.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                    color: isSelected == true && itemId == 1
                        ? MyColors.MainPrimary
                        : MyColors.MainBeerus,
                    width: 2.0,
                  ),
                  color: isSelected == true && itemId == 1
                      ? MyColors.timeBack
                      : MyColors.MainGoku),
              child: Center(
                child: Text(
                  "today".tr(),
                  style: TextStyle(
                      fontSize: 8.sp,
                      fontFamily: 'alexandria_regular',
                      fontWeight: FontWeight.w400,
                      color: MyColors.MainTrunks),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 1.h,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isSelected = true;
                itemId = 2;
                myOrdersController.filterDate.value = "tommorow";
                myOrdersController.time.value = "";
              });
            },
            child: Container(
              height: 6.h,
              padding: EdgeInsetsDirectional.all(1.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                    color: isSelected == true && itemId == 2
                        ? MyColors.MainPrimary
                        : MyColors.MainBeerus,
                    width: 2.0,
                  ),
                  color: isSelected == true && itemId == 2
                      ? MyColors.timeBack
                      : MyColors.MainGoku),
              child: Center(
                child: Text(
                  "tomorrow".tr(),
                  style: TextStyle(
                      fontSize: 8.sp,
                      fontFamily: 'alexandria_regular',
                      fontWeight: FontWeight.w400,
                      color: MyColors.MainTrunks),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 1.h,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isSelected = true;
                itemId = 3;
                myOrdersController.time.value = "times";
                pickTime(context);
              });
            },
            child: Container(
              height: 6.h,
              padding: EdgeInsetsDirectional.all(1.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                    color: isSelected == true && itemId == 3
                        ? MyColors.MainPrimary
                        : MyColors.MainBeerus,
                    width: 2.0,
                  ),
                  color: isSelected == true && itemId == 3
                      ? MyColors.timeBack
                      : MyColors.MainGoku),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/calendar2.svg'),
                  SizedBox(
                    width: 1.h,
                  ),
                  Text(
                    "select_date2".tr(),
                    style: TextStyle(
                        fontSize: 8.sp,
                        fontFamily: 'alexandria_regular',
                        fontWeight: FontWeight.w400,
                        color: MyColors.MainTrunks),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget orderType() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isSelected2 = true;
                myOrdersController.orderType.value = "baskets";
                itemId2 = 1;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 10.h,
              padding: EdgeInsetsDirectional.all(1.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                    color: isSelected2 == true && itemId2 == 1
                        ? MyColors.MainPrimary
                        : MyColors.MainBeerus,
                    width: 2.0,
                  ),
                  color: isSelected2 == true && itemId2 == 1
                      ? MyColors.timeBack
                      : MyColors.MainGoku),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: SvgPicture.asset(
                    'assets/cart5.svg',
                    color: MyColors.MainTrunks,
                  )),
                  SizedBox(
                    height: 1.h,
                  ),
                  Center(
                    child: Text(
                      'baskets'.tr(),
                      style: TextStyle(
                          fontSize: 8.sp,
                          fontFamily: 'alexandria_medium',
                          fontWeight: FontWeight.w400,
                          color: MyColors.MainTrunks),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 1.h,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isSelected2 = true;
                myOrdersController.orderType.value = "subscriptions";
                itemId2 = 2;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 10.h,
              padding: EdgeInsetsDirectional.all(1.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                    color: isSelected2 == true && itemId2 == 2
                        ? MyColors.MainPrimary
                        : MyColors.MainBeerus,
                    width: 2.0,
                  ),
                  color: isSelected2 == true && itemId2 == 2
                      ? MyColors.timeBack
                      : MyColors.MainGoku),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: SvgPicture.asset(
                    'assets/crown.svg',
                    color: MyColors.MainTrunks,
                  )),
                  SizedBox(
                    height: 1.h,
                  ),
                  Center(
                    child: Text(
                      'subscriptions'.tr(),
                      style: TextStyle(
                          fontSize: 8.sp,
                          fontFamily: 'alexandria_medium',
                          fontWeight: FontWeight.w400,
                          color: MyColors.MainTrunks),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 1.h,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isSelected2 = true;
                myOrdersController.orderType.value = "upon_request";
                itemId2 = 3;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 10.h,
              padding: EdgeInsetsDirectional.all(1.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                    color: isSelected2 == true && itemId2 == 3
                        ? MyColors.MainPrimary
                        : MyColors.MainBeerus,
                    width: 2.0,
                  ),
                  color: isSelected2 == true && itemId2 == 3
                      ? MyColors.timeBack
                      : MyColors.MainGoku),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: SvgPicture.asset(
                    'assets/t_shirt.svg',
                    color: MyColors.MainTrunks,
                  )),
                  SizedBox(
                    height: 1.h,
                  ),
                  Center(
                    child: Text(
                      'upon_request'.tr(),
                      style: TextStyle(
                          fontSize: 8.sp,
                          fontFamily: 'alexandria_medium',
                          fontWeight: FontWeight.w400,
                          color: MyColors.MainTrunks),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget orderCode() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 7.h,
                  child: TextButton(
                    style: flatButtonStyle,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        myOrdersController.getMyOrders(
                            context,
                            myOrdersController.orderStatus.value,
                            myOrdersController.filterDate.value,
                            myOrdersController.orderType.value,
                            myOrdersController.codeController.text);
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'confirm'.tr(),
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'alexandria_extraBold',
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 1.h,
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                        color: MyColors.MainBeerus,
                        width: 1.0,
                      ),
                      color: MyColors.MainGoku),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: myOrdersController.codeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_code'.tr();
                      }
                      return null;
                    },
                    maxLines: 1,
                    decoration: const InputDecoration(
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                            color: Colors.red, style: BorderStyle.solid),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                            color: MyColors.MainBeerus,
                            style: BorderStyle.solid),
                      ),
                      fillColor: Colors.green,
                      focusColor: Colors.green,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: MyColors.MainBeerus,
                          )),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                            color: Colors.red, style: BorderStyle.solid),
                      ),
                    ),
                    style: TextStyle(
                        fontSize: 11.sp,
                        fontFamily: 'alexandria_regular',
                        fontWeight: FontWeight.w300,
                        color: MyColors.MainTrunks),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> pickTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: MyColors.MainPrimary, // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: MyColors.MainPrimary, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: MyColors.MainPrimary, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
        );

        final dateFormat = DateFormat('yyyy-MM-dd');
        final formattedDate = dateFormat.format(selectedDateTime!);

        final dateTimeString = '$formattedDate ';
        myOrdersController.filterDate.value = dateTimeString;
        //addPayloadController.upT = dateTimeString;
        print(dateTimeString);
      });
    }
  }
}
