import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:ghassal_laundry/conustant/toast_class.dart';
import 'package:ghassal_laundry/data/model/preferencesModel/PreferencesResponse.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

import '../../../../../business/auth/registerController/RegisterController.dart';
import '../../../../../business/ghassalBasketsController/GhassalBasketsController.dart';
import '../../../../../conustant/my_colors.dart';
import '../../../../../data/model/basketModel/BasketListResponse.dart';
import '../../../../../data/model/selectedBasketModel/SelectedBasketModel.dart';

class SelectBasketScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectBasketScreen();
  }
}

class _SelectBasketScreen extends State<SelectBasketScreen> {
  var selectedFlage = 0;
  var isSelected = true;
  int? itemId = 1;
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  final ghassalBasketsController = Get.put(GhassalBasketsController());
  final registerController = Get.put(RegisterController());
  int prefprice = 0;
  var clickAction = "add";
  var qul = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      clearData();

      ghassalBasketsController.getBasketsList(
          registerController.lat.toString(), registerController.lng.toString());
      //baskets=ghassalBasketsController.basketList[0];
      //preferences=ghassalBasketsController.preferencesList[0];
    });
  }

  var indexx = 0;
  Baskets? baskets;
  Preferences? preferences;

  void clearData() {
    setState(() {
      ghassalBasketsController.basketItem.clear();
      //ghassalBasketsController.itemPrices.clear();
      //ghassalBasketsController.itemPrices2.clear();
      ghassalBasketsController.productsJson.value = "";
      ghassalBasketsController.preferencesItem.clear();
      ghassalBasketsController.itemIroningId.value = 1;
      ghassalBasketsController.isIroningSelected.value = true;
      //ghassalBasketsController.totalPrice.value=0;
      //ghassalBasketsController.totalAfterDiscount.value=0.0;
      ghassalBasketsController.selectedProductList.clear();
    });
  }

  void clearData2() {
    setState(() {
      ghassalBasketsController.basketItem.clear();
      //ghassalBasketsController.itemPrices.clear();
      //ghassalBasketsController.itemPrices2.clear();
      ghassalBasketsController.productsJson.value = "";
      ghassalBasketsController.preferencesItem.clear();
      //ghassalBasketsController.totalPrice.value=0;
      //ghassalBasketsController.totalAfterDiscount.value=0.0;
      ghassalBasketsController.preferencesList.forEach((item) {
        item.isChecked = false;
      });
      ghassalBasketsController.selectedProductList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => !ghassalBasketsController.isLoading.value
        ? Scaffold(
            backgroundColor: MyColors.BGColor,
            body: SafeArea(
              child:
                  ghassalBasketsController.basketListResponse.value.success ==
                          true
                      ? Container(
                          margin: EdgeInsetsDirectional.only(
                              start: 2.h, end: 2.h, top: 2.h),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customBar(),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Text("number_baskets".tr(),
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontFamily: 'alexandria_bold',
                                        fontWeight: FontWeight.w500,
                                        color: MyColors.MainBulma)),
                                SizedBox(
                                  height: 1.h,
                                ),
                                basketsList(),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Text("ironing_baskets".tr(),
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontFamily: 'alexandria_bold',
                                        fontWeight: FontWeight.w500,
                                        color: MyColors.MainBulma)),
                                SizedBox(
                                  height: 1.h,
                                ),
                                ironingBaskets(),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Text("preferences".tr(),
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontFamily: 'alexandria_bold',
                                        fontWeight: FontWeight.w500,
                                        color: MyColors.MainBulma)),
                                SizedBox(
                                  height: 1.h,
                                ),
                                preferencesList()
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                          ghassalBasketsController
                                  .basketListResponse.value.message ??
                              "",
                          style: TextStyle(
                              color: MyColors.MainBulma,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp),
                        )),
            ),
            bottomNavigationBar: Container(
                color: Colors.white,
                margin: EdgeInsetsDirectional.all(1.h),
                height: 9.h,
                child: Container(
                  margin: EdgeInsetsDirectional.only(
                      start: 1.h, end: 1.h, bottom: 2.h),
                  width: double.infinity,
                  height: 7.h,
                  child: TextButton(
                    style: flatButtonStyle,
                    onPressed: () async {
                      if (qul != 0) {
                        if (clickAction == "add") {
                          calculatePlus(indexx, qul);
                          ghassalBasketsController.productsJson2.value =
                              ghassalBasketsController.convertBasketListToJson2(
                                  ghassalBasketsController.basketItemSelected);
                          print("Updated JSON2: " +
                              ghassalBasketsController.productsJson2.value);

                          Navigator.pop(context);
                        } else {
                          calculatePlus(indexx, qul);
                          Navigator.pop(context);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "please_select_basket_first".tr(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
                        );
                      }
                    },
                    child: Text(
                      'confirm'.tr(),
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'regular',
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                )),
          )
        : const Scaffold(
            body: Center(
                child: CircularProgressIndicator(
            color: MyColors.MainPrimary,
          ))));
  }

  Widget customBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("customize_baskets".tr(),
            style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'alexandria_bold',
                fontWeight: FontWeight.w500,
                color: MyColors.MainBulma)),
        GestureDetector(
          onTap: () {
            clearData();
            Navigator.pop(context);
          },
          child: SvgPicture.asset('assets/close_circle2.svg'),
        ),
      ],
    );
  }

  Widget basketsList() {
    if (ghassalBasketsController.basketList.isNotEmpty) {
      return SizedBox(
        height: 25.h,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: ghassalBasketsController.basketList.length,
            itemBuilder: (context, int index) {
              return
                  /*BasketsItem(
                is_selected: selectedFlage==index,
                onTap: () {
                  setState(() {
                    if(selectedFlage==index) {
                      return;
                    }else{
                      selectedFlage=index;
                      clearData();
                      ghassalBasketsController.preferencesList.forEach((item) {
                        item.isChecked = false;
                      });
                    }

                  });
                },
                 baskets: ghassalBasketsController.basketList[index]
              );*/
                  Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedFlage == index) {
                          return;
                        } else {
                          selectedFlage = index;
                          qul = 1;
                          indexx = index;
                          clearData();
                          ghassalBasketsController.preferencesList
                              .forEach((item) {
                            item.isChecked = false;
                          });
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsetsDirectional.only(end: 1.h, bottom: 1.h),
                      padding: EdgeInsetsDirectional.all(1.5.h),
                      height: 19.h,
                      width: 21.h,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          border: Border.all(
                            color: selectedFlage == index
                                ? MyColors.MainPrimary
                                : MyColors.MainGoku,
                            width: selectedFlage == index ? 2.0 : 1.0,
                          ),
                          color: selectedFlage == index
                              ? MyColors.Back
                              : MyColors.MainGoku),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            ghassalBasketsController.basketList[index].image ??
                                "",
                            width: 7.h,
                            height: 6.h,
                            fit: BoxFit.fill,
                          ),
                          /*SizedBox(height: 1.h,),
                            Text("information_about_package".tr(),
                                style:  TextStyle(fontSize: 8.sp,
                                    fontFamily: 'alexandria_regular',
                                    fontWeight: FontWeight.w300,
                                    color:MyColors.MainTrunks)),*/
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                              ghassalBasketsController
                                      .basketList[index].title ??
                                  "",
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  fontFamily: 'alexandria_medium',
                                  fontWeight: FontWeight.w500,
                                  color: MyColors.MainTrunks)),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                              ghassalBasketsController
                                              .isIroningSelected.value ==
                                          true &&
                                      ghassalBasketsController
                                              .itemIroningId.value ==
                                          1
                                  ? "${ghassalBasketsController.basketList[index].priceWash.toString() ?? "0"} ${'currency'.tr()}"
                                  : "${ghassalBasketsController.basketList[index].priceIroning.toString() ?? "0"} ${'currency'.tr()}",
                              style: TextStyle(
                                  fontSize: 8.sp,
                                  fontFamily: 'alexandria_regular',
                                  fontWeight: FontWeight.w400,
                                  color: MyColors.MainPrimary)),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: selectedFlage == index,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              indexx = index;
                              qul = qul + 1;
                              print("mk " + (qul).toString());
                              clickAction = "add";
                            });
                          },
                          child: Container(
                            padding: EdgeInsetsDirectional.only(
                                start: 2.h, end: 2.h),
                            height: 5.h,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                border: Border.all(
                                  color: MyColors.MainPrimary,
                                  width: 1.0,
                                ),
                                color: MyColors.MainPrimary),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 4.h,
                        ),
                        Text(qul.toString(),
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: 'alexandria_bold',
                                fontWeight: FontWeight.w700,
                                color: MyColors.counterColor)),
                        SizedBox(
                          width: 4.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              indexx = index;
                              if (qul >= 1) {
                                qul = qul -
                                    1; //ghassalBasketsController.basketList[index].quantity++;
                                print("mk " + qul.toString());
                                clickAction = "mines";
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsetsDirectional.only(
                                start: 2.h, end: 2.h),
                            height: 5.h,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                border: Border.all(
                                  color: MyColors.MainGoku,
                                  width: 1.0,
                                ),
                                color: MyColors.MainGoku),
                            child: Center(
                              child: SvgPicture.asset("assets/mines.svg"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
      );
    } else {
      return Container();
    }
  }

  void calculatePlus(int index, int qul) {
    setState(() {
      int existingIndex = ghassalBasketsController.basketItem.indexWhere(
          (item) => item.id == ghassalBasketsController.basketList[index].id);
      ghassalBasketsController.isIroningSelected.value == true &&
              ghassalBasketsController.itemIroningId.value == 1
          ? ghassalBasketsController.itemPrices
              .add((ghassalBasketsController.basketList[index].priceWash ?? 0))
          : ghassalBasketsController.itemPrices.add(
              (ghassalBasketsController.basketList[index].priceIroning ?? 0));
      ghassalBasketsController.quantityList.value++;
      ghassalBasketsController.discount.value = 0.0;
      ghassalBasketsController.CopunID = null;

      if (existingIndex != -1) {
        // Product ID exists in the list, increment its quantity
        var existingProduct =
            ghassalBasketsController.basketItem[existingIndex];
        if (existingProduct.quantity != null) {
          int uniqueId = DateTime.now().millisecondsSinceEpoch;
          var updatedQuantity = qul;
          //existingProduct.quantity! + 1; // Increment quantity if not null
          if (ghassalBasketsController.itemPrices2
              .containsKey(ghassalBasketsController.basketList[index].id)) {
            ghassalBasketsController.itemPrices2[ghassalBasketsController
                .basketList[index].id!] = (ghassalBasketsController.itemPrices2[
                        ghassalBasketsController.basketList[index].id] ??
                    0) +
                1;
          } else {
            ghassalBasketsController.itemPrices2[
                ghassalBasketsController.basketList[index].id!] = 1;
          }
          if (ghassalBasketsController.isIroningSelected.value == true &&
              ghassalBasketsController.itemIroningId.value == 1) {
            if (ghassalBasketsController.preferencesItem.isNotEmpty) {
              List<Prefrences> preferencesList = [];
              ghassalBasketsController.preferencesItem.forEach((pref) {
                preferencesList.add(Prefrences(
                  id: pref.id,
                  price: pref.price,
                ));
              });
              var updatedWashType = 0;
              //existingProduct.washType=0;
              ghassalBasketsController.basketItem[existingIndex] = Baskets(
                  Uniqid: uniqueId,
                  id: existingProduct.id,
                  priceWash: existingProduct.priceWash,
                  priceIroning: existingProduct.priceIroning,
                  quantity: updatedQuantity,
                  title: existingProduct.title,
                  washType: updatedWashType,
                  preferences2: preferencesList);

              //selected
              ghassalBasketsController.basketItemSelected[existingIndex] =
                  Baskets(
                      Uniqid: uniqueId,
                      id: existingProduct.id,
                      priceWash: existingProduct.priceWash,
                      priceIroning: existingProduct.priceIroning,
                      quantity: updatedQuantity,
                      title: existingProduct.title,
                      washType: updatedWashType,
                      preferences2: preferencesList);
            } else {
              var updatedWashType = 0;
              //existingProduct.washType=0;
              ghassalBasketsController.basketItem[existingIndex] = Baskets(
                  Uniqid: uniqueId,
                  id: existingProduct.id,
                  priceWash: existingProduct.priceWash,
                  priceIroning: existingProduct.priceIroning,
                  quantity: updatedQuantity,
                  title: existingProduct.title,
                  washType: updatedWashType,
                  preferences2: []);

              //selected
              ghassalBasketsController.basketItemSelected[existingIndex] =
                  Baskets(
                      Uniqid: uniqueId,
                      id: existingProduct.id,
                      priceWash: existingProduct.priceWash,
                      priceIroning: existingProduct.priceIroning,
                      quantity: updatedQuantity,
                      title: existingProduct.title,
                      washType: updatedWashType,
                      preferences2: []);
            }
          } else {
            if (ghassalBasketsController.preferencesItem.isNotEmpty) {
              List<Prefrences> preferencesList = [];
              ghassalBasketsController.preferencesItem.forEach((pref) {
                preferencesList.add(Prefrences(
                  id: pref.id,
                  price: pref.price,
                ));
              });
              var updatedWashType = 1;
              //existingProduct.washType=0;
              ghassalBasketsController.basketItem[existingIndex] = Baskets(
                  Uniqid: uniqueId,
                  id: existingProduct.id,
                  priceWash: existingProduct.priceWash,
                  priceIroning: existingProduct.priceIroning,
                  quantity: updatedQuantity,
                  title: existingProduct.title,
                  washType: updatedWashType,
                  preferences2: preferencesList);

              //selected
              ghassalBasketsController.basketItemSelected[existingIndex] =
                  Baskets(
                      Uniqid: uniqueId,
                      id: existingProduct.id,
                      priceWash: existingProduct.priceWash,
                      priceIroning: existingProduct.priceIroning,
                      quantity: updatedQuantity,
                      title: existingProduct.title,
                      washType: updatedWashType,
                      preferences2: preferencesList);
            } else {
              var updatedWashType = 1;
              //existingProduct.washType=0;
              ghassalBasketsController.basketItem[existingIndex] = Baskets(
                  Uniqid: uniqueId,
                  id: existingProduct.id,
                  priceWash: existingProduct.priceWash,
                  priceIroning: existingProduct.priceIroning,
                  quantity: updatedQuantity,
                  title: existingProduct.title,
                  washType: updatedWashType,
                  preferences2: []);

              //selected
              ghassalBasketsController.basketItemSelected[existingIndex] =
                  Baskets(
                      Uniqid: uniqueId,
                      id: existingProduct.id,
                      priceWash: existingProduct.priceWash,
                      priceIroning: existingProduct.priceIroning,
                      quantity: updatedQuantity,
                      title: existingProduct.title,
                      washType: updatedWashType,
                      preferences2: []);
            }
          }
        }
      } else {
        int uniqueId = DateTime.now().millisecondsSinceEpoch;
        if (ghassalBasketsController.itemPrices2
            .containsKey(ghassalBasketsController.basketList[index].id)) {
          ghassalBasketsController
                  .itemPrices2[ghassalBasketsController.basketList[index].id!] =
              (ghassalBasketsController.itemPrices2[
                          ghassalBasketsController.basketList[index].id] ??
                      0) +
                  1;
        } else {
          ghassalBasketsController
              .itemPrices2[ghassalBasketsController.basketList[index].id!] = 1;
        }

        if (ghassalBasketsController.isIroningSelected.value == true &&
            ghassalBasketsController.itemIroningId.value == 1) {
          if (ghassalBasketsController.preferencesItem.isNotEmpty) {
            List<Prefrences> preferencesList = [];
            ghassalBasketsController.preferencesItem.forEach((pref) {
              preferencesList.add(Prefrences(
                id: pref.id,
                price: pref.price,
              ));
            });
            var updatedWashType = 0;
            //existingProduct.washType=0;
            ghassalBasketsController.basketItem.add(
              Baskets(
                  Uniqid: uniqueId,
                  id: ghassalBasketsController.basketList[index].id,
                  priceWash:
                      ghassalBasketsController.basketList[index].priceWash,
                  priceIroning:
                      ghassalBasketsController.basketList[index].priceIroning,
                  quantity: qul,
                  title: ghassalBasketsController.basketList[index].title,
                  washType: updatedWashType,
                  preferences2: preferencesList),
            );

            //selected
            ghassalBasketsController.basketItemSelected.add(
              Baskets(
                  Uniqid: uniqueId,
                  id: ghassalBasketsController.basketList[index].id,
                  priceWash:
                      ghassalBasketsController.basketList[index].priceWash,
                  priceIroning:
                      ghassalBasketsController.basketList[index].priceIroning,
                  quantity: qul,
                  title: ghassalBasketsController.basketList[index].title,
                  washType: updatedWashType,
                  preferences2: preferencesList),
            );
          } else {
            var updatedWashType = 0;
            //existingProduct.washType=0;
            ghassalBasketsController.basketItem.add(
              Baskets(
                  Uniqid: uniqueId,
                  id: ghassalBasketsController.basketList[index].id,
                  priceWash:
                      ghassalBasketsController.basketList[index].priceWash,
                  priceIroning:
                      ghassalBasketsController.basketList[index].priceIroning,
                  quantity: qul,
                  title: ghassalBasketsController.basketList[index].title,
                  washType: updatedWashType,
                  preferences2: []),
            );

            //selected
            ghassalBasketsController.basketItemSelected.add(
              Baskets(
                  Uniqid: uniqueId,
                  id: ghassalBasketsController.basketList[index].id,
                  priceWash:
                      ghassalBasketsController.basketList[index].priceWash,
                  priceIroning:
                      ghassalBasketsController.basketList[index].priceIroning,
                  quantity: qul,
                  title: ghassalBasketsController.basketList[index].title,
                  washType: updatedWashType,
                  preferences2: []),
            );
          }
        } else {
          if (ghassalBasketsController.preferencesItem.isNotEmpty) {
            List<Prefrences> preferencesList = [];
            ghassalBasketsController.preferencesItem.forEach((pref) {
              preferencesList.add(Prefrences(
                id: pref.id,
                price: pref.price,
              ));
            });
            var updatedWashType = 1;
            //existingProduct.washType=0;
            ghassalBasketsController.basketItem.add(
              Baskets(
                  Uniqid: uniqueId,
                  id: ghassalBasketsController.basketList[index].id,
                  priceWash:
                      ghassalBasketsController.basketList[index].priceWash,
                  priceIroning:
                      ghassalBasketsController.basketList[index].priceIroning,
                  quantity: qul,
                  title: ghassalBasketsController.basketList[index].title,
                  washType: updatedWashType,
                  preferences2: preferencesList),
            );

            //selected
            ghassalBasketsController.basketItemSelected.add(
              Baskets(
                  Uniqid: uniqueId,
                  id: ghassalBasketsController.basketList[index].id,
                  priceWash:
                      ghassalBasketsController.basketList[index].priceWash,
                  priceIroning:
                      ghassalBasketsController.basketList[index].priceIroning,
                  quantity: qul,
                  title: ghassalBasketsController.basketList[index].title,
                  washType: updatedWashType,
                  preferences2: preferencesList),
            );
          } else {
            var updatedWashType = 1;
            //existingProduct.washType=0;
            ghassalBasketsController.basketItem.add(
              Baskets(
                  Uniqid: uniqueId,
                  id: ghassalBasketsController.basketList[index].id,
                  priceWash:
                      ghassalBasketsController.basketList[index].priceWash,
                  priceIroning:
                      ghassalBasketsController.basketList[index].priceIroning,
                  quantity: 1,
                  title: ghassalBasketsController.basketList[index].title,
                  washType: updatedWashType,
                  preferences2: []),
            );

            //selected
            ghassalBasketsController.basketItemSelected.add(
              Baskets(
                  Uniqid: uniqueId,
                  id: ghassalBasketsController.basketList[index].id,
                  priceWash:
                      ghassalBasketsController.basketList[index].priceWash,
                  priceIroning:
                      ghassalBasketsController.basketList[index].priceIroning,
                  quantity: 1,
                  title: ghassalBasketsController.basketList[index].title,
                  washType: updatedWashType,
                  preferences2: []),
            );
          }
        }
      }

      ghassalBasketsController.calculateTotalPrice();

      //ghassalBasketsController.calculateTotalPrice(0);

      // Update the JSON representation of the products
      ghassalBasketsController.productsJson.value = ghassalBasketsController
          .convertBasketListToJson(ghassalBasketsController.basketItem);
      print("Updated JSON1: " + ghassalBasketsController.productsJson.value);
    });
  }

  Widget ironingBaskets() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                ghassalBasketsController.isIroningSelected.value = true;
                ghassalBasketsController.itemIroningId.value = 1;
                clearData2();
              });
            },
            child: Container(
              padding: EdgeInsetsDirectional.all(2.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                    color: ghassalBasketsController.isIroningSelected.value ==
                                true &&
                            ghassalBasketsController.itemIroningId.value == 1
                        ? MyColors.MainPrimary
                        : MyColors.MainGoku,
                    width: ghassalBasketsController.isIroningSelected.value ==
                                true &&
                            ghassalBasketsController.itemIroningId.value == 1
                        ? 2.0
                        : 1.0,
                  ),
                  color: Colors.white),
              child: Row(
                children: [
                  ghassalBasketsController.isIroningSelected.value == true &&
                          ghassalBasketsController.itemIroningId.value == 1
                      ? SvgPicture.asset('assets/radio_selected.svg')
                      : SvgPicture.asset('assets/radio_button.svg'),
                  SizedBox(
                    width: 1.h,
                  ),
                  Expanded(
                    child: Text("washing_ironing".tr(),
                        style: TextStyle(
                            fontSize: 8.sp,
                            fontFamily: 'alexandria_medium',
                            fontWeight: FontWeight.w400,
                            color: MyColors.MainBulma)),
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
                ghassalBasketsController.isIroningSelected.value = true;
                ghassalBasketsController.itemIroningId.value = 2;
                clearData2();
              });
            },
            child: Container(
              padding: EdgeInsetsDirectional.all(2.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                    color: ghassalBasketsController.isIroningSelected.value ==
                                true &&
                            ghassalBasketsController.itemIroningId.value == 2
                        ? MyColors.MainPrimary
                        : MyColors.MainGoku,
                    width: ghassalBasketsController.isIroningSelected.value ==
                                true &&
                            ghassalBasketsController.itemIroningId.value == 2
                        ? 2.0
                        : 1.0,
                  ),
                  color: Colors.white),
              child: Row(
                children: [
                  ghassalBasketsController.isIroningSelected.value == true &&
                          ghassalBasketsController.itemIroningId.value == 2
                      ? SvgPicture.asset('assets/radio_selected.svg')
                      : SvgPicture.asset('assets/radio_button.svg'),
                  SizedBox(
                    width: 1.h,
                  ),
                  Text("iron_only".tr(),
                      style: TextStyle(
                          fontSize: 8.sp,
                          fontFamily: 'alexandria_medium',
                          fontWeight: FontWeight.w400,
                          color: MyColors.MainBulma)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget preferencesList() {
    if (ghassalBasketsController.preferencesList.isNotEmpty) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: ghassalBasketsController.preferencesList.length,
          itemBuilder: (context, int index) {
            return Container(
              padding: EdgeInsetsDirectional.all(1.5.h),
              margin: EdgeInsetsDirectional.only(bottom: 1.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: MyColors.MainGoku, width: 2.0),
                  color: Colors.white),
              child: Row(
                children: [
                  //SvgPicture.asset('assets/leaf.svg'),
                  Image.network(
                    ghassalBasketsController.preferencesList[index].image ?? "",
                    width: 6.h,
                    height: 6.h,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    width: 1.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          ghassalBasketsController
                                  .preferencesList[index].name ??
                              "",
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'alexandria_medium',
                              fontWeight: FontWeight.w300,
                              color: MyColors.MainBulma)),
                      SizedBox(
                        height: 1.h,
                      ),
                      Text(
                          ghassalBasketsController
                                  .preferencesList[index].description ??
                              "",
                          style: TextStyle(
                              fontSize: 8.sp,
                              fontFamily: 'alexandria_regular',
                              fontWeight: FontWeight.w300,
                              color: MyColors.MainTrunks)),
                      SizedBox(
                        height: 1.h,
                      ),
                      Text(
                          "${ghassalBasketsController.preferencesList[index].price.toString() ?? ""} ${'currency'.tr()}",
                          style: TextStyle(
                              fontSize: 8.sp,
                              fontFamily: 'alexandria_regular',
                              fontWeight: FontWeight.w400,
                              color: MyColors.MainPrimary)),
                    ],
                  ),
                  const Spacer(),
                  Checkbox(
                    checkColor: Colors.white,
                    value: ghassalBasketsController
                        .preferencesList[index].isChecked,
                    activeColor: MyColors.MainPrimary,
                    onChanged: (bool? isChecked) {
                      setState(() {
                        preferences =
                            ghassalBasketsController.preferencesList[index];
                        ghassalBasketsController
                            .preferencesList[index].isChecked = isChecked!;

                        if (isChecked == true) {
                          //int uniqueId = DateTime.now().millisecondsSinceEpoch;
                          // Create a new Preferences object and add it to preferencesItem
                          final item =
                              ghassalBasketsController.preferencesList[index];
                          final id = item.id;
                          final price = item.price;
                          //final uniqueId = item.unIq;
                          //print("klm "+uniqueId.toString());
                          final newPreference = Preferences(
                              id: id, price: price); //unIq: uniqueId);
                          ghassalBasketsController.preferencesItem
                              .add(newPreference);
                        } else {
                          // Remove the Preferences object from preferencesItem
                          // final id = ghassalBasketsController.preferencesList[index].unIq;
                          // print("bkbk "+id.toString());
                          // ghassalBasketsController.preferencesItem.removeWhere((item) => item.unIq == id);
                          final id = ghassalBasketsController
                              .preferencesList[index].id;
                          print("bkbk " + id.toString());
                          ghassalBasketsController.preferencesItem
                              .removeWhere((item) => item.id == id);
                        }

                        // ghassalBasketsController.productsJson.value = ghassalBasketsController.convertBasketListToJson(ghassalBasketsController.basketItem);
                        // print("Updated JSON2: " + ghassalBasketsController.productsJson.value);
                      });
                    },
                  ),
                ],
              ),
            );
          });
    } else {
      return Container();
    }
  }
}
