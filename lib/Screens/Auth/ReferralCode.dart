import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ReferralCode extends StatefulWidget {
  String shopName, shopPhone, shopAddress, shopUid;
  ReferralCode({this.shopName, this.shopPhone, this.shopAddress, this.shopUid});

  @override
  _ReferralCodeState createState() => _ReferralCodeState();
}

class _ReferralCodeState extends State<ReferralCode> {
  TextEditingController referralCode = new TextEditingController(text: '');

  void writeData() async {
    final dbRef = FirebaseDatabase.instance
        .reference()
        .child('Distributors')
        .child(referralCode.text)
        .child('Shops');
    dbRef.set({
      'shopName': widget.shopName,
      'shopPhone': widget.shopPhone,
      'shopAddress': widget.shopAddress,
      'shopUid': widget.shopUid
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
