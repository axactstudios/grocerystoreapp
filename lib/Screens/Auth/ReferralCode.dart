import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocerystoreapp/Classes/Constants.dart';
import 'package:grocerystoreapp/Screens/NavBar.dart';
import 'package:random_string/random_string.dart';

class ReferralCode extends StatefulWidget {
  String shopName, shopPhone, shopAddress, shopUid;
  ReferralCode({this.shopName, this.shopPhone, this.shopAddress, this.shopUid});

  @override
  _ReferralCodeState createState() => _ReferralCodeState();
}

class _ReferralCodeState extends State<ReferralCode> {
  TextEditingController referralCode = new TextEditingController(text: '');

  void writeData() async {
    String key = await randomAlphaNumeric(15);

    final dbRef = FirebaseDatabase.instance
        .reference()
        .child('Distributors')
        .child(referralCode.text)
        .child('Shops')
        .child(key);
    dbRef.set({
      'shopName': widget.shopName,
      'shopPhone': widget.shopPhone,
      'shopAddress': widget.shopAddress,
      'shopUid': widget.shopUid
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kSecondaryColor,
        body: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Image.asset(
                'images/referral.png',
                height: MediaQuery.of(context).size.height * 0.3,
                color: kPrimaryColor,
              ),
              Center(
                child: Text(
                  'Enter your referral code',
                  style:
                      GoogleFonts.openSans(fontSize: 24, color: kPrimaryColor),
                ),
              ),
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  controller: referralCode,
                ),
              ),
              Spacer(),
              RaisedButton(
                onPressed: () {
                  writeData();
                },
                child: Text('Enter'),
              ),
              Spacer(),
            ],
          ),
        ));
  }
}
