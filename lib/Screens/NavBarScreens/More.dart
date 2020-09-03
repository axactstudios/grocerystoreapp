import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grocerystoreapp/Classes/Constants.dart';
import 'package:grocerystoreapp/Screens/Auth/LoginPage.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  FirebaseAuth mAuth = FirebaseAuth.instance;

  String shopName, shopAddress, shopPhone, shopZip, shopImage;

  void getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String shopCategory = await prefs.getString('category');
    FirebaseUser user = await mAuth.currentUser();
    final dbRef = FirebaseDatabase.instance
        .reference()
        .child(shopCategory)
        .child(user.uid);
    dbRef.once().then((DataSnapshot snapshot) async {
      shopName = await snapshot.value['name'];
      shopImage = await snapshot.value['imageUrl'];
      print(snapshot.value);
      shopAddress = await snapshot.value['address'];
      shopPhone = await snapshot.value['phoneNo'];

      setState(() {
        print(shopName);
      });
    });
  }

  @override
  void initState() {
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    final pHeight = MediaQuery.of(context).size.height;
    final pWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        actions: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                'More Options',
                style:
                    TextStyle(fontFamily: 'Poppins', fontSize: pHeight * 0.025),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            shopName != null
                ? Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(shopImage),
                            radius: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(shopName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                  )),
                              Text('Shop Address',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: kSecondaryColor,
                                    fontFamily: 'Poppins',
                                  )),
                              Container(
                                  width: pWidth / 1.4,
                                  child: Text(shopAddress)),
                              Text('Phone- $shopPhone')
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: Center(
                      child: SpinKitFadingFour(
                        color: kSecondaryColor,
                      ),
                    ),
                  ),
            InkWell(
              onTap: () {
                _launchURL('https://www.google.com/');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 19.5),
                child: Row(
                  children: [
                    SizedBox(
                      width: pWidth * 0.144,
                    ),
                    Icon(
                      Icons.info_outline,
                      size: 40,
                    ),
                    SizedBox(
                      width: pWidth * 0.0853,
                    ),
                    Text(
                      'About',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: pWidth,
              child: Divider(
                color: Colors.black.withOpacity(
                  0.3,
                ),
                thickness: 0.5,
              ),
            ),
            InkWell(
              onTap: () {
                _launchURL('https://www.google.com/');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 19.5),
                child: Row(
                  children: [
                    SizedBox(
                      width: pWidth * 0.144,
                    ),
                    Icon(
                      Icons.warning,
                      size: 40,
                    ),
                    SizedBox(
                      width: pWidth * 0.0853,
                    ),
                    Text(
                      'Send Feedback',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: pWidth,
              child: Divider(
                color: Colors.black.withOpacity(
                  0.3,
                ),
                thickness: 0.5,
              ),
            ),
            InkWell(
              onTap: () {
                FirebaseAuth.instance.signOut();
                pushNewScreen(context, screen: LoginPage(), withNavBar: false);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 19.5),
                child: Row(
                  children: [
                    SizedBox(
                      width: pWidth * 0.144,
                    ),
                    Icon(
                      Icons.exit_to_app,
                      size: 40,
                    ),
                    SizedBox(
                      width: pWidth * 0.0853,
                    ),
                    Text(
                      'Log Out',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: pWidth,
              child: Divider(
                color: Colors.black.withOpacity(
                  0.3,
                ),
                thickness: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchURL(String launchUrl) async {
    String url = launchUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
