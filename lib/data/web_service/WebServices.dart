import 'package:dio/dio.dart' as dio1;
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';

import '../../conustant/di.dart';
import '../../conustant/my_colors.dart';
import '../../conustant/shared_preference_serv.dart';
import '../model/FaqsModel/FaqsResponse.dart';
import '../model/TermsAndConditionsModel/TermsAndConditionsResponse.dart';
import '../model/UpdateStatusModel/UpdateStatusResponse.dart';
import '../model/aboutAsModel/AboutAsResponse.dart';
import '../model/addressModel/addAddressModel/AddAddressResponse.dart';
import '../model/addressModel/addressListModel/AddressListResponse.dart';
import '../model/addressModel/deleteModel/DeleteResponse.dart';
import '../model/addressModel/editAddressModel/EditAddressResponse.dart';
import '../model/auth/createUserModel/CompleteUserInfoResponse.dart';
import '../model/auth/introModel/IntroResponse.dart';
import '../model/auth/loginModel/LoginResponse.dart';
import '../model/auth/verifyModel/VerifyCodeResponse.dart';
import '../model/auth/verifyModel/resendModel/ResendCodeResponse.dart';
import '../model/basketModel/BasketListResponse.dart';
import '../model/copunModel/CopunResponse.dart';
import '../model/createOrderBasketModel/CreateOrderBasketResponse.dart';
import '../model/createOrderModel/CreateOrderResponse.dart';
import '../model/homeModel/HomeResponse.dart';
import '../model/hoursModel/HoursResponse.dart';
import '../model/myOrdersModel/MyOrdersRespons.dart';
import '../model/notificationModel/NotificationResponse.dart';
import '../model/orderDetailsModel/OrderDetailsResponse.dart';
import '../model/pickupDateModel/PickupDateResponse.dart';
import '../model/preferencesModel/PreferencesResponse.dart';
import '../model/productModel/ProductResponse.dart';
import '../model/rateOrderModel/RateOrderResponse.dart';
import '../model/resubscribtionModel/ResubscribtionResponse.dart';
import '../model/socialModel/SocialResponse.dart';
import '../model/subscriptionsModel/SubscriptionsResponse.dart';
import '../model/updateTokenModel/UpdateTokenResponse.dart';
import '../model/urgentPriceModel/UrgentPriceResponse.dart';
import '../model/videoModel/VideoResponse.dart';

///this class for connect with apis
class WebService {
  late dio1.Dio dio;
  late dio1.BaseOptions options;
  var baseUrl = "https://ghassal.mtjrsahl-ksa.com/api";
  final SharedPreferencesService sharedPreferencesService =
  instance<SharedPreferencesService>();
  // var language;
  // var userToken;

  WebService() {
    options = dio1.BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(milliseconds: 70 * 1000),
      receiveTimeout: Duration(milliseconds: 70 * 1000),
    );
    dio = dio1.Dio(options);
  }

  void handleError(DioException e) {
    String message = '';

    if (e.error is SocketException) {
      message = 'No internet connection';
    }  else if (e.response != null) {
      if(e.response?.statusCode==400){
        dynamic responseData = e.response!.data['message'];
      }
      if (e.response?.statusCode == 422) {
        dynamic responseData = e.response!.data['message'];

        if (responseData is List) {
          if (responseData.isNotEmpty) {
            message = responseData[0];
          }
        } else
        if (responseData is String) {
          message = responseData;
        } else {
          message = 'An error occurred';
        }
      } else {
        message = '${e.response}';
      }
    } else if (e.type == DioExceptionType.cancel) {
      message = 'Request was canceled';
    } else {
      message = 'An error occurred';
    }
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,backgroundColor: MyColors.SupportiveChichi
    );
    print("jkjkjkjik"+message);
  }

  Future<IntroResponse> getIntro()async{
    try {
    var Url="/introduction_screens";
    print(Url);
    print(options.baseUrl+Url);
    dio1.Response response = await dio.get(Url, //data: params,
        options: dio1.Options(
          headers: {
            "Locale": sharedPreferencesService.getString("lang"),
          },
        )
    );
    print(response);
    return IntroResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return IntroResponse();
    }
  }

  Future<LoginResponse> login(String phone,String code)async{
    try {
      var LoginUrl="/login";
      print(LoginUrl);
      var params={
        'mobile': phone,
        'refer_code': code,
      };
      print(options.baseUrl+LoginUrl+params.toString());
      dio1.Response response = await dio.post(LoginUrl, data: params);
      print(response);
      if(response.statusCode==200){
        print("klkl"+LoginResponse.fromJson(response.data).toString());
        return LoginResponse.fromJson(response.data);
      }else{
        print("klkl121"+response.statusMessage.toString());
        return LoginResponse();
      }
    }catch(e){
      print(e.toString());
      return LoginResponse();
    }
  }

  Future<VerifyCodeResponse> verifyCode(String code)async{
    try {
      var LoginUrl="/verify_mobile";
      print(LoginUrl);
      var params={
        'code': code,
      };
      print(options.baseUrl+LoginUrl+params.toString());
      dio1.Response response = await dio.post(LoginUrl, data: params,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          ));
      print(response);
      if(response.statusCode==200){
        print("klkl"+VerifyCodeResponse.fromJson(response.data).toString());
        return VerifyCodeResponse.fromJson(response.data);
      }else{
        print("klkl121"+response.statusMessage.toString());
        return VerifyCodeResponse();
      }
    }catch(e){
      print(e.toString());
      return VerifyCodeResponse();
    }
  }

  Future<ResendCodeResponse> resendCode()async{
    try {
      var LoginUrl="/resend_code";
      print(LoginUrl);
      print(options.baseUrl+LoginUrl);
      dio1.Response response = await dio.post(LoginUrl,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("tokenUser"),
            },
          ));
      print(response);
      if(response.statusCode==200){
        print("klkl"+ResendCodeResponse.fromJson(response.data).toString());
        return ResendCodeResponse.fromJson(response.data);
      }else{
        print("klkl121"+response.statusMessage.toString());
        return ResendCodeResponse();
      }
    }catch(e){
      print(e.toString());
      return ResendCodeResponse();
    }
  }

  Future<CompleteUserInfoResponse> completeUserInfo(String name,
      String streetName,
      String type,String lat,String lng,
      String email,
      String phone)async{
    try {
      var Url="/update_user";
      print(Url);
      if(streetName==""){
        var params={
          'name': name,
          'email': email,
          'mobile': phone,
        };
        print(options.baseUrl+Url+params.toString());
        dio1.Response response = await dio.post(Url,data: params,
            options: dio1.Options(
              headers: {
                "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
                "Locale": sharedPreferencesService.getString("lang"),
                "Accept": "application/json",
              },
            ));
        print(response);
        print("klkl"+CompleteUserInfoResponse.fromJson(response.data).toString());
        return CompleteUserInfoResponse.fromJson(response.data);
      }else{
        var params={
          'name': name,
          'email': email,
          'mobile': phone,
          'street_name':streetName,
          'type':type,
          'lat':lat,
          'lng':lng,
        };
        print(options.baseUrl+Url+params.toString());
        dio1.Response response = await dio.post(Url,data: params,
            options: dio1.Options(
              headers: {
                "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
                "Locale": sharedPreferencesService.getString("lang"),
                "Accept": "application/json",
              },
            ));
        print(response);
        if(response.statusCode==200){
          print("klkl"+CompleteUserInfoResponse.fromJson(response.data).toString());
          return CompleteUserInfoResponse.fromJson(response.data);
        }else{
          print("klkl121"+response.statusMessage.toString());
          return CompleteUserInfoResponse();
        }
      }
    }on DioException  catch(e){
      print(e.toString());
      handleError(e);
      return CompleteUserInfoResponse();
    }
  }

  Future<dynamic> updateProfile(String name,String email,String mobile)async{
    try {
      var Url="/update_user";
      print(Url);
      var params ={
        'name': name,
        'email': email,
        'mobile':mobile,
      };
      print(options.baseUrl+Url+params.toString());
      dio1.Response response = await dio.post(Url,data: params,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
              "Accept": "application/json",
            },
          ));
      print(response);
      if(response.statusCode==200){
        print("klkl"+CompleteUserInfoResponse.fromJson(response.data).toString());
        return CompleteUserInfoResponse.fromJson(response.data);
      }else{
        print("klkl121"+response.statusMessage.toString());
        return CompleteUserInfoResponse();
      }
    }on DioException  catch(e){
      print(e.toString());
      handleError(e);
      return CompleteUserInfoResponse();
    }
  }


  Future<FaqsResponse> faqs(String type)async{
    try {
      var Url="/common/faqs";
      print(Url);
      print(Url);
      var params={
        'type': type,
      };
      print(options.baseUrl+Url+params.toString());
      dio1.Response response = await dio.post(Url,data: params,
          options: dio1.Options(
            headers: {
              // "authorization": "Bearer ${sharedPreferencesService.getString(
              //     "tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return FaqsResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return FaqsResponse();
    }
  }

  Future<TermsAndConditionsResponse> termsAndCondition()async{
    try {
      var Url="/common/page/terms-and-conditions";
      print(Url);
      print(options.baseUrl+Url);
      dio1.Response response = await dio.get(Url,
          options: dio1.Options(
            headers: {
              // "authorization": "Bearer ${sharedPreferencesService.getString(
              //     "tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return TermsAndConditionsResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return TermsAndConditionsResponse();
    }
  }

  Future<AboutAsResponse> aboutUs()async{
    try {
      var Url="/common/page/about-us";
      print(Url);
      print(options.baseUrl+Url);
      dio1.Response response = await dio.get(Url,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString(
                  "tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return AboutAsResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return AboutAsResponse();
    }
  }

  Future<SocialResponse> getSocialLinks()async{
    try {
      var Url="/common/settings?";
      print(Url);
      var params={
        'keys[]': ["contact_us","social_media_links"],
      };
      print(options.baseUrl+Url+params.toString());
      dio1.Response response = await dio.get(Url,queryParameters: params,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString(
                  "tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return SocialResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return SocialResponse();
    }
  }

  Future<AddressListResponse> getAddress()async{
    try {
      var Url="/addresses/list";
      print(Url);
      print(options.baseUrl+Url);
      dio1.Response response = await dio.get(Url,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return AddressListResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return AddressListResponse();
    }
  }

  Future<DeleteResponse> deleteAddress(int id)async{
    try {
      var Url="/addresses/delete/$id";
      print(Url);
      print(options.baseUrl+Url);
      dio1.Response response = await dio.delete(Url,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return DeleteResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return DeleteResponse();
    }
  }

  Future<AddAddressResponse> addAddress(String address,String lat,String lng,String type)async{
    try {
      var LoginUrl="/addresses/create";
      print(LoginUrl);
      var params={
        'street_name': address,
        'lat': lat,
        'lng': lng,
        'type': type,
      };
      print(options.baseUrl+LoginUrl+params.toString());
      dio1.Response response = await dio.post(LoginUrl,data: params,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          ));
      print(response);
      return AddAddressResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return AddAddressResponse();
    }
  }

  Future<EditAddressResponse> editAddress(String address,String lat,String lng,String type,int id)async{
    try {
      var LoginUrl="/addresses/update/$id";
      print(LoginUrl);
      var params={
        'street_name': address,
        'lat': lat,
        'lng': lng,
        'type': type,
      };
      print(options.baseUrl+LoginUrl+params.toString());
      dio1.Response response = await dio.post(LoginUrl,data: params,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          ));
      print(response);
      return EditAddressResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return EditAddressResponse();
    }
  }

  Future<BasketListResponse> getBaskets(String lat,String lng)async{
    try {
      var Url="/baskets?";
      var params={
        'lat': lat,
        'lng': lng
      };
      print(options.baseUrl+Url+params.toString());
      dio1.Response response = await dio.get(Url,queryParameters: params,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return BasketListResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return BasketListResponse();
    }
  }

  Future<PreferencesResponse> getPreferences(String lat,String lng)async{
    try {
      var Url="/preferences?";
      var params={
        'lat': lat,
        'lng': lng
      };
      print(options.baseUrl+Url+params.toString());
      dio1.Response response = await dio.get(Url,queryParameters: params,
          options: dio1.Options(
            headers: {
              // "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return PreferencesResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return PreferencesResponse();
    }
  }

  Future<HomeResponse> getHomeData(String lat,String lng)async{
    //try {
      var Url="/home_page?";
      var params={
        'lat': lat,
        'lng': lng
      };
      print(options.baseUrl+Url+params.toString());
      dio1.Response response = await dio.get(Url,queryParameters: params,
          options:
          // ignore: unrelated_type_equality_checks
          sharedPreferencesService.getBool("islogin")==true?
          dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          ):dio1.Options(
            headers: {
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return HomeResponse.fromJson(response.data);
    // }catch(e){
    //   print(e.toString());
    //   return HomeResponse();
    // }
  }

  Future<CreateOrderResponse> createOrderBasket(
      String addressId,
      int couponId,
      String type,
      String deliveryDate,
      String payment,
      String notes,
      String totalAfterDiscount,
      String discount,
      String total,
      String products)async{
    try {
      var Url="/order/create";
      var params={};
      if(couponId==0){
        params={
          'address_id': addressId,
          'type':type,
          'delivery_date':"",
          'received_date':deliveryDate,
          'payment':payment,
          'notes':notes,
          'total_after_discount':totalAfterDiscount,
          'discount':discount,
          'total':total,
          'products':products,
          'order_type':"baskets"
        };
      }else{
        params={
          'address_id': addressId,
          'type':type,
          'delivery_date':"",
          'received_date':deliveryDate,
          'payment':payment,
          'notes':notes,
          'total_after_discount':totalAfterDiscount,
          'discount':discount,
          'total':total,
          'products':products,
          'order_type':"baskets"
        };
      }

      print(options.baseUrl+Url+params.toString());
      dio1.Response response = await dio.post(Url,data: params,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return CreateOrderResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return CreateOrderResponse();
    }
  }

  Future<CreateOrderResponse> createOrderUpOnRequest(
      String addressId,
      int couponId,
      String type,
      String deliveryDate,
      String payment,
      String notes,
      String totalAfterDiscount,
      String discount,
      String total,
      String products,
      String prefernse)async{
    try {
      var Url="/order/create";
      var params={};
      if(couponId==0){
        if(prefernse=="") {
          params = {
            'address_id': addressId,
            'type': type,
            'delivery_date': "",
            'received_date': deliveryDate,
            'payment': payment,
            'notes': notes,
            'total_after_discount': totalAfterDiscount,
            'discount': discount,
            'total': total,
            'products': products,
            'prefrences': '[]',
            'order_type': "products"
          };
        }else{
          params = {
            'address_id': addressId,
            'type': type,
            'delivery_date': "",
            'received_date': deliveryDate,
            'payment': payment,
            'notes': notes,
            'total_after_discount': totalAfterDiscount,
            'discount': discount,
            'total': total,
            'products': products,
            'prefrences': prefernse,
            'order_type': "products"
          };
        }
      }else{
        if(prefernse=="") {
          params = {
            'address_id': addressId,
            'type': type,
            'delivery_date': "",
            'received_date': deliveryDate,
            'payment': payment,
            'notes': notes,
            'total_after_discount': totalAfterDiscount,
            'discount': discount,
            'total': total,
            'products': products,
            'prefrences': '[]',
            'order_type': "products"
          };
        }else{
          params = {
            'address_id': addressId,
            'type': type,
            'delivery_date': "",
            'received_date': deliveryDate,
            'payment': payment,
            'notes': notes,
            'total_after_discount': totalAfterDiscount,
            'discount': discount,
            'total': total,
            'products': products,
            'prefrences': prefernse,
            'order_type': "products"
          };
        }
      }

      print(options.baseUrl+Url+params.toString());
      dio1.Response response = await dio.post(Url,data: params,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return CreateOrderResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return CreateOrderResponse();
    }
  }


  Future<CreateOrderResponse> createOrderSubscription(
      String addressId,
      int couponId,
      String type,
      String deliveryDate,
      String payment,
      String notes,
      String totalAfterDiscount,
      String discount,
      String total,
      String products,
      String preference)async{
    //try {
      var Url="/order/create";
      var params={};
      if(couponId==0){
        if(preference=="") {
          params = {
            'address_id': addressId,
            'type': type,
            'delivery_date': "",
            'received_date': deliveryDate,
            'payment': payment,
            'notes': notes,
            'total_after_discount': totalAfterDiscount,
            'discount': discount,
            'total': total,
            'products': products,
            'prefrences': '[]',
            'order_type':"subscribtions"
          };
        }else{
          params = {
            'address_id': addressId,
            'type': type,
            'delivery_date': "",
            'received_date': deliveryDate,
            'payment': payment,
            'notes': notes,
            'total_after_discount': totalAfterDiscount,
            'discount': discount,
            'total': total,
            'products': products,
            'prefrences': preference,
            'order_type':"subscribtions"
          };
        }
      }else{
        if(preference=="") {
          params = {
            'address_id': addressId,
            'type': type,
            'delivery_date': "",
            'received_date': deliveryDate,
            'payment': payment,
            'notes': notes,
            'total_after_discount': totalAfterDiscount,
            'discount': discount,
            'total': total,
            'products': products,
            'prefrences': '[]',
            'order_type':"subscribtions"
          };
        }else{
          params = {
            'address_id': addressId,
            'type': type,
            'delivery_date': "",
            'received_date': deliveryDate,
            'payment': payment,
            'notes': notes,
            'total_after_discount': totalAfterDiscount,
            'discount': discount,
            'total': total,
            'products': products,
            'prefrences': preference,
            'order_type':"subscribtions"
          };
        }
      }

      print(options.baseUrl+Url+params.toString());
      dio1.Response response = await dio.post(Url,data: params,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return CreateOrderResponse.fromJson(response.data);
    // }catch(e){
    //   print(e.toString());
    //   return CreateOrderResponse();
    // }
  }

  Future<copunResponse> validateCoupon(String code)async{
    try {
      var Url="/common/validate_coupon";
      print(Url);
      var params={
        'code': code,
      };
      print(options.baseUrl+Url+params.toString());
      dio1.Response response = await dio.get(Url,queryParameters: params,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString(
                  "tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return copunResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return copunResponse();
    }
  }

  Future<PickupDateResponse> getPickupDate()async{
    try {
      var Url="/branchs/pickup_dates";
      print(Url);
      print(options.baseUrl+Url);
      dio1.Response response = await dio.get(Url,
          options: dio1.Options(
            headers: {
              //"authorization": "Bearer ${userToken}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return PickupDateResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return PickupDateResponse();
    }
  }

  Future<HoursResponse> getHours(String date,String addressId,String dateType)async{
    try {
      var Url="/branchs/working_hours";
      print(Url);
      var params={
        'date': date,
        'address_id': addressId,
        'date_type': dateType,
      };
      print(options.baseUrl+Url+params.toString());
      dio1.Response response = await dio.get(Url,queryParameters: params,
          options: dio1.Options(
            headers: {
              //"authorization": "Bearer ${userToken}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return HoursResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return HoursResponse();
    }
  }

  Future<MyOrdersRespons> getMyOrders(String status,String date,String type,String id)async{
    try {
      var Url="/order/list?";
      print(Url);
      var params={
        'status': status,
        'date': date,
        'type': type,
        'id': id,
      };
      print(options.baseUrl+Url+params.toString());
      dio1.Response response = await dio.get(Url,queryParameters: params,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString(
                  "tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return MyOrdersRespons.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return MyOrdersRespons();
    }
  }

  Future<OrderDetailsResponse> getOrderDetails(String id)async{
    try {
      var Url="/order/details/$id";
      print(options.baseUrl+Url);
      dio1.Response response = await dio.get(Url,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString(
                  "tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return OrderDetailsResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return OrderDetailsResponse();
    }
  }


  Future<DeleteResponse> deleteOrder(String id)async{
    try {
      var Url="/order/cancel";
      print(Url);
      var params={
        'order_id': id,
      };
      print(options.baseUrl+Url+params.toString());
      dio1.Response response = await dio.post(Url,data: params,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return DeleteResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return DeleteResponse();
    }
  }

  Future<UpdateStatusResponse> updateOrderStatus(int id,String status,String transactionId,String userId)async{
    try {
      var Url="/orders/updateOrderStatus";
      print(Url);
      var params={
        'order_id':id,
        'status':status,
        'transaction_id':transactionId,
        'user_sub_id':userId
      };
      print(options.baseUrl+Url+params.toString());
      dio1.Response response = await dio.post(Url,data: params,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return UpdateStatusResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return UpdateStatusResponse();
    }
  }

  Future<UpdateStatusResponse> updatePaymentStatus(int id,String status,String transactionId)async{
    try {
      var Url="/order/updatePaymentStatus";
      print(Url);
      var params={
        'order_id':id,
        'status':status,
        'transaction_id':transactionId
      };
      print(options.baseUrl+Url+params.toString());
      dio1.Response response = await dio.post(Url,data: params,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return UpdateStatusResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return UpdateStatusResponse();
    }
  }

  Future<SubscriptionsResponse> getSubscriptions(String lat,String lng)async{
    try {
      var Url="/subscribtions?";
      var params={
        'lat':lat,
        'lng':lng
      };
      print(options.baseUrl+Url+params.toString());
      dio1.Response response = await dio.get(Url,queryParameters: params,
          options: dio1.Options(
            headers: {
              /*"authorization": "Bearer ${sharedPreferencesService.getString(
                  "tokenUser")}",*/
              "Locale": sharedPreferencesService.getString("lang"),
              "Accept": "application/json",
            },
          )
      );
      print(response);
      return SubscriptionsResponse.fromJson(response.data);
    }on DioException  catch(e){
      print(e.toString());
      handleError(e);
      return SubscriptionsResponse();
    }
  }

  Future<VideoResponse> getVideo()async{
    try {
      var Url="/common/video_method";
      print(options.baseUrl+Url);
      dio1.Response response = await dio.get(Url);
      print(response);
      return VideoResponse.fromJson(response.data);
    }on DioException  catch(e){
      print(e.toString());
      handleError(e);
      return VideoResponse();
    }
  }

  Future<ResubscribtionResponse> reSubscription(
      String addressId,
      String deliveryDate,
      String notes,
      String preference,
      int userSubId,
      int deliveryCost,
      String orderType,
      String total,
      String payment
      )async{
    try {
      var Url="/subscribtions/resubscribtion";
      var params = {
        'address_id': addressId,
        'delivery_date': "",
        'received_date': deliveryDate,
        'notes': notes,
        'prefrences': preference,
        'user_sub_id': userSubId,
        'delivery_cost': deliveryCost,
        'type': orderType,
        'total': total,
        'payment': payment
      };
      print(options.baseUrl+Url+params.toString());
      dio1.Response response = await dio.post(Url,data: params,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return ResubscribtionResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return ResubscribtionResponse();
    }
  }

  Future<ProductResponse> getProductCat(String lat,String lng)async{
    try {
      var Url="/categories/list?";
      var params={
        'lat':lat,
        'lng':lng
      };
      print(options.baseUrl+Url+params.toString());
      dio1.Response response = await dio.get(Url,queryParameters: params,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString(
                  "tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
              "Accept": "application/json",
            },
          )
      );
      print(response);
      return ProductResponse.fromJson(response.data);
    }on DioException  catch(e){
      print(e.toString());
      handleError(e);
      return ProductResponse();
    }
  }

  Future<NotificationResponse> getNotificationData()async{
    print("tokkk"+sharedPreferencesService.getString("tokenUser"));
    try {
      var Url="/notifications/list";
      print(Url);
      print(options.baseUrl+Url);
      dio1.Response response = await dio.get(Url,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return NotificationResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return NotificationResponse();
    }
  }

  Future<UpdateTokenResponse?> UpdateToken(String token)async{
    var params;
    try {
      var HomeUrl="/update_token";
      if(Platform.isIOS){
        params={
          'ios_token': token,
        };
      }else{
        params={
          'android_token': token,
        };
      }
      print(options.baseUrl+HomeUrl+params.toString());
      dio1.Response response = await dio.post(
          HomeUrl,
          data: params,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print("tokenre"+response.toString());
      return UpdateTokenResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return UpdateTokenResponse();
    }
  }

  Future<RateOrderResponse> rateOrder(
      int id,
      String note,
      String wash,
      String ironing,
      String driverStars,
      )async{
    try {
      var Url="/order/rate";
        print(Url);
        var params={
          'order_id': id,
          'note': note,
          'wash': wash,
          'ironing': ironing,
          'driver_stars': driverStars,
        };
        print(options.baseUrl+Url+params.toString());
        dio1.Response response = await dio.post(Url,data: params,
            options: dio1.Options(
              headers: {
                "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
                "Locale": sharedPreferencesService.getString("lang"),
              },
            )
        );
        print(response);
        return RateOrderResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return RateOrderResponse();
    }
  }

  Future<UrgentPriceResponse> getUrgentPrice()async{
    try {
      var Url="/common/settings?";
      print(Url);
      var params={
        'keys[]': ["urgent_price"],
      };
      print(options.baseUrl+Url+params.toString());
      dio1.Response response = await dio.get(Url,queryParameters: params,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString(
                  "tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return UrgentPriceResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return UrgentPriceResponse();
    }
  }

}