import 'package:flutter/rendering.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:countdown/auth.dart';

class DonationPage extends StatefulWidget {
  DonationPage({Key key}) : super(key: key);

  static final String routeName = '/donation';

  @override
  _DonationPageState createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {

  Set<String> _kIds = <String>['donation_1', 'donation_2', 'donation_5', 'donation_10'].toSet();
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products;

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    InAppPurchaseConnection.enablePendingPurchases();

    final Stream purchaseUpdates = InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) {
      print("purchases: $purchases");
    });

    _initializeProducts();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _initializeProducts() async {

    final bool available = await InAppPurchaseConnection.instance.isAvailable();

    if(!available) {
      //TODO: Print error
      return;
    }

    final QueryPurchaseDetailsResponse queryPurchaseDetailsResponse = await InAppPurchaseConnection.instance.queryPastPurchases();
    if (queryPurchaseDetailsResponse.error != null) {
      // Handle the error.
    }
    for (PurchaseDetails purchase in queryPurchaseDetailsResponse.pastPurchases) {
        print(purchase);
    }

    final ProductDetailsResponse response = await InAppPurchaseConnection.instance.queryProductDetails(_kIds);

    setState(() {
      _products = response.productDetails;
      _loading = false;
    });

  }

  void _purchaseProductId(String productId) {

    for(ProductDetails productDetails in _products) {
      if(productDetails.id == productId) {
        final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
        InAppPurchaseConnection.instance.buyConsumable(purchaseParam: purchaseParam, autoConsume: true);
        return;
      }
    }

    print("ERROR: Product ID $productId not found");
  }

  Widget _renderLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {

    if(_loading) return _renderLoading();

    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 100, bottom: 20),
              child: Text(
                "Donate Us",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  child: Text("\$1 USD"),
                  onPressed: () {
                    _purchaseProductId('donation_1');
                  }
                ),
                RaisedButton(
                  child: Text("\$2 USD"),
                  onPressed: () {
                    _purchaseProductId('donation_2');
                  }
                ),
                RaisedButton(
                  child: Text("\$5 USD"),
                  onPressed: () {
                    _purchaseProductId('donation_5');
                  }
                ),
                RaisedButton(
                  child: Text("\$10 USD"),
                  onPressed: () {
                    _purchaseProductId('donation_10');
                  }
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: Text(
                "Top Donors",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}