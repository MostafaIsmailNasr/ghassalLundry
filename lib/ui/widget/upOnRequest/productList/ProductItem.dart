import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

import '../../../../business/ghassalUpOnRequestController/GhassalUpOnRequestController.dart';
import '../../../../conustant/my_colors.dart';
import '../../../../data/model/productModel/ProductResponse.dart';

class ProductItem extends StatefulWidget{
  Products products;
  var key;

  ProductItem({required this.products,required this.key});

  @override
  State<StatefulWidget> createState() {
    return _ProductItem();
  }
}

class _ProductItem extends State<ProductItem>{
  bool isvisible=false;
  int counter=0;
  final ghassalUpOnRequestController = Get.put(GhassalUpOnRequestController());
  @override
  void initState() {
    if (ghassalUpOnRequestController.getItemPrice(widget.products.id!)>=1) {
      // Only call setState if the visibility state needs to change
      if (!isvisible) {
        setState(() {
          isvisible = true;
        });
      }
    } else {
      // Only call setState if the visibility state needs to change
      if (isvisible) {
        setState(() {
          isvisible = false;
        });
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(1.h),
      margin: EdgeInsetsDirectional.only(bottom: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(
            widget.products.image??"",width: 8.h,height: 8.h,fit: BoxFit.fill,
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
              return SvgPicture.asset('assets/jacket.svg');
              }),
          SizedBox(width: 1.h,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.products.name??"",
                  style:  TextStyle(fontSize: 12.sp,
                      fontFamily: 'alexandria_bold',
                      fontWeight: FontWeight.w500,
                      color:MyColors.MainTrunks)),
              Text("${widget.products.regularPrice??""} ${"currency".tr()}",
                  style:  TextStyle(fontSize: 10.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w500,
                      color:MyColors.MainPrimary)),
            ],
          ),
          const Spacer(),
          GestureDetector(
              onTap: (){
                setState(() {
                  isvisible=true;
                  //counter++;
                  calculatePlus();
                });
              },
              child: SvgPicture.asset('assets/ic_round-plus.svg')),
          SizedBox(width: 1.h,),
          Visibility(
            visible: isvisible,
            child: Row(
              children: [
                Text(ghassalUpOnRequestController.getItemPrice(widget.products.id!).toString(),
                    //counter.toString(),
                    style:  TextStyle(fontSize: 12.sp,
                        fontFamily: 'alexandria_bold',
                        fontWeight: FontWeight.w500,
                        color:MyColors.MainTrunks)),
                SizedBox(width: 1.h,),
                ghassalUpOnRequestController.getItemPrice(widget.products.id!)==1?
                GestureDetector(
                    onTap: (){
                      setState(() {
                        counter=0;
                        calculateMinus();
                        isvisible=false;
                      });
                    },
                    child: SvgPicture.asset('assets/remove.svg'))
                    :GestureDetector(
                    onTap: (){
                      // setState(() {
                      //   if(counter>1) {
                      //     counter--;
                      //   }
                      // });
                      calculateMinus();
                    },
                    child: SvgPicture.asset('assets/ic_round-minus.svg'))
              ],
            ),
          )
        ],
      ),
    );
  }

  void calculatePlus() {
    setState(() {
      int existingIndex = ghassalUpOnRequestController.cartItem.indexWhere((item) => item.id == widget.products.id);
      ghassalUpOnRequestController.itemPrices.add((widget.products.regularPrice??0));
      ghassalUpOnRequestController.quantityList.value++;
      ghassalUpOnRequestController.discount.value=0.0;
      ghassalUpOnRequestController.CopunID=null;
      widget.products.isvisible=true;
      if (existingIndex != -1) {
        // Product ID exists in the list, increment its quantity
        var existingProduct = ghassalUpOnRequestController.cartItem[existingIndex];
        if (existingProduct.quantity != null) {
          var updatedQuantity = existingProduct.quantity! + 1; // Increment quantity if not null
          if (ghassalUpOnRequestController.itemPrices2.containsKey(widget.products.id)) {
            ghassalUpOnRequestController.itemPrices2[widget.products.id!] = (ghassalUpOnRequestController.itemPrices2[widget.products.id] ?? 0) + 1;
          } else {
            ghassalUpOnRequestController.itemPrices2[widget.products.id!] = 1;
          }
          ghassalUpOnRequestController.cartItem[existingIndex] = Products(
            id: existingProduct.id,
            regularPrice: existingProduct.regularPrice,
            quantity: updatedQuantity,
              name: existingProduct.name
          );
        }
      } else {
        if (ghassalUpOnRequestController.itemPrices2.containsKey(widget.products.id)) {
          ghassalUpOnRequestController.itemPrices2[widget.products.id!] = (ghassalUpOnRequestController.itemPrices2[widget.products.id] ?? 0) + 1;
        } else {
          ghassalUpOnRequestController.itemPrices2[widget.products.id!] = 1;
        }
        ghassalUpOnRequestController.cartItem.add(
          Products(
              id: widget.products.id,
              regularPrice: widget.products.regularPrice,
              quantity:1,
            name: widget.products.name
          ),
        );
      }
      ghassalUpOnRequestController.calculateTotalPrice();

      // Update the JSON representation of the products
      ghassalUpOnRequestController.productsJson.value = ghassalUpOnRequestController.convertProductListToJson(ghassalUpOnRequestController.cartItem);
      print("Updated JSON1: " + ghassalUpOnRequestController.productsJson.value);
    });
  }

  void calculateMinus() {
    setState(() {
      ghassalUpOnRequestController.discount.value=0.0;
      ghassalUpOnRequestController.CopunID=null;
      int existingIndex = ghassalUpOnRequestController.cartItem.indexWhere((item) => item.id == widget.products.id);

      if (existingIndex != -1) {
        // Product ID exists in the list, increment its quantity
        var existingProduct = ghassalUpOnRequestController.cartItem[existingIndex];
        if (existingProduct.quantity! >1) {
          var updatedQuantity = existingProduct.quantity! - 1; // Increment quantity if not null
          if (ghassalUpOnRequestController.itemPrices2.containsKey(widget.products.id!)) {
            if (ghassalUpOnRequestController.itemPrices2[widget.products.id]! > 0) {
              ghassalUpOnRequestController.itemPrices2[widget.products.id!] = ghassalUpOnRequestController.itemPrices2[widget.products.id]! - 1;
            }
          }

          ghassalUpOnRequestController.cartItem[existingIndex] = Products(
            id: existingProduct.id,
            regularPrice: existingProduct.regularPrice,
            quantity: updatedQuantity,
              name: existingProduct.name
          );
          ghassalUpOnRequestController.quantityList.value--;
          if (ghassalUpOnRequestController.itemPrices.isNotEmpty) {
            ghassalUpOnRequestController.itemPrices.removeLast(); // Remove the last added price from the list
          }
          ghassalUpOnRequestController.calculateTotalPrice();
        }
        else {
          if (ghassalUpOnRequestController.itemPrices2.containsKey(widget.products.id!)) {
            if (ghassalUpOnRequestController.itemPrices2[widget.products.id]! > 0) {
              ghassalUpOnRequestController.itemPrices2[widget.products.id!] = ghassalUpOnRequestController.itemPrices2[widget.products.id]! - 1;
            }
          }
          ghassalUpOnRequestController.quantityList.value--;
          if (ghassalUpOnRequestController.itemPrices.isNotEmpty) {
            ghassalUpOnRequestController.itemPrices.removeLast(); // Remove the last added price from the list
          }
          ghassalUpOnRequestController.cartItem.removeWhere((element) => element.id==widget.products.id);
          ghassalUpOnRequestController.calculateTotalPrice();
        }
      }

      // Update the JSON representation of the products
      ghassalUpOnRequestController.productsJson.value = ghassalUpOnRequestController.convertProductListToJson(ghassalUpOnRequestController.cartItem);
      print("Updated JSON1: " + ghassalUpOnRequestController.productsJson.value);
    });
  }

  int calculateTotalPrice() {
    int totalPrice = 0;
    setState(() {
      for (var product in ghassalUpOnRequestController.cartItem) {
        totalPrice += (product.regularPrice ?? 0) * (product.quantity ?? 0);
      }
      print("jkhjhj"+totalPrice.toString());
      ghassalUpOnRequestController.totalPrice.value=totalPrice;
      ghassalUpOnRequestController.totalAfterDiscount.value=ghassalUpOnRequestController.totalPrice.value.toDouble();
    });
    return totalPrice;
  }

}