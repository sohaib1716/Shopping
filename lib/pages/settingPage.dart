import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopinguser/authProfile/auth.dart';
import 'package:shopinguser/authProfile/login.dart';
import '../authProfile/completeProfile.dart';
import '../globalVariable.dart';

class settingPage extends StatefulWidget {
  @override
  _settingPageState createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String add = "--",
      food = "--",
      phone = "--",
      city = "--",
      state = "--",
      dob = "--",
      fav = "--",
      gender = "--";
  bool merchant = false;
  String userString = "User";

  String userName;

  String userNumber;

  String userEmail;

  String userAddress;

  String userPincode;

  String userCity;

  String userState;
  String userGender;
  String userOrderDate;
  // SharedPreferences.setMockInitialValues (Map<String, dynamic> values);

  @override
  void initState() {
    // TODO: implement initState
    getUserDetailsByUserId();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 188,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22)),
              color: colorDark,
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 33,
              ),
              Center(
                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  child: Image.network(
                    _auth.currentUser.photoURL,
                    width: 66,
                    height: 66,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                _auth.currentUser.displayName,
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Visibility(
                visible: merchant,
                child: Text(
                  "Merchant Account",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 33,
              ),
              userAddress != null
                  ? Flexible(
                      child: ListView(
                        children: [
                          buildProfileText("Email", _auth.currentUser.email),
                          buildDivider(),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 22, right: 22),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Text(
                                      "Phone",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    )),
                                Expanded(
                                    flex: 7,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image.asset(
                                          "images/flag.png",
                                          height: 22,
                                          width: 26,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 6),
                                          child: Text(
                                            _auth.currentUser.phoneNumber,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: colorBlack2),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          buildDivider(),
                          buildProfileText("Address", userAddress),
                          buildDivider(),
                          buildProfileText("City", userCity),
                          buildDivider(),
                          buildProfileText("State", userState),
                          buildDivider(),
                          buildProfileText("Gender", userGender),
                          buildDivider(),
                          Card(
                            margin:
                                EdgeInsets.only(left: 22, right: 22, top: 22),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: colorDark),
                              child: Center(
                                child: InkWell(
                                  onTap: () async {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                completeProfile()));
                                  },
                                  child: Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.only(
                                left: 22, right: 22, top: 8, bottom: 33),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: colorDark, width: 2),
                              ),
                              child: Center(
                                child: InkWell(
                                  onTap: () async {
                                    await FirebaseAuth.instance.signOut();
                                    signOutGoogle();
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
                                  },
                                  child: Text(
                                    "Logout",
                                    style: TextStyle(
                                        fontSize: 20, color: colorDark),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 88),
                      child: Center(child: CircularProgressIndicator()),
                    )
            ],
          ),
        ],
      ),
    );
  }

  Padding buildProfileText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              )),
          Expanded(
              flex: 7,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 16, color: colorBlack2),
              )),
        ],
      ),
    );
  }

  Divider buildDivider() {
    return Divider(
      indent: 22,
      endIndent: 22,
      height: 44,
      thickness: 2,
    );
  }

  Future<void> getUserDetailsByUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id');
    print("User Id :: $userId");

    get(Config.mainUrl + Config.getUserDetails + "?uid=$userId").then((value) {
      print("User Response :: ${value.body}");
      final data = jsonDecode(value.body.toString());
      int dd = getJsonLength(data);
      print("DD :: $dd");
      Map<String, dynamic> map = data[0] as Map<String, dynamic>;
      print("Map :: $map");
      userName = map["name"].toString();
      userNumber = (map["number"].toString());
      userEmail = (map["email"].toString());
      userAddress = (map["address"].toString());
      userPincode = (map["pincode"].toString());
      userCity = (map["city"].toString());
      userState = (map["state"].toString());
      userGender = (map["gender"].toString());
      userOrderDate = (map["date"].toString());
      setState(() {
        // print("productName :: $productName");
      });
    });
  }

  Future<void> checkMerchant() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    merchant = prefs.getBool('merchant');
    print("merchant :: $merchant");
    setState(() {});
  }

  void getData() {
    FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(_auth.currentUser.uid)
        .once()
        .then((DataSnapshot snap) {
      Map<dynamic, dynamic> values = snap.value;
      add = values["address1"].toString() +
          " " +
          values["address2"].toString() +
          " " +
          values["pincode"].toString();
      food = values["food"].toString();
      phone = values["phone"].toString();
      city = values["city"].toString();
      dob = values["dob"].toString();
      fav = values["fav"].toString();
      state = values["state"].toString();
      gender = values["gender"].toString();
      setState(() {
        print(food);
      });
    });
  }
}
