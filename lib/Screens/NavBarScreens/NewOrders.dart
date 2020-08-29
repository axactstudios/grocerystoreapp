import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grocerystoreapp/Classes/Constants.dart';
import 'package:grocerystoreapp/Classes/Orders.dart';
import 'package:grocerystoreapp/Widgets/OrderPullUp.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class NewOrders extends StatefulWidget {
  @override
  _NewOrdersState createState() => _NewOrdersState();
}

class _NewOrdersState extends State<NewOrders> {
  List<Order> newOrders = [];
  bool isFetching = false;
  FirebaseAuth mAuth = FirebaseAuth.instance;

  getOrders() async {
    newOrders.clear();
    setState(() {
      isFetching = true;
    });
    FirebaseUser user = await mAuth.currentUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String category = await prefs.getString('category');
    final dbRef = FirebaseDatabase.instance
        .reference()
        .child(category)
        .child(user.uid)
        .child('Orders');
    await dbRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value == null) {
        setState(() {
          print(snapshot.value);
          isFetching = false;
        });
      } else {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, value) async {
          Order newOrder = Order();
          newOrder.customerZip = await value['customerZip'];
          newOrder.customerUid = await value['customerUid'];
          newOrder.customerPhone = await value['customerPhone'];
          newOrder.customerName = await value['customerName'];
          newOrder.customerAddress = await value['customerAddress'];
          newOrder.status = await value['status'];
          newOrder.deliveryDate = await value['deliveryDate'];
          newOrder.orderTime = await value['orderTime'];
          newOrder.itemsQty = List<int>.from(await value['itemsQty']);
          newOrder.orderDate = await value['orderDate'];
          newOrder.key = key;
          newOrder.shippingDate = await value['shippingDate'];
          newOrder.orderAmount = await value['orderAmount'];
          newOrder.isCompleted = await value['isCompleted'];
          newOrder.itemsName = List<String>.from(await value['itemsName']);
          if (!newOrder.isCompleted) {
            newOrders.add(newOrder);
          }
        });
        setState(() {
          print(newOrders.length);
          isFetching = false;
        });
      }
    });
  }

  @override
  void initState() {
    getOrders();
  }

  void shipped(String orderKey, String userUid) async {
    DateTime shipped = await DateTime.now();
    String shippedTime = await DateFormat('dd-MM-yyyy').format(shipped);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String category = await prefs.getString('category');
    FirebaseUser user = await mAuth.currentUser();
    final dbRef = FirebaseDatabase.instance
        .reference()
        .child(category)
        .child(user.uid)
        .child('Orders')
        .child(orderKey);
    await dbRef.update({'status': 'Shipped', 'shippingDate': shippedTime}).then(
        (value) {
      setState(() {
        getOrders();
      });
    });

    final dbRef2 = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(userUid)
        .child('Orders')
        .child(orderKey);
    dbRef2.update({'status': 'Shipped', 'shippingDate': shippedTime});
  }

  void delivered(String orderKey, String userUid) async {
    DateTime delivered = await DateTime.now();
    String deliveredTime = await DateFormat('dd-MM-yyyy').format(delivered);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String category = await prefs.getString('category');
    FirebaseUser user = await mAuth.currentUser();
    final dbRef = FirebaseDatabase.instance
        .reference()
        .child(category)
        .child(user.uid)
        .child('Orders')
        .child(orderKey);
    dbRef.update({
      'status': 'Delivered',
      'deliveryDate': deliveredTime,
      'isCompleted': true
    }).then((value) {
      setState(() {
        getOrders();
      });
    });

    final dbRef2 = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(userUid)
        .child('Orders')
        .child(orderKey);
    dbRef2.update({
      'status': 'Delivered',
      'deliveryDate': deliveredTime,
      'isCompleted': true
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
            'New Orders',
            style: TextStyle(fontFamily: 'Poppins', fontSize: pHeight * 0.025),
          ),
        ),
      ),
      backgroundColor: kPrimaryColor,
      body: Container(
        height: pHeight,
        width: pWidth,
        child: Column(
          children: <Widget>[
            isFetching
                ? Expanded(
                    child: Center(
                      child: SpinKitFadingFour(
                        color: kSecondaryColor,
                      ),
                    ),
                  )
                : (newOrders.length == 0
                    ? Expanded(
                        child: Center(
                          child: Text(
                            'No new orders',
                            style: TextStyle(
                                color: kSecondaryColor,
                                fontFamily: 'Poppins',
                                fontSize: pHeight * 0.035,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                            itemCount: newOrders.length,
                            itemBuilder: (context, index) {
                              var item = newOrders[index];
                              return Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: InkWell(
                                  onTap: () {
                                    pushNewScreen(context,
                                        screen: OrderPullUp(
                                          order: item,
                                        ),
                                        withNavBar: false);
                                  },
                                  child: Card(
                                    margin: EdgeInsets.only(bottom: 15),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            'Order ${index + 1}',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: kSecondaryColor,
                                                fontSize: pHeight * 0.03,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  child: Text(
                                                    'Customer Name :  ',
                                                    style: TextStyle(
                                                        color: kSecondaryColor,
                                                        fontFamily: 'Poppins',
                                                        fontSize:
                                                            pHeight * 0.02),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  child: Text(
                                                    '${item.customerName}',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: kSecondaryColor,
                                                        fontFamily: 'Poppins',
                                                        fontSize:
                                                            pHeight * 0.02),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  child: Text(
                                                    'Phone Number :  ',
                                                    style: TextStyle(
                                                        color: kSecondaryColor,
                                                        fontFamily: 'Poppins',
                                                        fontSize:
                                                            pHeight * 0.02),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  child: Text(
                                                    '${item.customerPhone}',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: kSecondaryColor,
                                                        fontFamily: 'Poppins',
                                                        fontSize:
                                                            pHeight * 0.02),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  child: Text(
                                                    'Address :  ',
                                                    style: TextStyle(
                                                        color: kSecondaryColor,
                                                        fontFamily: 'Poppins',
                                                        fontSize:
                                                            pHeight * 0.02),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  child: Text(
                                                    '${item.customerAddress} - ${item.customerZip}',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: kSecondaryColor,
                                                        fontFamily: 'Poppins',
                                                        fontSize:
                                                            pHeight * 0.02),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  child: Text(
                                                    'Ordered on :  ',
                                                    style: TextStyle(
                                                        color: kSecondaryColor,
                                                        fontFamily: 'Poppins',
                                                        fontSize:
                                                            pHeight * 0.02),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  child: Text(
                                                    '${item.orderDate} at ${item.orderTime}',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: kSecondaryColor,
                                                        fontFamily: 'Poppins',
                                                        fontSize:
                                                            pHeight * 0.02),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  child: Text(
                                                    'Order Amount :  ',
                                                    style: TextStyle(
                                                        color: kSecondaryColor,
                                                        fontFamily: 'Poppins',
                                                        fontSize:
                                                            pHeight * 0.02),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  child: Text(
                                                    'Rs. ${item.orderAmount}',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: kSecondaryColor,
                                                        fontFamily: 'Poppins',
                                                        fontSize:
                                                            pHeight * 0.02),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  child: Text(
                                                    'Order Status :  ',
                                                    style: TextStyle(
                                                        color: kSecondaryColor,
                                                        fontFamily: 'Poppins',
                                                        fontSize:
                                                            pHeight * 0.02),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  child: Text(
                                                    '${item.status}',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: kSecondaryColor,
                                                        fontFamily: 'Poppins',
                                                        fontSize:
                                                            pHeight * 0.02),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: pHeight * 0.01,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 1,
                                                child: InkWell(
                                                  onTap: () {
                                                    shipped(item.key,
                                                        item.customerUid);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: kSecondaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Order Shipped',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize:
                                                                  pHeight *
                                                                      0.025),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: pWidth * 0.01,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: InkWell(
                                                  onTap: () {
                                                    delivered(item.key,
                                                        item.customerUid);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: kSecondaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Order delivered',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize:
                                                                  pHeight *
                                                                      0.025),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ))
          ],
        ),
      ),
    );
  }
}
