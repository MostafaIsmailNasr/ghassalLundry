
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

import 'dart:math' as math;

import '../../../../../business/addressListController/AddressListController.dart';
import '../../../../../business/auth/registerController/RegisterController.dart';
import '../../../../../business/homeController/HomeController.dart';
import '../../../../../conustant/my_colors.dart';
import '../../../../../conustant/toast_class.dart';

class EditLocationScreen extends StatefulWidget{
  var latedit;
  var lngedit;
  var addressEdit;
  var id;
  var typeEd;
  var isSelected2;
  var itemId2;

  EditLocationScreen(
      {required this.latedit,
        required this.lngedit,
        required this.addressEdit,
        required this.id,
        required this.typeEd,
        required this.isSelected2,required this.itemId2});

  @override
  State<StatefulWidget> createState() {
    return _LocationScreen();
  }
}
const kGoogleApiKey = 'AIzaSyCCnt7HXFCbMv-KVWNIlpCu8iLGP7RCyCU';
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _LocationScreen extends State<EditLocationScreen> {
  final homeController = Get.put(HomeController());
  late  CameraPosition initialCameraPosition;
  Set<Marker> markersList = {};
  late GoogleMapController googleMapController;
  final Mode _mode = Mode.overlay;
  var lat;
  var lng;
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ));
  var isSelected=false;
  int? itemId=0;
  var address;

  final addressListController = Get.put(AddressListController());
  final registerController = Get.put(RegisterController());


  @override
  void initState() {
    lat=widget.latedit;
    lng=widget.lngedit;
    initialCameraPosition =
    widget.latedit!=null&& widget.lngedit!=null?
    CameraPosition(
        target:LatLng(double.parse(widget.latedit), double.parse(widget.lngedit)), zoom: 14.0):
    const CameraPosition(
        target:LatLng(30.052417, 31.326583), zoom: 14.0);
    _onMapTapped(LatLng(double.parse(lat),double.parse(lng)));

    super.initState();
  }

  // @override
  // void initState() {
  //   registerController.lat=homeController.lat;
  //   registerController.lng=homeController.lng;
  //   initialCameraPosition =
  //       CameraPosition(
  //           target:LatLng(registerController.lat,  registerController.lat), zoom: 14.0);
  //   _onMapTapped(LatLng(registerController.lat,registerController.lng));
  //   initialCameraPosition = CameraPosition(
  //       target: LatLng(homeController.lat, homeController.lng), zoom: 14.0);
  //
  //   registerController.addressType="home";
  //   super.initState();
  // }

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
                  future: getAddressFromLatLng(lat??"", lng??""),
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
                      widget.typeEd=registerController.addressType;
                      print("ooooooooooo");
                    });

                  },
                  child: Container(
                    height: 5.5.h,
                    width: 25.w,
                    margin:  EdgeInsetsDirectional.only(start: 1.h, end: 1.h),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        border: Border.all(color:((isSelected==true && itemId==1)||(widget.isSelected2==true && widget.itemId2==1 &&widget.typeEd=="home"))? MyColors.MainPrimary:MyColors.MainGoku,
                          width: 1.0,),
                        color:((isSelected==true && itemId==1)||(widget.isSelected2==true && widget.itemId2==1 &&widget.typeEd=="home"))? MyColors.MainPrimary:Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/home3.svg',color: ((isSelected==true && itemId==1)||(widget.isSelected2==true && widget.itemId2==1 &&widget.typeEd=="home"))?Colors.white:MyColors.MainTrunks),
                        SizedBox(width: 1.5.w,),
                        Text('home2'.tr(),
                            style:  TextStyle(fontSize: 8.sp,
                                fontFamily: 'alexandria_regular',
                                fontWeight: FontWeight.w400,
                                color:((isSelected==true && itemId==1)||(widget.isSelected2==true && widget.itemId2==1 &&widget.typeEd=="home"))?Colors.white:MyColors.MainPrimary)),
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
                      widget.typeEd=registerController.addressType;
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
                          color: ((isSelected==true && itemId==2)||(widget.isSelected2==true && widget.itemId2==2 &&widget.typeEd=="work"))? MyColors.MainPrimary:MyColors.MainGoku, width: 1.0,),
                        color: ((isSelected==true && itemId==2)||(widget.isSelected2==true && widget.itemId2==2 &&widget.typeEd=="work"))? MyColors.MainPrimary:Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/building.svg',color: ((isSelected==true && itemId==2)||(widget.isSelected2==true && widget.itemId2==2 &&widget.typeEd=="work"))?Colors.white:MyColors.MainTrunks),
                        SizedBox(width: 1.5.w,),
                        Text('work'.tr(),
                            style:  TextStyle(fontSize: 8.sp,
                                fontFamily: 'alexandria_regular',
                                fontWeight: FontWeight.w400,
                                color:((isSelected==true && itemId==2)||(widget.isSelected2==true && widget.itemId2==2 &&widget.typeEd=="work"))?Colors.white:MyColors.MainPrimary)),
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
                    addressListController.editAddress(context, lat, lng,widget.addressEdit,widget.id,widget.typeEd);
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
    Fluttertoast.showToast(
        msg: response.errorMessage??"",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
    );
  }


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
      lat=latitude.toString();
      lng=longitude.toString();
    });
    pickUpAddress = address;
    print("lop1" + address.toString());
  }

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

      lat = position.latitude.toString();
      lng = position.longitude.toString();
    });
  }

  String? pickUpAddress = 'Loading...';

  Future<String> getAddressFromLatLng(dynamic latitude, longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          double.parse(latitude), double.parse(longitude));

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String address =
            '${placemark.street}, ${placemark.locality}, ${placemark.country}';
        widget.addressEdit=address;
        log("adresss"+address.toString());

        return address;
      } else {
        return "Address not found";
      }
    } catch (e) {
      return "";
    }
  }




}