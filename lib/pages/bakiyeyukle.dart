import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:projeodevi/pages/home.dart';
import 'package:projeodevi/service/auth_service.dart';

class bakiyeYukle extends StatefulWidget {
  @override
  _bakiyeYukleState createState() => _bakiyeYukleState();
}

class _bakiyeYukleState extends State<bakiyeYukle> {
  TextEditingController statusController = TextEditingController();

  AuthService _authService = AuthService();
  int toplambakiye = 0;
  String gelenYaziBakiye2 = '';
  String gelenYaziTarihDoc = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
        gelenYaziBakiye2 = gelenVeri2.data()['bakiye'];
      });
    });
  }

  DateTime ntpTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadNTPTime();
  }

  void _loadNTPTime() async {
    setState(() async {
      ntpTime = await NTP.now();
    });
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          yaziGetir2();
          Future<void> _showBakiyeDialog(BuildContext context) {
            return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Text(
                        "${statusController.text} TL bakiye yüklemek istediğinizden emin misiniz?",
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
                                  DateTime currentDateDoc = ntpTime.toLocal();
                                  String currentDate =
                                      DateFormat('yyyy-MM-dd HH:mm')
                                          .format(currentDateDoc);
                                  var deger = int.parse(statusController.text);
                                  var bakiyeanlik = int.parse(gelenYaziBakiye2);
                                  toplambakiye = deger + bakiyeanlik;
                                  _authService
                                      .updateBakiye(toplambakiye.toString());
                                  _authService.deleteilkkayit();
                                  _authService.addStatus(
                                      '+${statusController.text}',
                                      '$currentDate',
                                      '$currentDateDoc');

                                  Fluttertoast.showToast(
                                      msg: "İşlem Başarılı.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 4,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()));
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
                padding: EdgeInsets.only(left: (size.width * .20)),
                child: Text('Bakiye Yükle'),
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
                          maxLength: 3,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.payments,
                              color: Colors.white,
                            ),
                            hintText: 'Yüklenecek Tutar',
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
                          _showBakiyeDialog(context);
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
                              "Bakiye Yükle",
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
