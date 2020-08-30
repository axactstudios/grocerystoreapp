import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grocerystoreapp/Classes/Constants.dart';
import 'package:grocerystoreapp/Classes/Products.dart';
import 'package:grocerystoreapp/Screens/NavBarScreens/Products.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class UpdateProduct extends StatefulWidget {
  Product item;
  String shopCategory, productCategory;

  UpdateProduct({this.item, this.shopCategory, this.productCategory});

  @override
  _UpdateProductState createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  TextEditingController name = new TextEditingController(text: '');
  TextEditingController desc = new TextEditingController(text: '');
  TextEditingController price = new TextEditingController(text: '');
  TextEditingController qty = new TextEditingController(text: '');

  FirebaseAuth mAuth = FirebaseAuth.instance;

  @override
  void initState() {
    name.text = widget.item.name;
    price.text = widget.item.price;
    desc.text = widget.item.desc;
    qty.text = widget.item.stockQty.toString();
  }

  @override
  Widget build(BuildContext context) {
    final pHeight = MediaQuery.of(context).size.height;
    final pWidth = MediaQuery.of(context).size.width;
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: pHeight * 0.5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Update ${widget.item.name}',
                  style: TextStyle(
                      color: kSecondaryColor,
                      fontFamily: 'Poppins',
                      fontSize: pHeight * 0.025),
                ),
                SizedBox(
                  height: pHeight * 0.01,
                ),
                TextFormField(
                  controller: name,
                  validator: (value) {
                    if (value.length == 0) {
                      return 'Invalid name';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: pHeight * 0.01,
                ),
                TextFormField(
                  controller: desc,
                  validator: (value) {
                    if (value.length == 0) {
                      return 'Invalid description';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Product Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: pHeight * 0.01,
                ),
                TextFormField(
                  controller: qty,
                  validator: (value) {
                    if (value.length == 0) {
                      return 'Invalid stock quantity';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Stock quantity',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: pHeight * 0.01,
                ),
                TextFormField(
                  controller: price,
                  validator: (value) {
                    if (value.length == 0) {
                      return 'Invalid price';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: pHeight * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DialogButton(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "UPDATE",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      color: Colors.green,
                      onPressed: () async {
                        FirebaseUser user = await mAuth.currentUser();
                        final dbRef = FirebaseDatabase.instance
                            .reference()
                            .child(widget.shopCategory)
                            .child(user.uid)
                            .child('Categories')
                            .child(widget.productCategory)
                            .child(widget.item.key);
                        dbRef.update({
                          'name': name.text,
                          'price': int.parse(price.text),
                          'stockQty': int.parse(qty.text),
                          'desc': desc.text
                        }).then((value) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Products(),
                            ),
                          );
                        });
                      },
                    ),
                    SizedBox(
                      width: pWidth * 0.05,
                    ),
                    DialogButton(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "CANCEL",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Products(),
                        ),
                      ),
                      color: Colors.red,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
