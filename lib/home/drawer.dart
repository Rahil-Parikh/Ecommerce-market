import 'package:flutter/material.dart';
import 'package:market/blocks/auth_block.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  final GlobalKey<NavigatorState> _navigatorKey;
  AppDrawer( this._navigatorKey);
  @override
  _AppDrawerState createState() => _AppDrawerState(_navigatorKey);
}

class _AppDrawerState extends State<AppDrawer> {
  final GlobalKey<NavigatorState> _navigatorKey;
  _AppDrawerState( this._navigatorKey);
  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    return Column(
      children: <Widget>[
        if (auth.isLoggedIn)
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/drawer-header.jpg'),
            )),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://avatars2.githubusercontent.com/u/2400215?s=120&v=4'),
            ),
            accountEmail: Text(auth.user['user_email']),
            accountName: Text(auth.user['user_display_name']),
          ),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.home, color: Theme.of(context).accentColor),
                title: Text('Home'),
                onTap: () {
                  print("@@"+_navigatorKey.toString());
                  _navigatorKey.currentState.pushNamed('/');
                },
              ),// Home
              ListTile(
                leading: Icon(Icons.shopping_basket,
                    color: Theme.of(context).accentColor),
                title: Text('Shop'),
                trailing: Text('New',
                    style: TextStyle(color: Theme.of(context).primaryColor)),
                onTap: () {

                  setState(() {
                    Navigator.pop(context);
                    print("@@shop");
                    _navigatorKey.currentState.pushNamed('/shop',arguments: _navigatorKey);
                  });

                },
              ),//Shop
              ListTile(
                leading:
                    Icon(Icons.category, color: Theme.of(context).accentColor),
                title: Text('Categorise'),
                onTap: () {
                  Navigator.pop(context);
                  //Navigator.pushNamed(context, '/categorise');
                  _navigatorKey.currentState.pushNamed('/categorise');
                },
              ),//Categories
              ListTile(
                leading:
                    Icon(Icons.favorite, color: Theme.of(context).accentColor),
                title: Text('My Wishlist'),
                trailing: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text('4',
                      style: TextStyle(color: Colors.white, fontSize: 10.0)),
                ),
                onTap: () {
                  Navigator.pop(context);
                  //Navigator.pushNamed(context, '/wishlist');
                  _navigatorKey.currentState.pushNamed('/wishlist');
                },
              ),//Quick List
              ListTile(
                leading: Icon(Icons.shopping_cart,
                    color: Theme.of(context).accentColor),
                title: Text('My Cart'),
                trailing: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text('2',
                      style: TextStyle(color: Colors.white, fontSize: 10.0)),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _navigatorKey.currentState.pushNamed('/cart');
//                  Navigator.pushNamed(context, '/cart');
                },
              ),//Cart
              if (!auth.isLoggedIn)
              ListTile(
                leading: Icon(Icons.lock, color: Theme.of(context).accentColor),
                title: Text('Login'),
                onTap: () {
                  Navigator.pop(context);
                  _navigatorKey.currentState.pushNamed('/auth');
                },
              ),//Login
              Divider(),
              ListTile(
                leading:
                    Icon(Icons.settings, color: Theme.of(context).accentColor),
                title: Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  _navigatorKey.currentState.pushNamed('/settings');
                },
              ),//Settings
              if (auth.isLoggedIn)
                ListTile(
                leading: Icon(Icons.exit_to_app,
                    color: Theme.of(context).accentColor),
                title: Text('Logout'),
                onTap: () async {
                  await auth.logout();
                },
              )//Logout
            ],
          ),
        )
      ],
    );
  }
}
