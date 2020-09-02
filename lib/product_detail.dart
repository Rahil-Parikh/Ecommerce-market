import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market/database/persist_fire.dart';


class Products extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey;
  final Map<dynamic, dynamic> product;
  const Products(this.product,this._navigatorKey);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    bool discount = product['discount'] != 0;
    double price = product['price'].toDouble();
    double previousPrice;
    if (discount)
      previousPrice =
          product['old_price'].toDouble();
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 260,
                child: Hero(
                  tag: product,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: product['img_url'],
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment(-1.0, -1.0),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Text(
                          product['name'],
                          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text(
                                  '\₹' + price.toStringAsFixed(2),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if(discount)
                                Text(
                                    '\₹' + previousPrice.toStringAsFixed(2),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        decoration: TextDecoration.lineThrough
                                    )
                                ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
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
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                            alignment: Alignment(-1.0, -1.0),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                'Description',
                                style: TextStyle(color: Colors.black, fontSize: 20,  fontWeight: FontWeight.w600),
                              ),
                            )
                        ),
                        Container(
                            alignment: Alignment(-1.0, -1.0),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                product['detail'],
                                style: TextStyle(color: Colors.black, fontSize: 16),
                              ),
                            )
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

      ),
    );

  }
}
