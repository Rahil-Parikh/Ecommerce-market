import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:market/database/persist_fire.dart';
import 'package:market/shop/shopList.dart';

import 'drawer.dart';
import 'slider.dart';

class Home extends StatefulWidget {
  final GlobalKey<NavigatorState> _navigatorKey;
  Home(this._navigatorKey);
  _HomeState createState() => _HomeState(_navigatorKey);
}

class _HomeState extends State<Home> {
  final GlobalKey<NavigatorState> _navigatorKey;
  _HomeState(this._navigatorKey);
  final dbHelper = DatabaseHelper.instance;

  //name :{price,}
  List<Map<String, dynamic>> prod;
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];
  void _query() async {
    final bool b = await dbHelper.refresh();
   print("@@"+b.toString());
  }
  Future<bool> _fetchValues() async {
    //await Future.delayed(Duration(seconds: 3));
    prod = await dbHelper.queryAllRows();
    prod.forEach((row) => print("@@" + row.toString()));
    return true;
  }

  Widget _appBar(BuildContext context) {
    return SliverAppBar(
      // Provide a standard title.
      // title: Text('asdas'),
      // pinned: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {
            _query();
          },
        ),
      ],
      // Allows the user to reveal the app bar if they begin scrolling
      // back up the list of items.
      // floating: true,
      // Display a placeholder widget to visualize the shrinking size.
      flexibleSpace: HomeSlider(),
      // Make the initial height of the SliverAppBar larger than normal.
      expandedHeight: 300,
    );
  }
  Widget _listViewProducts(BuildContext context) {
    return Container(
        child: FutureBuilder(
            future: _fetchValues(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              try {
                if (snapshot.hasData && prod.isNotEmpty) {
                  return ListView.builder(
                      itemCount: prod.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> productElement = prod[index];
                        //String name = productElement['name'];
                        bool discount = productElement['discount'] != 0;
                        double price = productElement['price'].toDouble();
                        double previousPrice;
                        if (discount)
                          previousPrice =
                              productElement['old_price'].toDouble();
                        return InkWell(
                          onTap: () {
                            print('Card tapped.');
                            setState(() {
                              print(
                                  "@@" + productElement.runtimeType.toString());
                              Navigator.pop(context);
                              _navigatorKey.currentState.pushNamed('/product',
                                  arguments: {
                                    "ele": productElement,
                                    "key": _navigatorKey
                                  });
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Divider(
                                height: 0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10.0),
                                child: ListTile(
                                  trailing: Icon(Icons.navigate_next),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Container(
                                      decoration:
                                      BoxDecoration(color: Colors.blue),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: productElement['img_url'],
                                        placeholder: (context, url) =>
                                            Center(
                                                child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                      ),
                                    ),
                                  ), //Image
                                  title: Text(
                                    productElement['name'],
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ), //Name of the product
                                  subtitle: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 2.0, bottom: 1),
                                            child: Text(
                                                '\₹' + price.toStringAsFixed(2),
                                                style: TextStyle(
                                                  color: Theme
                                                      .of(context)
                                                      .accentColor,
                                                  fontWeight: FontWeight.w700,
                                                )),
                                          ), //Price
                                          if (discount)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6.0),
                                              child: Text(
                                                  '(\₹' +
                                                      previousPrice
                                                          .toStringAsFixed(2) +
                                                      ')',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w700,
                                                      fontStyle:
                                                      FontStyle.italic,
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough)),
                                            ), //discount
                                        ],
                                      ),
                                      //Price
                                      Row(children: <Widget>[
                                        if (discount)
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(top: 2.0),
                                            child: Text(
                                                (((previousPrice - price) *
                                                    100) /
                                                    previousPrice)
                                                    .toStringAsFixed(2) +
                                                    "% discount",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.redAccent,
                                                )),
                                          ),
                                      ]) //Discount percentage
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
//        children: products.map((product) {
//          return Builder(
//            builder:
//            },
                  );
                } else if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else if (prod.isEmpty) {
                  setState(() {});
                  return Center(child: Text("Please Reload!"));
                } else {
                  return Center(child: Text("Error"));
                }
              } catch (e) {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }

  Widget _list(BuildContext context) {
    return SliverList(
      // Use a delegate to build items as they're scrolled on screen.
      delegate: SliverChildBuilderDelegate(
        // The builder function returns a ListTile with a title that
        // displays the index of the current item.
        (context, index) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 14.0, left: 8.0, right: 8.0),
              child: Text(
                  'Featured',
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
            ),//Featured Products
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              height: 240.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: imgList.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: 140.0,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/products',
                                  arguments: i.toString());
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 160,
                                  child: Hero(
                                    tag: '$i',
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: i,
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          new Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Two Gold Rings',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text('\$200',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontWeight: FontWeight.w700)),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Padding(
//                  padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
//                  child: Text('Shop By Category',
//                      style: TextStyle(
//                          color: Theme.of(context).accentColor,
//                          fontSize: 18,
//                          fontWeight: FontWeight.w700)),
//                ),
//                Padding(
//                  padding:
//                      const EdgeInsets.only(right: 8.0, top: 8.0, left: 8.0),
//                  child: RaisedButton(
//                      color: Theme.of(context).primaryColor,
//                      child: Text('View All',
//                          style: TextStyle(color: Colors.white)),
//                      onPressed: () {
//                        Navigator.pushNamed(context, '/categorise');
//                      }),
//                )
//              ],
//            ),// Shop By Category
//            Container(
//              child: GridView.count(
//                shrinkWrap: true,
//                physics: NeverScrollableScrollPhysics(),
//                crossAxisCount: 2,
//                padding: EdgeInsets.only(top: 8, left: 6, right: 6, bottom: 12),
//                children: List.generate(4, (index) {
//                  return Container(
//                    child: Card(
//                      clipBehavior: Clip.antiAlias,
//                      child: InkWell(
//                        onTap: () {
//                          print('Card tapped.');
//                        },
//                        child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            SizedBox(
//                              height:
//                                  (MediaQuery.of(context).size.width / 2) - 70,
//                              width: double.infinity,
//                              child: CachedNetworkImage(
//                                fit: BoxFit.cover,
//                                imageUrl: imgList[index],
//                                placeholder: (context, url) =>
//                                    Center(child: CircularProgressIndicator()),
//                                errorWidget: (context, url, error) =>
//                                    new Icon(Icons.error),
//                              ),
//                            ),
//                            ListTile(
//                                title: Text(
//                              'Two Gold Rings',
//                              style: TextStyle(
//                                  fontWeight: FontWeight.w700, fontSize: 16),
//                            ))
//                          ],
//                        ),
//                      ),
//                    ),
//                  );
//                }),
//              ),
//            ),//Categories
          ],
        ),
        // Builds 1000 ListTiles
        childCount: 1,
      ),
    );
  }

  Widget _homeScrollView(BuildContext context) {
    return CustomScrollView(
        // Add the app bar and list of items as slivers in the next steps.
        slivers: <Widget>[
          _appBar(context),
          //SliverToBoxAdapter(child:Expanded(child: _listViewProducts(context))),
          _list(context),
        ]);
  }

//  @override
//  Widget build(BuildContext context) {
//    print("@@Home");
//    return Scaffold(
//      drawer: Drawer(
//        child: AppDrawer(),
//      ),
//      body: SafeArea(
//        top: false,
//        left: false,
//        right: false,
//        child: _homeScrollView(context),
//      ),
//    );
//  }
  @override
  Widget build(BuildContext context) {
    print("@@Home");
    return _homeScrollView(context);
  }
}
