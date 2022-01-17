import 'dart:convert';
import 'dart:io';
import 'package:drawer_swipe/drawer_swipe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopinguser/authProfile/completeAllDetails.dart';
import 'package:shopinguser/authProfile/login.dart';
import 'package:shopinguser/pages/foodDetailPage.dart';
import 'package:shopinguser/pages/resultPage.dart';
import 'package:shopinguser/pages/settingPage.dart';
import 'package:shopinguser/pages/shoppingCart.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import '../globalVariable.dart';
import 'orderHistory.dart';

class userHomePage extends StatefulWidget {
  @override
  _userHomePageState createState() => _userHomePageState();
}

class _userHomePageState extends State<userHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final searchController = TextEditingController();
  var foodName = ["Burger", "Pizza", "Snacks", "Chinese"];
  String deliverText = "India";
  var merchantUID = [];
  var foodID = [];
  var foodPrice = ["199", "249", "99", "129"];
  var foodImages = [
    ImageLink.burgerImage,
    ImageLink.pizzaImage,
    ImageLink.snacksImage,
    ImageLink.chineseImage
  ];

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
  var drawerKey = GlobalKey<SwipeDrawerState>();

  @override
  void initState() {
    // getData();
    getListedFood();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ));
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: WillPopScope(
        onWillPop: () {
          return showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('Do you want to exit an App'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('No'),
                    ),
                    FlatButton(
                      onPressed: () => exit(0),
                      /*Navigator.of(context).pop(true)*/
                      child: Text('Yes'),
                    ),
                  ],
                ),
              ) ??
              false;
        },
        child: Scaffold(
          body: SwipeDrawer(
            radius: 20,
            key: drawerKey,
            hasClone: false,
            bodyBackgroundPeekSize: 30,
            backgroundColor: colorCard,
            // pass drawer widget
            drawer: buildDrawer(),
            // pass body widget
            // child: buildBody(),
            child: SimpleGestureDetector(
              onHorizontalSwipe: (SwipeDirection direction) {
                if (direction == SwipeDirection.left) {
                  if (drawerKey.currentState.isOpened()) {
                    drawerKey.currentState.closeDrawer();
                    // setState(() {
                    //   navBarShow = true;
                    // });
                  }
                } else if (direction == SwipeDirection.right) {
                  if (!drawerKey.currentState.isOpened()) {
                    drawerKey.currentState.openDrawer();
                    // setState(() {
                    //   navBarShow = false;
                    // });
                  }
                }
              },
              child: SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 33, left: 14, right: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Deliver to",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_rounded,
                                      size: 20,
                                      color: colorDark,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      deliverText,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: colorBlack2,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () async {
                                // await FirebaseAuth.instance.signOut();
                                // signOutGoogle();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => settingPage()));
                              },
                              child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(55)),
                                child: Image.network(
                                  _auth.currentUser.photoURL,
                                  width: 36,
                                  height: 36,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: Container(
                              height: 46,
                              decoration: BoxDecoration(
                                  color: Color(0xfff3f3f3),
                                  // border: Border.all(color: colorBlack3, width: 2),
                                  borderRadius: BorderRadius.circular(12)),
                              margin:
                                  EdgeInsets.only(left: 14, right: 8, top: 33),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 6),
                                    child: Icon(
                                      Icons.search_rounded,
                                      size: 22,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Flexible(
                                    child: TextField(
                                      style: TextStyle(
                                          color: colorBlack2, fontSize: 18),
                                      controller: searchController,
                                      textAlign: TextAlign.left,
                                      cursorColor: colorBlack2,
                                      decoration: new InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              "Search restaurants or foods",
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                print(
                                    "searchController.text :: ${searchController.text}");
                                if (searchController.text.length > 0) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          resultPage(searchController.text)));
                                }
                              },
                              child: Container(
                                height: 46,
                                decoration: BoxDecoration(
                                    color: colorDark,
                                    // border: Border.all(color: colorBlack3, width: 2),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Icon(
                                  Icons.search_rounded,
                                  color: Colors.white,
                                ),
                                margin: EdgeInsets.only(
                                    top: 30, left: 8, right: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Card(
                      //     margin: EdgeInsets.only(top: 22, left: 14, right: 14),
                      //     semanticContainer: true,
                      //     clipBehavior: Clip.antiAliasWithSaveLayer,
                      //     elevation: 2,
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(8)),
                      //     child: Image.asset(
                      //       "images/foodim.jpg",
                      //       fit: BoxFit.cover,
                      //       width: double.infinity,
                      //       height: 144,
                      //     )),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 33, left: 14, right: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Categories",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: colorBlack2),
                            ),
                            Text(
                              "See all",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: colorDark),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, top: 8),
                        child: SizedBox(
                          height: 88,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: foodName.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                resultPage(foodName[index])));
                                  },
                                  child: SizedBox(
                                    width: 88,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                      color: colorCard,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.network(
                                            foodImages[index],
                                            width: 38,
                                            height: 38,
                                            fit: BoxFit.fill,
                                          ),
                                          Text(
                                            foodName[index],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: colorDark),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 33, left: 14, right: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Popular",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: colorBlack2),
                            ),
                            Text(
                              "See all",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: colorDark),
                            ),
                          ],
                        ),
                      ),
                      MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 4, right: 4, top: 8),
                          // child: SizedBox(
                          //   height: 222,
                          //   child: ListView.builder(
                          //       scrollDirection: Axis.horizontal,
                          //       itemCount: foodName.length,
                          //       itemBuilder: (context, index) {
                          //         return SizedBox(
                          //           width: 166,
                          //           child: Card(
                          //             semanticContainer: true,
                          //             clipBehavior: Clip.antiAliasWithSaveLayer,
                          //             shape: RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.circular(12.0),
                          //             ),
                          //             elevation: 0,
                          //             color: colorCard,
                          //             child: Column(
                          //               children: [
                          //                 Padding(
                          //                   padding: const EdgeInsets.only(
                          //                       top: 12, bottom: 12),
                          //                   child: Image.network(
                          //                     foodImages[index],
                          //                     height: 111,
                          //                     width: 100,
                          //                     fit: BoxFit.fill,
                          //                   ),
                          //                 ),
                          //                 Text(
                          //                   foodName[index],
                          //                   style: TextStyle(
                          //                       fontSize: 20,
                          //                       color: colorDark,
                          //                       fontWeight: FontWeight.bold),
                          //                 ),
                          //                 Text(
                          //                   foodPrice[index] + rupees,
                          //                   style: TextStyle(
                          //                       fontSize: 20,
                          //                       color: colorDark1,
                          //                       fontWeight: FontWeight.bold),
                          //                 )
                          //               ],
                          //             ),
                          //           ),
                          //         );
                          //       }),
                          // ),
                          child: GridView.count(
                              primary: false,
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                              children:
                                  List.generate(productName.length, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                foodDetailPage(
                                                    productId[index])));
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
                                            maxLines: 1,
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
                              })),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // body: SingleChildScrollView(
          //   child: Column(
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.only(top: 33, left: 14, right: 14),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   "Deliver to",
          //                   style: TextStyle(fontSize: 16, color: Colors.grey),
          //                 ),
          //                 Row(
          //                   children: [
          //                     Icon(
          //                       Icons.location_on_rounded,
          //                       size: 20,
          //                       color: colorDark,
          //                     ),
          //                     SizedBox(
          //                       width: 4,
          //                     ),
          //                     Text(
          //                       deliverText,
          //                       style: TextStyle(
          //                           fontSize: 20,
          //                           color: colorBlack2,
          //                           fontWeight: FontWeight.bold),
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //             InkWell(
          //               onTap: () async {
          //                 // await FirebaseAuth.instance.signOut();
          //                 // signOutGoogle();
          //                 Navigator.of(context).push(MaterialPageRoute(
          //                     builder: (context) => settingPage()));
          //               },
          //               child: Card(
          //                 semanticContainer: true,
          //                 clipBehavior: Clip.antiAliasWithSaveLayer,
          //                 elevation: 4,
          //                 shape: RoundedRectangleBorder(
          //                     borderRadius: BorderRadius.circular(55)),
          //                 child: Image.network(
          //                   _auth.currentUser.photoURL,
          //                   width: 36,
          //                   height: 36,
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //       Row(
          //         children: [
          //           Expanded(
          //             flex: 8,
          //             child: Container(
          //               height: 46,
          //               decoration: BoxDecoration(
          //                   color: Color(0xfff3f3f3),
          //                   // border: Border.all(color: colorBlack3, width: 2),
          //                   borderRadius: BorderRadius.circular(8)),
          //               margin: EdgeInsets.only(left: 14, right: 8, top: 30),
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.only(left: 8, right: 6),
          //                     child: Icon(
          //                       Icons.search_rounded,
          //                       size: 22,
          //                       color: Colors.grey,
          //                     ),
          //                   ),
          //                   Flexible(
          //                     child: TextField(
          //                       style:
          //                           TextStyle(color: colorBlack2, fontSize: 18),
          //                       controller: searchController,
          //                       textAlign: TextAlign.left,
          //                       cursorColor: colorBlack2,
          //                       decoration: new InputDecoration(
          //                           border: InputBorder.none,
          //                           hintText: "Search restaurants or foods",
          //                           hintStyle: TextStyle(color: Colors.grey)),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //           Expanded(
          //             flex: 2,
          //             child: Container(
          //               height: 46,
          //               decoration: BoxDecoration(
          //                   color: colorDark,
          //                   // border: Border.all(color: colorBlack3, width: 2),
          //                   borderRadius: BorderRadius.circular(8)),
          //               child: Icon(
          //                 Icons.search_rounded,
          //                 color: Colors.white,
          //               ),
          //               margin: EdgeInsets.only(top: 30, left: 8, right: 14),
          //             ),
          //           ),
          //         ],
          //       ),
          //       Card(
          //           margin: EdgeInsets.only(top: 22, left: 14, right: 14),
          //           semanticContainer: true,
          //           clipBehavior: Clip.antiAliasWithSaveLayer,
          //           elevation: 2,
          //           shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(8)),
          //           child: Image.asset(
          //             "images/foodim.jpg",
          //             fit: BoxFit.cover,
          //             width: double.infinity,
          //             height: 144,
          //           )),
          //       Padding(
          //         padding: const EdgeInsets.only(top: 20, left: 14, right: 14),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text(
          //               "Categories",
          //               style: TextStyle(
          //                   fontSize: 18,
          //                   fontWeight: FontWeight.bold,
          //                   color: colorBlack2),
          //             ),
          //             Text(
          //               "See all",
          //               style: TextStyle(
          //                   fontSize: 18,
          //                   fontWeight: FontWeight.bold,
          //                   color: colorDark),
          //             ),
          //           ],
          //         ),
          //       ),
          //       SizedBox(
          //         height: 142,
          //         child: ListView.builder(
          //             scrollDirection: Axis.horizontal,
          //             itemCount: foodName.length,
          //             itemBuilder: (context, index) {
          //               return Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: SizedBox(
          //                   width: 124,
          //                   child: Card(
          //                     shape: RoundedRectangleBorder(
          //                       borderRadius: BorderRadius.circular(10.0),
          //                     ),
          //                     elevation: 0,
          //                     color: colorDark,
          //                     child: Padding(
          //                       padding: const EdgeInsets.all(8.0),
          //                       child: Column(
          //                         mainAxisAlignment: MainAxisAlignment.center,
          //                         crossAxisAlignment: CrossAxisAlignment.center,
          //                         children: [
          //                           Icon(
          //                             Icons.emoji_food_beverage_rounded,
          //                             size: 66,
          //                             color: Colors.white,
          //                           ),
          //                           Text(
          //                             foodName[index],
          //                             textAlign: TextAlign.center,
          //                             style: TextStyle(
          //                                 fontSize: 16,
          //                                 fontWeight: FontWeight.bold,
          //                                 color: Colors.white),
          //                           )
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               );
          //             }),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(top: 6, left: 14, right: 14),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text(
          //               "Popular",
          //               style: TextStyle(
          //                   fontSize: 18,
          //                   fontWeight: FontWeight.bold,
          //                   color: colorBlack2),
          //             ),
          //             Text(
          //               "See all",
          //               style: TextStyle(
          //                   fontSize: 18,
          //                   fontWeight: FontWeight.bold,
          //                   color: colorDark),
          //             ),
          //           ],
          //         ),
          //       ),
          //       SizedBox(
          //         height: 244,
          //         child: ListView.builder(
          //             scrollDirection: Axis.horizontal,
          //             itemCount: foodName.length,
          //             itemBuilder: (context, index) {
          //               return Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: SizedBox(
          //                   width: 222,
          //                   child: Card(
          //                     semanticContainer: true,
          //                     clipBehavior: Clip.antiAliasWithSaveLayer,
          //                     shape: RoundedRectangleBorder(
          //                       borderRadius: BorderRadius.circular(10.0),
          //                     ),
          //                     elevation: 2,
          //                     child: Column(
          //                       // mainAxisAlignment: MainAxisAlignment.center,
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Image.asset(
          //                           "images/foodim.jpg",
          //                           height: 133,
          //                           width: double.infinity,
          //                           fit: BoxFit.fill,
          //                         ),
          //                         Padding(
          //                           padding:
          //                               const EdgeInsets.only(top: 8, left: 12),
          //                           child: Column(
          //                             crossAxisAlignment:
          //                                 CrossAxisAlignment.start,
          //                             children: [
          //                               Text(
          //                                 foodName[index],
          //                                 style: TextStyle(
          //                                     fontSize: 16,
          //                                     color: colorBlack2,
          //                                     fontWeight: FontWeight.bold),
          //                               ),
          //                               Text(
          //                                 "2 Km",
          //                                 style: TextStyle(
          //                                   fontSize: 14,
          //                                   color: Colors.grey,
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                         Align(
          //                           alignment: Alignment.bottomRight,
          //                           child: Container(
          //                             height: 36,
          //                             width: 66,
          //                             decoration: BoxDecoration(
          //                                 color: colorDark,
          //                                 borderRadius: BorderRadius.only(
          //                                     topLeft: Radius.circular(10))),
          //                             margin: EdgeInsets.only(left: 14, top: 8),
          //                             child: Center(
          //                               child: Text(
          //                                 '\u{20B9} 195',
          //                                 style: TextStyle(
          //                                     fontSize: 18, color: Colors.white),
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               );
          //             }),
          //       ),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }

  Widget buildDrawer() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0, top: 33),
          child: ListTile(
            leading: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(55)),
              child: Image.network(
                _auth.currentUser.photoURL,
                width: 38,
                height: 38,
              ),
            ),
            title: Text(_auth.currentUser.displayName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            // subtitle: Text(" ", style: TextStyle(fontSize: 16)),
          ),
        ),
        Divider(
          indent: 14,
          endIndent: 14,
          thickness: 1,
        ),
        ListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          horizontalTitleGap: 0,
          leading: Icon(
            Icons.phone,
            size: 24,
            color: colorDark,
          ),
          title: Text(_auth.currentUser.phoneNumber,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        ListTile(
          horizontalTitleGap: 0,
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          leading: Icon(
            Icons.email_rounded,
            size: 24,
            color: colorDark,
          ),
          title: Text("rp131318@gmail.com",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Divider(
          indent: 14,
          endIndent: 14,
          thickness: 1,
        ),
        ListTile(
          horizontalTitleGap: 0,
          visualDensity: VisualDensity(horizontal: 0, vertical: -2),
          onTap: () {
            get(Config.mainUrl +
                    Config.checkUser +
                    "?email=" +
                    _auth.currentUser.email)
                .then((value) {
              print(value.body);
              if (value.body == "1") {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => settingPage()));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => completeAllDetails(false)));
              }
            });
          },
          leading: Icon(
            Icons.account_circle_rounded,
            size: 26,
            color: colorDark,
          ),
          title: Text("Profile",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ListTile(
          onTap: () async {
            await get(Config.mainUrl +
                    Config.checkUser +
                    "?email=" +
                    _auth.currentUser.email)
                .then((value) {
              print(value.body);
              if (value.body == "1") {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => shoppingCart()));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => completeAllDetails(false)));
              }
            });
          },
          horizontalTitleGap: 0,
          visualDensity: VisualDensity(horizontal: 0, vertical: -2),
          leading: Icon(
            Icons.shopping_cart_rounded,
            size: 26,
            color: colorDark,
          ),
          title: Text("Your Cart",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => orderHistory()));
          },
          horizontalTitleGap: 0,
          visualDensity: VisualDensity(horizontal: 0, vertical: -2),
          leading: Icon(
            Icons.history_rounded,
            size: 26,
            color: colorDark,
          ),
          title: Text("Order History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ListTile(
          onTap: () {
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (context) => AboutUsPage()));
          },
          horizontalTitleGap: 0,
          visualDensity: VisualDensity(horizontal: 0, vertical: -2),
          leading: Icon(
            Icons.info_rounded,
            size: 26,
            color: colorDark,
          ),
          title: Text("About Us",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ListTile(
          horizontalTitleGap: 0,
          visualDensity: VisualDensity(horizontal: 0, vertical: -2),
          leading: Icon(
            Icons.help_rounded,
            size: 26,
            color: colorDark,
          ),
          title: Text("Help & Support",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ListTile(
          onTap: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Logout"),
                  content: SizedBox(
                      height: 33, child: Text("Do you really want to Logout?")),
                  actions: [
                    FlatButton(
                      child: Text(
                        "Yes",
                        style: TextStyle(color: colorDark),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginPage()));
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "No",
                        style: TextStyle(color: colorDark),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              },
            );
          },
          horizontalTitleGap: 0,
          visualDensity: VisualDensity(horizontal: 0, vertical: -2),
          leading: Icon(
            Icons.power_settings_new_rounded,
            size: 26,
            color: Colors.red,
          ),
          title: Text("Logout",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  void getData() {
    final User user = FirebaseAuth.instance.currentUser;
    final uid = user.uid.toString();
    FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(uid)
        .once()
        .then((DataSnapshot snap) {
      deliverText = snap.value["pincode"].toString() +
          ", " +
          snap.value["city"].toString();

      setState(() {});
    });
  }

  void getListedFood() {
    productName..clear();
    productPrice..clear();
    productImage..clear();
    productId..clear();
    productMeas.clear();
    productGst.clear();
    productCode.clear();
    productDes.clear();
    productCat.clear();
    productQnt.clear();
    productQntPrice.clear();
    productShopId.clear();
    get(Config.mainUrl + Config.getProducts).then((value) {
      print(value.body);
      final data = jsonDecode(value.body.toString());
      int dd = getJsonLength(data);

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
            print("productName :: $productName");
          });
        }
      }
    });

    // merchantUID.clear();
    // FirebaseDatabase.instance
    //     .reference()
    //     .child("Listed Food")
    //     .once()
    //     .then((DataSnapshot snap) {
    //   Map<dynamic, dynamic> values = snap.value;
    //   values.forEach((key, value) {
    //     merchantUID.add(key.toString());
    //   });
    //   print("merchantUID :: $merchantUID");
    //   getProductID();
    // });
  }

  void getProductID() {
    foodID.clear();
    for (int i = 0; i < merchantUID.length; i++) {
      FirebaseDatabase.instance
          .reference()
          .child("Listed Food")
          .child(merchantUID[i])
          .once()
          .then((DataSnapshot snap) {
        Map<dynamic, dynamic> values = snap.value;
        values.forEach((key, value) {
          foodID.add(key.toString());
          print("foodID :: $foodID");
        });
      });
      if (i == merchantUID.length - 1) {
        print("foodID :: $foodID");
      }
    }
  }

  void getUserDetailsByUserId(String userId) {
    print("User Id 2 :: $userId");
    get(Config.mainUrl + Config.getUserDetails + "?uid=$userId").then((value) {
      print("User Response :: ${value.body}");
      final data = jsonDecode(value.body.toString());

      UserDetails.name = data[0]['name'].toString();
      UserDetails.number = data[0]['number'].toString();
      UserDetails.email = data[0]['email'].toString();
      UserDetails.address = data[0]['address'].toString();
      UserDetails.pincode = data[0]['pincode'].toString();
      UserDetails.city = data[0]['city'].toString();
      UserDetails.state = data[0]['state'].toString();
      UserDetails.id = userId;
      setState(() {
        deliverText = "${UserDetails.city},${UserDetails.pincode}";
        print("Name :: ${UserDetails.email}");
      });

      // int dd = getJsonLength(data);
      // print("DD :: $dd");
      // for (int i = 0; i < dd; i++) {
      //   Map<String, dynamic> map = data[i] as Map<String, dynamic>;
      //   print("Map :: $map");
      //   userName.add(map["name"].toString());
      //   userNumber.add(map["number"].toString());
      //   userEmail.add(map["email"].toString());
      //   userAddress.add(map["address"].toString());
      //   userPincode.add(map["pincode"].toString());
      //   userCity.add(map["city"].toString());
      //   userState.add(map["state"].toString());
      //   userGender.add(map["gender"].toString());
      //   userOrderDate.add(map["date"].toString());
      //   if (i == dd - 1) {
      //     setState(() {
      //       // print("productName :: $productName");
      //     });
      //   }
      // }
    });
  }

  void getUserId() {
    get(Config.mainUrl + Config.getUserId + "?email=${_auth.currentUser.email}")
        .then((value) async {
      print("User Id:: ${value.body}");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', value.body);
      getUserDetailsByUserId(value.body);
    });
  }

  Future<void> _pullRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    getListedFood();
  }
}
