
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

import '../../../../business/addressListController/AddressListController.dart';
import '../../../../business/auth/registerController/RegisterController.dart';
import '../../../../business/homeController/HomeController.dart';
import '../../../../conustant/my_colors.dart';
import '../../../../conustant/toast_class.dart';
import 'dart:math' as math;

class LocationScreen extends StatefulWidget{
  var from;
  LocationScreen(this.from);
  @override
  State<StatefulWidget> createState() {
    return _LocationScreen();
  }
}
const kGoogleApiKey = 'AIzaSyCCnt7HXFCbMv-KVWNIlpCu8iLGP7RCyCU';
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _LocationScreen extends State<LocationScreen> {
  final homeController = Get.put(HomeController());
  late  CameraPosition initialCameraPosition;
  Set<Marker> markersList = {};
  late GoogleMapController googleMapController;
  final Mode _mode = Mode.overlay;
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  var isSelected=true;
  int? itemId=1;
  var address;

  final registerController = Get.put(RegisterController());
  final addressListController = Get.put(AddressListController());


  @override
  void initState() {
    registerController.lat=homeController.lat;
    registerController.lng=homeController.lng;
    initialCameraPosition =
    CameraPosition(
        target:LatLng(registerController.lat,  registerController.lat), zoom: 14.0);
    _onMapTapped(LatLng(registerController.lat,registerController.lng));
       initialCameraPosition = CameraPosition(
        target: LatLng(homeController.lat, homeController.lng), zoom: 14.0);

    registerController.addressType="home";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
                Navigator.pop(context);
            },
            icon: Transform.rotate(
                angle:homeController.lang=="en"? 180 *math.pi /180:0,
                child: SvgPicture.asset('assets/back.svg'))
        ),
        title: Text(
            'delivery_location'.tr(),
            style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'alexandria_bold',
                fontWeight: FontWeight.w500,
                color: MyColors.MainBulma)),
      ),
      body:
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [

            GestureDetector(
              onTap: () {
                _handlePressButton();
              },
              child: Container(
                height: 8.h,
                margin:  EdgeInsetsDirectional.only(start: 2.5.h, end: 2.5.h),
                padding: EdgeInsetsDirectional.all(2.h),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(color: MyColors.MainGoku, width: 1.0,),
                    color: Colors.white),
                child: Location(),
              ),
            ),
            Container(
              margin: EdgeInsetsDirectional.only(top: 9.h),
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                initialCameraPosition: initialCameraPosition,
                markers: markersList,
                onTap: _onMapTapped,
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller) {
                  googleMapController = controller;
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 27.h,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(
                    color: MyColors.MainGoku,
                    width: 1.0,
                  ),
                  color: MyColors.MainGoku),
              padding: EdgeInsetsDirectional.all(1.5.h),
              margin:  EdgeInsetsDirectional.only(start: 1.h, end: 1.h,top: 1.h),
              child: FutureBuilder<String>(
                  future: getAddressFromLatLng(registerController.lat??"", registerController.lng??""),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return  SizedBox(
                          height: 3.h,
                          width: 5.w,
                          child: const CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text(
                          'Error: ${snapshot.error}');
                    } else {
                      pickUpAddress = snapshot.data;
                      return  Text(
                        textAlign: TextAlign.start,
                        pickUpAddress!,maxLines: 2,
                      );
                    }
                  }),
            ),
             SizedBox(height: 1.5.h,),
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    setState(() {
                      isSelected=true;
                      itemId=1;
                      registerController.addressType="home";
                      print("ooooooooooo");
                    });

                  },
                  child: Container(
                    height: 5.5.h,
                    width: 25.w,
                    margin:  EdgeInsetsDirectional.only(start: 1.h, end: 1.h),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        border: Border.all(color:isSelected==true && itemId==1? MyColors.MainPrimary:MyColors.MainGoku,
                          width: 1.0,),
                        color:isSelected==true && itemId==1? MyColors.MainPrimary:Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/home3.svg',color: isSelected==true && itemId==1?Colors.white:MyColors.MainTrunks),
                         SizedBox(width: 1.5.w,),
                        Text('home2'.tr(),
                            style:  TextStyle(fontSize: 8.sp,
                            fontFamily: 'alexandria_regular',
                            fontWeight: FontWeight.w400,
                            color:isSelected==true && itemId==1?Colors.white:MyColors.MainPrimary)),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      isSelected=true;
                      itemId=2;
                      registerController.addressType="work";
                      print("ppppppppppppp");
                    });

                  },
                  child: Container(
                    height: 5.5.h,
                    width: 25.w,
                    margin:  EdgeInsetsDirectional.only(start: 1.h, end: 1.h),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                          color: isSelected==true && itemId==2? MyColors.MainPrimary:MyColors.MainGoku, width: 1.0,),
                        color: isSelected==true && itemId==2? MyColors.MainPrimary:Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/building.svg',color: isSelected==true && itemId==2?Colors.white:MyColors.MainTrunks),
                         SizedBox(width: 1.5.w,),
                        Text('work'.tr(),
                            style:  TextStyle(fontSize: 8.sp,
                                fontFamily: 'alexandria_regular',
                                fontWeight: FontWeight.w400,
                                color:isSelected==true && itemId==2?Colors.white:MyColors.MainPrimary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
             SizedBox(height: 2.h,),
            Container(
              width: double.infinity,
              height: 7.h,
              margin:  EdgeInsetsDirectional.only(start: 2.5.h, end: 2.5.h),
              child: TextButton(
                style: flatButtonStyle,
                onPressed: () {
                  if(widget.from=="listAddress"){
                    if(registerController.lat==""
                    ||registerController.lng==""
                    ||registerController.address2.value==""
                    ||registerController.addressType==""){
                      ToastClass.showCustomToast(context, "Enter All Data", "error");
                    }else{
                      addressListController.addAddress(
                          context,
                          registerController.lat,
                          registerController.lng,
                          registerController.address2.value,registerController.addressType);
                    }
                  }else if(widget.from=="sub"){
                    if(registerController.lat==""
                        ||registerController.lng==""
                        ||registerController.address2.value==""
                        ||registerController.addressType==""){
                      ToastClass.showCustomToast(context, "Enter All Data", "error");
                    }else{
                      addressListController.addAddress(
                          context,
                          registerController.lat,
                          registerController.lng,
                          registerController.address2.value,registerController.addressType);


                    }
                  }
                  else{
                    if(registerController.lat==""
                        ||registerController.lng==""
                        ||registerController.address2.value==""
                        ||registerController.addressType==""){
                      ToastClass.showCustomToast(context, "Enter All Data", "error");
                    }else{
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text('confirm_address'.tr(),
                  style:  TextStyle(fontSize: 12.sp,
                      fontFamily: 'alexandria_bold',
                      fontWeight: FontWeight.w500,
                      color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Location() {
    return Row(
      children: [
        SvgPicture.asset('assets/location2.svg',),
         SizedBox(width: 2.w,),
        Text(
            'search_for_your_address'.tr(),
            style:  TextStyle(fontSize: 12.sp,
            fontFamily: 'alexandria_regular',
            fontWeight: FontWeight.w300,
            color: MyColors.MainBulma)),
      ],
    );
  }

///this to handle if press in search
  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white))),
        components: [Component(Component.country, "eg"),]);


    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response) {
    print("ddd" + response.errorMessage!.toString());
    ToastClass.showCustomToast(context, response.errorMessage!, 'error');
  }


  ///this to handle if press in search
  Future<void> displayPrediction(Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    double latitude = detail.result.geometry!.location.lat;
    double longitude = detail.result.geometry!.location.lng;

    markersList.clear();
    markersList.add(
      Marker(
        markerId: const MarkerId("0"),
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(title: detail.result.name),
      ),
    );
    googleMapController.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), 14.0),
    );
    address = await getAddressFromLatLng(latitude.toString(), longitude.toString());
    setState(() {
        registerController.lat=latitude.toString();
        registerController.lng=longitude.toString();
    });
    pickUpAddress = address;
    print("lop1" + address.toString());
  }

  ///this handle if press in map to display marker
  void _onMapTapped(LatLng position) async {
    setState(() {
      markersList.clear(); // Clear previous markers
      markersList.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: InfoWindow(
            title: 'Marker',
            snippet: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
          ),
        ),
      );
      address= getAddressFromLatLng(position.latitude,position.longitude);
      print("lop2"+address.toString());

      registerController.lat = position.latitude.toString();
      registerController.lng = position.longitude.toString();
    });
  }

  String? pickUpAddress = 'Loading...';

  ///this to handle get address name from lat and lng
  Future<String> getAddressFromLatLng(dynamic latitude, longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          double.parse(latitude), double.parse(longitude));

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];

        registerController.address2.value =
            '${placemark.street}, ${placemark.locality}, ${placemark.country}';
          return registerController.address2.value;

      } else {
        return "Address not found";
      }
    } catch (e) {
      return "";
    }
  }




}