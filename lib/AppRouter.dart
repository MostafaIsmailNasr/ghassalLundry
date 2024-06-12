import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghassal_laundry/ui/screen/auth/completeRegister/complete_register_screen.dart';
import 'package:ghassal_laundry/ui/screen/auth/intro/into_slider_screen.dart';
import 'package:ghassal_laundry/ui/screen/auth/location/location_screen.dart';
import 'package:ghassal_laundry/ui/screen/auth/login/login_screen.dart';
import 'package:ghassal_laundry/ui/screen/auth/register/register_screen.dart';
import 'package:ghassal_laundry/ui/screen/auth/splash/splash_screen.dart';
import 'package:ghassal_laundry/ui/screen/auth/virefyCode/virefy_code_screen.dart';
import 'package:ghassal_laundry/ui/screen/buttomNavigation/drower.dart';
import 'package:ghassal_laundry/ui/screen/createOrder/ghassalBasketsScreens/ghassal_baskets_screens.dart';
import 'package:ghassal_laundry/ui/screen/createOrder/ghassalBasketsScreens/selectBasketScreen/select_basket_screen.dart';
import 'package:ghassal_laundry/ui/screen/createOrder/ghassalBasketsScreens/selectedBasketScreen/selected_basket_screen.dart';
import 'package:ghassal_laundry/ui/screen/createOrder/ghassalSubscriptionScreens/customizePackage/customize_package_screen.dart';
import 'package:ghassal_laundry/ui/screen/createOrder/ghassalSubscriptionScreens/ghassal_subscription_screens.dart';
import 'package:ghassal_laundry/ui/screen/createOrder/ghassalUpOnRequestScreen/ghassal_upon_request_screen.dart';
import 'package:ghassal_laundry/ui/screen/createOrder/homeBasketSub/home_basket_sub_screen.dart';
import 'package:ghassal_laundry/ui/screen/morePages/aboutApp/about_app_screen.dart';
import 'package:ghassal_laundry/ui/screen/morePages/faqs/faqs.dart';
import 'package:ghassal_laundry/ui/screen/morePages/myLocations/editLocation/edit_location_screen.dart';
import 'package:ghassal_laundry/ui/screen/morePages/myLocations/my_locations_screen.dart';
import 'package:ghassal_laundry/ui/screen/morePages/profile/profile_screen.dart';
import 'package:ghassal_laundry/ui/screen/morePages/termsAndConditions/terms_and_condition.dart';
import 'package:ghassal_laundry/ui/screen/notification/notification_screen.dart';
import 'package:ghassal_laundry/ui/screen/orderDetails/order_details_screen.dart';
import 'package:ghassal_laundry/ui/screen/orderMethod/order_method_screen.dart';

import 'data/model/basketModel/BasketListResponse.dart';

/// this is const class to handle navigation from pages from here
class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case'/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case'/into_slider_screen':
        return MaterialPageRoute(builder: (_) => IntoSliderScreen());
      case'/drower':
        return MaterialPageRoute(builder: (_) => DrowerPage(index: 0,));
      case'/ghassal_baskets_screens':
        return MaterialPageRoute(builder: (_) => GhassalBasketsScreens());
      case'/select_basket_screens':
        return MaterialPageRoute(builder: (_) => SelectBasketScreen());
      case'/selected_basket_screens':
        final baskets=settings.arguments as Baskets;
        return MaterialPageRoute(builder: (_) => SelectedBasketScreen(selectedBaskets:  baskets));
      case'/ghassal_subscription_screens':
        return MaterialPageRoute(builder: (_) => GhassalSubscriptionScreens());
      case'/ghassal_upon_request_screens':
        return MaterialPageRoute(builder: (_) => GhassalUpOnRequestScreen());
      case'/customize_package_screens':
        return MaterialPageRoute(builder: (_) => CustomizePackageScreen());
      case'/notificatio_screen':
        return MaterialPageRoute(builder: (_) => NotificationScreen());
      case'/login_screen':
        final from=settings.arguments as String;
        return MaterialPageRoute(builder: (_) => LoginScreen(from: from,));
      case'/virefy_code_screen':
        final code=settings.arguments as int;
        final from=settings.arguments as String;
        return MaterialPageRoute(builder: (_) => VirefyCodeScreen(code: code,from: from,));
      case'/register_screen':
        final from=settings.arguments as String;
        return MaterialPageRoute(builder: (_) => RegisterScreen(from: from,));
      case'/complete_register_screen':
        final from=settings.arguments as String;
        return MaterialPageRoute(builder: (_) => CompleteRegisterScreen(from: from,));
      case'/location_screen':
        final from=settings.arguments as String;
        return MaterialPageRoute(builder: (_) => LocationScreen(from));
      case'/terms_and_condition_screen':
        return MaterialPageRoute(builder: (_) => TermsAndConditionScreen());
      case'/about_app_screen':
        return MaterialPageRoute(builder: (_) => AboutAppScreen());
      case'/faqs':
        return MaterialPageRoute(builder: (_) => FaqsScreen());
      case'/order_method_screen':
        final from=settings.arguments as String;
        return MaterialPageRoute(builder: (_) => OrderMethodScreen(from));
      case'/profile_screen':
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case'/my_location_screen':
        return MaterialPageRoute(builder: (_) => MyLocationsScreen());
      case'/edit_location_screen':
        final lant=settings.arguments as String;
        final lngt=settings.arguments as String;
        final street=settings.arguments as String;
        final id=settings.arguments as int;
        final type=settings.arguments as String;
        final isSelected2=settings.arguments as bool;
        final itemId2=settings.arguments as String;

        return MaterialPageRoute(builder: (_) => EditLocationScreen(lngedit: lant,latedit: lngt,addressEdit: street,id: id,typeEd: type,isSelected2: isSelected2,itemId2: itemId2,));
      case'/home_basket_sub_screen':
        final id=settings.arguments as int;
        return MaterialPageRoute(builder: (_) => HomeBasketSubScreen(userId: id,));
      case'/order_details_screen':
        final code=settings.arguments as String;
        final id=settings.arguments as String;
        return MaterialPageRoute(builder: (_) => OrderDetailsScreen(code: code,id: id,));
    }
  }
}

