import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/auth_screen/login_screen.dart';
import 'package:habit_tracker/pages/auth_screen/register_screen.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'app_route.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case AppRoute.register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case AppRoute.home:
        return MaterialPageRoute(builder: (_) => HomePage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return const Scaffold(
          body: Center(child: Text('Erreur : Route inconnue')),
        );
      },
    );
  }
}
