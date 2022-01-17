import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shopinguser/globalVariable.dart';

import 'foodDetailPage.dart';

class resultPage extends StatefulWidget {
  String searchText;

  resultPage(this.searchText);

  @override
  _resultPageState createState() => _resultPageState(searchText);
}

class _resultPageState extends State<resultPage> {
  String searchText;
  bool isProducts = true;
  bool isStore = false;

  //Shop Var
  var shopId = [];
  var shopName = [];
  var shopAddress = [];
  var shopState = [];
  var shopCity = [];
  var shopArea = [];
  var shopImage = [];

  // Products Var
  var productName = [];
  var productId = [];
  var productMeas = [];
  var productCat = [];
  var productPrice = [];
  var productImage = [];
  var productGst = [];
  var productCode = [];
  var productDes = [];
  var productQnt = [];
  var productQntPrice = [];
  var productShopId = [];

  _resultPageState(this.searchText);

  @override
  void initState() {
    // TODO: implement initState
    getResult(searchText);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ));
    return WillPopScope(
      onWillPop: () {
        if (isStore) {
          setState(() {
            isProducts = false;
            isStore = false;
          });
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 44, left: 14),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    isProducts ? "Products" : "Stores",
                    style: TextStyle(
                        fontSize: 22,
                        color: colorDark,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 14),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Showing results of " + searchText,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              isProducts
                  ? productName.length > 0
                      ? GridView.count(
                          primary: false,
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          children: List.generate(productName.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        foodDetailPage(productId[index])));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Card(
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                  color: colorCard,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12, bottom: 12),
                                        child: Image.network(
                                          productImage[index],
                                          height: 111,
                                          width: 100,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Text(
                                        productName[index],
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 22,
                                            // color: colorDark,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        productPrice[index] + rupees,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: colorDark1,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }))
                      : Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: loadingWidget(),
                      )
                  : shopName.length > 0
                      ? SizedBox(
                          height: 166 * shopName.length.toDouble(),
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: shopName.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    getListedFood(shopId[index]);
                                    isStore = true;
                                  },
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    margin: EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                        top: 14,
                                        bottom: index == 4 ? 22 : 0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Card(
                                              semanticContainer: true,
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Image.network(
                                                shopImage[index],
                                                width: 88,
                                                height: 88,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 7,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: Column(
                                                // mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    shopName[index],
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: colorDark),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.star,
                                                        color: colorDark,
                                                        size: 16,
                                                      ),
                                                      Text(
                                                        "3.5 Star",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .location_on_rounded,
                                                        color: colorDark,
                                                        size: 16,
                                                      ),
                                                      Text(
                                                        shopCity[index],
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .location_on_rounded,
                                                        color: colorDark,
                                                        size: 16,
                                                      ),
                                                      Text(
                                                        shopState[index],
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 166),
                          child: Column(
                            children: [
                              Image.network(
                                "https://cdn-icons-png.flaticon.com/512/4555/4555999.png",
                                width: 100,
                                height: 100,
                                color: colorDark,
                              ),
                              SizedBox(
                                height: 22,
                              ),
                              Text(
                                "Can't find products.",
                                style: TextStyle(fontSize: 22),
                              )
                            ],
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  void getResult(String searchText) {
    get(Config.mainUrl + Config.getSearchResults + "?search=$searchText")
        .then((value) {
      print("Search :: ${value.body}");
      if (value.body != "0") {
        // show results
        final data = jsonDecode(value.body.toString());
        int dd = getJsonLength(data);

        Map<String, dynamic> map = data[0] as Map<String, dynamic>;
        print("Map :: $map");
        if (map['type'].toString() == "products") {
          //Products
          isProducts = true;
        } else if (map['type'].toString() == "shop") {
          // Shops
          isProducts = false;
        }

        for (int i = 0; i < dd; i++) {
          Map<String, dynamic> map = data[i] as Map<String, dynamic>;
          print("Map :: $map");
          if (map['type'].toString() == "products") {
            //Products
            productName.add(map["product_name"].toString());
            productPrice.add(map["price"].toString());
            productImage.add(map["product_image"].toString());
            productId.add(map["id"].toString());
            productMeas.add(map["measurement"].toString());
            productGst.add(map["gst_percent"].toString());
            productCode.add(map["sac_code"].toString());
            productDes.add(map["product_desc"].toString());
            productCat.add(map["pr_category"].toString());
            productQnt.add(map["quantity"].toString());
            productQntPrice.add(map["quantity_price"].toString());
            productShopId.add(map["shop_id"].toString());
          } else if (map['type'].toString() == "shop") {
            // Shops
            shopId.add(map["shop_id"].toString());
            shopName.add(map["name"].toString());
            shopAddress.add(map["address"].toString());
            shopArea.add(map["area"].toString());
            shopCity.add(map["city"].toString());
            shopState.add(map["state"].toString());
            shopImage.add(map["image"].toString());
            isStore = true;
          }
          if (i == dd - 1) {
            setState(() {
              print("productName :: $productName");
            });
          }
        }
      } else {
        // no results or error
      }
    });
  }

  Future<void> getListedFood(String shopId) async {
    productName.clear();
    productPrice.clear();
    productImage.clear();
    productId.clear();
    productMeas.clear();
    productGst.clear();
    productCode.clear();
    productDes.clear();
    productCat.clear();
    productQnt.clear();
    productQntPrice.clear();
    productShopId.clear();

    get(Config.mainUrl + Config.merchantProductsUrl + "?shop_id=" + shopId)
        .then((value) {
      final data = jsonDecode(value.body.toString());

      var dd = getJsonLength(data);
      print("DD :: $dd");

      for (int i = 0; i < dd; i++) {
        Map<String, dynamic> map = data[i] as Map<String, dynamic>;
        print("Map :: $map");

        productName.add(map["product_name"].toString());
        productPrice.add(map["price"].toString());
        productImage.add(map["product_image"].toString());
        productId.add(map["id"].toString());
        productMeas.add(map["measurement"].toString());
        productGst.add(map["gst_percent"].toString());
        productCode.add(map["sac_code"].toString());
        productDes.add(map["product_desc"].toString());
        productCat.add(map["pr_category"].toString());
        productQnt.add(map["quantity"].toString());
        productQntPrice.add(map["quantity_price"].toString());
        productShopId.add(map["shop_id"].toString());

        if (i == dd - 1) {
          setState(() {
            isProducts = true;
          });
        }
      }
    });
  }


  Widget noData() {
    Future.delayed(Duration(seconds: 3), () {
      return Center(
        child: Column(
          children: [
            Icon(
              Icons.error,
              size: 44,
              color: colorDark,
            ),
            Text("No Data Found"),
          ],
        ),
      );
    });
  }
}
