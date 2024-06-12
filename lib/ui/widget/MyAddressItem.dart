import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../conustant/my_colors.dart';
import '../../data/model/addressModel/addressListModel/AddressListResponse.dart';
import '../screen/buttomSheets/deleteAddressButtomSheet/delete_address_sheet.dart';
import '../screen/morePages/myLocations/editLocation/edit_location_screen.dart';

class MyAddressItem extends StatelessWidget{
  final Address address;

  MyAddressItem({required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsetsDirectional.only(bottom: 1.h),
      decoration:  BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: Colors.white,
          border: Border.all(color: MyColors.MainGoku)),
      child: Padding(
        padding:  EdgeInsets.all(1.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsetsDirectional.only(start: 2.5.h,end: 2.5.h,top: 1.h,bottom: 1.h),
                  decoration:  BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: MyColors.MainPrimary,
                      border: Border.all(color: MyColors.MainPrimary)),
                  child: Row(
                    children: [
                      address.type=="home"?
                      SvgPicture.asset('assets/home3.svg'):SvgPicture.asset('assets/buildings5.svg'),
                      SizedBox(width: 1.h,),
                      Text(address.type??"",
                        style:  TextStyle(fontSize: 10.sp,
                            fontFamily: 'alexandria_medium',
                            fontWeight: FontWeight.w300,
                            color:Colors.white),),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                    onTap: (){
                      showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          backgroundColor:Colors.white,
                          builder: (BuildContext context)=> Padding(
                              padding: EdgeInsets.only( bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: DeleteAddressSheet(id: address!.id!,)
                          )
                      );
                    },
                    child: SvgPicture.asset('assets/delete_order.svg')),
                SizedBox(width: 1.h,),
                GestureDetector(
                    onTap: (){
                      if(address.type=="home"){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  EditLocationScreen(
                              latedit: address.lat,lngedit: address.lng,addressEdit: address.streetName,
                              id:address.id,typeEd:address.type,isSelected2: true,itemId2: 1,
                          )),
                        );
                      }else{
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  EditLocationScreen(
                            latedit: address.lat,lngedit: address.lng,addressEdit: address.streetName,
                            id:address.id,typeEd:address.type,isSelected2: true,itemId2: 2,
                          )),
                        );
                      }

                      print("ffw"+address.type!.toString());
                    },
                    child: SvgPicture.asset('assets/edit.svg')),
              ],
            ),
            SizedBox(height: 1.h,),
            Text(address.streetName??"",
              style:  TextStyle(fontSize: 12.sp,
                  fontFamily: 'alexandria_regular',
                  fontWeight: FontWeight.w300,
                  color:MyColors.textColor),),
            // SizedBox(height: 1.h,),
            // Text("16 شارع الجورة,بجوار درة الرافدين,تبوك",
            //   style:  TextStyle(fontSize: 12.sp,
            //       fontFamily: 'alexandria_regular',
            //       fontWeight: FontWeight.w300,
            //       color:MyColors.textColor),),
            SizedBox(height: 2.h,),
          ],
        ),
      ),
    );
  }

}