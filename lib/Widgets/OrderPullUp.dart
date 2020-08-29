import 'package:flutter/material.dart';
import 'package:grocerystoreapp/Classes/Constants.dart';
import 'package:grocerystoreapp/Classes/Orders.dart';

class OrderPullUp extends StatefulWidget {
  Order order;
  OrderPullUp({this.order});
  @override
  _OrderPullUpState createState() => _OrderPullUpState();
}

class _OrderPullUpState extends State<OrderPullUp> {
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
                'Order Details',
                style:
                    TextStyle(fontFamily: 'Poppins', fontSize: pHeight * 0.025),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Customer Name :  ',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: kSecondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: pHeight * 0.02),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        widget.order.customerName,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: kSecondaryColor,
                          fontSize: pHeight * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: pHeight * 0.015,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Phone Number :  ',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: kSecondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: pHeight * 0.02),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        widget.order.customerPhone,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: kSecondaryColor,
                          fontSize: pHeight * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: pHeight * 0.015,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Address :  ',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: kSecondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: pHeight * 0.02),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        '${widget.order.customerAddress}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: kSecondaryColor,
                          fontSize: pHeight * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: pHeight * 0.015,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Order Amount :  ',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: kSecondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: pHeight * 0.02),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        widget.order.orderAmount,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: kSecondaryColor,
                          fontSize: pHeight * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: pHeight * 0.015,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Ordered on :  ',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: kSecondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: pHeight * 0.02),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        '${widget.order.orderDate} at ${widget.order.orderTime}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: kSecondaryColor,
                          fontSize: pHeight * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: pHeight * 0.015,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Order status :  ',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: kSecondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: pHeight * 0.02),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        widget.order.status,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: kSecondaryColor,
                          fontSize: pHeight * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: pHeight * 0.015,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Shipping Date :  ',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: kSecondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: pHeight * 0.02),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        widget.order.shippingDate,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: kSecondaryColor,
                          fontSize: pHeight * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: pHeight * 0.015,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Delivery Date :  ',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: kSecondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: pHeight * 0.02),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        widget.order.deliveryDate,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: kSecondaryColor,
                          fontSize: pHeight * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: pHeight * 0.025,
                ),
                SizedBox(
                  width: pWidth,
                  child: Divider(
                    thickness: 1.0,
                    color: kSecondaryColor.withOpacity(0.5),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Item Name',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: kSecondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: pHeight * 0.02),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Item Quantity',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: kSecondaryColor,
                          fontSize: pHeight * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: pHeight * 0.015,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.order.itemsName.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(
                                  widget.order.itemsName[index],
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: kSecondaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: pHeight * 0.02),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  widget.order.itemsQty[index].toString(),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: kSecondaryColor,
                                    fontSize: pHeight * 0.025,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
