import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../../business/auth/registerController/RegisterController.dart';
import '../../../../../business/ghassalSubscriptionController/GhassalSubscriptionController.dart';
import '../../../../../conustant/my_colors.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../conustant/toast_class.dart';
import '../../../../../data/model/basketModel/BasketListResponse.dart';
import '../../../../../data/model/preferencesModel/PreferencesResponse.dart';
import '../../../../../data/model/selectedBasketModel/SelectedBasketModel.dart';
import '../../../../widget/basket/basketsList/BasketsItem.dart';
import '../../../../widget/subscription/moreBaskets/MoreBasketsItem.dart';

class CustomizePackageScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CustomizePackageScreen();
  }
}

class _CustomizePackageScreen extends State<CustomizePackageScreen>{
  var selectedFlage=0;
  var isSelected=false;
  int? itemId=0;
  var clickAction="";
  var qul=0;
  var indexx=0;
  Preferences? preferences;
  List<bool> checkedList = List.generate(6, (index) => false);
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  final ghassalSubscriptionController = Get.put(GhassalSubscriptionController());
  final registerController = Get.put(RegisterController());

  void clearData(){
    setState(() {
      ghassalSubscriptionController.basketItem.clear();
      ghassalSubscriptionController.productsJson.value="";
      ghassalSubscriptionController.preferencesItem.clear();
      ghassalSubscriptionController.itemIroningId.value=1;
      ghassalSubscriptionController.isIroningSelected.value=true;
      ghassalSubscriptionController.selectedProductList.clear();
    });

  }

  void clearData2(){
    setState(() {
      ghassalSubscriptionController.basketItem.clear();
      ghassalSubscriptionController.productsJson.value="";
      ghassalSubscriptionController.preferencesItem.clear();
      ghassalSubscriptionController.preferencesList.forEach((item) {
        item.isChecked = false;
      });
      ghassalSubscriptionController.selectedProductList.clear();
    });

  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      clearData();
      ghassalSubscriptionController.getBasketsList(
          registerController.lat.toString(), registerController.lng.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => !ghassalSubscriptionController.isLoading.value? Scaffold(
      backgroundColor: MyColors.BGColor,
      body: SafeArea(
        child: Container(
          margin: EdgeInsetsDirectional.only(start: 2.h,end: 2.h,top: 2.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customBar(),
                SizedBox(height: 2.h,),
                Text("determine".tr(),
                    style:  TextStyle(fontSize: 10.sp,
                        fontFamily: 'alexandria_bold',
                        fontWeight: FontWeight.w500,
                        color:MyColors.MainBulma)),
                SizedBox(height: 1.h,),
                basketsList(),
                SizedBox(height: 1.h,),
                Text("ironing_baskets".tr(),
                    style:  TextStyle(fontSize: 10.sp,
                        fontFamily: 'alexandria_bold',
                        fontWeight: FontWeight.w500,
                        color:MyColors.MainBulma)),
                SizedBox(height: 1.h,),
                ironingBaskets(),
                SizedBox(height: 1.h,),
                Text("preferences".tr(),
                    style:  TextStyle(fontSize: 10.sp,
                        fontFamily: 'alexandria_bold',
                        fontWeight: FontWeight.w500,
                        color:MyColors.MainBulma)),
                SizedBox(height: 1.h,),
                preferencesList()
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
          color: Colors.white,
          margin: EdgeInsetsDirectional.all(1.h),
          height: 8.h,
          child:
          Container(
            margin: EdgeInsetsDirectional.only(start: 1.h, end: 1.h,),
            width: double.infinity,
            height: 7.h,
            child: TextButton(
              style: flatButtonStyle,
              onPressed: () async {
                if(qul!=0){
                  ghassalSubscriptionController.moreSelected.value=true;
                  if(clickAction=="add"){
                    calculatePlus(indexx,qul);
                    Navigator.pop(context);
                  }else{
                    calculatePlus(indexx,qul);
                    Navigator.pop(context);
                  }

                }else{
                  ToastClass.showCustomToast(context, "please_select_basket_first".tr(), "error");
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
          )
      ),
    )
        :const Scaffold(body: Center(child: CircularProgressIndicator(color: MyColors.MainPrimary),)));
  }

  Widget customBar(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("customize_package".tr(),
                style:  TextStyle(fontSize: 12.sp,
                    fontFamily: 'alexandria_bold',
                    fontWeight: FontWeight.w500,
                    color:MyColors.MainBulma)),
            SizedBox(height: 1.h,),
            Row(
              children: [
                SvgPicture.asset('assets/info_circle.svg'),
                SizedBox(width: 1.h,),
                SizedBox(
                  width: 36.h,
                  child: Text("please_specify_the".tr(),
                    style:  TextStyle(fontSize: 8.sp,
                        fontFamily: 'alexandria_regular',
                        fontWeight: FontWeight.w300,
                        color:MyColors.MainTrunks),),
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: SvgPicture.asset('assets/close_circle2.svg'),
        ),
      ],
    );
  }

  Widget basketsList() {
    if (ghassalSubscriptionController.basketList.isNotEmpty) {
      return SizedBox(
        height: 25.h,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: ghassalSubscriptionController.basketList.length,
            itemBuilder: (context, int index) {
              return
                Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          if(selectedFlage==index) {
                            return;
                          }else{
                            selectedFlage=index;
                            qul=0;
                            clearData();
                            ghassalSubscriptionController.preferencesList.forEach((item) {
                              item.isChecked = false;
                            });
                          }

                        });
                      },
                      child: Container(
                        margin: EdgeInsetsDirectional.only(end: 1.h,bottom: 1.h),
                        padding: EdgeInsetsDirectional.all(1.5.h),
                        height: 18.h,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                            border: Border.all(
                              color: selectedFlage==index?MyColors.MainPrimary: MyColors.MainGoku,
                              width:selectedFlage==index?2.0: 1.0,),
                            color: selectedFlage==index?MyColors.Back: MyColors.MainGoku),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(ghassalSubscriptionController.basketList[index].image??"",width: 10.h,height: 5.h,),
                            SizedBox(height: 1.h,),
                            Text("information_about_package".tr(),
                                style:  TextStyle(fontSize: 8.sp,
                                    fontFamily: 'alexandria_regular',
                                    fontWeight: FontWeight.w300,
                                    color:MyColors.MainTrunks)),
                            SizedBox(height: 1.h,),
                            Text(ghassalSubscriptionController.basketList[index].title??"",
                                style:  TextStyle(fontSize: 10.sp,
                                    fontFamily: 'alexandria_medium',
                                    fontWeight: FontWeight.w500,
                                    color:MyColors.MainTrunks)),
                            SizedBox(height: 1.h,),
                            Text(
                                ghassalSubscriptionController.isIroningSelected.value==true
                                    &&ghassalSubscriptionController.itemIroningId.value==1?
                                "${ghassalSubscriptionController.basketList[index].priceWash.toString()??"0"} ${'currency'.tr()}"
                                    :"${ghassalSubscriptionController.basketList[index].priceIroning.toString()??"0"} ${'currency'.tr()}",
                                style:  TextStyle(fontSize: 8.sp,
                                    fontFamily: 'alexandria_regular',
                                    fontWeight: FontWeight.w400,
                                    color:MyColors.MainPrimary)),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible:selectedFlage==index,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                indexx=index;
                                qul=qul+1;
                                print("mk "+(qul).toString());
                                clickAction="add";
                              });
                            },
                            child: Container(
                              padding: EdgeInsetsDirectional.only(start: 2.h,end: 2.h),
                              height: 5.h,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                  border: Border.all(
                                    color: MyColors.MainPrimary, width: 1.0,),
                                  color:  MyColors.MainPrimary),
                              child: const Center(
                                child: Icon(Icons.add,color: Colors.white,),
                              ),
                            ),
                          ),
                          SizedBox(width: 4.h,),
                          Text(qul.toString(),
                              style:  TextStyle(fontSize: 14.sp,
                                  fontFamily: 'alexandria_bold',
                                  fontWeight: FontWeight.w700,
                                  color:MyColors.counterColor)),
                          SizedBox(width: 4.h,),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                indexx=index;
                                if(qul>=1) {
                                  qul = qul -
                                      1; //ghassalBasketsController.basketList[index].quantity++;
                                  print("mk " + qul.toString());
                                  clickAction = "mines";
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsetsDirectional.only(start: 2.h,end: 2.h),
                              height: 5.h,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                  border: Border.all(
                                    color: MyColors.MainGoku, width: 1.0,),
                                  color:  MyColors.MainGoku),
                              child:  Center(
                                child: SvgPicture.asset("assets/mines.svg"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );


            }
        ),
      );
    } else {
      return Container();
    }
  }

  Widget ironingBaskets(){
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: (){
              setState(() {
                ghassalSubscriptionController.isIroningSelected.value=true;
                ghassalSubscriptionController.itemIroningId.value=1;
                clearData2();
              });
            },
            child: Container(
              padding: EdgeInsetsDirectional.all(2.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                    color:ghassalSubscriptionController.isIroningSelected.value==true
                        && ghassalSubscriptionController.itemIroningId.value==1?MyColors.MainPrimary: MyColors.MainGoku,
                    width:ghassalSubscriptionController.isIroningSelected.value==true
                        && ghassalSubscriptionController.itemIroningId.value==1? 2.0: 1.0,),
                  color:  Colors.white),
              child: Row(
                children: [
                  ghassalSubscriptionController.isIroningSelected.value==true
                      && ghassalSubscriptionController.itemIroningId.value==1?SvgPicture.asset('assets/radio_selected.svg'):
                  SvgPicture.asset('assets/radio_button.svg'),
                  SizedBox(width: 1.h,),
                  Expanded(
                    child: Text("washing_ironing".tr(),
                        style:  TextStyle(fontSize: 8.sp,
                            fontFamily: 'alexandria_medium',
                            fontWeight: FontWeight.w400,
                            color:MyColors.MainBulma)),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 1.h,),
        Expanded(
          child: GestureDetector(
            onTap: (){
              setState(() {
                ghassalSubscriptionController.isIroningSelected.value=true;
                ghassalSubscriptionController.itemIroningId.value=2;
                clearData2();
              });
            },
            child: Container(
              padding: EdgeInsetsDirectional.all(2.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                    color: ghassalSubscriptionController.isIroningSelected.value==true
                        && ghassalSubscriptionController.itemIroningId.value==2?MyColors.MainPrimary: MyColors.MainGoku,
                    width:ghassalSubscriptionController.isIroningSelected.value==true
                        && ghassalSubscriptionController.itemIroningId.value==2?2.0: 1.0,),
                  color:  Colors.white),
              child: Row(
                children: [
                  ghassalSubscriptionController.isIroningSelected.value==true
                      && ghassalSubscriptionController.itemIroningId.value==2?SvgPicture.asset('assets/radio_selected.svg'):
                  SvgPicture.asset('assets/radio_button.svg'),
                  SizedBox(width: 1.h,),
                  Text("iron_only".tr(),
                      style:  TextStyle(fontSize: 8.sp,
                          fontFamily: 'alexandria_medium',
                          fontWeight: FontWeight.w400,
                          color:MyColors.MainBulma)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget preferencesList() {
    if (ghassalSubscriptionController.preferencesList.isNotEmpty) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: ghassalSubscriptionController.preferencesList.length,
          itemBuilder: (context, int index) {
            return Container(
              padding: EdgeInsetsDirectional.all(1.5.h),
              margin: EdgeInsetsDirectional.only(bottom: 1.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                      color: MyColors.MainGoku,
                      width: 2.0),
                  color:  Colors.white),
              child: Row(
                children: [
                  //SvgPicture.asset('assets/leaf.svg'),
                  Image.network(ghassalSubscriptionController.preferencesList[index].image??"",width: 5.h,height: 5.h,),
                  SizedBox(width: 1.h,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ghassalSubscriptionController.preferencesList[index].name??"",
                          style:  TextStyle(fontSize: 12.sp,
                              fontFamily: 'alexandria_medium',
                              fontWeight: FontWeight.w300,
                              color:MyColors.MainBulma)),
                      SizedBox(height: 1.h,),
                      Text(ghassalSubscriptionController.preferencesList[index].description??"",
                          style:  TextStyle(fontSize: 8.sp,
                              fontFamily: 'alexandria_regular',
                              fontWeight: FontWeight.w300,
                              color:MyColors.MainTrunks)),
                      SizedBox(height: 1.h,),
                      Text("${ghassalSubscriptionController.preferencesList[index].price.toString()??""} ${'currency'.tr()}",
                          style:  TextStyle(fontSize: 8.sp,
                              fontFamily: 'alexandria_regular',
                              fontWeight: FontWeight.w400,
                              color:MyColors.MainPrimary)),
                    ],
                  ),
                  const Spacer(),
                  Checkbox(
                    checkColor: Colors.white,
                    value: ghassalSubscriptionController.preferencesList[index].isChecked,
                    activeColor: MyColors.MainPrimary,
                    onChanged: (bool? isChecked) {
                      setState(() {
                        preferences=ghassalSubscriptionController.preferencesList[index];
                        ghassalSubscriptionController.preferencesList[index].isChecked = isChecked!;

                        if (isChecked == true) {
                          // Create a new Preferences object and add it to preferencesItem
                          final item = ghassalSubscriptionController.preferencesList[index];
                          final id = item.id;
                          final price = item.price;
                          //final uniqueId = item.unIq;
                          //print("klm "+uniqueId.toString());
                          final newPreference = Preferences(id: id, price: price);//unIq: uniqueId);
                          ghassalSubscriptionController.preferencesItem.add(newPreference);
                        } else {
                          // Remove the Preferences object from preferencesItem
                          // final id = ghassalBasketsController.preferencesList[index].unIq;
                          // print("bkbk "+id.toString());
                          // ghassalBasketsController.preferencesItem.removeWhere((item) => item.unIq == id);
                          final id = ghassalSubscriptionController.preferencesList[index].id;
                          print("bkbk "+id.toString());
                          ghassalSubscriptionController.preferencesItem.removeWhere((item) => item.id == id);
                        }



                        // ghassalBasketsController.productsJson.value = ghassalBasketsController.convertBasketListToJson(ghassalBasketsController.basketItem);
                        // print("Updated JSON2: " + ghassalBasketsController.productsJson.value);
                      });
                    },

                  ),
                ],
              ),
            );
          }
      );
    } else {
      return Container();
    }
  }

  void calculatePlus(int index,int qul) {
    setState(() {
      int existingIndex = ghassalSubscriptionController.basketItem.indexWhere((item) => item.id == ghassalSubscriptionController.basketList[index].id);
      ghassalSubscriptionController.isIroningSelected.value==true
          &&ghassalSubscriptionController.itemIroningId.value==1?
      ghassalSubscriptionController.itemPrices.add((ghassalSubscriptionController.basketList[index].priceWash??0))
          :ghassalSubscriptionController.itemPrices.add((ghassalSubscriptionController.basketList[index].priceIroning??0));
      ghassalSubscriptionController.quantityList.value++;
      ghassalSubscriptionController.discount.value=0.0;
      ghassalSubscriptionController.CopunID=null;

      if (existingIndex != -1) {
        // Product ID exists in the list, increment its quantity
        var existingProduct = ghassalSubscriptionController.basketItem[existingIndex];
        if (existingProduct.quantity != null) {
          int uniqueId = DateTime.now().millisecondsSinceEpoch;
          var updatedQuantity = qul;
          if (ghassalSubscriptionController.itemPrices2.containsKey(ghassalSubscriptionController.basketList[index].id)) {
            ghassalSubscriptionController.itemPrices2[ghassalSubscriptionController.basketList[index].id!] = (ghassalSubscriptionController.itemPrices2[ghassalSubscriptionController.basketList[index].id] ?? 0) + 1;
          } else {
            ghassalSubscriptionController.itemPrices2[ghassalSubscriptionController.basketList[index].id!] = 1;
          }
          if(ghassalSubscriptionController.isIroningSelected.value==true
              &&ghassalSubscriptionController.itemIroningId.value==1){
            if(ghassalSubscriptionController.preferencesItem.isNotEmpty){
              List<Prefrences> preferencesList = [];
              ghassalSubscriptionController.preferencesItem.forEach((pref) {
                preferencesList.add(Prefrences(
                  id: pref.id,
                  price: pref.price,
                ));
              });
              var updatedWashType = 0;
              ghassalSubscriptionController.basketItem[existingIndex] = Baskets(
                  Uniqid: uniqueId,
                  id: existingProduct.id,
                  priceWash:  existingProduct.priceWash,
                  priceIroning: existingProduct.priceIroning,
                  quantity: updatedQuantity,
                  title: existingProduct.title,
                  washType: updatedWashType,
                  preferences2: preferencesList
              );
            }
            else{
              var updatedWashType = 0;
              ghassalSubscriptionController.basketItem[existingIndex] = Baskets(
                  Uniqid: uniqueId,
                  id: existingProduct.id,
                  priceWash:  existingProduct.priceWash,
                  priceIroning: existingProduct.priceIroning,
                  quantity: updatedQuantity,
                  title: existingProduct.title,
                  washType: updatedWashType,
                  preferences2: []
              );
            }
          }
          else{
            if(ghassalSubscriptionController.preferencesItem.isNotEmpty){
              List<Prefrences> preferencesList = [];
              ghassalSubscriptionController.preferencesItem.forEach((pref) {
                preferencesList.add(Prefrences(
                  id: pref.id,
                  price: pref.price,
                ));
              });
              var updatedWashType = 1;
              ghassalSubscriptionController.basketItem[existingIndex] = Baskets(
                  Uniqid: uniqueId,
                  id: existingProduct.id,
                  priceWash:  existingProduct.priceWash,
                  priceIroning: existingProduct.priceIroning,
                  quantity: updatedQuantity,
                  title: existingProduct.title,
                  washType: updatedWashType,
                  preferences2: preferencesList
              );
            }
            else{
              var updatedWashType = 1;
              ghassalSubscriptionController.basketItem[existingIndex] = Baskets(
                  Uniqid: uniqueId,
                  id: existingProduct.id,
                  priceWash:  existingProduct.priceWash,
                  priceIroning: existingProduct.priceIroning,
                  quantity: updatedQuantity,
                  title: existingProduct.title,
                  washType: updatedWashType,
                  preferences2: []
              );
            }

          }

        }
      }
      else {
        int uniqueId = DateTime.now().millisecondsSinceEpoch;
        if (ghassalSubscriptionController.itemPrices2.containsKey(ghassalSubscriptionController.basketList[index].id)) {
          ghassalSubscriptionController.itemPrices2[ghassalSubscriptionController.basketList[index].id!] = (ghassalSubscriptionController.itemPrices2[ghassalSubscriptionController.basketList[index].id] ?? 0) + 1;
        } else {
          ghassalSubscriptionController.itemPrices2[ghassalSubscriptionController.basketList[index].id!] = 1;
        }

        if(ghassalSubscriptionController.isIroningSelected.value==true
            &&ghassalSubscriptionController.itemIroningId.value==1){

          if(ghassalSubscriptionController.preferencesItem.isNotEmpty){
            List<Prefrences> preferencesList = [];
            ghassalSubscriptionController.preferencesItem.forEach((pref) {
              preferencesList.add(Prefrences(
                id: pref.id,
                price: pref.price,
              ));
            });
            var updatedWashType = 0;
            ghassalSubscriptionController.basketItem.add(
              Baskets(
                  Uniqid: uniqueId,
                  id: ghassalSubscriptionController.basketList[index].id,
                  priceWash:  ghassalSubscriptionController.basketList[index].priceWash,
                  priceIroning: ghassalSubscriptionController.basketList[index].priceIroning,
                  quantity: qul,
                  title: ghassalSubscriptionController.basketList[index].title,
                  washType: updatedWashType,
                  preferences2: preferencesList
              ),
            );
          }
          else{
            var updatedWashType = 0;
            //existingProduct.washType=0;
            ghassalSubscriptionController.basketItem.add(
              Baskets(
                  Uniqid: uniqueId,
                  id: ghassalSubscriptionController.basketList[index].id,
                  priceWash:  ghassalSubscriptionController.basketList[index].priceWash,
                  priceIroning: ghassalSubscriptionController.basketList[index].priceIroning,
                  quantity: qul,
                  title: ghassalSubscriptionController.basketList[index].title,
                  washType: updatedWashType,
                  preferences2: []
              ),
            );
          }

        }
        else{
          if(ghassalSubscriptionController.preferencesItem.isNotEmpty){
            List<Prefrences> preferencesList = [];
            ghassalSubscriptionController.preferencesItem.forEach((pref) {
              preferencesList.add(Prefrences(
                id: pref.id,
                price: pref.price,
              ));
            });
            var updatedWashType = 1;
            ghassalSubscriptionController.basketItem.add(
              Baskets(
                  Uniqid: uniqueId,
                  id: ghassalSubscriptionController.basketList[index].id,
                  priceWash:  ghassalSubscriptionController.basketList[index].priceWash,
                  priceIroning: ghassalSubscriptionController.basketList[index].priceIroning,
                  quantity: qul,
                  title: ghassalSubscriptionController.basketList[index].title,
                  washType: updatedWashType,
                  preferences2: preferencesList
              ),
            );
          }
          else{
            var updatedWashType = 1;
            ghassalSubscriptionController.basketItem.add(
              Baskets(
                  Uniqid: uniqueId,
                  id: ghassalSubscriptionController.basketList[index].id,
                  priceWash:  ghassalSubscriptionController.basketList[index].priceWash,
                  priceIroning: ghassalSubscriptionController.basketList[index].priceIroning,
                  quantity: 1,
                  title: ghassalSubscriptionController.basketList[index].title,
                  washType: updatedWashType,
                  preferences2: []
              ),
            );
          }}
      }

      ghassalSubscriptionController.calculateTotalBaskets();

      //ghassalBasketsController.calculateTotalPrice(0);

      // Update the JSON representation of the products
      ghassalSubscriptionController.productsJson.value = ghassalSubscriptionController.convertBasketSubToJson(ghassalSubscriptionController.basketItem);
      print("Updated JSON1: " + ghassalSubscriptionController.productsJson.value);


    });
  }

}