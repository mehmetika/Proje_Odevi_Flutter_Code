import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projeodevi/pages/home.dart';
import 'package:projeodevi/service/auth_service.dart';

class resetEmail extends StatefulWidget {
  @override
  _resetEmailState createState() => _resetEmailState();
}

class _resetEmailState extends State<resetEmail> {
  TextEditingController statusController = TextEditingController();
  TextEditingController newEmail = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService _authService = AuthService();
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
          Future<void> _showResetEmailDialog(BuildContext context) {
            return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Text(
                        "E-Postanızı değiştirmek istediğinizden emin misiniz?",
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
                                  _authService
                                      .updateEmail(newEmail.text)
                                      .then((value) {
                                    FirebaseFirestore.instance
                                        .collection("Person")
                                        .doc(getCurrentUser2())
                                        .update({'email': newEmail.text});
                                    Fluttertoast.showToast(
                                        msg: "E-posta Başarıyla Değiştirildi.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 4,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    return Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                  }).catchError((onError) {
                                    Navigator.pop(context);
                                  });
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
                child: Text('E-posta Değiştir'),
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
                        height: size.height * .1,
                      ),
                      TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: newEmail,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.payments,
                              color: Colors.white,
                            ),
                            hintText: 'Yeni E-posta',
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
                      TextField(
                          controller: statusController,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          cursorColor: Colors.white,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.payments,
                              color: Colors.white,
                            ),
                            hintText: 'Parola',
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
                          if (statusController.text == '' ||
                              newEmail.text == '') {
                            Fluttertoast.showToast(
                                msg:
                                    "Hatalı giriş.E-posta veya Parola bölümü boş bırakılamaz!.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 4,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            _authService
                                .signIn(gelenYaziEmail2, statusController.text)
                                .then((value) {
                              _showResetEmailDialog(context);
                            });
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
