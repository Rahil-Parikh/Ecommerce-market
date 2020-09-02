import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:market/database/persist_fire.dart';

////import 'package:market/read_docs.dart';
//import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'search.dart';


class Shop extends StatefulWidget {
  final GlobalKey<NavigatorState> _navigatorKey;
  Shop(this._navigatorKey);
  @override
  _ShopState createState() => _ShopState(_navigatorKey);
}

class _ShopState extends State<Shop> {
  final GlobalKey<NavigatorState> _navigatorKey;
  _ShopState(this._navigatorKey);
  final dbHelper = DatabaseHelper.instance;
  //name :{price,}
  List<Map<String, dynamic>> prod;


  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _listViewProducts(BuildContext context) {
    return Container(
        child: FutureBuilder(
            future: _fetchValues(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              try {
                if (snapshot.hasData&&prod.isNotEmpty) {
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
                              Query w;
                              print("@@"+productElement.runtimeType.toString());
                              Navigator.pop(context);
                              _navigatorKey.currentState.pushNamed('/product',arguments: {"ele" :productElement,"key":_navigatorKey});
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
                                        placeholder: (context, url) => Center(
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
                                                  color: Theme.of(context)
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
                }else if (prod.isEmpty) {
                  setState(() {

                  });
                  return Center(child: Text("Please Reload!"));
                } else {
                  return Center(child: Text("Error"));
                }
              } catch (e) {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }

  Widget _gridViewProducts(BuildContext context) {
    return FutureBuilder(
        future: _fetchValues(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          try{
            if (prod.isNotEmpty) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.7),
                shrinkWrap: true,
//                  crossAxisCount: 2,
//                  childAspectRatio: 0.7,
                padding: EdgeInsets.only(top: 8, left: 6, right: 6, bottom: 12),
                itemCount: prod.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> productElement = prod[index];
                  bool discount = productElement['discount'] == 1;
                  //String name = productElement['name'];
                  double price = productElement['price'].toDouble();
                  double previousPrice;
                  if (discount)
                    previousPrice = productElement['old_price'].toDouble();
                  return Container(
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: InkWell(
                        onTap: () {
                          print('Card tapped.');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height:
                              (MediaQuery.of(context).size.width / 2 - 5.5),
                              width: double.infinity,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: productElement['img_url'],
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                              ),
                            ), //Image
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: ListTile(
                                  subtitle: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SafeArea(
                                              child: Text(
                                                productElement['name'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                    color: Colors.black),
                                              )),
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2.0, bottom: 1),
                                                child: Text(
                                                    '\₹' + price.toStringAsFixed(2),
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                      fontWeight: FontWeight.w700,
                                                    )),
                                              ),
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
                                                          fontWeight: FontWeight.w700,
                                                          fontStyle: FontStyle.italic,
                                                          color: Colors.grey,
                                                          decoration: TextDecoration
                                                              .lineThrough)),
                                                ),
                                            ],
                                          ),
                                          if (discount)
                                            Row(
                                              children: <Widget>[
                                                if (discount)
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        top: 2.0),
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
                                              ],
                                            ),
                                        ],
                                      ),
                                      Spacer(),
                                      Material(
                                        color: Colors.blue,
                                        child: InkWell(
                                          onTap: () => () {
                                            print("Container pressed");
                                          }, // handle your onTap here
                                          child: Container(
                                            color: Colors.blue,
                                            child: Row(children: <Widget>[
                                              Icon(Icons.add, size: 15),
                                              Icon(
                                                Icons.shopping_cart,
                                                size: 30,
                                              )
                                            ]),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                //List.generate(products.length, (index) {}
              );
            } else if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else if (prod.isEmpty) {
              setState(() {
                Future.delayed(Duration(seconds: 2));
              });
              return Center(child: Text("Please Reload!"));
            } else {
              return Center(child: Text("Error"));
            }
          }
          catch(e){
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<bool> _fetchValues() async {
    //await Future.delayed(Duration(seconds: 3));
    prod = await dbHelper.queryAllRows();
    prod.forEach((row) => print("@@" + row.toString()));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    print("@@build");
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                scaffoldKey.currentState
                    .showBottomSheet((context) => ShopSearch());
              },
            )
          ],
          title: Text('Shop'),
        ),
        body: Builder(
          builder: (BuildContext context) {
            return DefaultTabController(
                length: 2,
                child: Column(
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints(maxHeight: 150.0),
                      child: Material(
                        color: Theme.of(context).accentColor,
                        child: TabBar(
                          indicatorColor: Colors.blue,
                          tabs: [
                            Tab(icon: Icon(Icons.view_list)),
                            Tab(icon: Icon(Icons.grid_on)),
                          ],
                        ),
                      ),
                    ), //View option
                    Expanded(
                      child: TabBarView(
                        children: [
                          _listViewProducts(context),
                          _gridViewProducts(context)
                        ],
                      ),
                    ),
                  ],
                ));
          },
        ),
//Rating Row
//                                                  Row(
//                                                    children: <Widget>[
//                                                      SmoothStarRating(
//                                                          allowHalfRating: false,
//                                                          onRated: (v) {
//                                                            product['rating'] = v;
//                                                            setState(() {});
//                                                          },
//                                                          starCount: 5,
//                                                          rating: product['rating'],
//                                                          size: 16.0,
//                                                          color: Colors.amber,
//                                                          borderColor: Colors.amber,
//                                                          spacing:0.0
//                                                      ),
//                                                      Padding(
//                                                        padding: const EdgeInsets.only(left: 6.0),
//                                                        child: Text('(4)', style: TextStyle(
//                                                            fontWeight: FontWeight.w300,
//                                                            color: Theme.of(context).primaryColor
//                                                        )),
//                                                      )
//                                                    ],
//                                                  )//Rating

//        body: DefaultTabController(
//            length: 2,
//            child: Column(
//              children: <Widget>[
//                Container(
//                  constraints: BoxConstraints(maxHeight: 150.0),
//                  child: Material(
//                    color: Theme.of(context).accentColor,
//                    child: TabBar(
//                      indicatorColor: Colors.blue,
//                      tabs: [
//                        Tab(icon: Icon(Icons.view_list)),
//                        Tab(icon: Icon(Icons.grid_on)),
//                      ],
//                    ),
//                  ),
//                ),
//                Expanded(
//                  child: TabBarView(
//                    children: [
//                      Container(
//                        child: ListView(
//                          children: products.map((product) {
//                            return Builder(
//                              builder: (BuildContext context) {
//                                return  InkWell(
//                                  onTap: () {
//                                    print('Card tapped.');
//                                  },
//                                  child: Column(
//                                    crossAxisAlignment: CrossAxisAlignment.start,
//                                    children: <Widget>[
//                                      Divider(
//                                        height: 0,
//                                      ),
//                                      Padding(
//                                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
//                                        child: ListTile(
//                                          trailing: Icon(Icons.navigate_next),
//                                          leading: ClipRRect(
//                                            borderRadius: BorderRadius.circular(5.0),
//                                            child: Container(
//                                              decoration: BoxDecoration(
//                                                  color: Colors.blue
//                                              ),
//                                              child: CachedNetworkImage(
//                                                fit: BoxFit.cover,
//                                                imageUrl: product['image'],
//                                                placeholder: (context, url) => Center(
//                                                    child: CircularProgressIndicator()
//                                                ),
//                                                errorWidget: (context, url, error) => new Icon(Icons.error),
//                                              ),
//                                            ),
//                                          ),
//                                          title: Text(
//                                            product['name'],
//                                            style: TextStyle(
//                                                fontSize: 14
//                                            ),
//                                          ),
//                                          subtitle: Column(
//                                            crossAxisAlignment: CrossAxisAlignment.start,
//                                            children: <Widget>[
//                                              Row(
//                                                children: <Widget>[
//                                                  Padding(
//                                                    padding: const EdgeInsets.only(top: 2.0, bottom: 1),
//                                                    child: Text('\$200', style: TextStyle(
//                                                      color: Theme.of(context).accentColor,
//                                                      fontWeight: FontWeight.w700,
//                                                    )),
//                                                  ),
//                                                  Padding(
//                                                    padding: const EdgeInsets.only(left: 6.0),
//                                                    child: Text('(\$400)', style: TextStyle(
//                                                        fontWeight: FontWeight.w700,
//                                                        fontStyle: FontStyle.italic,
//                                                        color: Colors.grey,
//                                                        decoration: TextDecoration.lineThrough
//                                                    )),
//                                                  )
//                                                ],
//                                              ),
//                                              Row(
//                                                children: <Widget>[
//                                                  SmoothStarRating(
//                                                      allowHalfRating: false,
//                                                      onRatingChanged: (v) {
//                                                        product['rating'] = v;
//                                                        setState(() {});
//                                                      },
//                                                      starCount: 5,
//                                                      rating: product['rating'],
//                                                      size: 16.0,
//                                                      color: Colors.amber,
//                                                      borderColor: Colors.amber,
//                                                      spacing:0.0
//                                                  ),
//                                                  Padding(
//                                                    padding: const EdgeInsets.only(left: 6.0),
//                                                    child: Text('(4)', style: TextStyle(
//                                                      fontWeight: FontWeight.w300,
//                                                      color: Theme.of(context).primaryColor
//                                                    )),
//                                                  )
//                                                ],
//                                              )
//                                            ],
//                                          ),
//                                        ),
//                                      ),
//                                    ],
//                                  ),
//                                );
//                              },
//                            );
//                          }).toList(),
//                        ),
//                      ),
//                      Container(
//                        child: GridView.count(
//                          shrinkWrap: true,
//                          crossAxisCount: 2,
//                          childAspectRatio: 0.7,
//                          padding: EdgeInsets.only(top: 8, left: 6, right: 6, bottom: 12),
//                          children: List.generate(products.length, (index) {
//                            return Container(
//                              child: Card(
//                                clipBehavior: Clip.antiAlias,
//                                child: InkWell(
//                                  onTap: () {
//                                    print('Card tapped.');
//                                  },
//                                  child: Column(
//                                    crossAxisAlignment: CrossAxisAlignment.start,
//                                    children: <Widget>[
//                                      SizedBox(
//                                        height: (MediaQuery.of(context).size.width / 2 - 5),
//                                        width: double.infinity,
//                                        child: CachedNetworkImage(
//                                          fit: BoxFit.cover,
//                                          imageUrl: products[index]['image'],
//                                          placeholder: (context, url) => Center(
//                                              child: CircularProgressIndicator()
//                                          ),
//                                          errorWidget: (context, url, error) => new Icon(Icons.error),
//                                        ),
//                                      ),
//                                      Padding(
//                                        padding: const EdgeInsets.only(top: 5.0),
//                                        child: ListTile(
//                                            title: Text(
//                                              'Two Gold Rings',
//                                              style: TextStyle(
//                                                  fontWeight: FontWeight.bold,
//                                                  fontSize: 16
//                                              ),
//                                            ),
//                                          subtitle: Column(
//                                            crossAxisAlignment: CrossAxisAlignment.start,
//                                            children: <Widget>[
//                                              Row(
//                                                children: <Widget>[
//                                                  Padding(
//                                                    padding: const EdgeInsets.only(top: 2.0, bottom: 1),
//                                                    child: Text('\$200', style: TextStyle(
//                                                      color: Theme.of(context).accentColor,
//                                                      fontWeight: FontWeight.w700,
//                                                    )),
//                                                  ),
//                                                  Padding(
//                                                    padding: const EdgeInsets.only(left: 6.0),
//                                                    child: Text('(\$400)', style: TextStyle(
//                                                        fontWeight: FontWeight.w700,
//                                                        fontStyle: FontStyle.italic,
//                                                        color: Colors.grey,
//                                                        decoration: TextDecoration.lineThrough
//                                                    )),
//                                                  )
//                                                ],
//                                              ),
//                                              Row(
//                                                children: <Widget>[
//                                                  SmoothStarRating(
//                                                      allowHalfRating: false,
//                                                      onRatingChanged: (v) {
//                                                        products[index]['rating'] = v;
//                                                        setState(() {});
//                                                      },
//                                                      starCount: 5,
//                                                      rating: products[index]['rating'],
//                                                      size: 16.0,
//                                                      color: Colors.amber,
//                                                      borderColor: Colors.amber,
//                                                      spacing:0.0
//                                                  ),
//                                                  Padding(
//                                                    padding: const EdgeInsets.only(left: 6.0),
//                                                    child: Text('(4)', style: TextStyle(
//                                                        fontWeight: FontWeight.w300,
//                                                        color: Theme.of(context).primaryColor
//                                                    )),
//                                                  )
//                                                ],
//                                              )
//                                            ],
//                                          ),
//                                        ),
//                                      )
//                                    ],
//                                  ),
//                                ),
//                              ),
//                            );
//                          }),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ],
//            ))
      ),
    );
  }
}
