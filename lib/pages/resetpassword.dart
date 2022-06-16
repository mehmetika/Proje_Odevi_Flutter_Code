import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projeodevi/pages/home.dart';

class resetPassword extends StatefulWidget {
  @override
  _resetPasswordState createState() => _resetPasswordState();
}

class _resetPasswordState extends State<resetPassword> {
  TextEditingController statusController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String gelenYaziEmail2 = '';
  getCurrentUser2() {
    User user = _auth.currentUser;
    var uid = user.uid;
    return uid;
  }

  void yaziGetir2() {
    FirebaseFirestore.instance
        .collection('Person')
        .doc(getCurrentUser2())
        .get()
        .then((gelenVeri2) {
      setState(() {
        gelenYaziEmail2 = gelenVeri2.data()['email'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          yaziGetir2();
          Future<void> _showResetPasswordDialog(BuildContext context) {
            return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Text(
                        "Parolanızı değiştirmek istediğinizden emin misiniz?",
                        textAlign: TextAlign.center,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      content: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  if (gelenYaziEmail2 ==
                                      statusController.text) {
                                    _auth.sendPasswordResetEmail(
                                        email: statusController.text);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                    Fluttertoast.showToast(
                                        msg:
                                            "E-postanıza parola sıfırlama maili gönderildi.Lütfen mailinizi kontrol ediniz!.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 4,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Hatalı e-posta.Girilen e-posta hesabınıza tanımlı e-postadan farklı olamaz!.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 4,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                },
                                child: Text(
                                  "Evet",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Vazgeç",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )));
                });
          }

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Padding(
                padding: EdgeInsets.only(left: (size.width * .15)),
                child: Text('Parola Değiştir'),
              ),
              backgroundColor: Colors.blue,
            ),
            body: Center(
              child: Container(
                height: size.height * .7,
                width: size.width * .85,
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(.75),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(.75),
                          blurRadius: 10,
                          spreadRadius: 2)
                    ]),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                      ),
                      TextField(
                          controller: statusController,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.payments,
                              color: Colors.white,
                            ),
                            hintText: 'E-posta Adresi',
                            prefixText: ' ',
                            hintStyle: TextStyle(color: Colors.white),
                            focusColor: Colors.white,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.white,
                            )),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.white,
                            )),
                          )),
                      SizedBox(
                        height: 45,
                      ),
                      InkWell(
                        onTap: () {
                          if (statusController.text != '') {
                            _showResetPasswordDialog(context);
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "Hatalı giriş.E-posta bölümü boş bırakılamaz!.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 4,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                        child: Container(
                          height: size.height * .065,
                          width: size.width * .7,
                          padding: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              //color: colorPrimaryShade,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Center(
                                child: Text(
                              "Gönder ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * .05,
                              ),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
