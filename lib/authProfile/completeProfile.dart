import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopinguser/pages/userHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopinguser/widget/progressHud.dart';
import '../globalVariable.dart';
import 'login.dart';

class completeProfile extends StatefulWidget {
  @override
  _completeProfileState createState() => _completeProfileState();
}

class _completeProfileState extends State<completeProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId;
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final address1Controller = TextEditingController();
  final foodTagsController = TextEditingController();
  final _smsController = TextEditingController();
  final address2Controller = TextEditingController();
  final pinCodeController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final customTagController = TextEditingController();
  final dobController = TextEditingController();
  final favController = TextEditingController();
  final emailController = TextEditingController();
  bool loading = false;
  bool otpLoading = false;
  bool isRegister = true; //  false
  StateSetter _setState;
  bool dialog = true;
  double popHeight;
  String foodTag = "";
  bool merchant = false;
  String radioButtonItem = "Male";
  String userString = "User";
  bool profileCon = true;
  var listedFood = [];

  // Group Value for Radio Button.
  int id = 1;

  var foodTagesList = ["Pizza", "Burger", "Cold Drinks", "Chinese", "Other"];
  var foodTagesSelected = [];

  String userName;

  String userNumber;

  String userEmail;

  String userAddress;

  String userPincode;

  String userCity;

  String userState;
  String userGender;
  String userOrderDate;
  bool isLoading = false;

  @override
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    getUserDetailsByUserId();
    // setState(() {
    //   nameController.text = auth.currentUser.displayName.toString();
    // });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      body: ProgressHUD(
        isLoading: isLoading,
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
                        padding: const EdgeInsets.only(left: 18, top: 46),
                        child: Text(
                          "User Details",
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
                          "You can change your details any time.",
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
              SizedBox(
                height: 22,
              ),
              titleTextField("Full Name", nameController),
              SizedBox(
                height: 12,
              ),
              // titleTextField("Email", emailController, false),
              // SizedBox(
              //   height: 12,
              // ),
              // titleTextField("Phone Number", phoneController, false),
              // SizedBox(
              //   height: 12,
              // ),

              titleTextField("Delivery Address", address1Controller),
              SizedBox(
                height: 12,
              ),

              titleTextField(
                  "Pin Code", pinCodeController, true, TextInputType.number),
              SizedBox(
                height: 12,
              ),
              titleTextField("City", cityController),
              SizedBox(
                height: 12,
              ),
              titleTextField("State", stateController),
              SizedBox(
                height: 22,
              ),
              InkWell(
                onTap: () {
                  if (validateField(context, nameController) &&
                      validateField(context, address1Controller) &&
                      validateField(context, pinCodeController) &&
                      validateField(context, cityController) &&
                      validateField(context, stateController)) {
                    sendUserData();
                  }
                },
                child: Container(
                    width: double.infinity,
                    height: 46,
                    decoration: BoxDecoration(
                        color: colorDark,
                        // border: Border.all(color: colorBlack3, width: 2),
                        borderRadius: BorderRadius.circular(8)),
                    margin: EdgeInsets.only(
                        left: 14, right: 14, top: 22, bottom: 22),
                    child: Center(
                        child: Text(
                      "Submit Details",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ))),
              )
            ],
          ),
        ),
      ),
    );
  }

  void verifyPhoneNumber() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    print("User ::" + user.toString());
    final uid = user.uid;

    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await auth.currentUser
          .linkWithCredential(phoneAuthCredential)
          .then((user) {
        print(uid);
      }).catchError((error) {
        print(error.toString());
      });

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => userHomePage()));

      // sendUserData();
      setState(() {
        loading = false;
      });
    };

    //Listens for errors with verification, such as too many attempts
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      showSnackbar(
          context,
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}',
          Colors.grey);
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      // showSnackbar(
      //     'Please check your phone for the verification code.', Colors.grey);
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: "+91" + phoneController.text,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackbar(context, "Failed to Verify Phone Number: ${e}", Colors.grey);
    }
  }

  // void showSnackbar(context,String message, MaterialColor red) {
  //   final snackBar = SnackBar(backgroundColor: red, content: Text(message));
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  void signInWithPhoneNumber() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    print("User ::" + user.toString());
    final uid = user.uid;
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );
      await auth.currentUser.linkWithCredential(credential).then((user) {
        print(uid);
      }).catchError((error) {
        print(error.toString());
      });
      // final User user = (await _auth.signInWithCredential(credential)).user;

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => userHomePage()));
      // sendUserData();
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  void _showDialog() {
    dialog = true;
    popHeight = 300;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: Text("Select Food Category Tags"),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                _setState = setState;
                return setupAlertDialoadContainer();
              },
            ),
          );
        });
  }

  void sendUserData() {
    get(Config.mainUrl +
            Config.updateProfile +
            "?uid=${UserDetails.id}&name=${nameController.text}&address=${address1Controller.text}&pincode=${pinCodeController.text}&city=${cityController.text}&state=${stateController.text}")
        .then((value) {
      if (value.body == "done") {
        showSnackbar(context, "Data update successfully", Colors.green);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => userHomePage()));
      }
      print("user Details Update :: ${value.body}");
    });
    // final User user = FirebaseAuth.instance.currentUser;
    // final uid = user.uid.toString();
    // FirebaseDatabase.instance.reference().child("Users").child(uid).update({
    //   "name": _auth.currentUser.displayName,
    //   "email": _auth.currentUser.email,
    //   "phone": phoneController.text,
    //   "address1": address1Controller.text,
    //   "address2": address2Controller.text,
    //   "pincode": pinCodeController.text,
    //   "city": cityController.text,
    //   "state": stateController.text,
    //   "food": foodTag,
    //   "fav": favController.text,
    //   "dob": dobController.text,
    //   "gender": radioButtonItem,
    //   "type": userString,
    //   "con": 1,
    // });
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void checkUserData() {
    FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(_auth.currentUser.uid)
        .once()
        .then((DataSnapshot snap) async {
      nameController.text = _auth.currentUser.displayName;
      phoneController.text = snap.value["phone"].toString();
      emailController.text = _auth.currentUser.email;
      if (snap.value["con"].toString() == "1") {
        profileCon = false;
        address1Controller.text = snap.value["address1"].toString();
        address2Controller.text = snap.value["address2"].toString();
        pinCodeController.text = snap.value["pincode"].toString();
        cityController.text = snap.value["city"].toString();
        stateController.text = snap.value["state"].toString();
        dobController.text = snap.value["dob"].toString();
        favController.text = snap.value["fav"].toString();
        listedFood = snap.value["food"].toString().split(" | ");
        listedFood.remove("");
        for (int i = 0; i < listedFood.length; i++) {
          foodTagesSelected
              .add(foodTagesList.indexOf(listedFood[i].toString()));
        }
        foodTag = snap.value["food"].toString();
        print("listedFood :: $listedFood");
      }
      setState(() {});
    });
  }

  setupAlertDialoadContainer() {
    return Container(
      height: popHeight,
      child: Column(
        children: [
          Divider(
            thickness: 1,
          ),
          Visibility(
            visible: dialog,
            child: Flexible(
              child: ListView.builder(
                  itemCount: foodTagesList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        if (foodTagesList[index] == "Other") {
                          _setState(() {
                            dialog = false;
                            popHeight = 188;
                          });
                        } else {
                          if (foodTagesSelected
                              .toString()
                              .contains(index.toString())) {
                            foodTag = foodTag.replaceAll(
                                " | " + foodTagesList[index], "");
                            foodTagesSelected.remove(index);
                          } else {
                            foodTagesSelected.add(index);
                            foodTag = foodTag + " | " + foodTagesList[index];
                          }
                          _setState(() {
                            print("foodTagesSelected :: $foodTagesSelected");
                            print("foodTag :: $foodTag");
                          });
                        }
                      },
                      title: Text(
                        foodTagesList[index],
                        style: TextStyle(
                            color: foodTagesSelected
                                    .toString()
                                    .contains(index.toString())
                                ? colorDark
                                : colorBlack2,
                            fontSize: 18,
                            fontWeight: foodTagesSelected
                                    .toString()
                                    .contains(index.toString())
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                      leading: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: colorBlack1,
                      ),
                    );
                  }),
            ),
          ),
          Visibility(
            visible: !dialog,
            child: Container(
              height: 46,
              width: 222,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colorBlack3, width: 2),
                  borderRadius: BorderRadius.circular(8)),
              margin: EdgeInsets.only(left: 14, right: 4, top: 8, bottom: 33),
              child: TextField(
                style: TextStyle(color: colorBlack2, fontSize: 18),
                controller: customTagController,
                textAlign: TextAlign.center,
                cursorColor: Colors.white,
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText: "Custom Food Tags",
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Divider(
            thickness: 1,
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    foodTag = "";
                    foodTagesSelected.clear();
                    customTagController.clear();
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  "Clear All",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (customTagController.text.length > 0) {
                      foodTag = foodTag + " | " + customTagController.text;
                    }
                    customTagController.clear();
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  "Done",
                  style: TextStyle(
                      color: colorDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> checkMerchant() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    merchant = prefs.getBool('merchant');
    if (merchant) {
      userString = "Merchant";
    }
    setState(() {});
  }

  Widget titleTextField(String s, TextEditingController nameController,
      [bool enable = true, final keyBoard = TextInputType.text]) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              s,
              style: TextStyle(
                  fontSize: 18, color: colorDark, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          height: 46,
          decoration: BoxDecoration(
              // color:  colorLight,
              border: Border.all(color: grey, width: 1),
              borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.only(left: 18, right: 18, top: 6),
          padding: EdgeInsets.only(left: 18),
          child: TextField(
            enabled: enable,
            style: TextStyle(color: colorBlack2, fontSize: 18),
            controller: nameController,
            keyboardType: keyBoard,
            textAlign: TextAlign.left,
            cursorColor: colorBlack2,
            decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: " ",
                hintStyle: TextStyle(color: Colors.grey)),
          ),
        ),
      ],
    );
  }

  void chooseDate() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1900, 3, 5),
        maxTime: DateTime.now(),
        theme: DatePickerTheme(
            // headerColor: global,
            backgroundColor: Colors.white,
            itemStyle: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            cancelStyle: TextStyle(color: Colors.black, fontSize: 16),
            doneStyle: TextStyle(color: colorDark, fontSize: 16)),
        onChanged: (date) {
      print('change $date in time zone ' +
          date.timeZoneOffset.inHours.toString());
      setState(() {
        dobController.text = date.toString().split(" ")[0].toString();
      });
    }, onConfirm: (date) {
      print('confirm $date');
      setState(() {
        dobController.text = date.toString().split(" ")[0].toString();
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  // void submitDetails() {
  //   if (nameController.text.length > 0 &&
  //       phoneController.text.length > 0 &&
  //       address1Controller.text.length > 0 &&
  //       pinCodeController.text.length > 0 &&
  //       cityController.text.length > 0 &&
  //       stateController.text.length > 0 &&
  //       dobController.text.length > 0) {
  //     sendUserData();
  //   } else {
  //     showSnackbar(context, "Please provide correct details.", Colors.grey);
  //   }
  // }

  Future<void> getUserDetailsByUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id');

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
// void _showSnackbar() {
//   final snackBar = SnackBar(
//       backgroundColor: Colors.redAccent,
//       content: Text("Fields can't be empty"));
//   ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }
}
