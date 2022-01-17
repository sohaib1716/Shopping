import 'dart:convert';

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopinguser/authProfile/login.dart';
import 'package:shopinguser/pages/userHomePage.dart';
import 'package:shopinguser/widget/button_widget.dart';
import 'package:shopinguser/widget/progressHud.dart';

import '../globalVariable.dart';

class shoppingCart extends StatefulWidget {
  @override
  _shoppingCartState createState() => _shoppingCartState();
}

class _shoppingCartState extends State<shoppingCart> {
  double total = 0;
  bool isLoading = false;
  int step = 0;
  int id = 1;
  String radioButtonItem = "COD";

  @override
  void initState() {
    // TODO: implement initState
    for (int i = 0; i < cartProductOrderPrice.length; i++) {
      total = total + double.parse(cartProductOrderPrice[i]);
    }
    print("total ::$total");

    totalAmount = total.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProgressHUD(
        isLoading: isLoading,
        child: Stack(
          children: [
            Visibility(
              visible: step == 1 ? true : false,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      margin: const EdgeInsets.only(top: 44, left: 12),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12, left: 12),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Shipping Address",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: colorDark),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12, left: 12),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "${UserDetails.name}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 12),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "${UserDetails.address} ${UserDetails.pincode} ${UserDetails.city} ${UserDetails.state}",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 22, left: 12),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Order Summary",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: colorDark),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              // color: grey,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Product",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Text(
                                    "Price",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Text(
                                    "Qty",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Text(
                                    "Subtotal",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: cartProductId.length > 0
                                ? SizedBox(
                                    height:
                                        55 * cartProductId.length.toDouble(),
                                    child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: cartProductId.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            padding: EdgeInsets.all(8),
                                            margin: EdgeInsets.only(
                                                top: 0, left: 5, right: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              // color: (double.parse(index.toString()) % 2.0) == 0
                                              //     ? grey
                                              //     : colorCard,
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        cartProductName[index]
                                                            .toString()
                                                            .capitalize(),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "${cartProductPrice[index]}$rupees",
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "${cartProductQnt[index]} ${cartProductQntMeas[index]} ",
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "${cartProductOrderPrice[index]}$rupees",
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  thickness: 1,
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                  )
                                : Container(),
                          ),
                          buildProfileText("Shipping fee", "100 $rupees"),
                          SizedBox(
                            height: 4,
                          ),
                          buildProfileText("Sub total", "${total} $rupees"),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 18, left: 12, right: 12, bottom: 18),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Total",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      "${total + 100} $rupees",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Card(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: ListTile(
                        leading: Radio(
                          activeColor: colorDark,
                          value: 2,
                          groupValue: id,
                          onChanged: (val) {
                            setState(() {
                              radioButtonItem = 'Pay Online';
                              id = 2;
                            });
                          },
                        ),
                        title: Text(
                          'Pay Online',
                          style: new TextStyle(
                              fontSize: 18.0,
                              color: colorBlack1,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Pay using UPI or card.',
                          style:
                              new TextStyle(fontSize: 14.0, color: colorBlack1),
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.only(left: 12, right: 12, top: 12),
                      child: ListTile(
                        leading: Radio(
                          activeColor: colorDark,
                          value: 1,
                          groupValue: id,
                          onChanged: (val) {
                            setState(() {
                              radioButtonItem = 'COD';
                              id = 1;
                            });
                          },
                        ),
                        title: Text(
                          'COD',
                          style: new TextStyle(
                              fontSize: 18.0,
                              color: colorBlack1,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Cash on delivery.',
                          style:
                              new TextStyle(fontSize: 14.0, color: colorBlack1),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    ButtonWidget(
                        context, "Checkout", payFunction, false, 12, 12),
                    SizedBox(
                      height: 44,
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: step == 0 ? true : false,
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
                                "Your Cart",
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
                                "Your added cart products will show here.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, left: 18),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: InkWell(
                                    onTap: () {
                                      if (total > 0) {
                                        setState(() {
                                          step = 1;
                                        });
                                        // checkOutFunction();
                                      }
                                    },
                                    child: Container(
                                        width: 100,
                                        height: 33,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            // border: Border.all(
                                            //     color: border ? colorDark : Colors.transparent,
                                            //     width: border ? 2 : 0),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Center(
                                            child: Text(
                                          "Checkout",
                                          style: TextStyle(
                                              fontSize: 18, color: colorDark),
                                        ))),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, right: 18),
                                child: Text(
                                  "Total : " + totalAmount + " " + rupees,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 22,
                          ),
                        ],
                      ),
                    ),
                    cartProductId.length > 0
                        ? SizedBox(
                            height: 166 * cartProductId.length.toDouble(),
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: cartProductId.length,
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
                                        bottom: index == 4 ? 22 : 0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 25,
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
                                                cartProductImage[index],
                                                width: 88,
                                                height: 88,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 40,
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
                                                    cartProductName[index],
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: colorDark),
                                                  ),
                                                  Text(
                                                    cartProductPrice[index] +
                                                        rupees +
                                                        "/" +
                                                        cartProductMeas[index],
                                                    style: TextStyle(
                                                      fontSize: 18,
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
                                                        "Surat",
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
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 33),
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
                                                          const EdgeInsets.only(
                                                              right: 4),
                                                      child: Text(
                                                        cartProductQnt[index]
                                                                .toString() +
                                                            " " +
                                                            cartProductQntMeas[
                                                                index],
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: colorDark,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        cartProductName
                                                            .removeAt(index);
                                                        cartProductImage
                                                            .removeAt(index);
                                                        cartProductPrice
                                                            .removeAt(index);
                                                        cartProductMeas
                                                            .removeAt(index);
                                                        cartProductQnt
                                                            .removeAt(index);
                                                        cartProductId
                                                            .removeAt(index);
                                                        cartProductShopId
                                                            .removeAt(index);
                                                        cartProductOrderPrice
                                                            .removeAt(index);
                                                        cartProductQntMeas
                                                            .removeAt(index);
                                                        total = 0;
                                                        for (int i = 0;
                                                            i <
                                                                cartProductOrderPrice
                                                                    .length;
                                                            i++) {
                                                          total = total +
                                                              double.parse(
                                                                  cartProductOrderPrice[
                                                                      i]);
                                                        }
                                                        print("total ::$total");

                                                        totalAmount =
                                                            total.toString();
                                                        setState(() {});
                                                      },
                                                      child: Icon(
                                                        Icons
                                                            .indeterminate_check_box_rounded,
                                                        size: 30,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  cartProductOrderPrice[index] +
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
                                  "Ops! Your cart is empty.",
                                  style: TextStyle(fontSize: 22),
                                )
                              ],
                            ),
                          )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: step == 2 ? true : false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      "https://cdn.freebiesupply.com/images/thumbs/2x/successful-purchase-t33.png",
                      height: 266,
                      width: 266,
                    ),
                    Text(
                      "Your order is completed!",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      "Your order expected delivery in 5-7 days.",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    ButtonWidget(
                        context, "Continue shopping", homePageFunction),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding buildProfileText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 12, right: 12),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18),
              )),
          Expanded(
              flex: 1,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18),
              )),
        ],
      ),
    );
  }

  checkOutFunction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id');

    String paymentMethod = "COD";

    if (radioButtonItem == "COD") {
      paymentMethod = "COD";
    } else {
      paymentMethod = "Prepaid";
    }

    setState(() {
      isLoading = true;
    });
    for (int i = 0; i < cartProductId.length; i++) {
      final milli = DateTime.now().microsecondsSinceEpoch;
      print("milli :: $milli");
      await Future.delayed(const Duration(milliseconds: 100), () async {
        print("Shop Id :: ${cartProductShopId[i].toString()}");
        await post(Config.mainUrl + Config.sendOrder, body: {
          "pr_id": cartProductId[i].toString(),
          "shop_id": cartProductShopId[i].toString(),
          "user_id": userId,
          "pay_method": paymentMethod,
          "price": cartProductOrderPrice[i].toString(),
          "amount": cartProductQnt[i].toString() +
              " " +
              cartProductQntMeas[i].toString(),
          "order_status": "1",
          "order_remark": "Order Successful",
          "order_id": milli.toString(),
        }).then((value) async {
          print("Checkout :: ${value.body}");
        });
      });
      if (i == cartProductId.length - 1) {
        setState(() {
          step = 2;
          isLoading = false;
        });

        //////////////////////

        // showSnackbar(context, "Thank You for giving order.", Colors.green);
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => LoginPage()));
      }
    }
  }

  payFunction() async {
    // setState(() {
    //   step = 2;
    // });

    if (radioButtonItem == "COD") {
      checkOutFunction();
    } else {
      final milli = DateTime.now().microsecondsSinceEpoch;
      print("milli :: $milli");
      final body = {
        "orderId": "$milli",
        "orderAmount": "$total",
        "orderCurrency": "INR",
      };

      await post("https://test.cashfree.com/api/v2/cftoken/order",
              headers: {
                "x-client-id": "99603f0e407c8b854e505344830699",
                "x-client-secret": "ae52dc8bf63e04039029235dbc78db159a4b1033"
              },
              body: json.encode(body))
          .then((value) {
        final a = jsonDecode(value.body.toString().replaceAll("\n", ""));
        print("Value :: ${a['cftoken']}");
        print("milli :: $milli");

        Map<String, dynamic> inputParams = {
          "orderId": "$milli",
          "orderAmount": "$total",
          "customerName": "${UserDetails.name}",
          "orderNote": "Delivered Fast",
          "orderCurrency": "INR",
          "appId": "99603f0e407c8b854e505344830699",
          "customerPhone": "${UserDetails.number}",
          "customerEmail": "${UserDetails.email}",
          "stage": "TEST",
          "tokenData": "${a['cftoken']}",
          // "notifyUrl": notifyUrl
        };
        CashfreePGSDK.doUPIPayment(inputParams).then((value) {
          print("Value 11 :: ${value['txStatus']}");

          if (value['txStatus'] == "SUCCESS") {
            checkOutFunction();
            showSnackbar(context, "${value['txMsg']}", Colors.green);
          } else {
            showSnackbar(context, "${value['txMsg']}", Colors.red);
          }

          // value?.forEach((key, value) {
          //   print("$key : $value");
          //   if (key.toString() == "txStatus" && value.toString() == "SUCCESS") {
          //     checkOutFunction();
          //     if (key.toString() == "txMsg") {
          //       showSnackbar(context, "Error : $value", Colors.green);
          //     }
          //   } else {
          //     if (key.toString() == "txMsg") {
          //       showSnackbar(context, "Error : $value", Colors.red);
          //     }
          //   }
          //   //Do something with the result
          // });
        });
      });
    }
  }

  homePageFunction() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => userHomePage()));
  }
}
