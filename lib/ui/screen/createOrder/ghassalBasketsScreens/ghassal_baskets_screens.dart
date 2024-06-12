import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkApms.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTokeniseType.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:ghassal_laundry/conustant/toast_class.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:sizer/sizer.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';

import '../../../../business/addressListController/AddressListController.dart';
import '../../../../business/auth/registerController/RegisterController.dart';
import '../../../../business/dropOffController/DropOffController.dart';
import '../../../../business/ghassalBasketsController/GhassalBasketsController.dart';
import '../../../../business/homeController/HomeController.dart';
import '../../../../conustant/my_colors.dart';
import '../../../widget/basket/selectedBasketsItem/SelectedBasketsItem.dart';
import '../../buttomSheets/authSheets/auth/auth_buttom_sheet.dart';
import '../../buttomSheets/choosePymentSheet/choose_pyment_sheet.dart';
import '../../buttomSheets/dropDownTimeButtomSheet/drop_down_time_buttomSheet.dart';

class GhassalBasketsScreens extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GhassalBasketsScreens();
  }
}

class _GhassalBasketsScreens extends State<GhassalBasketsScreens> {
  final homeController = Get.put(HomeController());
  final _formKey = GlobalKey<FormState>();
  var con = true;
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  final dropOffController = Get.put(DropOffController());
  final ghassalBasketsController = Get.put(GhassalBasketsController());
  final registerController = Get.put(RegisterController());
  final addressListController = Get.put(AddressListController());

  Future<void> check() async {
    final hasInternet = await InternetConnectivity().hasInternetConnection;
    setState(() {
      con = hasInternet;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // clearData();
      check();
      registerController.address2.value = "";
      registerController.address2.value = "";
      ghassalBasketsController.workStreetName.value = "";
      ghassalBasketsController.workAddressId = "";
      ghassalBasketsController.homeStreetName.value = "";
      ghassalBasketsController.homeAddressId = "";
      dropOffController.basketHours = "";
      dropOffController.basketDate = "";
      dropOffController.finalBasketTime.value = "";
      dropOffController.formattedDateBasket = "";
      dropOffController.finalBasketTimeOrder.value = "";
      ghassalBasketsController.payment.value = "";
      ghassalBasketsController.urgentPrice.value = 0;
      if (ghassalBasketsController.sharedPreferencesService
              .getBool("islogin") ==
          true) {
        ghassalBasketsController.getAddressList(context);
      } else {
        ghassalBasketsController.isLoading.value = false;
        ghassalBasketsController.homeAddressId = "";
        ghassalBasketsController.homeStreetName.value = "";
        ghassalBasketsController.workAddressId = "";
        ghassalBasketsController.workStreetName.value = "";
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //bool canPop = await showExitConfirmationDialog(context);

        clearData();
        return true;
      },
      child: con
          ? Obx(() => !ghassalBasketsController.isLoading.value
              ? Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    leading: IconButton(
                        onPressed: () {
                          clearData();
                          Navigator.pop(context);
                        },
                        icon: Transform.rotate(
                            angle: homeController.lang == "en"
                                ? 180 * math.pi / 180
                                : 0,
                            child: SvgPicture.asset(
                              'assets/back.svg',
                            ))),
                    title: Text('ghassal_baskets'.tr(),
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'alexandria_bold',
                            fontWeight: FontWeight.w500,
                            color: MyColors.MainBulma)),
                  ),
                  body: Container(
                    margin: EdgeInsetsDirectional.only(
                        start: 2.h, end: 2.h, top: 1.h),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("customize_baskets".tr(),
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  fontFamily: 'alexandria_bold',
                                  fontWeight: FontWeight.w500,
                                  color: MyColors.MainBulma)),
                          SizedBox(
                            height: 1.h,
                          ),
                          selectedBasketsList(),
                          addBasket(),
                          SizedBox(
                            height: 1.h,
                          ),
                          address(),
                          SizedBox(
                            height: 1.h,
                          ),
                          receivingDate(),
                          SizedBox(
                            height: 1.h,
                          ),
                          coupon(),
                          SizedBox(
                            height: 1.h,
                          ),
                          // payment(),
                          // SizedBox(
                          //   height: 1.h,
                          // ),
                          notes(),
                          SizedBox(
                            height: 2.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                  bottomNavigationBar: Container(
                      color: Colors.white,
                      height: 9.h,
                      margin: EdgeInsetsDirectional.only(bottom: 1.h),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Obx(() => Visibility(
                                      visible: ghassalBasketsController
                                          .isVisable2.value,
                                      child: const CircularProgressIndicator(
                                        color: MyColors.MainPrimary,
                                      ),
                                    )),
                                Obx(() => Visibility(
                                      visible: !ghassalBasketsController
                                          .isVisable2.value,
                                      child: Container(
                                        margin: EdgeInsetsDirectional.only(
                                          start: 1.h,
                                          end: 1.h,
                                        ),
                                        width: double.infinity,
                                        height: 7.h,
                                        child: TextButton(
                                          style: flatButtonStyle,
                                          onPressed: () async {
                                            // Perform your existing logic here
                                            if (ghassalBasketsController
                                                    .sharedPreferencesService
                                                    .getBool("islogin") ==
                                                false) {
                                              showModalBottomSheet<void>(
                                                  isScrollControlled: true,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    20)),
                                                  ),
                                                  context: context,
                                                  backgroundColor: Colors.white,
                                                  builder: (BuildContext
                                                          context) =>
                                                      Padding(
                                                          padding: EdgeInsets.only(
                                                              bottom: MediaQuery
                                                                      .of(
                                                                          context)
                                                                  .viewInsets
                                                                  .bottom),
                                                          child: AuthButtomSheet(
                                                              from: "basket")));
                                            } else {
                                              validation();
                                            }
                                          },
                                          child: Text(
                                            'Confirmation'.tr(),
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontFamily: 'regular',
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 1.h,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("total".tr(),
                                    style: TextStyle(
                                        fontSize: 8.sp,
                                        fontFamily: 'alexandria_medium',
                                        fontWeight: FontWeight.w400,
                                        color: MyColors.MainTrunks)),
                                Text(
                                    "${ghassalBasketsController.totalAfterDiscount.value} ${"currency".tr()}",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: 'alexandria_bold',
                                        fontWeight: FontWeight.w400,
                                        color: MyColors.MainZeno)),
                              ],
                            ),
                          )
                        ],
                      )),
                )
              : const Scaffold(
                  body: Center(
                      child: CircularProgressIndicator(
                    color: MyColors.MainPrimary,
                  )),
                ))
          : Scaffold(
              body: internet(),
            ),
    );
  }

  Widget internet() {
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
              SizedBox(
                height: 1.h,
              ),
              Text(
                'without_internet_connection'.tr(),
                style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'alexandria_bold',
                    fontWeight: FontWeight.w600,
                    color: MyColors.MainTrunks),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                'reconnecting'.tr(),
                style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: 'alexandria_regular',
                    fontWeight: FontWeight.w300,
                    color: MyColors.MainTrunks),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 1.5.h,
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
                    await check();
                    ghassalBasketsController.workStreetName.value = "";
                    ghassalBasketsController.workAddressId = "";
                    ghassalBasketsController.homeStreetName.value = "";
                    ghassalBasketsController.homeAddressId = "";
                    dropOffController.basketHours = "";
                    dropOffController.basketDate = "";
                    dropOffController.finalBasketTime.value = "";
                    dropOffController.formattedDateBasket = "";
                    dropOffController.finalBasketTimeOrder.value = "";
                    ghassalBasketsController.payment.value = "";
                    ghassalBasketsController.urgentPrice.value = 0;
                    if (ghassalBasketsController.sharedPreferencesService
                            .getBool("islogin") ==
                        true) {
                      ghassalBasketsController.getAddressList(context);
                    } else {
                      ghassalBasketsController.isLoading.value = false;
                      ghassalBasketsController.homeAddressId = "";
                      ghassalBasketsController.homeStreetName.value = "";
                      ghassalBasketsController.workAddressId = "";
                      ghassalBasketsController.workStreetName.value = "";
                    }
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

  Widget selectedBasketsList() {
    if (ghassalBasketsController.basketItemSelected.isNotEmpty) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: ghassalBasketsController.basketItemSelected.length,
          itemBuilder: (context, int index) {
            return SelectedBasketsItem(
                selectedBaskets:
                    ghassalBasketsController.basketItemSelected[index]);
          });
    } else {
      return Container();
    }
  }

  Widget addBasket() {
    return GestureDetector(
      onTap: () {
        if (ghassalBasketsController.sharedPreferencesService
                .getBool("islogin") ==
            false) {
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
                  child: AuthButtomSheet(from: "basket")));
        } else {
          Navigator.pushNamed(context, '/select_basket_screens');
        }
      },
      child: Container(
        padding: EdgeInsetsDirectional.all(2.h),
        margin: EdgeInsetsDirectional.only(bottom: 1.h),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(
              color: MyColors.MainGoku,
              width: 1.0,
            ),
            color: MyColors.MainGohan),
        child: Row(
          children: [
            SvgPicture.asset("assets/cart_add.svg"),
            SizedBox(
              width: 1.h,
            ),
            Text("add_another_basket".tr(),
                style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'alexandria_regular',
                    fontWeight: FontWeight.w300,
                    color: MyColors.MainPrimary)),
          ],
        ),
      ),
    );
  }

  Widget address() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("receiving_address".tr(),
            style: TextStyle(
                fontSize: 11.sp,
                fontFamily: 'alexandria_bold',
                fontWeight: FontWeight.w500,
                color: MyColors.MainBulma)),
        SizedBox(
          height: 1.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ghassalBasketsController.addressList.isNotEmpty
                ? Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          clearData();
                          ghassalBasketsController.isSelected = true;
                          ghassalBasketsController.addressType = "home";
                          ghassalBasketsController.itemId = 1;
                          dropOffController.basketHours = "";
                          dropOffController.basketDate = "";
                          dropOffController.finalBasketTime.value = "";
                          ghassalBasketsController.addressId.value =
                              ghassalBasketsController.homeAddressId;
                          registerController.address2.value =
                              ghassalBasketsController.homeStreetName.value;
                          registerController.lat =
                              ghassalBasketsController.homeLat;
                          registerController.lng =
                              ghassalBasketsController.homeLng;
                        });
                      },
                      child: Container(
                        height: 6.h,
                        padding: EdgeInsetsDirectional.all(0.5.h),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            border: Border.all(
                              color:
                                  ghassalBasketsController.isSelected == true &&
                                          ghassalBasketsController.itemId == 1
                                      ? MyColors.MainPrimary
                                      : MyColors.MainSecondary,
                              width: 1.0,
                            ),
                            color:
                                ghassalBasketsController.isSelected == true &&
                                        ghassalBasketsController.itemId == 1
                                    ? MyColors.MainGohan
                                    : Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/home_smile.svg",
                              color:
                                  ghassalBasketsController.isSelected == true &&
                                          ghassalBasketsController.itemId == 1
                                      ? MyColors.MainPrimary
                                      : MyColors.MainSecondary,
                            ),
                            SizedBox(
                              width: 1.h,
                            ),
                            Text("home2".tr(),
                                style: TextStyle(
                                    fontSize: 8.sp,
                                    fontFamily: 'alexandria_medium',
                                    fontWeight: FontWeight.w400,
                                    color: ghassalBasketsController
                                                    .isSelected ==
                                                true &&
                                            ghassalBasketsController.itemId == 1
                                        ? MyColors.MainPrimary
                                        : MyColors.MainSecondary)),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: 0.h,
                  ),
            ghassalBasketsController.addressList.isNotEmpty
                ? SizedBox(
                    width: 1.h,
                  )
                : SizedBox(
                    width: 0.h,
                  ),
            ghassalBasketsController.addressList.isNotEmpty
                ? Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          clearData();
                          ghassalBasketsController.isSelected = true;
                          ghassalBasketsController.addressType = "office";
                          ghassalBasketsController.itemId = 2;
                          dropOffController.basketHours = "";
                          dropOffController.basketDate = "";
                          dropOffController.finalBasketTime.value = "";
                          ghassalBasketsController.addressId.value =
                              ghassalBasketsController.workAddressId;
                          registerController.address2.value =
                              ghassalBasketsController.workStreetName.value;
                          registerController.lat =
                              ghassalBasketsController.workLat;
                          registerController.lng =
                              ghassalBasketsController.workLng;
                        });
                      },
                      child: Container(
                        height: 6.h,
                        padding: EdgeInsetsDirectional.all(0.5.h),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            border: Border.all(
                              color:
                                  ghassalBasketsController.isSelected == true &&
                                          ghassalBasketsController.itemId == 2
                                      ? MyColors.MainPrimary
                                      : MyColors.MainSecondary,
                              width: 1.0,
                            ),
                            color:
                                ghassalBasketsController.isSelected == true &&
                                        ghassalBasketsController.itemId == 2
                                    ? MyColors.MainGohan
                                    : Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/buildings.svg",
                                color: ghassalBasketsController.isSelected ==
                                            true &&
                                        ghassalBasketsController.itemId == 2
                                    ? MyColors.MainPrimary
                                    : MyColors.MainSecondary),
                            SizedBox(
                              width: 1.h,
                            ),
                            Text("office".tr(),
                                style: TextStyle(
                                    fontSize: 8.sp,
                                    fontFamily: 'alexandria_medium',
                                    fontWeight: FontWeight.w400,
                                    color: ghassalBasketsController
                                                    .isSelected ==
                                                true &&
                                            ghassalBasketsController.itemId == 2
                                        ? MyColors.MainPrimary
                                        : MyColors.MainSecondary)),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: 0.h,
                  ),
            ghassalBasketsController.addressList.isNotEmpty
                ? SizedBox(
                    width: 1.h,
                  )
                : SizedBox(
                    width: 0.h,
                  ),
            ghassalBasketsController.addressList.isNotEmpty
                ? Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          clearData();
                          ghassalBasketsController.isSelected = true;
                          ghassalBasketsController.addressType =
                              "another_address";
                          ghassalBasketsController.itemId = 3;
                          dropOffController.basketHours = "";
                          dropOffController.basketDate = "";
                          dropOffController.finalBasketTime.value = "";
                          if (ghassalBasketsController.sharedPreferencesService
                                  .getBool("islogin") ==
                              false) {
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
                                    child: AuthButtomSheet(from: "basket")));
                          } else {
                            Navigator.pushNamed(context, "/location_screen",
                                arguments: "listAddress");
                            //ghassalBasketsController.addressId.value=addressListController.addressId.value;
                          }
                        });
                      },
                      child: Container(
                        height: 6.h,
                        padding: EdgeInsetsDirectional.all(0.5.h),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            border: Border.all(
                              color:
                                  ghassalBasketsController.isSelected == true &&
                                          ghassalBasketsController.itemId == 3
                                      ? MyColors.MainPrimary
                                      : MyColors.MainSecondary,
                              width: 1.0,
                            ),
                            color:
                                ghassalBasketsController.isSelected == true &&
                                        ghassalBasketsController.itemId == 3
                                    ? MyColors.MainGohan
                                    : Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/map0.svg",
                              color:
                                  ghassalBasketsController.isSelected == true &&
                                          ghassalBasketsController.itemId == 3
                                      ? MyColors.MainPrimary
                                      : MyColors.MainSecondary,
                            ),
                            SizedBox(
                              width: 1.h,
                            ),
                            Expanded(
                              child: Text("another_address".tr(),
                                  style: TextStyle(
                                      fontSize: 8.sp,
                                      fontFamily: 'alexandria_medium',
                                      fontWeight: FontWeight.w400,
                                      color: ghassalBasketsController
                                                      .isSelected ==
                                                  true &&
                                              ghassalBasketsController.itemId ==
                                                  3
                                          ? MyColors.MainPrimary
                                          : MyColors.MainSecondary)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        clearData();
                        ghassalBasketsController.isSelected = true;
                        ghassalBasketsController.addressType =
                            "another_address";
                        ghassalBasketsController.itemId = 3;
                        dropOffController.basketHours = "";
                        dropOffController.basketDate = "";
                        dropOffController.finalBasketTime.value = "";
                        if (ghassalBasketsController.sharedPreferencesService
                                .getBool("islogin") ==
                            false) {
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
                                  child: AuthButtomSheet(from: "basket")));
                        } else {
                          Navigator.pushNamed(context, "/location_screen",
                              arguments: "listAddress");
                          //ghassalBasketsController.addressId.value=addressListController.addressId.value;
                        }
                      });
                    },
                    child: Container(
                      height: 6.h,
                      width: 15.h,
                      padding: EdgeInsetsDirectional.all(0.5.h),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          border: Border.all(
                            color:
                                ghassalBasketsController.isSelected == true &&
                                        ghassalBasketsController.itemId == 3
                                    ? MyColors.MainPrimary
                                    : MyColors.MainSecondary,
                            width: 1.0,
                          ),
                          color: ghassalBasketsController.isSelected == true &&
                                  ghassalBasketsController.itemId == 3
                              ? MyColors.MainGohan
                              : Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/map0.svg",
                            color:
                                ghassalBasketsController.isSelected == true &&
                                        ghassalBasketsController.itemId == 3
                                    ? MyColors.MainPrimary
                                    : MyColors.MainSecondary,
                          ),
                          SizedBox(
                            width: 1.h,
                          ),
                          Expanded(
                            child: Text("another_address".tr(),
                                style: TextStyle(
                                    fontSize: 8.sp,
                                    fontFamily: 'alexandria_medium',
                                    fontWeight: FontWeight.w400,
                                    color: ghassalBasketsController
                                                    .isSelected ==
                                                true &&
                                            ghassalBasketsController.itemId == 3
                                        ? MyColors.MainPrimary
                                        : MyColors.MainSecondary)),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
        SizedBox(
          height: 1.h,
        ),
        Row(
          children: [
            SvgPicture.asset(
              'assets/location2.svg',
              width: 2.h,
              height: 2.h,
            ),
            SizedBox(
              width: 2.w,
            ),
            SizedBox(
                width: 30.h,
                child: Obx(
                  () => registerController.address2.value != ""
                      ? Text(
                          registerController.address2.value.toString(),
                          style: TextStyle(
                              fontSize: 8.sp,
                              fontFamily: 'alexandria_regular',
                              fontWeight: FontWeight.w300,
                              color: MyColors.MainTrunks),
                          maxLines: 2,
                        )
                      : Text(
                          'add_delivery_location'.tr(),
                          style: TextStyle(
                              fontSize: 8.sp,
                              fontFamily: 'alexandria_regular',
                              fontWeight: FontWeight.w300,
                              color: MyColors.MainTrunks),
                          maxLines: 2,
                        ),
                )),
          ],
        ),
      ],
    );
  }

  Widget receivingDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("receiving_date".tr(),
            style: TextStyle(
                fontSize: 11.sp,
                fontFamily: 'alexandria_bold',
                fontWeight: FontWeight.w500,
                color: MyColors.MainBulma)),
        SizedBox(
          height: 1.h,
        ),
        GestureDetector(
          onTap: () {
            if (registerController.address2.value != "") {
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          dropDownTimeButtomSheet(
                            from: "baskets",
                          ),
                        ],
                      )));
            } else {
              Fluttertoast.showToast(
                  msg: "please_select_address".tr(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
              );
            }
          },
          child: Container(
            padding: EdgeInsetsDirectional.all(1.h),
            margin: EdgeInsetsDirectional.only(bottom: 1.h),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                  color: MyColors.MainGoku,
                  width: 1,
                ),
                color: Colors.white),
            child: Row(
              children: [
                SvgPicture.asset("assets/calendar.svg"),
                SizedBox(
                  width: 1.h,
                ),
                SizedBox(
                  width: 32.h,
                  child: Obx(() => dropOffController.finalBasketTime.value != ""
                      ? Text(dropOffController.finalBasketTime.value,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'alexandria_regular',
                              fontWeight: FontWeight.w300,
                              color: MyColors.MainTrunks))
                      : Text('select_date'.tr(),
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'alexandria_regular',
                              fontWeight: FontWeight.w300,
                              color: MyColors.MainTrunks))),
                ),
                const Spacer(),
                Transform.rotate(
                    angle:
                        homeController.lang == "en" ? 180 * math.pi / 180 : 0,
                    child: SvgPicture.asset(
                      'assets/alt_arrow.svg',
                    ))
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsetsDirectional.all(1.5.h),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              border: Border.all(
                color: MyColors.MainGoku,
                width: 1.0,
              ),
              color: MyColors.MainGoku),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset("assets/truck.svg"),
                      SizedBox(
                        width: 1.h,
                      ),
                      Text("express_access_service".tr(),
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'alexandria_medium',
                              fontWeight: FontWeight.w300,
                              color: MyColors.MainBulma)),
                      Container(
                        padding: EdgeInsetsDirectional.all(0.5.h),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            border: Border.all(
                              color: MyColors.MainBeerus,
                              width: 1.0,
                            ),
                            color: MyColors.MainBeerus),
                        child: Text(
                            "${ghassalBasketsController.urgentPriceTxt.value} ${"currency".tr()}",
                            style: TextStyle(
                                fontSize: 6.sp,
                                fontFamily: 'alexandria_regular',
                                fontWeight: FontWeight.w400,
                                color: MyColors.MainTrunks)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  SizedBox(
                    width: 30.h,
                    child: Text("representative".tr(),
                        style: TextStyle(
                            fontSize: 8.sp,
                            fontFamily: 'alexandria_regular',
                            fontWeight: FontWeight.w300,
                            color: MyColors.MainTrunks)),
                  ),
                ],
              ),
              Row(
                children: [
                  Obx(() => Visibility(
                      visible: ghassalBasketsController.isUrgent.value,
                      child: const CircularProgressIndicator(
                        color: MyColors.MainPrimary,
                      ))),
                  Obx(() => ghassalBasketsController.isUrgent.value == true
                      ? Container()
                      : CupertinoSwitch(
                          value: ghassalBasketsController.lights,
                          activeColor: MyColors.MainPrimary,
                          onChanged: (bool value) {
                            setState(() {
                              ghassalBasketsController.lights = value;
                              if (value == true) {
                                ghassalBasketsController.orderType.value =
                                    "urgent";
                                ghassalBasketsController.isUrgent.value = true;
                                ghassalBasketsController.getUrgentPrice("");
                                ghassalBasketsController.calculateTotalPrice();
                              } else {
                                ghassalBasketsController.orderType.value =
                                    "normal";
                                ghassalBasketsController.urgentPrice.value = 0;
                                ghassalBasketsController.calculateTotalPrice();
                              }
                            });
                          })),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget coupon() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("discount_code".tr(),
              style: TextStyle(
                  fontSize: 11.sp,
                  fontFamily: 'alexandria_bold',
                  fontWeight: FontWeight.w500,
                  color: MyColors.MainBulma)),
          SizedBox(
            height: 1.h,
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Obx(() => Visibility(
                        visible: ghassalBasketsController.isVisable.value,
                        child: const CircularProgressIndicator(
                          color: MyColors.MainPrimary,
                        ))),
                    Obx(
                          () => ghassalBasketsController.isVisable.value == true
                          ? Container()
                          : Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 7.h,
                          child: TextButton(
                            style: flatButtonStyle,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ghassalBasketsController.isVisable.value =
                                true;
                                ghassalBasketsController
                                    .validateCoupon(context);
                              }
                            },
                            child: Text(
                              'use'.tr(),
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: 'alexandria_extraBold',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
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
                        color: MyColors.MainGoku,
                        width: 1.0,
                      ),
                      color: MyColors.MainGoku),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: ghassalBasketsController.codeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_code'.tr();
                      }
                      return null;
                    },
                    maxLines: 1,
                    decoration: InputDecoration(
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                            color: Colors.red, style: BorderStyle.solid),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                            color: MyColors.MainBeerus,
                            style: BorderStyle.solid),
                      ),
                      fillColor: Colors.green,
                      focusColor: Colors.green,
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: MyColors.MainBeerus,
                          )),
                      focusedErrorBorder: const OutlineInputBorder(
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

  Widget payment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("payment_methods".tr(),
            style: TextStyle(
                fontSize: 11.sp,
                fontFamily: 'alexandria_bold',
                fontWeight: FontWeight.w500,
                color: MyColors.MainBulma)),
        SizedBox(
          height: 1.h,
        ),
        GestureDetector(
          onTap: () {
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ChoosePyment(from: "basket"),
                      ],
                    )));
          },
          child: Container(
            padding: EdgeInsetsDirectional.all(1.5.h),
            margin: EdgeInsetsDirectional.only(bottom: 1.h),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                  color: MyColors.MainGoku,
                  width: 1,
                ),
                color: Colors.white),
            child: Row(
              children: [
                //SvgPicture.asset("assets/mastercard.svg"),
                //SizedBox(width: 1.h,),
                Text("choose_payment_method".tr(),
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'alexandria_regular',
                        fontWeight: FontWeight.w400,
                        color: MyColors.MainTrunks)),
                const Spacer(),
                Text(ghassalBasketsController.payment.value,
                    style: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: 'alexandria_medium',
                        fontWeight: FontWeight.w500,
                        color: MyColors.MainSecondary)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget notes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("notes".tr(),
            style: TextStyle(
                fontSize: 11.sp,
                fontFamily: 'alexandria_bold',
                fontWeight: FontWeight.w500,
                color: MyColors.MainBulma)),
        SizedBox(
          height: 1.h,
        ),
        Container(
          height: 15.h,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              border: Border.all(
                color: MyColors.MainGoku,
                width: 1.0,
              ),
              color: Colors.white),
          child: TextFormField(
            maxLines: 4,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: ghassalBasketsController.noteController,
            decoration: InputDecoration(
              errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide:
                    BorderSide(color: Colors.red, style: BorderStyle.solid),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(
                    color: MyColors.MainGoku, style: BorderStyle.solid),
              ),
              focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    style: BorderStyle.solid,
                    color: MyColors.MainGoku,
                  )),
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide:
                    BorderSide(color: Colors.red, style: BorderStyle.solid),
              ),
              hintText: 'write'.tr(),
              hintStyle: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'lexend_regular',
                  fontWeight: FontWeight.w400,
                  color: MyColors.MainTrunks),
            ),
            style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'alexandria_regular',
                fontWeight: FontWeight.w400,
                color: MyColors.MainZeno),
          ),
        )
      ],
    );
  }

  clearData() {
    setState(() {
      dropOffController.basketHours = "";
      dropOffController.basketDate = "";
      dropOffController.finalBasketTime.value = "";
      ghassalBasketsController.codeController.clear();
      ghassalBasketsController.noteController.clear();
      ghassalBasketsController.isSelected = false;
      ghassalBasketsController.addressType = "";
      ghassalBasketsController.itemId = -1;
      ghassalBasketsController.totalAfterDiscount.value = 0.0;
      ghassalBasketsController.totalPrice.value = 0;
      ghassalBasketsController.codeController.clear();
      ghassalBasketsController.lights = false;
      ghassalBasketsController.selectedProductList.clear();
      ghassalBasketsController.basketItemSelected.clear();
      ghassalBasketsController.deliveryCost.value = 0;
      ghassalBasketsController.payment.value = "";
    });
  }

  void validation() {
    if (ghassalBasketsController.addressId == null ||
        registerController.address2.value == "") {
      Fluttertoast.showToast(
          msg: "please_select_address".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
      );
    } else if (dropOffController.finalBasketTime.value == "") {
      Fluttertoast.showToast(
          msg: "please_select_date_and_time_first".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
      );
    } else if (ghassalBasketsController.basketItemSelected.isEmpty) {
      Fluttertoast.showToast(
          msg: "please_select_basket_first".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
      );
    }
    // else if (ghassalBasketsController.payment.value == "") {
    //   ToastClass.showCustomToast(
    //       context, "please_choose_payment".tr(), "error");
    // }
    else {
      /*ghassalBasketsController.isVisable2.value = true;
      if (ghassalBasketsController.payment.value == "tabby") {
        ghassalBasketsController
            .createOrder(context, dropOffController.finalBasketTimeOrder.value)
            .then((_) {
          if (ghassalBasketsController.createOrderResponse.value.success ==
              true) {
            createSession();
          }
        });
      }
      else if (ghassalBasketsController.payment.value == "cash") {
        ghassalBasketsController.isVisable2.value = true;
        ghassalBasketsController
            .createOrder(context, dropOffController.finalBasketTimeOrder.value)
            .then((_) {
          if (ghassalBasketsController.createOrderResponse.value.success ==
              true) {
            ghassalBasketsController.updateOrderStatus(context, "pending", "");
          }
        });
      }*/
      //else if (ghassalBasketsController.payment.value == "payTaps") {
      ghassalBasketsController.isVisable2.value = true;
      ghassalBasketsController
          .createOrder(context, dropOffController.finalBasketTimeOrder.value)
          .then((_) {
        if (ghassalBasketsController.createOrderResponse.value.success ==
            true) {
          ghassalBasketsController.isVisable2.value = false;
          payPressed();
          // ghassalBasketsController.updateOrderStatusPayTaps(context, "pending", "").then((_) {
          //   if (ghassalBasketsController.updateStatusResponse.value.success == true) {
          //     ghassalBasketsController.isVisable2.value = false;
          //     payPressed();
          //   } else {
          //     ghassalBasketsController.isVisable2.value = false;
          //     ToastClass.showCustomToast(
          //         context,
          //         ghassalBasketsController
          //                 .updateStatusResponse.value.message ??
          //             "",
          //         "error");
          //   }
          // });
        }
      });
      //}
    }
  }

  ////////////////tabby/////////////////////////////
  void _setStatus(String newStatus) {
    setState(() {
      ghassalBasketsController.status = newStatus;
    });
  }

  Future<void> createSession() async {
    try {
      _setStatus('pending');
      final s = await TabbySDK().createSession(TabbyCheckoutPayload(
        merchantCode: 'SAR',
        payment: Payment(
          amount: ghassalBasketsController.totalAfterDiscount.value.toString(),
          currency: Currency.sar,
          buyer: Buyer(
            email: '',
            phone: '',
            name: '',
            dob: '2019-08-24',
          ),
          buyerHistory: BuyerHistory(
            loyaltyLevel: 0,
            registeredSince: '2019-08-24T14:15:22Z',
            wishlistCount: 0,
          ),
          shippingAddress: const ShippingAddress(
            city: 'string',
            address: 'string',
            zip: 'string',
          ),
          order: Order(referenceId: 'id123', items: [
            OrderItem(
              title: 'Jersey',
              description: 'Jersey',
              quantity: 1,
              unitPrice: '10.00',
              referenceId: 'uuid',
              productUrl: 'http://example.com',
              category: 'clothes',
            )
          ]),
          orderHistory: [
            OrderHistoryItem(
              purchasedAt: '2019-08-24T14:15:22Z',
              amount: '10.00',
              paymentMethod: OrderHistoryItemPaymentMethod.card,
              status: OrderHistoryItemStatus.newOne,
            )
          ],
        ),
        lang: Lang.ar,
      ));

      debugPrint('Session id: ${s.sessionId}');

      setState(() {
        ghassalBasketsController.session = s;
      });
      _setStatus('created');
      openInAppBrowser();
    } catch (e, s) {
      printError(e, s);
      _setStatus('error');
    }
  }

  void openInAppBrowser() {
    TabbyWebView.showWebView(
      context: context,
      webUrl: ghassalBasketsController
          .session!.availableProducts.installments!.webUrl,
      onResult: (WebViewResult resultCode) {
        print("nammmmmme " + resultCode.name);
        if (resultCode.name == "CAPTURED" || resultCode.name == "authorized") {
          ghassalBasketsController.updateOrderStatus(context, "pending", "");
        } else {
          ghassalBasketsController.isVisable2.value = false;
          clearData();
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: resultCode.name,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red);
        }
      },
    );
  }

////////////////////////////////////////////////////

/////////payTaps//////
  PaymentSdkConfigurationDetails generateConfig() {
    var billingDetails = BillingDetails(
        // (ghassalBasketsController.sharedPreferencesService.getString("fullName")==null
        //     ||ghassalBasketsController.sharedPreferencesService.getString("fullName")=="null"
        //     ||ghassalBasketsController.sharedPreferencesService.getString("fullName")=="")?
        // "ghassal":ghassalBasketsController.sharedPreferencesService.getString("fullName"),
        // (ghassalBasketsController.sharedPreferencesService.getString("email")==null
        //     ||ghassalBasketsController.sharedPreferencesService.getString("email")=="null"
        //     ||ghassalBasketsController.sharedPreferencesService.getString("email")=="")?
        // "ghassal@gmail.com":ghassalBasketsController.sharedPreferencesService.getString("email"),
        "ghassal app",
        "ghassal@gmail.com",
        "+97311111111",
        "address",
        "ae",
        "Dubai",
        "Dubai",
        "12345");
    var shippingDetails = ShippingDetails(
        "ghassal app",
        "ghassal@gmail.com",
        "+97311111111",
        // ghassalBasketsController.sharedPreferencesService.getString("fullName")??"trio",
        // ghassalBasketsController.sharedPreferencesService.getString("email")??"trio@gmail",
        // ghassalBasketsController.sharedPreferencesService.getString("phone_number")??"+97311111111",
        "address",
        "ae",
        "Dubai",
        "Dubai",
        "12345");
    List<PaymentSdkAPms> apms = [];
    apms.add(PaymentSdkAPms.AMAN);
    final configuration = PaymentSdkConfigurationDetails(
        profileId: "110736",
        serverKey: "S6JNJ2T9H9-JJGRK6ML9G-2TNNTTLMNL",
        clientKey: "C6KMRB-6N2Q66-TRKGNB-7BGPB2",
        cartId: "12433",
        cartDescription: "Flowers",
        merchantName: "Flowers Store",
        screentTitle: "Pay with Card",
        amount: double.parse(
            ghassalBasketsController.totalAfterDiscount.toString()),
        showBillingInfo: false,
        forceShippingInfo: false,
        currencyCode: "SAR",
        merchantCountryCode: "SA",
        billingDetails: billingDetails,
        shippingDetails: shippingDetails,
        alternativePaymentMethods: apms,
        linkBillingNameWithCardHolderName: true);
    configuration.tokeniseType = PaymentSdkTokeniseType.MERCHANT_MANDATORY;
    return configuration;
  }

  Future<void> payPressed() async {
    FlutterPaytabsBridge.startCardPayment(generateConfig(), (event) {
      setState(() {
        if (event["status"] == "success") {
          var transactionDetails = event["data"];
          print(transactionDetails);
          if (transactionDetails["isSuccess"]) {
            ghassalBasketsController.updateOrderStatusPayTaps(
                context, "pending", "");
            ghassalBasketsController
                .updatePaymentStatus(
                    context, "paid", transactionDetails["transactionReference"])
                .then((_) {
              if (ghassalBasketsController.updateStatusResponse.value.success ==
                  true) {
                clearData();
                ghassalBasketsController.onAlertButtonsPressed(context);
              }
            });
            if (transactionDetails["isPending"]) {
              print("transaction pending");
            }
          } else {
            ghassalBasketsController
                .updatePaymentStatus(context, "unpaid",
                    transactionDetails["transactionReference"])
                .then((_) {
              if (ghassalBasketsController.updateStatusResponse.value.success ==
                  true) {
                clearData();
                ghassalBasketsController.onAlertButtonsFailer(context);
              }
            });
          }
        } else if (event["status"] == "error") {
          ghassalBasketsController.isVisable2.value = false;
          Fluttertoast.showToast(
              msg: "Error in Transaction",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red);
          // Handle error here.
        } else if (event["status"] == "event") {
          print("eventttttttt");
          // Handle events here.
        }
      });
    });
  }
}
