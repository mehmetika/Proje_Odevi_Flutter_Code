import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeodevi/pages/home.dart';
import 'package:projeodevi/service/auth_service.dart';

class hesapOzet extends StatefulWidget {
  @override
  _hesapOzetState createState() => _hesapOzetState();
}

class _hesapOzetState extends State<hesapOzet> {
  AuthService _authService = AuthService();
  int hesapOzetUzunluk;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: (size.width * .20)),
          child: Text('Hesap Özeti'),
        ),
        leading: new IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: StreamBuilder(
        stream: _authService.getStatus(),
        builder: (context, snapshot) {
          void hesapOzetUzunlugu() {
            if (snapshot.data.docs.length >= 15) {
              hesapOzetUzunluk = 15;
            } else {
              hesapOzetUzunluk = snapshot.data.docs.length;
            }
          }

          hesapOzetUzunlugu();
          return !snapshot.hasData
              ? CircularProgressIndicator()
              : Align(
                  alignment: Alignment.topCenter,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: hesapOzetUzunluk,
                      itemBuilder: (context, index) {
                        int reverseIndex =
                            snapshot.data.docs.length - 1 - index;
                        DocumentSnapshot mypost =
                            snapshot.data.docs[reverseIndex];
                        return (mypost['bakiyeGecmis'] == null)
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 250),
                                child: Container(
                                  height: size.height * .15,
                                  width: size.width * .2,
                                  decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(.75),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(.75),
                                            blurRadius: 10,
                                            spreadRadius: 2)
                                      ]),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 30),
                                        child: Container(
                                          width: size.width * .7,
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.credit_card,
                                                size: size.height * .035,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: size.width * .03,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  "Geçmiş kayıt bulunamadı!",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: size.width * .05,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(15),
                                child: Container(
                                  height: size.height * .15,
                                  width: size.width * .2,
                                  decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(.75),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(.75),
                                            blurRadius: 10,
                                            spreadRadius: 2)
                                      ]),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: size.width * .9,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: size.width * .27,
                                            ),
                                            Icon(
                                              Icons.credit_card,
                                              size: size.height * .035,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: size.width * .03,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Center(
                                                  child: Text(
                                                "${mypost['bakiyeGecmis']} TL",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: size.width * .05,
                                                ),
                                              )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                      Container(
                                        width: size.width * .70,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: size.width * .1,
                                            ),
                                            Icon(
                                              Icons.history,
                                              size: size.height * .035,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: size.width * .03,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Center(
                                                  child: Text(
                                                "${mypost['odemeZamani']}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: size.width * .05,
                                                ),
                                              )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                      }),
                );
        },
      ),
    );
  }
}
