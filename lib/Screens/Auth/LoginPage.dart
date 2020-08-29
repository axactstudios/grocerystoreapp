import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocerystoreapp/Classes/Constants.dart';
import 'package:grocerystoreapp/Classes/CustomIcons.dart';

import '../NavBar.dart';
import 'RegistrationPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool shopExists = false;

  TextEditingController phone = new TextEditingController(text: '');
  TextEditingController otp = new TextEditingController(text: '');
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final pHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kPrimaryColor,
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: pHeight * 0.06),
                child: Text(
                  'Logo',
                  style: TextStyle(
                      fontSize: pHeight * 0.045, fontFamily: 'Poppins'),
                ),
              ),
              SizedBox(
                height: pHeight * 0.042,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset('images/onboarding.png'),
              ),
              SizedBox(
                height: pHeight * 0.01,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 32.0,
                            right: 32,
                            top: 36,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.length < 10) {
                                      return 'Invalid phone number';
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: phone,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: kFormColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: 'Enter Mobile Number',
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      _onVerifyCode();
                                    },
                                    child: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 32.0,
                            right: 32,
                            top: 15,
                          ),
                          child: TextFormField(
                            validator: (value) {
                              if (value.length < 6) {
                                return 'Invalid OTP';
                              } else {
                                return null;
                              }
                            },
                            controller: otp,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: kFormColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'Enter OTP',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 90, right: 90),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 3, color: Colors.white),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(40),
                                  ),
                                ),
                                child: Ink(
                                    decoration: const ShapeDecoration(
                                      color: Colors.lightBlue,
                                      shape: CircleBorder(),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Custom_icons_iconsdart.facebook,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      iconSize: 50,
                                      onPressed: () {},
                                    )),
                              ),
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 3, color: Colors.white),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(40),
                                  ),
                                ),
                                child: Ink(
                                    decoration: const ShapeDecoration(
                                      color: Colors.green,
                                      shape: CircleBorder(),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Custom_icons_iconsdart.twitter,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      iconSize: 50,
                                      onPressed: () {},
                                    )),
                              ),
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 3, color: Colors.white),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(40),
                                  ),
                                ),
                                child: Ink(
                                    decoration: const ShapeDecoration(
                                      color: Colors.lightBlue,
                                      shape: CircleBorder(),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Custom_icons_iconsdart.gplus,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      iconSize: 50,
                                      onPressed: () {
                                        _handleSignIn();
                                      },
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FloatingActionButton(
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _onFormSubmitted();
                                    }
                                  },
                                  backgroundColor: kAccentColor,
                                  child: Icon(
                                    Icons.chevron_right,
                                    size: 40,
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
            ],
          ),
        ),
      ),
    );
  }

  void showToast(message, Color color) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: color,
      textColor: Colors.pinkAccent,
      fontSize: 16.0,
    );
  }

  bool isCodeSent = false;
  String _verificationId;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void _onVerifyCode() async {
    setState(() {
      isCodeSent = true;
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((AuthResult value) async {
        if (value.user != null) {
          String uid = value.user.uid;
          final dbRef = FirebaseDatabase.instance.reference();
          await dbRef.once().then((DataSnapshot snapshot) async {
            Map<dynamic, dynamic> values = snapshot.value;
            values.forEach((key, value) {
              if (key == uid) {
                setState(() {
                  shopExists = true;
                });
              }
            });
          });

          if (shopExists) {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => RegistrationPage(),
              ),
            );
          }
        } else {
          showToast("Error validating OTP, try again", Colors.white);
        }
      }).catchError((error) {
        showToast("Try again in sometime", Colors.white);
      });
    };
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      showToast(authException.message, Colors.white);
      setState(() {
        isCodeSent = false;
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      showToast('sent', Colors.white);
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91${phone.text}",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _onFormSubmitted() async {
    AuthCredential _authCredential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: otp.text,
    );

    _firebaseAuth
        .signInWithCredential(_authCredential)
        .then((AuthResult value) async {
      if (value.user != null) {
        String uid = value.user.uid;
        final dbRef = FirebaseDatabase.instance.reference();
        await dbRef.once().then((DataSnapshot snapshot) async {
          Map<dynamic, dynamic> values = snapshot.value;
          values.forEach((key, val) {
            if (key == uid) {
              setState(() {
                shopExists = true;
              });
            }
          });
        });

        if (shopExists) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => RegistrationPage(),
            ),
          );
        }
      } else {
        showToast("Error validating OTP, try again", Colors.white);
      }
    }).catchError((error) {
      showToast("Something went wrong", Colors.white);
    });
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    if (user != null) {
      final dbRef = FirebaseDatabase.instance.reference();
      await dbRef.once().then((DataSnapshot snapshot) async {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, value) {
          if (key == user.uid) {
            setState(() {
              shopExists = true;
            });
          }
        });
      });
    }
    if (shopExists) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => RegistrationPage(),
        ),
      );
    }
    return user;
  }
}
