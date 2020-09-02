import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:market/database/persist_fire.dart';

////import 'package:market/read_docs.dart';
//import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'search.dart';

class ShopList extends StatefulWidget {
  final GlobalKey<NavigatorState> _navigatorKey;

  ShopList(this._navigatorKey);

  @override
  _ShopState createState() => _ShopState(_navigatorKey);
}

class _ShopState extends State<ShopList> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<NavigatorState> _navigatorKey;
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  _ShopState(this._navigatorKey);

  final dbHelper = DatabaseHelper.instance;

  //name :{price,}
  List<Map<String, dynamic>> prod;
  List<Map<String, dynamic>> featured;
  List<Map<String, dynamic>> categories;
  Future<bool> _fetchValuesBool;

  Widget _listViewProducts(BuildContext context) {
    return Container(
        child: FutureBuilder(
            future: _fetchValuesBool,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              try {
                if (snapshot.hasData && prod.isNotEmpty) {
                  return Expanded(
                      child: ListView.builder(
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
                                  print("@@" +
                                      productElement.runtimeType.toString());
                                  Navigator.pop(context);
                                  _navigatorKey.currentState
                                      .pushNamed('/product', arguments: {
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
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        child: Container(
                                          decoration:
                                              BoxDecoration(color: Colors.blue),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: productElement['img_url'],
                                            placeholder: (context, url) => Center(
                                                child:
                                                    CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
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
                                                    '\₹' +
                                                        price
                                                            .toStringAsFixed(2),
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    )),
                                              ), //Price
                                              if (discount)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 6.0),
                                                  child: Text(
                                                      '(\₹' +
                                                          previousPrice
                                                              .toStringAsFixed(
                                                                  2) +
                                                          ')',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: Colors.grey,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough)),
                                                ), //discount
                                            ],
                                          ),
                                          //Price
                                          Row(children: <Widget>[
                                            if (discount)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2.0),
                                                child: Text(
                                                    (((previousPrice - price) *
                                                                    100) /
                                                                previousPrice)
                                                            .toStringAsFixed(
                                                                2) +
                                                        "% discount",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic,
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
                          ));
                } else if (!snapshot.hasData) {
                  print("@@Novalues in _buildFeatures ");
                  return Center(child: CircularProgressIndicator());
                } else if (prod.isEmpty) {
                  setState(() {});
                  return Center(child: Text("Please Reload!"));
                } else {
                  return Center(child: Text("Error"));
                }
              } catch (e) {
                print("@@Error in _listViewProducts " + e.toString());
                return Center(child: CircularProgressIndicator());
              }
            }));
  }

  Future<bool> _fetchValues() async {
    //await Future.delayed(Duration(seconds: 3));
    prod = await dbHelper.queryAllRows();
    prod.forEach((row) => print("@@" + row.toString()));
    featured = await dbHelper.queryFeaturedRows();
    print("@@@!" + featured.toString());
    featured.forEach((row) => print("@@" + row.toString()));
    categories = await dbHelper.queryCategoryTableRows();
    print("##"+categories.runtimeType.toString()+" "+categories[0].runtimeType.toString()+" "+categories[0]['categories'].runtimeType.toString());
    categories.forEach((row) => print("@@" + row.toString()));
    return true;
  }

//  Future<bool> _fetchCategories(List<String> categories) async {
//    //await Future.delayed(Duration(seconds: 3));
//    cat = await dbHelper.queryFeaturedRows(categories);
//    cat.forEach((row) => print("@@" + row.toString()));
//    return true;
//  }
  Widget _buildCategories(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: _fetchValuesBool,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            try {
              if (snapshot.hasData &&
                  prod.isNotEmpty &&
                  categories.isNotEmpty) {

                return Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children:
                          List<Widget>.generate(categories.length, (int index) {
                        Map<String, dynamic> category = categories[index];
                        return Container(
                          padding:
                              EdgeInsets.only(bottom: 5, right: 5, left: 5),
                          child: OutlineButton(
                            child: Text(category['category'].toString()),
                            onPressed: () {
                              print("Category");
                            },
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          ),
                        );
                      })),
                );
              } else if (!snapshot.hasData) {
                print("@@Novalues in _buildFeatures ");
                return Center(child: CircularProgressIndicator());
              } else if (prod.isEmpty) {
                setState(() {});
                return Center(child: Text("Please Reload!"));
              } else {
                return Center(child: Text("Error"));
              }
            } catch (e) {
              print("@@Error in _listViewProducts " + e.toString());
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
//      Container(
//      child:
//    );
  }

  Widget _buildFeatures(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      Padding(
        padding: EdgeInsets.only(top: 14.0, left: 8.0, right: 8.0),
        child: Text('Featured',
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
      ),
      Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          height: 240.0,
          child: FutureBuilder(
              future: _fetchValuesBool,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                try {
                  if (snapshot.hasData && featured.isNotEmpty) {
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: featured.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map<String, dynamic> featuredElement =
                              featured[index];
                          print("!!" + featuredElement.toString());
                          return Container(
                            width: 140.0,
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    print("@@" +
                                        featuredElement.runtimeType.toString());
                                    Navigator.pop(context);
                                    _navigatorKey.currentState
                                        .pushNamed('/product', arguments: {
                                      "ele": featuredElement,
                                      "key": _navigatorKey
                                    });
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 160,
                                      child: Hero(
                                        tag: '$featuredElement["name"]',
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: featuredElement["img_url"],
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              new Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        featuredElement["name"].toString(),
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      subtitle: Text(
                                          '\₹' +
                                              featuredElement["price"]
                                                  .toDouble()
                                                  .toStringAsFixed(2),
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).accentColor,
                                              fontWeight: FontWeight.w700)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
//        children: products.map((product) {
//          return Builder(
//            builder:
//            },
                        );
                  } else if (!snapshot.hasData) {
                    print("@@Novalues _buildFeatures ");
                    return Center(child: CircularProgressIndicator());
                  } else if (prod.isEmpty) {
                    setState(() {});
                    return Center(child: Text("Please Reload!"));
                  } else {
                    return Center(child: Text("Error"));
                  }
                } catch (e) {
                  print("@@Error in _buildFeatures " + e.toString());
                  return Center(child: CircularProgressIndicator());
                }
              })),
    ]);
  }

//  Widget _buildFeatures(BuildContext context) {
//    return Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: <Widget>[
//        Padding(
//          padding: EdgeInsets.only(top: 14.0, left: 8.0, right: 8.0),
//          child: Text(
//              'Featured',
//              style: TextStyle(
//                  color: Theme
//                      .of(context)
//                      .accentColor,
//                  fontSize: 18,
//                  fontWeight: FontWeight.w700)),
//        ),
//        //Featured Products
//        Container(
//          margin: EdgeInsets.symmetric(vertical: 8.0),
//          height: 240.0,
//          child: ListView.builder(
//            scrollDirection: Axis.horizontal,
//            itemCount: featured.length,
//            itemBuilder: Builder(
//              builder: (BuildContext context) {
//                return
//              },
//            ),
//          ),
//        ),
////            Row(
////              mainAxisAlignment: MainAxisAlignment.spaceBetween,
////              children: <Widget>[
////                Padding(
////                  padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
////                  child: Text('Shop By Category',
////                      style: TextStyle(
////                          color: Theme.of(context).accentColor,
////                          fontSize: 18,
////                          fontWeight: FontWeight.w700)),
////                ),
////                Padding(
////                  padding:
////                      const EdgeInsets.only(right: 8.0, top: 8.0, left: 8.0),
////                  child: RaisedButton(
////                      color: Theme.of(context).primaryColor,
////                      child: Text('View All',
////                          style: TextStyle(color: Colors.white)),
////                      onPressed: () {
////                        Navigator.pushNamed(context, '/categorise');
////                      }),
////                )
////              ],
////            ),// Shop By Category
////            Container(
////              child: GridView.count(
////                shrinkWrap: true,
////                physics: NeverScrollableScrollPhysics(),
////                crossAxisCount: 2,
////                padding: EdgeInsets.only(top: 8, left: 6, right: 6, bottom: 12),
////                children: List.generate(4, (index) {
////                  return Container(
////                    child: Card(
////                      clipBehavior: Clip.antiAlias,
////                      child: InkWell(
////                        onTap: () {
////                          print('Card tapped.');
////                        },
////                        child: Column(
////                          crossAxisAlignment: CrossAxisAlignment.start,
////                          children: <Widget>[
////                            SizedBox(
////                              height:
////                                  (MediaQuery.of(context).size.width / 2) - 70,
////                              width: double.infinity,
////                              child: CachedNetworkImage(
////                                fit: BoxFit.cover,
////                                imageUrl: imgList[index],
////                                placeholder: (context, url) =>
////                                    Center(child: CircularProgressIndicator()),
////                                errorWidget: (context, url, error) =>
////                                    new Icon(Icons.error),
////                              ),
////                            ),
////                            ListTile(
////                                title: Text(
////                              'Two Gold Rings',
////                              style: TextStyle(
////                                  fontWeight: FontWeight.w700, fontSize: 16),
////                            ))
////                          ],
////                        ),
////                      ),
////                    ),
////                  );
////                }),
////              ),
////            ),//Categories
//      ],
//    );
//  }

  @override
  Widget build(BuildContext context) {
    _fetchValuesBool = _fetchValues();
    print("@@build");
    int height;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 50,
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
      body: Column(
        children: <Widget>[
          _buildFeatures(context),
          _buildCategories(context),
          _listViewProducts(context),
        ],
      ),
    );
  }
}

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
