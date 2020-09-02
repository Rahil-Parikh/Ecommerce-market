import 'package:flutter/material.dart';
import 'package:market/categorise.dart';
import 'package:market/home/home.dart';
import 'package:market/product_detail.dart';
import 'package:market/settings.dart';
import 'package:market/shop/shop.dart';
import 'package:market/shop/shopList.dart';
import 'package:market/wishlist.dart';

import 'auth/auth.dart';
import 'cart.dart';

class NavigationRoutes {
  static List<String> pageRoutes = <String>[
    '/categorise',
    '/',
    '/shop',
    '/cart'
  ];

  static String getRouteAtIndex(int index) {
    return pageRoutes[index];
  }

//        '/': (BuildContext context) => Home(),
//        '/auth': (BuildContext context) => Auth(),
//        '/shop': (BuildContext context) => Shop(),
//        '/categorise': (BuildContext context) => Categorise(),
//        '/wishlist': (BuildContext context) => WishList(),
//        '/cart': (BuildContext context) => CartList(),
//        '/settings': (BuildContext context) => Settings(),
//        '/products': (BuildContext context) => Products()
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    WidgetBuilder builder;
    Map<String, dynamic> hello;
    switch (settings.name) {
      case '/':
        var k = args as Key;
        builder = (BuildContext context) => Home(k);
        break;
      case '/auth':
        builder = (BuildContext context) => Auth();
        break;
      case '/shop':
        var k = args as Key;
        builder = (BuildContext context) => ShopList(k);
        break;
      case '/categorise':
        builder = (BuildContext context) => Categorise();
        break;
      case '/wishlist':
        builder = (BuildContext context) => WishList();
        break;
      case '/cart':
        builder = (BuildContext context) => CartList();
        break;
      case '/settings':
        builder = (BuildContext context) => Settings();
        break;
      case '/product':
        Map m   = args as Map;
        Map<String, dynamic> data =m['ele'];
        var k = m['key'];
        builder = (BuildContext context) => Products(data,k);
        break;
      default:
        return _errorRoute();
    }
    return MaterialPageRoute(
      builder: builder,
      settings: settings,
      maintainState: false,
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text('Error!'),
        ),
      );
    });
  }
}
