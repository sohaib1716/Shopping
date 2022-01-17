import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shopinguser/authProfile/completeAllDetails.dart';
import 'package:shopinguser/globalVariable.dart';
import 'package:shopinguser/pages/shoppingCart.dart';
import 'package:shopinguser/widget/button_widget.dart';

class foodDetailPage extends StatefulWidget {
  String productId;

  foodDetailPage(this.productId);

  @override
  _foodDetailPageState createState() => _foodDetailPageState(productId);
}

class _foodDetailPageState extends State<foodDetailPage> {
  ScrollController _scrollController;
  double _scrollPosition;
  int image = 1;
  bool isLike = false;
  bool isStandard = true;
  bool isKg = false;
  var qnt = [];
  var qntPrice = [];
  int orderQnt = 0;
  var data;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String productId,
      productName,
      productPrice,
      productCode,
      productDes,
      productCat,
      productImage,
      productMea,
      productQnt,
      productQntPrice,
      productShopId,
      productGst;

  _foodDetailPageState(this.productId);

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    // print("productQnt :: $productQnt");
    getProductDetailsById(productId);
    // if (productQnt.length > 0 && productQntPrice.length > 0) {
    //   setState(() {
    //     isStandard = false;
    //   });
    // } else {
    //   if (productMea == "Kg") {
    //     orderQnt = 250;
    //     qnt = ["250 gm", "500 gm", "750 gm", "1000 gm"];
    //     qntPrice = [
    //       quantityPrice("250", "Gram"),
    //       quantityPrice("500", "Gram"),
    //       quantityPrice("750", "Gram"),
    //       quantityPrice("1000", "Gram")
    //     ];
    //   } else if (productMea == "Piece") {
    //     orderQnt = 1;
    //     qnt = ["1", "3", "5", "10"];
    //     qntPrice = [
    //       quantityPrice("1", "Piece"),
    //       quantityPrice("3", "Piece"),
    //       quantityPrice("5", "Piece"),
    //       quantityPrice("10", "Piece")
    //     ];
    //   } else if (productMea == "Litre") {
    //     orderQnt = 1;
    //     qnt = ["1", "3", "5", "10"];
    //     qntPrice = [
    //       quantityPrice("1", "Litre"),
    //       quantityPrice("3", "Litre"),
    //       quantityPrice("5", "Litre"),
    //       quantityPrice("10", "Litre")
    //     ];
    //   }
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      body: productName != null
          ? Container(
              color: colorDark,
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Card(
                      margin: EdgeInsets.only(top: 200),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(22),
                              topRight: Radius.circular(22))),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 144, left: 18, right: 18),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Text(
                                      productName,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      productPrice + rupees,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: colorDark1),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 18, top: 12),
                              child: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      margin: EdgeInsets.only(right: 12),
                                      padding:
                                          EdgeInsets.only(top: 4, bottom: 4),
                                      width: 60,
                                      // padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          color: colorDark,
                                          borderRadius:
                                              BorderRadius.circular(22)),
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Icon(
                                            Icons.star_border_rounded,
                                            size: 22,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "4.5",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (productMea == "Kg") {
                                        // if (orderQnt == 1000 && !isKg) {
                                        //   orderQnt = 1000;
                                        //   print("orderQnt :: $orderQnt");
                                        //   setState(() {});
                                        //   return;
                                        // }
                                        if (isKg) {
                                          orderQnt--;
                                          if (orderQnt < 1) {
                                            orderQnt = 750;
                                            isKg = false;
                                          }
                                          print("orderQnt :: $orderQnt");
                                          setState(() {});
                                          return;
                                        }
                                        orderQnt = orderQnt - 250;
                                        if (orderQnt <= 0) {
                                          orderQnt = 250;
                                        }
                                      } else {
                                        orderQnt--;
                                        if (orderQnt <= 0) {
                                          orderQnt = 1;
                                        }
                                      }
                                      print("orderQnt :: $orderQnt");
                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.indeterminate_check_box_rounded,
                                      size: 33,
                                      color: colorDark,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 2, right: 2),
                                    child: Text(
                                      productMea == "Kg"
                                          ? isKg
                                              ? orderQnt.toString() +
                                                  " " +
                                                  productMea
                                              : orderQnt.toString() + " Gram"
                                          : orderQnt.toString() +
                                              " " +
                                              productMea,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: colorDark,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (productMea == "Kg") {
                                        if (orderQnt > 500 && !isKg) {
                                          orderQnt = 1;
                                          isKg = true;
                                          print("orderQnt :: $orderQnt");
                                          setState(() {});
                                          return;
                                        }
                                        if (isKg) {
                                          orderQnt++;
                                          print("orderQnt :: $orderQnt");
                                          setState(() {});
                                          return;
                                        }
                                        orderQnt = orderQnt + 250;
                                      } else {
                                        orderQnt++;
                                      }
                                      print("orderQnt :: $orderQnt");
                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.add_box_rounded,
                                      size: 33,
                                      color: colorDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            ButtonWidget(
                                context, "Add to cart", addToCartFunction),
                            SizedBox(
                              height: 12,
                            ),
                            ButtonWidget(
                                context, "Order now", orderNowFunction, true),
                            Padding(
                              padding: const EdgeInsets.only(left: 18, top: 24),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Description",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 18, top: 12, right: 18),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  productDes + " " + flutterLongText,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
                                ),
                              ),
                            ),
                            // buildDivider(),
                            Padding(
                              padding: const EdgeInsets.only(left: 18, top: 24),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Quantity Price",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   height: 12,
                            // ),
                            SizedBox(
                              height: 40 * qnt.length.toDouble(),
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: qnt.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        productMea == "Kg"
                                            ? buildProfileText(
                                                qnt[index].toString().trim() +
                                                    " " +
                                                    "gm",
                                                qntPrice[index] + rupees)
                                            : buildProfileText(
                                                qnt[index].toString().trim() +
                                                    " " +
                                                    productMea,
                                                qntPrice[index] + rupees),
                                        SizedBox(
                                          height: 8,
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                            // isStandard
                            //     ? buildProfileText("250 gm", "50" + rupees)
                            //     : Text(" "),
                            // SizedBox(
                            //   height: 8,
                            // ),
                            // // buildDivider(),
                            // isStandard
                            //     ? buildProfileText("500 gm", "100" + rupees),
                            // SizedBox(
                            //   height: 8,
                            // ),
                            // // buildDivider(),
                            // isStandard
                            //     ? buildProfileText("750 gm", "150" + rupees),
                            // SizedBox(
                            //   height: 8,
                            // ),
                            // // buildDivider(),
                            // isStandard
                            //     ? buildProfileText("1000 gm", "200" + rupees),
                            Padding(
                              padding: const EdgeInsets.only(left: 18, top: 24),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "GST Details",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            buildProfileText("GST",
                                (double.parse(productGst)).toString() + " %"),
                            SizedBox(
                              height: 8,
                            ),
                            // buildDivider(),
                            buildProfileText("CGST",
                                (int.parse(productGst) / 2).toString() + " %"),
                            SizedBox(
                              height: 8,
                            ),
                            // buildDivider(),
                            buildProfileText("SGST",
                                (int.parse(productGst) / 2).toString() + " %"),
                            SizedBox(
                              height: 33,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 88),
                    opacity: image == 1 ? 1 : 0,
                    child: Center(
                      child: Card(
                        color: colorCard,
                        margin: EdgeInsets.only(bottom: 266),
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(200)),
                        child: Image.network(
                          productImage,
                          width: 222,
                          height: 222,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 88),
                    opacity: image == 0 ? 1 : 0,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Card(
                        color: colorCard,
                        margin: EdgeInsets.only(bottom: 288, right: 18),
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22)),
                        child: Image.network(
                          productImage,
                          width: 88,
                          height: 88,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 18, top: 44, left: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 33,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isLike = !isLike;
                            });
                          },
                          child: isLike
                              ? Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.red,
                                  size: 33,
                                )
                              : Icon(
                                  Icons.favorite_border_rounded,
                                  color: Colors.white,
                                  size: 33,
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  _scrollListener() {
    setState(() {
      if (_scrollController.offset > 40.0) {
        image = 0;
      } else {
        image = 1;
      }
      // print("_scrollController.offset :: ${_scrollController.offset}");
    });

    // print(
    //     "_scrollController.position.maxScrollExtent :: ${_scrollController.position.maxScrollExtent}");
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // print("reach the bottom");
      // setState(() {
      //   message = "reach the bottom";
      // });
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      // print("reach the top");
      // setState(() {
      //   message = "reach the top";
      // });
    }
  }

  Padding buildProfileText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 18, right: 18),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              )),
          Expanded(
              flex: 7,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18, color: colorBlack2),
              )),
        ],
      ),
    );
  }

  Divider buildDivider() {
    return Divider(
      indent: 22,
      endIndent: 22,
      height: 11,
      thickness: 2,
    );
  }

  addToCartFunction() {
    // if (cartProductId.contains(productId)) {
    //
    // } else {
    String prData;
    if (productMea == "Kg") {
      if (isKg) {
        prData = (orderQnt * 1000).toString();
      } else {
        prData = orderQnt.toString();
      }
      print("prData :: $prData");
      cartProductOrderPrice.add(quantityPrice(prData, "Gram"));
    } else if (productMea == "Piece") {
      cartProductOrderPrice.add(quantityPrice(orderQnt.toString(), "Piece"));
    } else if (productMea == "Litre") {
      cartProductOrderPrice.add(quantityPrice(orderQnt.toString(), "Litre"));
    }
    print("cartProductOrderPrice :: $cartProductOrderPrice");
    cartProductName.add(productName);
    cartProductImage.add(productImage);
    cartProductPrice.add(productPrice);
    // cartProductLocation.add("Surat");
    cartProductMeas.add(productMea);
    cartProductQnt.add(orderQnt);
    cartProductId.add(productId);
    cartProductShopId.add(productShopId);

    if (productMea == "Kg") {
      if (isKg) {
        cartProductQntMeas.add("Kg");
      } else {
        cartProductQntMeas.add("Gram");
      }
    } else {
      cartProductQntMeas.add(productMea);
    }

    showSnackbar(context, productName + " added in cart.", Colors.green);

    // }
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => shoppingCart()));
  }

  void getProductDetailsById(String id) {
    get(Config.mainUrl + Config.getProductDetailsById + "?id=$id")
        .then((value) {
      print("Product Response :: ${value.body}");
      data = jsonDecode(value.body.toString());

      // productId = data[0]['product_name'].toString()
      productName = data[0]['product_name'].toString();
      productPrice = data[0]['price'].toString();
      productCode = data[0]['sac_code'].toString();
      productDes = data[0]['product_desc'].toString();
      productCat = data[0]['pr_category'].toString();
      productImage = data[0]['product_image'].toString();
      productMea = data[0]['measurement'].toString();
      productQnt = data[0]['quantity'].toString();
      productQntPrice = data[0]['quantity_price'].toString();
      productShopId = data[0]['shop_id'].toString();
      productGst = data[0]['gst_percent'].toString();

      print("productQntPrice :: $productQntPrice");
      print("productQnt :: $productQnt");

      if (data[0]['quantity'].toString().length > 0 &&
          data[0]['quantity_price'].toString().length > 0) {
        if (productMea == "Kg") {
          orderQnt = 250;
          //
          qnt = productQnt.toString().split(",");
          qnt.remove("");
          qntPrice = productQntPrice.toString().split(",");
          qntPrice.remove("");
        } else {
          orderQnt = 1;
          qnt = productQnt.toString().split(",");
          qnt.remove("");
          qntPrice = productQntPrice.toString().split(",");
          qntPrice.remove("");
          //
        }
        setState(() {
          isStandard = false;
        });
      } else {
        if (data[0]['measurement'].toString() == "Kg") {
          orderQnt = 250;
          qnt = ["250", "500", "750", "1000"];
          qntPrice = [
            quantityPrice("250", "Gram"),
            quantityPrice("500", "Gram"),
            quantityPrice("750", "Gram"),
            quantityPrice("1000", "Gram")
          ];
        } else if (data[0]['measurement'].toString() == "Piece") {
          orderQnt = 1;
          qnt = ["1", "3", "5", "10"];
          qntPrice = [
            quantityPrice("1", "Piece"),
            quantityPrice("3", "Piece"),
            quantityPrice("5", "Piece"),
            quantityPrice("10", "Piece")
          ];
        } else if (data[0]['measurement'].toString() == "Litre") {
          orderQnt = 1;
          qnt = ["1", "3", "5", "10"];
          qntPrice = [
            quantityPrice("1", "Litre"),
            quantityPrice("3", "Litre"),
            quantityPrice("5", "Litre"),
            quantityPrice("10", "Litre")
          ];
        }
      }
      setState(() {
        print("Data :: ${data[0]['product_name']}");
      });
      // print("Value Body :: ${value.body}");
      // int dd = getJsonLength(data);
      // print("DD :: $dd");
      //   Map<String, dynamic> map = data[i] as Map<String, dynamic>;
      //   print("Map :: $map");
      //   productName.add(map["product_name"].toString());
      //   productPrice.add(map["price"].toString());
      //   productImage.add(map["product_image"].toString());
      //   productId.add(map["id"].toString());
      //   productMeas.add(map["measurement"].toString());
      //   productGst.add(map["gst_percent"].toString());
      //   productCode.add(map["sac_code"].toString());
      //   productDes.add(map["product_desc"].toString());
      //   productCat.add(map["pr_category"].toString());
      //   productDate.add(map['date'].toString());
    });
  }

  String quantityPrice(String quant, String _unit) {
    if (productPrice.length > 0) {
      double qntPrice = 0;
      switch (_unit) {
        case "Gram":
          qntPrice = (int.parse(quant) * double.parse(productPrice)) / 1000;
          break;
        case "Litre":
          qntPrice = int.parse(quant) * double.parse(productPrice);
          break;
        case "Piece":
          qntPrice = int.parse(quant) * double.parse(productPrice);
          break;
      }

      return qntPrice.toString();
    } else {
      return "0";
    }
  }

  orderNowFunction() {
    addToCartFunction();
    bool vv;

    get(Config.mainUrl + Config.checkUser + "?email=" + _auth.currentUser.email)
        .then((value) {
      print("value.body :: ${value.body}");
      if (value.body == "1") {
        vv = true;
      } else {
        vv = false;
      }
      print("VV :: $vv");
      if (true) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => shoppingCart()));
        //show Checkout

      } else {
        showSnackbar(
            context, "Please complete profile details to order.", Colors.amber);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => completeAllDetails(true)));
      }
    });
  }
}
