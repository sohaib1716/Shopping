library my_prj.globals;

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'dart:ui';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color colorAccent = Color(0xFFa8a8f9);
const Color colorLight = Color(0xFFf8ecee);
const Color colorDark = Color(0xFF6B45BC);
// const Color colorDark = Color(0xFF6066cf);
const Color colorDark1 = Color(0xFFfba92e);
const Color colorBlack1 = Color(0xFF5d5047);
const Color colorBlack2 = Color(0xFF1f1b18);
const Color colorBlack3 = Color(0xFF958787);
const Color colorText = Color(0xFF315074);
const Color colorBlack5 = Color(0xFF404145);
const Color colorCard = Color(0xfff3f3f3);
const Color colorDisable = Color(0xffEBEBE4);

final grey = Colors.grey;
final white = Colors.white;
final rupees = ' \u{20B9}';

var cartProductName = [];
var cartProductId = [];
var cartProductMeas = [];
var cartProductCat = [];
var cartProductPrice = [];
var cartProductImage = [];
var cartProductGst = [];
var cartProductCode = [];
var cartProductDes = [];
var cartProductQnt = [];
var cartProductQntPrice = [];
var cartProductShopId = [];
var cartProductQntMeas = [];
var cartProductOrderPrice = [];





Widget loadingWidget([String msg = "No details were found."]) {
  return Center(
    child: FutureBuilder(
        future: Future.delayed(Duration(seconds: 3)),
        builder: (c, s) => s.connectionState == ConnectionState.done
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "https://cdn-icons-png.flaticon.com/512/2345/2345152.png",
              width: 155,
              height: 155,
              color: colorDark,
            ),
            SizedBox(
              height: 22,
            ),
            Text(
              msg,
              style: TextStyle(fontSize: 18),
            )
          ],
        )
            : CircularProgressIndicator()),
  );
}

// userName.add(map["name"].toString());
//   userNumber.add(map["number"].toString());
//   userEmail.add(map["email"].toString());
//   userAddress.add(map["address"].toString());
//   userPincode.add(map["pincode"].toString());
//   userCity.add(map["city"].toString());
//   userState.add(map["state"].toString());
//   userGender.add(map["gender"].toString());
//   userOrderDate.add(map["date"].toString());
class UserDetails {
  static String name = "User";
  static String number = "User";
  static String email = "User";
  static String address = "User";
  static String pincode = "User";
  static String city = "User";
  static String state = "User";
  static String id = "User";
}

String totalAmount;

final FirebaseAuth _auth = FirebaseAuth.instance;

final User user = FirebaseAuth.instance.currentUser;
final uid = user.uid.toString();
String name, email;

var preDefineCategory = [];

class ImageLink {
  static String storeListingImage =
      "https://images.unsplash.com/photo-1534723452862-4c874018d66d?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8c3RvcmV8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60";
  static String listedFoodImage =
      "https://media.istockphoto.com/photos/table-top-view-of-indian-food-picture-id1212329362?k=6&m=1212329362&s=170667a&w=0&h=9XGLawVk3hCURarU72cwMDUc0hNFf9OmK-eqMUAckMo=";
  static String dailyRevenueImage =
      "https://images.pexels.com/photos/53621/calculator-calculation-insurance-finance-53621.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940";
  static String discountOfferSchemeImage =
      "https://img.freepik.com/free-vector/special-offer-sale-discount-banner_180786-46.jpg?size=626&ext=jpg";
  static String gstComplianceImage =
      "https://i1.wp.com/www.a2ztaxcorp.com/wp-content/uploads/2019/08/GST-Compliance-Rating.jpg";
  static String merchantAgreementImage =
      "https://images.pexels.com/photos/327540/pexels-photo-327540.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500";
  static String holidayManagementImage =
      "https://images.unsplash.com/photo-1475503572774-15a45e5d60b9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHx8&w=1000&q=80";
  static String suggestionBoxImage =
      "https://media.istockphoto.com/photos/hand-inserting-suggestion-into-suggestion-box-picture-id496792842?k=6&m=496792842&s=612x612&w=0&h=tjpiINzHztG4e-YxCUly2vui-QosVGfoVxNQj4Tu9F8=";

  static String burgerImage =
      "https://toppng.com/uploads/preview/burger-vector-png-image-black-and-white-download-burger-11562863804fhwuffqm2f.png";
  static String pizzaImage =
      "https://www.pngfind.com/pngs/m/80-800270_pizza-png-high-quality-image-png-de-pizza.png";
  static String snacksImage = "https://image.pngaaa.com/480/3187480-middle.png";
  static String chineseImage =
      "https://w7.pngwing.com/pngs/519/447/png-transparent-pancit-chinese-cuisine-lor-mee-malaysian-cuisine-chowking-chinese-style-food-recipe-cooking.png";
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString() => String.fromCharCodes(Iterable.generate(
    28, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

final flutterLongText = "Miusov, as a man man of breeding and deilcacy, could "
    "not but feel some inwrd qualms, when he reached the Father Superior's with "
    "Ivan: he felt ashamed of havin lost his temper. He felt that he ought to "
    "have disdaimed that despicable wretch, Fyodor Pavlovitch, too much to have "
    "been upset by him in Father Zossima's cell, and so to have "
    "forgotten himself.";
final flutterShortText = "Note that UltimateSpell displays the text in the "
    "dialog box sentence-by-sentence just like Microsoft Word.";

class Config {
  static String mainUrl = "http://sweetsavoury.online/";
  static String addUserDetails = "user_panel/upload_details.php";
  static String checkUser = "user_panel/user_exist.php";
  static String getProducts = "user_panel/get_products.php";
  static String sendOrder = "user_panel/send_order.php";
  static String getUserId = "user_panel/get_uid.php";
  static String getUserActiveProducts = "user_panel/active_orders.php";
  static String getSearchResults = "search/search_products.php";
  static String merchantProductsUrl = "merchant_product.php";
  static String getUserDetails = "user_panel/get_userdetails.php";
  static String getUserOrderHistory = "user_panel/active_orders.php";
  static String getProductDetailsById = "merchant_panel/get_productsbyID.php";
  static String productFeedback = "user_panel/feedback.php";
  static String updateProfile = "user_panel/update_profile.php";
}

int getJsonLength(jsonText) {
  int len = 0;
  try {
    while (jsonText[len] != null) {
      len++;
    }
    // print("Len :: $len");
  } catch (e) {
    print("Len Catch :: $len");
    return len;
  }
}

// ignore: missing_return
bool isProfileCompleted() {
  print("Email :: ${_auth.currentUser.email}");

  get(Config.mainUrl + Config.checkUser + "?email=" + _auth.currentUser.email)
      .then((value) {
    print(value.body);
    if (value.body == "1") {
      return true;
    } else {
      return false;
    }
  });
}

bool validateField(context, TextEditingController controller,
    [int validateLength = 0,
    String fieldType = "default",
    String errorMsg = "Field Can't be empty..."]) {
  if (controller.text.length > validateLength) {
    switch (fieldType) {
      case "default":
        return true;
        break;
      case "phone":
        if (controller.text.length == 10) {
          return true;
        }
        showSnackbar(context, "Phone number should be 10 digits", Colors.red);

        break;
      case "email":
        if (controller.text.contains(RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
          return true;
        }
        showSnackbar(context, "Provide correct email address", Colors.red);
        break;
      case "password":
        if (controller.text.length > 8) {
          return true;
        }
        showSnackbar(context, "Password should be 8 digits", Colors.red);
        break;
    }
  } else {
    showSnackbar(context, errorMsg, Colors.red);
    return false;
  }
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
            style: TextStyle(fontSize: 18, color: colorDark),
          ),
        ),
      ),
      Container(
        height: 46,
        decoration: BoxDecoration(
            // color: global.colorLight,
            border: Border.all(width: 1, color: grey),
            borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.only(left: 18, right: 18, top: 6),
        padding: EdgeInsets.only(left: 14),
        child: TextFormField(
          enabled: enable,
          style: TextStyle(fontSize: 18),
          controller: nameController,
          keyboardType: keyBoard,
          cursorColor: Colors.black45,
          // textAlign: TextAlign.center,
          decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: " ",
              hintStyle: TextStyle(color: Colors.grey)),
        ),
      ),
    ],
  );
}

Future<String> appCurrentUser(String key) async {
  final User user = FirebaseAuth.instance.currentUser;
  final uid = user.uid.toString();
  await FirebaseDatabase.instance
      .reference()
      .child("Users")
      .child(uid)
      .once()
      .then((DataSnapshot snap) {
    Map<dynamic, dynamic> values = snap.value;
    name = values["name"].toString();
    // email = values["email"].toString();
    return Future.value(name);
    // print("Return Data :: " + values[key].toString());
  });
}

void showSnackbar(context, String message, MaterialColor color) {
  final snackBar = SnackBar(
    backgroundColor: color,
    content: Text(message),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSnackbarWithButton(
    context, String message, MaterialColor color, btnText, function()) {
  final snackBar = SnackBar(
    backgroundColor: color,
    content: Text(message),
    action: SnackBarAction(
      label: btnText,
      onPressed: function(),
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<void> checkLocationPermission() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // if (prefs.getString('wTemp') != null) {
  //   WeatherData.temperature = prefs.getString('wTemp');
  //   WeatherData.feelTemperature = prefs.getString('wFeelTemp');
  //   WeatherData.placeName = prefs.getString('wPlace');
  //   WeatherData.weatherCondition = prefs.getString('wCon');
  // }

  await PermissionHandler()
      .requestPermissions([PermissionGroup.location]).then((value) {
    print("fun1");
    _getCurrentLocation();
  });
}

Future<void> copyToClipboard(context, copyText) async {
  await Clipboard.setData(ClipboardData(text: copyText));
  showSnackbar(context, '$copyText Copied to clipboard', Colors.green);
}

_getCurrentLocation() {
  print("outside");
  Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          forceAndroidLocationManager: true)
      .then((Position position) {
    _getAddressFromLatLng(position.latitude, position.longitude);
    print("fun2 :: ${position.latitude}");
  }).catchError((e) {
    print("Error Geo :: $e");
  });
}

_getAddressFromLatLng(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    Placemark place = placemarks[0];
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;

    FirebaseDatabase.instance.reference().child("Users").child(uid).update({
      "location": "${place.locality}, ${place.postalCode}, ${place.country}",
    }).then((value) {
      print("funnvj");
    });
  } catch (e) {
    print(e);
  }
}
