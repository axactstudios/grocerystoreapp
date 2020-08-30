import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';
import 'package:grocerystoreapp/Classes/Constants.dart';
import 'package:grocerystoreapp/Classes/Orders.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:intl/intl.dart';

class OrderPullUp extends StatefulWidget {
  Order order;
  OrderPullUp({this.order});
  @override
  _OrderPullUpState createState() => _OrderPullUpState();
}

class _OrderPullUpState extends State<OrderPullUp> {
  _generatePdfAndView(context) async {
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        build: (context) => [
              pdfLib.Column(
                  mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                  children: [
                    pdfLib.Padding(
                      padding: pdfLib.EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: pdfLib.Row(children: [
                        pdfLib.Text(
                          'Order Details',
                          style: pdfLib.TextStyle(
                            fontSize: 35,
                            color: PdfColors.black,
                          ),
                        ),
                      ]),
                    ),
                    pdfLib.Padding(
                      padding: pdfLib.EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: pdfLib.Row(children: [
                        pdfLib.Text(
                          widget.order.customerName,
                          style: pdfLib.TextStyle(
                            fontWeight: pdfLib.FontWeight.bold,
                            fontSize: 25,
                            color: PdfColors.black,
                          ),
                        ),
                      ]),
                    ),
                    pdfLib.Padding(
                      padding: pdfLib.EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: pdfLib.Row(children: [
                        pdfLib.Container(
                          width: 200,
                          child: pdfLib.Text(
                            widget.order.customerAddress +
                                ' - ' +
                                widget.order.customerZip,
                            style: pdfLib.TextStyle(
                              fontSize: 15,
                              color: PdfColors.black,
                            ),
                          ),
                        ),
                      ]),
                    ),
                    pdfLib.Padding(
                      padding: pdfLib.EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: pdfLib.Row(children: [
                        pdfLib.Text(
                          'Mobile Number : ${widget.order.customerPhone}',
                          style: pdfLib.TextStyle(
                            fontSize: 15,
                            color: PdfColors.black,
                          ),
                        ),
                      ]),
                    ),
                    pdfLib.SizedBox(
                      height: 15,
                    ),
                    pdfLib.Padding(
                      padding: pdfLib.EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: pdfLib.Row(
                          mainAxisAlignment:
                              pdfLib.MainAxisAlignment.spaceBetween,
                          children: [
                            pdfLib.Text(
                              'Item Name',
                              style: pdfLib.TextStyle(
                                fontSize: 20,
                                color: PdfColors.black,
                              ),
                            ),
                            pdfLib.Text(
                              'Item Quantity',
                              style: pdfLib.TextStyle(
                                fontSize: 20,
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                    ),
                    pdfLib.SizedBox(
                      height: 10,
                      child: pdfLib.Divider(color: PdfColors.black),
                    ),
                    pdfLib.ListView.builder(
                        itemCount: widget.order.itemsName.length,
                        itemBuilder: (context, index) {
                          return pdfLib.Padding(
                            padding:
                                pdfLib.EdgeInsets.only(top: 2.0, bottom: 2.0),
                            child: pdfLib.Row(
                                mainAxisAlignment:
                                    pdfLib.MainAxisAlignment.spaceBetween,
                                children: [
                                  pdfLib.Text(
                                    widget.order.itemsName[index],
                                    style: pdfLib.TextStyle(
                                      fontSize: 15,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                  pdfLib.Text(
                                    widget.order.itemsQty[index].toString(),
                                    style: pdfLib.TextStyle(
                                      fontSize: 15,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                ]),
                          );
                        }),
                    pdfLib.SizedBox(
                      height: 10,
                      child: pdfLib.Divider(color: PdfColors.black),
                    ),
                    pdfLib.Padding(
                      padding: pdfLib.EdgeInsets.only(top: 20.0, bottom: 5.0),
                      child: pdfLib.Row(
                          mainAxisAlignment:
                              pdfLib.MainAxisAlignment.spaceBetween,
                          children: [
                            pdfLib.Text(
                              'Order Amount : ',
                              style: pdfLib.TextStyle(
                                fontSize: 20,
                                color: PdfColors.black,
                              ),
                            ),
                            pdfLib.Text(
                              widget.order.orderAmount,
                              style: pdfLib.TextStyle(
                                fontSize: 20,
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                    ),
                    pdfLib.Padding(
                      padding: pdfLib.EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: pdfLib.Row(
                          mainAxisAlignment:
                              pdfLib.MainAxisAlignment.spaceBetween,
                          children: [
                            pdfLib.Text(
                              'Ordered on : ',
                              style: pdfLib.TextStyle(
                                fontSize: 20,
                                color: PdfColors.black,
                              ),
                            ),
                            pdfLib.Text(
                              widget.order.orderDate +
                                  ' at ' +
                                  widget.order.orderTime,
                              style: pdfLib.TextStyle(
                                fontSize: 20,
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                    )
                  ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;
    String dateTime = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final String path = '$dir/${widget.order.customerName} $dateTime.pdf';
    final File file = File(path);
    await file.writeAsBytes(pdf.save());
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
    //Navigator.of(context).push(MaterialPageRoute(
    //builder: (_) => PdfViewerPage(path: path),
    //));
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
                'Order Details',
                style:
                    TextStyle(fontFamily: 'Poppins', fontSize: pHeight * 0.025),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.print,
              color: Colors.white,
            ),
            onPressed: () {
              _generatePdfAndView(context);
            },
          )
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
