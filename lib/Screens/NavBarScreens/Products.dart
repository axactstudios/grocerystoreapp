import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grocerystoreapp/Classes/Constants.dart';
import 'package:grocerystoreapp/Classes/Products.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<String> categories = [];
  List<Product> products = [];
  FirebaseAuth mAuth = FirebaseAuth.instance;
  bool isFetchingCategories = false;
  bool isFetchingProducts = false;
  String shopCategory = '';
  int productsIndex = 0;
  int length = 0;

  void getShopCategory() async {
    FirebaseUser user = await mAuth.currentUser();
    final dbRef = FirebaseDatabase.instance.reference();
    await dbRef.once().then((DataSnapshot snapshot) async {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        String shopKey = key;
        dbRef.child(shopKey).once().then((DataSnapshot snap) {
          Map<dynamic, dynamic> vals = snap.value;
          vals.forEach((keys, value) {
            if (keys == user.uid && shopKey != 'Users') {
              setState(() async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('category', shopKey);
                shopCategory = shopKey;
                getCategories();
              });
            }
          });
        });
      });
    });
  }

  void getCategories() async {
    categories.clear();
    print('Shop Category is $shopCategory');
    FirebaseUser user = await mAuth.currentUser();
    setState(() {
      isFetchingCategories = true;
    });
    categories.clear();
    final dbRef = FirebaseDatabase.instance
        .reference()
        .child(shopCategory)
        .child(user.uid)
        .child('Categories');
    dbRef.once().then((DataSnapshot snap) {
      Map<dynamic, dynamic> values = snap.value;
      values.forEach((key, value) {
        categories.add(key);
      });
      setState(() {
        isFetchingCategories = false;
        print(categories.length);
        getProducts();
      });
    });
  }

  void getProducts() async {
    FirebaseUser user = await mAuth.currentUser();
    setState(() {
      isFetchingProducts = true;
    });
    products.clear();
    final dbRef = FirebaseDatabase.instance
        .reference()
        .child(shopCategory)
        .child(user.uid)
        .child('Categories')
        .child(categories[productsIndex]);
    dbRef.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) async {
        Product product = Product();
        product.key = key;
        product.name = await value['name'];
        product.price = await value['price'].toString();
        product.desc = await value['desc'];
        product.imageUrl = await value['imageUrl'];
        products.add(product);
      });
      setState(() {
        print(products.length);
        isFetchingProducts = false;
      });
    });
  }

  @override
  // ignore: must_call_super
  void initState() {
    getShopCategory();
  }

  delete(String productKey) async {
    FirebaseUser user = await mAuth.currentUser();
    final dbRef = FirebaseDatabase.instance
        .reference()
        .child(shopCategory)
        .child(user.uid)
        .child('Categories')
        .child(categories[productsIndex])
        .child(productKey)
        .remove()
        .then((value) {
      getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pHeight = MediaQuery.of(context).size.height;
    final pWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        title: Center(
          child: Text(
            'Grocery Store App',
            style: TextStyle(fontFamily: 'Poppins', fontSize: pHeight * 0.025),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: pHeight * 0.02,
          ),
          isFetchingCategories
              ? SpinKitFadingFour(
                  color: kSecondaryColor,
                )
              : (categories.length == 0
                  ? Center(
                      child: Text(
                        'No categories added by you',
                        style: TextStyle(
                            color: kSecondaryColor,
                            fontSize: pHeight * 0.02,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  : Container(
                      height: pHeight * 0.05,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  var item = categories[index];
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        productsIndex = index;
                                        getProducts();
                                      });
                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            item,
                                            style: TextStyle(
                                                color: productsIndex == index
                                                    ? kSecondaryColor
                                                    : kSecondaryColor
                                                        .withOpacity(0.5),
                                                fontFamily: 'Poppins',
                                                fontSize: pHeight * 0.025,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )),
                                  );
                                }),
                          ],
                        ),
                      ),
                    )),
          SizedBox(
            height: pHeight * 0.02,
          ),
          isFetchingProducts
              ? SpinKitFadingFour(
                  color: kSecondaryColor,
                )
              : (categories.length == 0
                  ? Expanded(
                      child: Center(
                        child: Text(
                          'No products to display',
                          style: TextStyle(
                              color: kSecondaryColor,
                              fontSize: pHeight * 0.02,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          var item = products[index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Card(
                              margin: EdgeInsets.only(bottom: 30.0),
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0,
                                    top: 8.0,
                                    bottom: 8.0,
                                    right: 8.0),
                                child: Container(
                                  height: pHeight * 0.15,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          item.imageUrl,
                                          height: pHeight * 0.15,
                                          width: pWidth * 0.25,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      SizedBox(
                                        width: pWidth * 0.02,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 12.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    item.name,
                                                    style: TextStyle(
                                                        color: kSecondaryColor,
                                                        fontSize:
                                                            pHeight * 0.02,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                  Text(
                                                    item.desc,
                                                    style: TextStyle(
                                                        color: kSecondaryColor,
                                                        fontSize:
                                                            pHeight * 0.015,
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  'Rs. ',
                                                  style: TextStyle(
                                                      color: kSecondaryColor,
                                                      fontSize: pHeight * 0.018,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Poppins'),
                                                ),
                                                Text(
                                                  item.price,
                                                  style: TextStyle(
                                                      color: kSecondaryColor,
                                                      fontSize: pHeight * 0.018,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Poppins'),
                                                ),
                                              ],
                                            ),
                                            InkWell(
                                              onTap: () {
                                                delete(item.key);
                                              },
                                              child: Container(
                                                height: pHeight * 0.04,
                                                width: pWidth * 0.574,
                                                decoration: BoxDecoration(
                                                  color: kSecondaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Delete Product',
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        color: Colors.white,
                                                        fontSize:
                                                            pHeight * 0.025),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )),
        ],
      ),
    );
  }
}
