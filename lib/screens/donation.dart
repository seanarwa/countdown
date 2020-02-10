import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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

  static final FirebaseDatabase _db = FirebaseDatabase.instance;
  static final DatabaseReference _donationRef = _db.reference().child('donation');
  static final _queryLimit = 5;

  Set<String> _kIds = <String>['donation_1', 'donation_2', 'donation_5', 'donation_10'].toSet();
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products;
  Map<String, dynamic> _topDonors = new Map();

  bool _loadingProducts = true;
  bool _loadingTopDonors = true;

  @override
  void initState() {
    super.initState();

    InAppPurchaseConnection.enablePendingPurchases();

    final Stream purchaseUpdates = InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) {
      for(PurchaseDetails purchaseDetails in purchases) {
        if(purchaseDetails.status == PurchaseStatus.purchased)
          _addCurrentUserDonation(purchaseDetails.productID);
      }
    });

    _initializeProducts();
    _initializeTopDonors();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _addCurrentUserDonation(String productID) async {

    int donation = 0;
    switch(productID) {
      case 'donation_1': donation = 1; break;
      case 'donation_2': donation = 2; break;
      case 'donation_5': donation = 5; break;
      case 'donation_10': donation = 10; break;
      default:
        print("ERROR: Unknown product ID: $productID");
        return;
    }

    FirebaseUser user = await Auth.getUser();

    if(user == null) {
      print("ERROR: Auth user is null");
      return;
    }

    var snapshot = await _donationRef.child(user.uid).once();

    if(snapshot.value != null)
      donation += snapshot.value['total_donation'];

    _donationRef.child(user.uid).set({
      'name': user.displayName,
      'total_donation': donation,
    });
  }

  void _initializeProducts() async {

    final bool available = await InAppPurchaseConnection.instance.isAvailable();

    if(!available) {
      //TODO: Print error
      return;
    }

    final ProductDetailsResponse response = await InAppPurchaseConnection.instance.queryProductDetails(_kIds);

    setState(() {
      _products = response.productDetails;
      _loadingProducts = false;
    });

  }

  void _initializeTopDonors() async {

    FirebaseUser user = await Auth.getUser();

    if(user == null) {
      print("ERROR: Auth user is null");
      return;
    }

    var count = _queryLimit;
    var stream = _donationRef.orderByChild("total_donation").limitToLast(_queryLimit).onChildAdded;
    var subscription;
    subscription = stream.listen((event) {
      String key = event.snapshot.key;
      var value = event.snapshot.value;
      setState(() {
        _topDonors.putIfAbsent(key, () => value);
        _loadingTopDonors = false;
      });
      count--;
      if(count <= 0)
        subscription.cancel();
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
    return CircularProgressIndicator();
  }

  Widget _renderTopDonors() {

    if(_loadingTopDonors) return _renderLoading();

    List<Widget> rows = [];

    var sortedKeys = _topDonors.keys.toList(growable:false)
      ..sort((k1, k2) => _topDonors[k1]["total_donation"].compareTo(-_topDonors[k2]["total_donation"]));

    for(var key in sortedKeys) {
      rows.add(new Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Text(
                  _topDonors[key]["name"],
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Expanded(child: Container(),),
                Text(
                  '\$${_topDonors[key]["total_donation"]} USD',
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }

  Widget _renderProducts() {

    if(_loadingProducts) return _renderLoading();

    return Row(
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
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Center(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[

                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Thank you for using Countdown",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  child: Text(
                    "Please consider donating to us as we can dedicate this fund to maintain and improve this app\n\n"
                        "Donations help us fund the necessary backend infrastructure as well as add more exciting features, such as:\n"
                        "\t• Leaderboards - see who recently died and who has the longest time to live\n"
                        "\t• Adding friends - link with friends to see their time and see leaderboard made just within your friend group\n"
                        "\tAnd more to come!\n\n"
                        "We are always open to suggestions. We greatly appreciate any feedback on what we can improve and what you would like too see next! Email to seanarwa@gmail.com",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  child: Text(
                    "Donate Us",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                ),
                _renderProducts(),
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
                _renderTopDonors(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}