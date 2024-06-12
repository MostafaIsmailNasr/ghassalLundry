
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

import '../../../../business/dropOffController/DropOffController.dart';
import '../../../../conustant/my_colors.dart';
import '../../../../conustant/toast_class.dart';
import '../../../widget/DateDropItem.dart';
import '../../../widget/TimeDropItem.dart';


class dropDownTimeButtomSheet extends StatefulWidget{
  var from;

  dropDownTimeButtomSheet({required this.from});

  @override
  State<StatefulWidget> createState() {
    return _dropDownTimeButtomSheet();
  }
}

class _dropDownTimeButtomSheet extends State<dropDownTimeButtomSheet>{
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  var selectedFlage=0;
  var selectedFlageTime;
  final dropOffController = Get.put(DropOffController());

  @override
  void initState() {
    dropOffController.from.value=widget.from;
    dropOffController.getPickUpDates(context);
    //dropOffController.dropDate=null;
    //dropOffController.dropDateHours=null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() =>!dropOffController.isLoading.value?
    Padding(
      padding:  EdgeInsets.only(right: 2.h,left: 2.h,top: 1.h,bottom: 1.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomBar(),
            SizedBox(height: 1.h,),
            dateList(),
            SizedBox(height: 1.h,),
        Obx(() =>!dropOffController.isLoading2.value?
        timeList()
            :const Center(child: CircularProgressIndicator(color: MyColors.MainPrimary),)),
            SizedBox(height: 1.h,),
            SizedBox(
              width: double.infinity,
              height: 7.h,
              child: TextButton(
                style: flatButtonStyle,
                onPressed: () {
                  if(widget.from=="baskets") {
                    if (dropOffController.basketDate != "" &&
                        dropOffController.basketHours != "") {
                      dropOffController.finalBasketTime.value ="${dropOffController.basketDate} ${dropOffController.basketHours}";
                      if(dropOffController.basketHoursOrder.contains("AM")){
                        dropOffController.finalBasketTimeOrder.value ="${dropOffController.formattedDateBasket} ${dropOffController.basketHoursOrder.replaceAll("AM", "")}";
                      }else{
                        dropOffController.finalBasketTimeOrder.value ="${dropOffController.formattedDateBasket} ${dropOffController.basketHoursOrder.replaceAll("PM", "")}";
                      }

                      Navigator.pop(context);
                    } else {
                      Fluttertoast.showToast(
                          msg: "please_select_date_and_time_first".tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
                      );
                    }
                  }
                  else if(widget.from=="subscription"){
                    if (dropOffController.subscriptionDate != null &&
                        dropOffController.subscriptionHours != null) {
                      dropOffController.finalsubscriptionTime.value =
                      "${dropOffController.subscriptionDate} ${dropOffController.subscriptionHours}";
                      if(dropOffController.subscriptionHoursOrder.contains("AM")){
                        dropOffController.finalSubscriptionOrder.value ="${dropOffController.formattedDateSubscription} ${dropOffController.subscriptionHoursOrder.replaceAll("AM", "")}";
                      }else{
                        dropOffController.finalSubscriptionOrder.value ="${dropOffController.formattedDateSubscription} ${dropOffController.subscriptionHoursOrder.replaceAll("PM", "")}";
                      }
                      Navigator.pop(context);
                    } else {
                      Fluttertoast.showToast(
                          msg: "please_select_date_and_time_first".tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
                      );
                    }
                  }
                  else if(widget.from=="upOnRequest"){
                    if (dropOffController.upOnRequestDate != null &&
                        dropOffController.upOnRequestHours != null) {
                      dropOffController.finalupOnRequestTime.value =
                      "${dropOffController.upOnRequestDate} ${dropOffController.upOnRequestHours}";
                      if(dropOffController.upOnRequestHoursOrder.contains("AM")){
                        dropOffController.finalUpOnRequestOrder.value ="${dropOffController.formattedDateUpOnRequest} ${dropOffController.upOnRequestHoursOrder.replaceAll("AM", "")}";
                      }else{
                        dropOffController.finalUpOnRequestOrder.value ="${dropOffController.formattedDateUpOnRequest} ${dropOffController.upOnRequestHoursOrder.replaceAll("PM", "")}";
                      }
                      Navigator.pop(context);
                    } else {
                      Fluttertoast.showToast(
                          msg: "please_select_date_and_time_first".tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
                      );
                    }
                  }
                  else if (widget.from == "homeBasketSub") {
                    print("jjh "+dropOffController.homeBasketSubHours);
                          if (dropOffController.homeBasketSubDate != null &&
                              dropOffController.homeBasketSubHours != "") {
                            dropOffController.finalHomeBasketSubTime.value =
                            "${dropOffController.homeBasketSubDate} ${dropOffController.homeBasketSubHours}";
                            if(dropOffController.homeBasketSubOrder.contains("AM")){
                              dropOffController.finalHomeBasketSubOrder.value ="${dropOffController.formattedDateHomeBasket} ${dropOffController.homeBasketSubOrder.replaceAll("AM", "")}";
                            }else{
                              dropOffController.finalHomeBasketSubOrder.value ="${dropOffController.formattedDateHomeBasket} ${dropOffController.homeBasketSubOrder.replaceAll("PM", "")}";
                            }
                            Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(
                                msg: "please_select_date_and_time_first".tr(),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
                            );
                          }
                        }
                      },
                child: Text('confirm_time'.tr(),
                  style:  TextStyle(fontSize: 12.sp,
                      fontFamily: 'alexandria_medium',
                      fontWeight: FontWeight.w500,
                      color: Colors.white),),
              ),
            )
          ],
        ),
      ))
    :const Center(child: CircularProgressIndicator(color: MyColors.MainPrimary),));
  }

  Widget CustomBar(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 3.h,),
        Text("time_receipt".tr(),
          style:  TextStyle(fontSize: 14.sp,
              fontFamily: 'alexandria_bold',
              fontWeight: FontWeight.w600,
              color:MyColors.MainBulma),),
        SizedBox(height: 1.h,),
        Row(
          children: [
            SvgPicture.asset('assets/info_circle.svg'),
            SizedBox(width: 1.h,),
            SizedBox(
              width: 38.h,
              child: Text("please_specify".tr(),
                style:  TextStyle(fontSize: 8.sp,
                    fontFamily: 'alexandria_regular',
                    fontWeight: FontWeight.w300,
                    color:MyColors.MainTrunks),),
            ),
          ],
        ),
        SizedBox(height: 1.h,),
      ],
    );
  }

  Widget dateList() {
    return Container(
      height: 9.5.h,
      margin: EdgeInsetsDirectional.only(bottom: 1.5.h),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: dropOffController.pickUpDateList.length,
          itemBuilder: (context,int index){
            return DateDropItem(
              is_selected: selectedFlage==index,
              onTap: () {
                setState(() {
                  selectedFlage=index;
                  selectedFlageTime=null;
                  if(widget.from=="baskets") {
                    dropOffController.basketDate =dropOffController.pickupDateResponse.value.data![index].date.toString().replaceAll("/", "-");
                    print("jhhj ${dropOffController.basketDate}");
                    final inputFormat = DateFormat('dd-MM-yyyy');
                    DateTime date = inputFormat.parse(dropOffController.basketDate);
                    dropOffController.formattedDateBasket = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                    print("bgd ${dropOffController.formattedDateBasket}");
                    // ignore: use_build_context_synchronously
                    dropOffController.getPickUpHoursDates2(dropOffController.formattedDateBasket.toString(),context);
                  }else if(widget.from=="subscription"){
                    dropOffController.subscriptionDate =dropOffController.pickupDateResponse.value.data![index].date.toString().replaceAll("/", "-");
                    print("jhhj ${dropOffController.subscriptionDate}");
                    final inputFormat = DateFormat('dd-MM-yyyy');
                    DateTime date = inputFormat.parse(dropOffController.subscriptionDate);
                    dropOffController.formattedDateSubscription = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                    print("bgd ${dropOffController.formattedDateSubscription}");
                    // ignore: use_build_context_synchronously
                    dropOffController.getPickUpHoursDates2(dropOffController.formattedDateSubscription.toString(),context);
                  }else if(widget.from=="upOnRequest"){

                    dropOffController.upOnRequestDate =dropOffController.pickupDateResponse.value.data![index].date.toString().replaceAll("/", "-");
                    print("jhhj ${dropOffController.upOnRequestDate}");
                    final inputFormat = DateFormat('dd-MM-yyyy');
                    DateTime date = inputFormat.parse(dropOffController.upOnRequestDate);
                    dropOffController.formattedDateUpOnRequest = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                    print("bgd ${dropOffController.formattedDateUpOnRequest}");
                    // ignore: use_build_context_synchronously
                    dropOffController.getPickUpHoursDates2(dropOffController.formattedDateUpOnRequest.toString(),context);


                  }else if(widget.from=="homeBasketSub"){
                    dropOffController.homeBasketSubDate =dropOffController.pickupDateResponse.value.data![index].date.toString().replaceAll("/", "-");
                    print("jhhj ${dropOffController.homeBasketSubDate}");
                    final inputFormat = DateFormat('dd-MM-yyyy');
                    DateTime date = inputFormat.parse(dropOffController.homeBasketSubDate);
                    dropOffController.formattedDateHomeBasket = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                    print("bgd ${dropOffController.formattedDateHomeBasket}");
                    // ignore: use_build_context_synchronously
                    dropOffController.getPickUpHoursDates2(dropOffController.formattedDateHomeBasket.toString(),context);

                  }

                });
              },
                dropOffDates: dropOffController.pickUpDateList[index]
            );
          }
      ),
    );
  }

  Widget timeList() {
    if(dropOffController.hoursResponse.value.success==true&&dropOffController.pickUpHoursList.isNotEmpty){
      return SizedBox(
          height: 20.h,
          child:
          GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (6 / 2.5),
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: dropOffController.pickUpHoursList.length,
              itemBuilder: (context, int index) {
                return TimeDropItem(
                    is_selected: selectedFlageTime==index,
                    onTap:dropOffController.hoursResponse.value.data?.times?[index].isAvailable==true?
                        () {
                      setState(() {
                        selectedFlageTime=index;
                        if(widget.from=="baskets") {
                          dropOffController.basketHours = "${dropOffController.hoursResponse.value.data!.times?[index].from} to ${dropOffController.hoursResponse.value.data!.times?[index].to}";
                          dropOffController.basketHoursOrder = "${dropOffController.hoursResponse.value.data!.times?[index].to}";
                          dropOffController.ghassalBasketsController.calculateTotalPrice();
                          // "9:00 الى 12:00"; //outputFormat.format(dateTime);
                        }else if(widget.from=="subscription"){
                          dropOffController.subscriptionHours = "${dropOffController.hoursResponse.value.data!.times?[index].from} to ${dropOffController.hoursResponse.value.data!.times?[index].to}";
                          dropOffController.subscriptionHoursOrder = "${dropOffController.hoursResponse.value.data!.times?[index].to}";
                          dropOffController.ghassalSubscriptionController.calculateTotalPrice();
                        }else if(widget.from=="upOnRequest"){
                          dropOffController.upOnRequestHours =
                          "9:00 الى 12:00"; //outputFormat.format(dateTime);
                          dropOffController.upOnRequestHours = "${dropOffController.hoursResponse.value.data!.times?[index].from} to ${dropOffController.hoursResponse.value.data!.times?[index].to}";
                          dropOffController.upOnRequestHoursOrder = "${dropOffController.hoursResponse.value.data!.times?[index].to}";
                          dropOffController.ghassalUpOnRequestController.calculateTotalPrice();
                        }else if(widget.from=="homeBasketSub"){
                          dropOffController.homeBasketSubHours = "${dropOffController.hoursResponse.value.data!.times?[index].from} to ${dropOffController.hoursResponse.value.data!.times?[index].to}";
                          dropOffController.homeBasketSubOrder = "${dropOffController.hoursResponse.value.data!.times?[index].to}";
                          dropOffController.ghassalSubscriptionController.calculateTotalReSubscription();
                        }
                      });
                    }:null,
                    hours: dropOffController.pickUpHoursList[index]
                );
              }));
    }else{
      return Container(
          height: 20.h,
          child:empty()
      );
    }

  }

}

class empty extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      // margin: EdgeInsets.only(top: 60),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
             //SvgPicture.asset('assets/no_notifactions.svg',width: 90,height: 90,),
              Image.asset("assets/calendar_empty.png",width: 90,height: 90,),
              //SizedBox(height: 10,),
              Text('there_are_no_times'.tr(),
                style: TextStyle(fontSize: 14.sp,
                    fontFamily: 'alexandria_bold',
                    fontWeight: FontWeight.w600,
                    color: MyColors.MainTrunks),
                textAlign: TextAlign.center,
              ),
              //SizedBox(height: 10,),
              Text('your_times_will_appear_here'.tr(),
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
