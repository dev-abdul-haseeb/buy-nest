import 'package:ecommerce_shopping_store/config/routes/route_names.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_shopping_store/View/views.dart';

class Routes{
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name) {

      case RouteNames.splashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case RouteNames.authNavigator:
        return MaterialPageRoute(builder: (context) => AuthNavigator());
      case RouteNames.loginScreen:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case RouteNames.signUpScreen:
        return MaterialPageRoute(builder: (context) => SignUpScreen());
      case RouteNames.resetPasswordScreen:
        return MaterialPageRoute(builder: (context) => ResetPasswordScreen());
      case RouteNames.homeScreen:
        return MaterialPageRoute(builder: (context) => HomeScreen());

      default:
        return MaterialPageRoute(builder: (context) {
          return Scaffold(
            body: Center(child: Text('No route')),
          );
        });
    }
  }
}