import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class Tab4 extends StatefulWidget {
  @override
  _Tab4State createState() => _Tab4State();
}

class _Tab4State extends State<Tab4> {
  final String testID = "curso_hubspot1";

  /// Is the API available on the device
  bool _available = true;

  /// The In App Purchase plugin
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;

  /// Products for sale
  List<ProductDetails> _products = [];

  /// Past purchases
  List<PurchaseDetails> _purchases = [];

  /// Updates to purchases
  StreamSubscription _subscription;

  /// Consumable credits the user can buy
  int _credits = 0;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

   @override
   void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  /// Initialize data
  void _initialize() async {
    // Check availability of In App Purchases
    _available = await _iap.isAvailable();

    if (_available) {
      await _getProducts();
      await _getPastPurchases();

    }
    // Listen to new purchases
    _subscription = _iap.purchaseUpdatedStream.listen((data) => setState(() {
          print("${data.last.status}");
          _purchases.addAll(data);
          _verifyPurchase(data.last);
        })); 
  }

  /// Purchase a product
  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    // _iap.buyNonConsumable(purchaseParam: purchaseParam);
    _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: true);
  }

  /// Spend credits and consume purchase when they run pit
  void _spendCredits(PurchaseDetails purchase) async {
    /// Decrement credits
    setState(() {
      _credits--;
    });


    // Mark consumed when credits run out
    if (_credits == 0) {
      if (Platform.isAndroid) {
      }
      await _getPastPurchases();
    }
  }

  /// Get all products available for sale
  Future<void> _getProducts() async {
    Set<String> ids = Set.from([testID, 'test_a']);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    setState(() {
      _products = response.productDetails;
    });
  }

  /// Gets past purchases
  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();

    for (PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
        
       
      }
      print('entro aqui');
    }


    setState(() {
      _purchases = response.pastPurchases;
    });
  }

  /// Returns purchase of specific product ID
  PurchaseDetails _hasPurchased(String productID) {
    return _purchases.firstWhere((purchase) => purchase.productID == productID,
        orElse: () => null);
  }

  /// Your own business logic to setup a consumable
  void _verifyPurchase(PurchaseDetails purchase ) {


    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      print('completo');
      setState(() {
        _credits = 10;
      });
    }else{
      print('No se ha completado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_available ? 'Open for Business' : 'Not Available'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var prod in _products)

              // UI if already purchased
              if (_hasPurchased(prod.id) != null) ...[
                Text('💎 $_credits', style: TextStyle(fontSize: 60)),
                FlatButton(
                  child: Text('Consume'),
                  color: Colors.green,
                  onPressed: () => _spendCredits(_hasPurchased(prod.id)),
                )
              ]

              // UI if NOT purchased
              else ...[
                Text(prod.title, style: Theme.of(context).textTheme.headline),
                Text(prod.description),
                Text(prod.price,
                    style: TextStyle(color: Colors.greenAccent, fontSize: 60)),
                FlatButton(
                  child: Text('Buy It'),
                  color: Colors.green,
                  onPressed: () => _buyProduct(prod),
                ),
              ]
          ],
        ),
      ),
    );
  }
}
