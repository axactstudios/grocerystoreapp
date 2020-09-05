import 'dart:io';
import 'package:grocerystoreapp/Screens/Auth/ReferralCode.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:gps/gps.dart';
import 'package:grocerystoreapp/Classes/Constants.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

import '../NavBar.dart';

//TODO:TOast Used
class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  var latlng;
  String category = 'Groceries';
  String imageUrl = '';
  String fileType = '';
  File file;
  String fileName = '';
  String operationText = '';
  bool isUploaded = true;
  String result = '';

  TextEditingController name = new TextEditingController(text: '');
  TextEditingController phone = new TextEditingController(text: '+91');
  TextEditingController address = new TextEditingController(text: '');
  TextEditingController desc = new TextEditingController(text: '');

  void _uploadFile(File file, String filename) async {
    StorageReference firebaseStorage = FirebaseStorage.instance.ref();
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    StorageReference storageReference;
    storageReference = firebaseStorage.child("$category/${user.uid}/$filename");

    final StorageUploadTask uploadTask = storageReference.putFile(file);
    // Fluttertoast.showToast(msg: 'Uploading...', gravity: ToastGravity.CENTER);
    print('Uploading');
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
    setState(() {
      imageUrl = url;
    });
    print('Uploaded');
    // Fluttertoast.showToast(
    //     msg: 'Upload Complete', gravity: ToastGravity.CENTER);
  }

  Future filePicker(BuildContext context) async {
    try {
      file = await FilePicker.getFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg'],
      );
      setState(() {
        fileName = p.basename(file.path);
      });
      print(fileName);

      _uploadFile(file, fileName);
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sorry...'),
              content: Text('Unsupported exception: $e'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
    setState(() {
      print(fileName);
    });
  }

  @override
  // ignore: must_call_super
  void initState() {
    getGps();
  }

  final _formKey = GlobalKey<FormState>();

  final controller = MapController(
    location: LatLng(0.0, 0.0),
  );

  double lat, lng;

  void getGps() async {
    latlng = await Gps.currentGps();
    lat = double.parse(latlng.lat);
    lng = double.parse(latlng.lng);
    setState(() {
      controller.location = LatLng(lat, lng);
      getLocation();
    });
  }

  getLocation() async {
    final coordinates = new Coordinates(lat, lng);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(first.subAdminArea);
    setState(() {
      address.text = first.addressLine;
    });
  }

  void writeData() async {
    // ignore: deprecated_member_use
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var dbRef =
        FirebaseDatabase.instance.reference().child(category).child(user.uid);
    dbRef.set({
      'name': name.text,
      'phoneNo': phone.text,
      'address': address.text,
      'desc': desc.text,
      'imageUrl': imageUrl
    });
  }

  @override
  Widget build(BuildContext context) {
    final pHeight = MediaQuery.of(context).size.height;
    final pWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: pHeight * 0.05,
                ),
                InkWell(
                  onTap: () {
                    filePicker(context);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(pHeight * 0.15),
                    child: Container(
                      color: Colors.white,
                      height: pHeight * 0.13,
                      width: pHeight * 0.13,
                      child: Icon(
                        Icons.shopping_basket,
                        color: Color(0xFF11263C),
                        size: pHeight * 0.1,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: pHeight * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: TextFormField(
                            controller: name,
                            validator: (value) {
                              if (value.length == 0) {
                                return 'Invalid name';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              icon: Icon(
                                Icons.perm_contact_calendar,
                                size: pHeight * 0.03,
                                color: Color(0xFF11263C),
                              ),
                              hintText: 'Shop Name',
                              hintStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF11263C),
                                  fontSize: pHeight * 0.025),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: pHeight * 0.001,
                          width: double.infinity,
                          child: Divider(
                            thickness: 1.5,
                            color: Color(0xFFC8CDD2),
                          ),
                        ),
                        SizedBox(
                          height: pHeight * 0.008,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: TextFormField(
                            controller: phone,
                            validator: (value) {
                              if (value.length < 13) {
                                return 'Invalid phone number';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              icon: Icon(
                                Icons.phone,
                                size: pHeight * 0.03,
                                color: Color(0xFF11263C),
                              ),
                              hintText: 'Mobile',
                              hintStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF11263C),
                                  fontSize: pHeight * 0.025),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        SizedBox(
                          height: pHeight * 0.001,
                          width: double.infinity,
                          child: Divider(
                            thickness: 1.5,
                            color: Color(0xFFC8CDD2),
                          ),
                        ),
                        SizedBox(
                          height: pHeight * 0.008,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: TextFormField(
                            controller: desc,
                            validator: (value) {
                              if (value.length == 0) {
                                return 'Invalid description';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              icon: Icon(
                                Icons.line_weight,
                                size: pHeight * 0.03,
                                color: Color(0xFF11263C),
                              ),
                              hintText: 'Shop description',
                              hintStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF11263C),
                                  fontSize: pHeight * 0.025),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: pHeight * 0.001,
                          width: double.infinity,
                          child: Divider(
                            thickness: 1.5,
                            color: Color(0xFFC8CDD2),
                          ),
                        ),
                        SizedBox(
                          height: pHeight * 0.008,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: TextFormField(
                            controller: address,
                            validator: (value) {
                              if (value.length == 0) {
                                return 'Invalid address';
                              } else {
                                return null;
                              }
                            },
                            maxLines: 4,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              icon: Icon(
                                Icons.mail,
                                size: pHeight * 0.03,
                                color: Color(0xFF11263C),
                              ),
                              hintText: 'Address',
                              hintStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF11263C),
                                  fontSize: pHeight * 0.025),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: pHeight * 0.00001,
                          width: double.infinity,
                          child: Divider(
                            thickness: 1.5,
                            color: Color(0xFFC8CDD2),
                          ),
                        ),
                        SizedBox(
                          height: pHeight * 0.008,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: DropdownButton<String>(
                            value: category,
                            elevation: 16,
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              size: pHeight * 0.035,
                              color: kSecondaryColor,
                            ),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: kSecondaryColor,
                              fontSize: pHeight * 0.022,
                            ),
                            underline: Container(
                              color: kPrimaryColor,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                category = newValue;
                              });
                            },
                            items: <String>[
                              'Groceries',
                              'Veggies',
                              'Dairy',
                              'Medicines',
                              'Stationary'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: pHeight * 0.00000001,
                          width: double.infinity,
                          child: Divider(
                            thickness: 1.5,
                            color: Color(0xFFC8CDD2),
                          ),
                        ),
                        SizedBox(
                          height: pHeight * 0.008,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: Color(0xFF11263C),
                                size: pHeight * 0.03,
                              ),
                              SizedBox(
                                width: pWidth * 0.05,
                              ),
                              Text(
                                'Delivery Location',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: pHeight * 0.025,
                                  color: Color(0xFF11263C),
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(
                                  Icons.gps_fixed,
                                  color: Color(0xFF11263C),
                                ),
                                onPressed: () {
                                  getGps();
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                            ),
                          ),
                          height: pHeight * 0.18,
                          child: Map(
                            controller: controller,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FloatingActionButton(
                          onPressed: () async {
                            FirebaseUser user =
                                await FirebaseAuth.instance.currentUser();
                            if (_formKey.currentState.validate()) {
                              if (imageUrl != null) {
                                await writeData();
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => ReferralCode(
                                      shopAddress: address.text,
                                      shopName: name.text,
                                      shopPhone: phone.text,
                                      shopUid: user.uid,
                                    ),
                                  ),
                                );
                              } else {
                                print('add an image first');
                                // Fluttertoast.showToast(
                                //     msg: 'Please add an image first',
                                //     textColor: Colors.black,
                                //     backgroundColor: Colors.white);
                              }
                            }
                          },
                          backgroundColor: kAccentColor,
                          child: Icon(
                            Icons.chevron_right,
                            size: 40,
//                                color: Color.fromARGB(255, 242, 96, 22),
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
  }
}
