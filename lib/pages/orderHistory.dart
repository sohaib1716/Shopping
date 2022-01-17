import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopinguser/widget/button_widget.dart';
import 'package:shopinguser/widget/progressHud.dart';

import '../globalVariable.dart';
import 'foodDetailPage.dart';

class orderHistory extends StatefulWidget {
  @override
  _orderHistoryState createState() => _orderHistoryState();
}

class _orderHistoryState extends State<orderHistory> {
  bool isLoading = false;
  var userId = [];
  var productId = [];
  var qnt = [];
  var paymentMethod = [];
  var qntPrice = [];
  var productName = [];
  var productMeas = [];
  var productCat = [];
  var productPrice = [];
  var productImage = [];
  var productDate1 = [];
  var productDate2 = [];
  var productDate3 = [];
  var productDate4 = [];
  var productGst = [];
  var productCode = [];
  var productDes = [];
  var productStatus = [];
  var productRemark = [];
  var productOrderQnt = [];
  var productOrderQntPrice = [];
  var data;
  double cardHeight = 0;
  double cardHeightFb = 0;
  String trackProductName;
  String trackProductStatus;
  String trackProductRemark;
  String trackProductId;
  String trackDt1;
  String trackDt2;
  String trackDt3;
  String trackDt4;
  final feedbackController = TextEditingController();
  int star = 0;

  @override
  void initState() {
    // TODO: implement initState
    getOrderHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      body: ProgressHUD(
        isLoading: isLoading,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  cardHeight = 0;
                  cardHeightFb = 0;
                });
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(22),
                            bottomRight: Radius.circular(22)),
                        color: colorDark,
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 18, top: 28),
                              child: Text(
                                "Order History",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 18),
                              child: Text(
                                "Your order products will show here.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 22,
                          ),
                        ],
                      ),
                    ),
                    productName.length > 0
                        ? SizedBox(
                            height: 300 * productName.length.toDouble(),
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: productName.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    margin: EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                        top: 14,
                                        bottom: index == productName.length - 1
                                            ? 22
                                            : 0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 25,
                                                child: Card(
                                                  semanticContainer: true,
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Image.network(
                                                    productImage[index],
                                                    width: 88,
                                                    height: 88,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 40,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8),
                                                  child: Column(
                                                    // mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        productName[index]
                                                            .toString()
                                                            .capitalize(),
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: colorDark),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(
                                                        productPrice[index] +
                                                            rupees +
                                                            "/" +
                                                            productMeas[index],
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.star,
                                                            color: colorDark,
                                                            size: 16,
                                                          ),
                                                          Text(
                                                            "4.2",
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
                                                            "Surat",
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
                                                                .date_range_rounded,
                                                            color: colorDark,
                                                            size: 16,
                                                          ),
                                                          Text(
                                                            "${productDate1[index].toString().split("-")[2]}-${productDate1[index].toString().split("-")[1]}-${productDate1[index].toString().split("-")[0]}",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 33),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        // Icon(
                                                        //   Icons.indeterminate_check_box_rounded,
                                                        //   size: 30,
                                                        //   color: Colors.grey,
                                                        // ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 4),
                                                          child: Text(
                                                            productOrderQnt[
                                                                    index]
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color:
                                                                    colorDark,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      productOrderQntPrice[
                                                              index] +
                                                          rupees,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Divider(
                                            thickness: 1,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              print(
                                                  "Product Id ::${productId[index]}");
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          foodDetailPage(
                                                              productId[
                                                                  index])));
                                              // product details
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, top: 4),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.info,
                                                      size: 24,
                                                      color: colorDark,
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      "Product Details",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Divider(
                                            thickness: 1,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              //Feedback
                                              trackProductName =
                                                  "Product Feedback";
                                              trackProductStatus =
                                                  productStatus[index]
                                                      .toString();
                                              trackProductRemark =
                                                  productRemark[index]
                                                      .toString();
                                              trackProductId =
                                                  productId[index].toString();
                                              print(
                                                  "trackProductStatus :: $trackProductStatus");
                                              setState(() {
                                                star = 0;
                                                feedbackController.clear();
                                                cardHeightFb = 500;
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, top: 4),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.feedback,
                                                      size: 24,
                                                      color: colorDark,
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      "Product Feedback",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Divider(
                                            thickness: 1,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              //Track
                                              trackProductName =
                                                  productName[index].toString();
                                              trackProductStatus =
                                                  productStatus[index]
                                                      .toString();
                                              trackProductRemark =
                                                  productRemark[index]
                                                      .toString();
                                              trackProductId =
                                                  productId[index].toString();
                                              print(
                                                  "trackProductStatus :: $trackProductStatus");
                                              setState(() {
                                                cardHeight = 500;
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, top: 4),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .track_changes_rounded,
                                                      size: 24,
                                                      color: colorDark,
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      "Track Order",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Text("Feedback"),
                                        ],
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
                                  "Ops! No order has placed till now.",
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
                            ),
                          )
                  ],
                ),
              ),
            ),
            productName.length > 0 && trackProductStatus != null
                ? buildTrackOrder()
                : Container(),
            productName.length > 0 ? buildFeedback() : Container()
          ],
        ),
      ),
    );
  }

  Align buildTrackOrder() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 222),
        width: double.infinity,
        height: cardHeight,
        margin: EdgeInsets.zero,
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.grey,
              blurRadius: 10.0,
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: cardHeight,
          child: Card(
            // color: colorGreenLight,
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(33),
                    topRight: Radius.circular(33))),
            elevation: 10,
            margin: EdgeInsets.only(top: 22, left: 4, right: 4),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 18, right: 18),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          cardHeight = 0;
                        });
                      },
                      child: Image.network(
                        "https://cdn-icons-png.flaticon.com/512/32/32178.png",
                        height: 16,
                        width: 16,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "${trackProductName}",
                      maxLines: 1,
                      style: TextStyle(
                          color: colorDark,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ListTile(
                  leading: Container(
                    // duration: Duration(milliseconds: 222),
                    width: 44,
                    height: 44,
                    // margin: EdgeInsets.only(left: 18, top: 18),
                    decoration: BoxDecoration(
                        color: int.parse(trackProductStatus) > 0
                            ? colorDark
                            : colorDisable,
                        borderRadius: BorderRadius.circular(100)),
                    child: Icon(
                      Icons.done_rounded,
                      color: int.parse(trackProductStatus) > 0
                          ? Colors.white
                          : Colors.grey,
                      size: 33,
                    ),
                  ),
                  title: Text(
                    "Order Placed Successfully",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: int.parse(trackProductStatus) > 0
                          ? colorDark
                          : colorDisable,
                    ),
                  ),
                  subtitle: Text(
                    "26-02-2021",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                ),
                ListTile(
                  leading: Container(
                    // duration: Duration(milliseconds: 222),
                    width: 44,
                    height: 44,
                    // margin: EdgeInsets.only(left: 18, top: 18),
                    decoration: BoxDecoration(
                        color: int.parse(trackProductStatus) > 1
                            ? colorDark
                            : colorDisable,
                        borderRadius: BorderRadius.circular(100)),
                    child: Icon(
                      Icons.done_rounded,
                      color: int.parse(trackProductStatus) > 1
                          ? Colors.white
                          : Colors.grey,
                      size: 33,
                    ),
                  ),
                  title: Text(
                    "Order dispatch",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: int.parse(trackProductStatus) > 1
                          ? colorDark
                          : colorDisable,
                    ),
                  ),
                  subtitle: Text(
                    "26-02-2021",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: int.parse(trackProductStatus) > 1
                          ? colorBlack5
                          : colorDisable,
                    ),
                  ),
                ),
                ListTile(
                  leading: Container(
                    // duration: Duration(milliseconds: 222),
                    width: 44,
                    height: 44,
                    // margin: EdgeInsets.only(left: 18, top: 18),
                    decoration: BoxDecoration(
                        color: int.parse(trackProductStatus) > 2
                            ? colorDark
                            : colorDisable,
                        borderRadius: BorderRadius.circular(100)),
                    child: Icon(
                      Icons.done_rounded,
                      color: int.parse(trackProductStatus) > 2
                          ? Colors.white
                          : Colors.grey,
                      size: 33,
                    ),
                  ),
                  title: Text(
                    "Out for delivery",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: int.parse(trackProductStatus) > 2
                          ? colorDark
                          : colorDisable,
                    ),
                  ),
                  subtitle: Text(
                    "26-02-2021",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: int.parse(trackProductStatus) > 2
                          ? colorBlack5
                          : colorDisable,
                    ),
                  ),
                ),
                ListTile(
                  leading: Container(
                    // duration: Duration(milliseconds: 222),
                    width: 44,
                    height: 44,
                    // margin: EdgeInsets.only(left: 18, top: 18),
                    decoration: BoxDecoration(
                        color: int.parse(trackProductStatus) > 3
                            ? colorDark
                            : colorDisable,
                        borderRadius: BorderRadius.circular(100)),
                    child: Icon(
                      Icons.done_rounded,
                      color: int.parse(trackProductStatus) > 3
                          ? Colors.white
                          : Colors.grey,
                      size: 33,
                    ),
                  ),
                  title: Text(
                    "Order delivered successfully",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: int.parse(trackProductStatus) > 3
                          ? colorDark
                          : colorDisable,
                    ),
                  ),
                  subtitle: Text(
                    "26-02-2021",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: int.parse(trackProductStatus) > 3
                          ? colorBlack5
                          : colorDisable,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Align buildFeedback() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 222),
        width: double.infinity,
        height: cardHeightFb,
        margin: EdgeInsets.zero,
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.grey,
              blurRadius: 10.0,
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: cardHeightFb,
          child: Card(
            // color: colorGreenLight,
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(33),
                    topRight: Radius.circular(33))),
            elevation: 10,
            margin: EdgeInsets.only(top: 22, left: 4, right: 4),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 18, right: 18),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          cardHeightFb = 0;
                        });
                      },
                      child: Image.network(
                        "https://cdn-icons-png.flaticon.com/512/32/32178.png",
                        height: 16,
                        width: 16,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "$trackProductName",
                      maxLines: 1,
                      style: TextStyle(
                          color: colorDark,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18, top: 33),
                  child: Text(
                    "How many rating you will give to this product ?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 18, right: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            star = 1;
                          });
                        },
                        child: Icon(
                          star > 0
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: 40,
                          color: star > 0 ? colorDark : Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            star = 2;
                          });
                        },
                        child: Icon(
                          star > 1
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: 40,
                          color: star > 1 ? colorDark : Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            star = 3;
                          });
                        },
                        child: Icon(
                          star > 2
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: 40,
                          color: star > 2 ? colorDark : Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            star = 4;
                          });
                        },
                        child: Icon(
                          star > 3
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: 40,
                          color: star > 3 ? colorDark : Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            star = 5;
                          });
                        },
                        child: Icon(
                          star > 4
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: 40,
                          color: star > 4 ? colorDark : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18, bottom: 18),
                  child: titleTextField("Feedback", feedbackController),
                ),
                ButtonWidget(context, "Submit Feedback", feedbackFunction),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getOrderHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id');

    get(Config.mainUrl + Config.getUserOrderHistory + "?uid=$userId")
        .then((value) {
      print("Order History :: ${value.body}");
      final data = jsonDecode(value.body.toString());
      int dd = getJsonLength(data);
      print("DD :: $dd");
      for (int i = 0; i < dd; i++) {
        Map<String, dynamic> map = data[i] as Map<String, dynamic>;
        print("Map :: $map");
        productOrderQnt.add(map["amount"].toString());
        productOrderQntPrice.add(map["price"].toString());
        productDate1.add(map['date1'].toString());
        productDate2.add(map['date2'].toString());
        productDate3.add(map['date3'].toString());
        productDate4.add(map['date4'].toString());
        productStatus.add(map["status"].toString());
        productRemark.add(map["remark"].toString());
        getProductDetailsById(map["product_id"].toString());
      }
    });
  }

  void getProductDetailsById(String id) {
    var temp = {'A': 3, 'B': 1, 'C': 2};

    // var sortedKeys = temp.keys.toList(growable: false)
    //   ..sort((k1, k2) => temp[k1].compareTo(temp[k2]));
    // LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
    //     key: (k) => k, value: (k) => temp[k]);
    // print("sortedMap $sortedMap");

    get(Config.mainUrl + Config.getProductDetailsById + "?id=$id")
        .then((value) {
      print("Product Response :: ${value.body}");
      data = jsonDecode(value.body.toString());
      print("Data :: ${data[0]['id']}");
      print("Value Body :: ${value.body}");
      int dd = getJsonLength(data);
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

        if (i == dd - 1) {
          setState(() {
            // print("productName :: ${productName.length}");
            print("productDate1 :: $productDate1");
            // print("productName :: $productName");
          });
        }
      }
    });
  }

  feedbackFunction() {
    if (validateField(context, feedbackController)) {
      get(Config.mainUrl +
              Config.productFeedback +
              "?pr_id=$trackProductId&us_id=${UserDetails.id}&feedback=${feedbackController.text}&rating=$star}")
          .then((value) {
        setState(() {
          cardHeight = 0;
          cardHeightFb = 0;
        });
        if (value.body == "done") {
          showSnackbar(
              context, "Thank you for your valuable feedback", Colors.green);
        } else {
          showSnackbar(context, "Error : ${value.body}", Colors.red);
        }
        print("Feedback Response :: ${value.body}");
      });
    }
  }
}
