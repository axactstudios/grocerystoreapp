import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grocerystoreapp/Classes/Items.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocerystoreapp/Classes/Constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'Products.dart';

//TODO:TOast Used
class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController name = new TextEditingController(text: '');
  TextEditingController desc = new TextEditingController(text: '');
  TextEditingController price = new TextEditingController(text: '');
  TextEditingController qty = new TextEditingController(text: '');
  TextEditingController newCategory = new TextEditingController(text: '');

  Items itms;
  String category = '';
  String imageUrl;
  String fileType = '';
  File file;
  String fileName = '';
  String operationText = '';
  bool isUploaded = true;
  String result = '';
  bool newCat = false;
  String prodCategory = '';
  final _formKey = GlobalKey<FormState>();
  List<String> categories = [];
  String shopCategory = '';
  bool isFetchingCategories = false;
  bool isFetchingItems = false;
  List<Items> items = [];
  String item = '';
  int index = 0;
  bool preExist = false;
  FirebaseAuth mAuth = FirebaseAuth.instance;

//  void getShopCategory() async {
//    FirebaseUser user = await mAuth.currentUser();
//    final dbRef = FirebaseDatabase.instance.reference();
//    await dbRef.once().then((DataSnapshot snapshot) async {
//      Map<dynamic, dynamic> values = snapshot.value;
//      values.forEach((key, value) {
//        String shopKey = key;
//        dbRef.child(shopKey).once().then((DataSnapshot snap) {
//          Map<dynamic, dynamic> vals = snap.value;
//          vals.forEach((keys, value) async {
//            if (keys == user.uid && shopKey != 'Users') {
//              SharedPreferences prefs = await SharedPreferences.getInstance();
//              prefs.setString('category', shopKey);
//              shopCategory = shopKey;
//              if (this.mounted) {
//                setState(() {
//                  getCategories();
//                });
//              }
//            }
//          });
//        });
//      });
//    });
//  }

  void getCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shopCategory = await prefs.getString('category');
    setState(() {
      print(shopCategory);
    });

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
      if (snap.value == null) {
        setState(() {
          isFetchingCategories = false;
        });
      } else {
        Map<dynamic, dynamic> values = snap.value;
        values.forEach((key, value) {
          categories.add(key);
        });
        setState(() {
          isFetchingCategories = false;
          category = categories[0];
          prodCategory = category;
          print(categories.length);
        });
      }
    });
  }

  void writeData() async {
    String dateTime = DateFormat('dd-M-yyyy').format(DateTime.now());

    // ignore: deprecated_member_use
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var dbRef = FirebaseDatabase.instance
        .reference()
        .child(shopCategory)
        .child(user.uid)
        .child('Categories')
        .child(prodCategory)
        .child(dateTime);
    dbRef.set({
      'name': name.text,
      'desc': desc.text,
      'price': int.parse(price.text),
      'stockQty': int.parse(qty.text),
      'imageUrl': imageUrl
    });
  }

  void _uploadFile(File file, String filename) async {
    StorageReference firebaseStorage = FirebaseStorage.instance.ref();
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    StorageReference storageReference;
    storageReference = firebaseStorage
        .child("$shopCategory/${user.uid}/$prodCategory/$filename");

    final StorageUploadTask uploadTask = storageReference.putFile(file);
    // Fluttertoast.showToast(msg: 'Uploading...', gravity: ToastGravity.CENTER);
    print('Uploading');
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
    setState(() {
      imageUrl = url;
    });
    print('Upload Completed');
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

  void getItems() async {
    items.clear();
    setState(() {
      isFetchingItems = true;
    });
    final dbRef = FirebaseDatabase.instance.reference().child('Products');
    dbRef.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) async {
        Items itm = Items();
        itm.name = await value['name'];
        itm.desc = await value['desc'];
        itm.price = await value['price'];
        itm.imageUrl = await value['imageUrl'];
        items.add(itm);
      });
      setState(() {
        isFetchingItems = false;
        print('Fetched');
        itms = items[0];
        index = 0;
        item = items[0].name;
        print(item);
      });
    });
  }

  @override
  void initState() {
    getCategories();
    getItems();
  }

  @override
  Widget build(BuildContext context) {
    final pHeight = MediaQuery.of(context).size.height;
    final pWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        title: Center(
          child: Text(
            'Add Product',
            style: TextStyle(fontFamily: 'Poppins', fontSize: pHeight * 0.025),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            isFetchingCategories
                ? Center(
                    child: SpinKitFadingFour(
                      color: kSecondaryColor,
                    ),
                  )
                : SingleChildScrollView(
                    child: Container(
                      width: pWidth,
                      height: pHeight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: pHeight * 0.05,
                              ),
                              InkWell(
                                onTap: () {
                                  filePicker(context);
                                },
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(pHeight * 0.15),
                                  child: file == null
                                      ? Container(
                                          color: Colors.white,
                                          height: pHeight * 0.13,
                                          width: pHeight * 0.13,
                                          child: Icon(
                                            Icons.image,
                                            color: Color(0xFF11263C),
                                            size: pHeight * 0.08,
                                          ),
                                        )
                                      : Image.file(
                                          file,
                                          height: pHeight * 0.13,
                                          width: pHeight * 0.13,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              SizedBox(
                                height: pHeight * 0.02,
                              ),
                              CheckboxListTile(
                                title: Text(
                                  "Select a product from catalogue",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: pHeight * 0.02),
                                ),
                                value: preExist,
                                onChanged: (newValue) {
                                  setState(() {
                                    preExist = newValue;
                                    itms = items[0];
                                    name.text = items[0].name;
                                    price.text = items[0].price.toString();
                                    desc.text = items[0].desc;
                                    imageUrl = items[0].imageUrl;
                                  });
                                },
                                controlAffinity: ListTileControlAffinity
                                    .leading, //  <-- leading Checkbox
                              ),
                              SizedBox(
                                height: pHeight * 0.01,
                              ),
                              preExist
                                  ? (isFetchingItems
                                      ? SpinKitFadingFour(
                                          color: kSecondaryColor,
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: DropdownButton<Items>(
                                            value: itms,
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
                                            onChanged: (Items newValue) {
                                              setState(() {
                                                itms = newValue;
                                                item = newValue.name;
                                                name.text = newValue.name;
                                                price.text =
                                                    newValue.price.toString();
                                                desc.text = newValue.desc;
                                                imageUrl = newValue.imageUrl;
                                              });
                                            },
                                            items: items
                                                .map<DropdownMenuItem<Items>>(
                                                    (Items val) {
                                              return DropdownMenuItem<Items>(
                                                value: val,
                                                child: Text(val.name),
                                              );
                                            }).toList(),
                                          ),
                                        ))
                                  : SizedBox(
                                      height: pHeight * 0.01,
                                    ),
                              SizedBox(
                                height: pHeight * 0.01,
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
                                      prodCategory = newValue;
                                    });
                                  },
                                  items: categories
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                height: pHeight * 0.02,
                              ),
                              CheckboxListTile(
                                title: Text(
                                  "Add a new category",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: pHeight * 0.02),
                                ),
                                value: newCat,
                                onChanged: (newValue) {
                                  setState(() {
                                    newCat = newValue;
                                  });
                                },
                                controlAffinity: ListTileControlAffinity
                                    .leading, //  <-- leading Checkbox
                              ),
                              SizedBox(
                                height: pHeight * 0.01,
                              ),
                              newCat
                                  ? TextFormField(
                                      controller: newCategory,
                                      validator: (value) {
                                        if (value.length == 0) {
                                          return 'Invalid category name';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          prodCategory = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Category Name',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: pHeight * 0.01,
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
                                        "ADD PRODUCT",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                    color: Colors.green,
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        if (imageUrl == null) {
                                          print('Add a image first');
                                          // Fluttertoast.showToast(
                                          //     msg: 'Add a image first',
                                          //     gravity: ToastGravity.CENTER);
                                        } else {
                                          await writeData();
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Products(),
                                            ),
                                          );
                                        }
                                      }
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
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
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
                              ),
                              SizedBox(
                                height: pHeight * 0.1,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
