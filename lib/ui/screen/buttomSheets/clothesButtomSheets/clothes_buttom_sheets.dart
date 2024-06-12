import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:ghassal_laundry/conustant/toast_class.dart';
import 'package:ghassal_laundry/data/model/productModel/ProductResponse.dart';
import 'package:sizer/sizer.dart';

import '../../../../business/auth/registerController/RegisterController.dart';
import '../../../../business/ghassalUpOnRequestController/GhassalUpOnRequestController.dart';
import '../../../../conustant/my_colors.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../widget/upOnRequest/clothesCategoryList/ClothesCategoryItem.dart';
import '../../../widget/upOnRequest/productList/ProductItem.dart';

class ClothesButtomSheets extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ClothesButtomSheets();
  }
}

class _ClothesButtomSheets extends State<ClothesButtomSheets>{
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  TextEditingController searchTxtController = TextEditingController();
  var selectedFlage=0;
  var selectedCategoryId;
  final ghassalUpOnRequestController = Get.put(GhassalUpOnRequestController());
  final registerController = Get.put(RegisterController());
  List<Products>? filteredProducts = [];

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {

      ghassalUpOnRequestController.getProductCat(
          registerController.lat.toString(), registerController.lng.toString()).then((_){

        selectedCategoryId=ghassalUpOnRequestController.productCatList[0].id;
        // Filter products based on the selected category ID
        filteredProducts = ghassalUpOnRequestController.productResponse.value.data!
            .where((category) => category.id == selectedCategoryId)
            .expand<Products>((category) => category.products ?? [])
            .toList();
      });

    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return
    Padding(
      padding: EdgeInsets.only(right: 1.h,left: 1.h,top: 1.h,bottom: 2.h),
      child: SingleChildScrollView(
        child: Obx(() => !ghassalUpOnRequestController.isLoading2.value?SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ghassalUpOnRequestController.productResponse.value.success==true?
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 2.h,),
              search(),
              SizedBox(height: 2.h,),
              Text("ironing_baskets".tr(),
                  style:  TextStyle(fontSize: 10.sp,
                      fontFamily: 'alexandria_bold',
                      fontWeight: FontWeight.w500,
                      color:MyColors.MainZeno)),
              SizedBox(height: 1.h,),
              categoriesList(),
              SizedBox(height: 1.h,),
              productList(),
              SizedBox(height: 1.h,),
              Container(
                margin: EdgeInsetsDirectional.only(start: 1.h, end: 1.h,),
                width: double.infinity,
                height: 7.h,
                child: TextButton(
                  style: flatButtonStyle,
                  onPressed: () async {
                    if(ghassalUpOnRequestController.cartItem.isNotEmpty){
                      Navigator.pop(context);
                    }else{
                      Fluttertoast.showToast(
                          msg: "please_select_items_first".tr(),
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
              ),
            ],
          )
              :Container(margin: EdgeInsetsDirectional.only(top: 10.h,start: 2.h,),
              child: Text(ghassalUpOnRequestController.productResponse.value.message??"",
                style: TextStyle(color: MyColors.MainBulma,fontWeight: FontWeight.w600,fontSize: 16.sp),)),
        )
        :const Center(child: CircularProgressIndicator(color: MyColors.MainPrimary),)),
      ),
    );
  }

  Widget search() {
    return TextFormField(
      textInputAction: TextInputAction.search,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: searchTxtController,
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(1.2.h, 0, 1.2.h, 0),
          child: SvgPicture.asset('assets/search_normal.svg'),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(color: MyColors.MainBeerus, style: BorderStyle.solid),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(style: BorderStyle.solid, color: MyColors.MainBeerus),
        ),
        hintText: 'search_for_product_names'.tr(),
        hintStyle: TextStyle(
          fontSize: 12.sp,
          fontFamily: 'alexandria_regular',
          fontWeight: FontWeight.w300,
          color: MyColors.textColor,
        ),
      ),
      style: TextStyle(
        fontSize: 12.sp,
        fontFamily: 'alexandria_medium',
        fontWeight: FontWeight.w300,
        color: MyColors.MainZeno,
      ),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: (query){
        if(query.isNotEmpty){
          _filterItems(query);
        }else{
          setState(() {
            // Filter products based on the selected category ID
            filteredProducts = ghassalUpOnRequestController.productResponse.value.data!
                .where((category) => category.id == selectedCategoryId)
                .expand<Products>((category) => category.products ?? [])
                .toList();
          });
        }
      }
    );
  }

  void _filterItems(String query) {
    log(query);
    final filter = filteredProducts!.where((element) {
      final name2 = element.name!.toLowerCase();
      final input = query.toLowerCase();
      return name2.contains(input);
    }).toList();

    // Trigger a rebuild with the filtered list
    setState(() {
      filteredProducts = filter;
    });
  }

  Widget categoriesList() {
    if (ghassalUpOnRequestController.productCatList.isNotEmpty) {
    return SizedBox(
      height: 7.h,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: ghassalUpOnRequestController.productCatList.length,
          itemBuilder: (context, int index) {
            return ClothesCategoryItem(
              is_selected: selectedFlage==index,
              onTap: () {
                setState(() {
                  selectedFlage=index;
                  selectedCategoryId = ghassalUpOnRequestController.productCatList[index].id; // Set selected category ID
                  // Filter products based on the selected category ID
                  searchTxtController.clear();
                  filteredProducts = ghassalUpOnRequestController.productResponse.value.data!
                      .where((category) => category.id == selectedCategoryId)
                      .expand<Products>((category) => category.products ?? [])
                      .toList();
                });
              },
              productCat: ghassalUpOnRequestController.productCatList[index],
            );
          }
      ),
    );
    } else {
      return Container();
    }
  }

  Widget productList() {
    if (ghassalUpOnRequestController.productResponse.value.data == null ||
        ghassalUpOnRequestController.productResponse.value.data!.isEmpty) {
      return Container();
    }

    if (filteredProducts!.isNotEmpty) {
      return SizedBox(
        height: 35.h,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: filteredProducts!.length,
          itemBuilder: (context, index) {
            return ProductItem(
                key: ValueKey(filteredProducts![index].id),
                products: filteredProducts![index]);
          },
        ),
      );
    } else {
      return empty();
    }
  }
}

class empty extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28.h,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SvgPicture.asset('assets/search_empty.svg',width: 15.h,height: 15.h,),
              SizedBox(height: 1.h,),
              Text('sorry_there_no_results'.tr(),
                style: TextStyle(fontSize: 14.sp,
                    fontFamily: 'alexandria_bold',
                    fontWeight: FontWeight.w600,
                    color: MyColors.MainTrunks),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h,),
              Text('sorry'.tr(),
                style: TextStyle(fontSize: 12.sp,
                    fontFamily: 'lexend_bold',
                    fontWeight: FontWeight.w400,
                    color: MyColors.Dark2),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

}