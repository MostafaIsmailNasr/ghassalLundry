import 'dart:ffi';
import 'dart:io';
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
import '../web_service/WebServices.dart';

///this class connect with webservice and hide the process of all func
class Repo {
  WebService webService;
  Repo(this.webService);

  Future<IntroResponse> getIntro()async{
    final intro=await webService.getIntro();
    return intro;
  }

  Future<LoginResponse> login(String phone,String code)async{
    final login=await webService.login(phone,code);
    return login;
  }

  Future<VerifyCodeResponse> verifyCode(String code)async{
    final verify=await webService.verifyCode(code);
    return verify;
  }

  Future<ResendCodeResponse> resendCode()async{
    final resend=await webService.resendCode();
    return resend;
  }

  Future<CompleteUserInfoResponse> completeUserInfo(String name,
      String streetName,
      String type,String lat,String lng,
      String email,String phone)async{
    final completeUserInfo=await webService.completeUserInfo(name, streetName, type, lat, lng, email,phone);
    return completeUserInfo;
  }

  Future<CompleteUserInfoResponse> updateProfile(String name,String email,String mobile)async{
    final update=await webService.updateProfile(name, email, mobile);
    return update;
  }

  Future<FaqsResponse> faqs(String type)async{
    final faqs=await webService.faqs(type);
    return faqs;
  }

  Future<TermsAndConditionsResponse> termsAndCondition()async{
    final terms=await webService.termsAndCondition();
    return terms;
  }

  Future<AboutAsResponse> aboutUs()async{
    final about=await webService.aboutUs();
    return about;
  }

  Future<SocialResponse> getSocialLinks()async{
    final social=await webService.getSocialLinks();
    return social;
  }

  Future<AddressListResponse> getAddress()async{
    final address=await webService.getAddress();
    return address;
  }

  Future<DeleteResponse> deleteAddress(int id)async{
    final delete=await webService.deleteAddress(id);
    return delete;
  }

  Future<AddAddressResponse> addAddress(String address,String lat,String lng,String type)async{
    final Addaddress=await webService.addAddress(address, lat, lng, type);
    return Addaddress;
  }

  Future<EditAddressResponse> editAddress(String address,String lat,String lng,String type,int id)async{
    final Editaddress=await webService.editAddress(address, lat, lng, type,id);
    return Editaddress;
  }

  Future<BasketListResponse> getBaskets(String lat,String lng)async{
    final baskets=await webService.getBaskets(lat, lng);
    return baskets;
  }

  Future<PreferencesResponse> getPreferences(String lat,String lng)async{
    final preferences=await webService.getPreferences(lat, lng);
    return preferences;
  }

  Future<HomeResponse> getHomeData(String lat,String lng)async{
    final home=await webService.getHomeData(lat, lng);
    return home;
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
    final orderBasket=await webService.createOrderBasket(addressId, couponId, type, deliveryDate, payment, notes, totalAfterDiscount, discount, total, products);
    return orderBasket;
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
      String products,String prefrence)async{
    final orderUpOnRequest=await webService.createOrderUpOnRequest(
        addressId, couponId, type, deliveryDate, payment, notes, totalAfterDiscount, discount, total, products,prefrence);
    return orderUpOnRequest;
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
      String products,String preference)async{
    final orderSubscription=await webService.createOrderSubscription(
        addressId,
        couponId,
        type,
        deliveryDate,
        payment,
        notes,
        totalAfterDiscount,
        discount,
        total,
        products,preference);
    return orderSubscription;
  }

  Future<copunResponse> validateCoupon(String code)async{
    final coupon=await webService.validateCoupon(code);
    return coupon;
  }

  Future<PickupDateResponse> getPickupDate()async{
    final pickupDate=await webService.getPickupDate();
    return pickupDate;
  }

  Future<HoursResponse> getHours(String date,String addressId,String dateType)async{
    final hours=await webService.getHours(date,addressId,dateType);
    return hours;
  }

  Future<MyOrdersRespons> getMyOrders(String status,String date,String type,String id)async{
    final myOrders=await webService.getMyOrders(status, date, type, id);
    return myOrders;
  }

  Future<OrderDetailsResponse> getOrderDetails(String id)async{
    final ordersDetails=await webService.getOrderDetails(id);
    return ordersDetails;
  }

  Future<DeleteResponse> deleteOrder(String id)async{
    final deleteOrder=await webService.deleteOrder(id);
    return deleteOrder;
  }

  Future<UpdateStatusResponse> updateOrderStatus(int id,String status,String transactionId,String userId)async{
    final updateOrderStatus=await webService.updateOrderStatus(id,status,transactionId,userId);
    return updateOrderStatus;
  }

  Future<UpdateStatusResponse> updatePaymentStatus(int id,String status,String transactionId)async{
    final updatePaymentStatus=await webService.updatePaymentStatus(id,status,transactionId);
    return updatePaymentStatus;
  }


  Future<SubscriptionsResponse> getSubscriptions(String lat,String lng)async{
    final getSubscription=await webService.getSubscriptions(lat,lng);
    return getSubscription;
  }

  Future<VideoResponse> getVideo()async{
    final video=await webService.getVideo();
    return video;
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
    final reSubscription=await webService.reSubscription(addressId,
        deliveryDate, notes, preference, userSubId,deliveryCost,orderType,total,payment);
    return reSubscription;
  }

  Future<ProductResponse> getProductCat(String lat,String lng)async{
    final cat=await webService.getProductCat(lat, lng);
    return cat;
  }

  Future<NotificationResponse> getNotificationData()async{
    final notification=await webService.getNotificationData();
    return notification;
  }

  Future<UpdateTokenResponse?> UpdateToken(String token)async{
    final tokenFir=await webService.UpdateToken(token);
    return tokenFir;
  }

  Future<RateOrderResponse> rateOrder(
      int id,
      String note,
      String wash,
      String ironing,
      String driverStars)async{
    final rate=await webService.rateOrder(id,note,wash,ironing,driverStars);
    return rate;
  }

  Future<UrgentPriceResponse> getUrgentPrice()async{
    final urgentPrice=await webService.getUrgentPrice();
    return urgentPrice;
  }

}