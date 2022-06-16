import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:projeodevi/pages/qrokumasayfa.dart';
import 'package:projeodevi/pages/uploadprofilephoto.dart';
import 'package:projeodevi/service/status_service.dart';

int bakiyeDeger;

class AnaSayfaBody extends StatefulWidget {
  @override
  _AnaSayfaBodyState createState() => _AnaSayfaBodyState();
}

class _AnaSayfaBodyState extends State<AnaSayfaBody> {
  StatusService _statusService = StatusService();

  int sonuc = 0;

  String barcodeScanRes = '';

  int gelenCuzdanVeriSayi = null;
  String gelenCuzdanVeri = '';
  String gelenYaziAd = '';
  String gelenYaziSoyad = '';
  String gelenYaziAboneNo = '';
  String gelenYaziEmail = '';
  String gelenYaziBakiye = '';
  String gelenYaziImage = '';
  String gelenYaziWallet = null;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  getCurrentUser1() {
    User user = _auth.currentUser;
    var uid = user.uid;
    return uid;
  }

  List<String> title = List();
  List<String> post = List();
  List<String> link = List();
  List<String> gecmisvarmi1 = List();
  List<String> gecmisivarmi11 = List();
  List<String> link1 = List();
  String url;
  String parse;
  String sonGelen;
  String gecmisivarmi;
  String gecmisivarmi2;
  String Calisiyormu;
  String KalanSure;
  void getirCuzdanVeri() async {
    debugPrint(gelenYaziWallet);
    var url = Uri.parse(
        'https://bscscan.com/address/0xbe297fc4Ef2e58Ff21FE80d94aE21aA2BAf3151A');
    var response =
        await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
    dom.Document document = parser.parse(response.body);
    final deger = document.getElementsByClassName('mb-3 mb-lg-0');
    post = deger.map((e) => e.getElementsByTagName("h1")[0].innerHtml).toList();
    debugPrint(post[0].toString().length.toString());
    if (post[0].toString().length.toString() == '124') {
      debugPrint('hata');
    } else {
      dom.Document document = parser.parse(response.body);
      final gecmisvarmi = document.getElementsByClassName('table table-hover');
      gecmisvarmi1 = gecmisvarmi
          .map((e) => e.getElementsByTagName("tbody")[0].innerHtml)
          .toList();
      gecmisivarmi = gecmisvarmi1[0];
      gecmisivarmi = gecmisivarmi.substring(73, 102);
      debugPrint(gecmisivarmi);

      if (gecmisivarmi == 'There are no matching entries') {
        var url = Uri.parse('https://bscscan.com/address/$gelenYaziWallet');
        var response =
            await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
        dom.Document document = parser.parse(response.body);
        final veri = document.getElementsByClassName('card-body');
        title = veri
            .map((e) => e.getElementsByTagName("div")[2].innerHtml)
            .toList();
        parse = title[0].toString();
        final withoutEquals = parse.replaceAll(RegExp("<b>.</b>"), '.');
        parse = withoutEquals;
        parse = parse.substring(0, 6);
        debugPrint(parse);
      } else {
        var url = Uri.parse('https://bscscan.com/address/$gelenYaziWallet');
        var response =
            await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
        dom.Document document = parser.parse(response.body);
        final veri = document.getElementsByClassName('card-body');
        title = veri
            .map((e) => e.getElementsByTagName("div")[2].innerHtml)
            .toList();
        parse = title[0].toString();
        final withoutEquals = parse.replaceAll(RegExp("<b>.</b>"), '.');
        parse = withoutEquals;
        parse = parse.substring(0, 6);
        debugPrint(parse);
        var url1 = Uri.parse(
            'https://bscscan.com/address/0xbe297fc4Ef2e58Ff21FE80d94aE21aA2BAf3151A');
        var response1 =
            await http.post(url1, body: {'name': 'doodle', 'color': 'blue'});
        dom.Document document1 = parser.parse(response1.body);
        final gecmis = document1.getElementsByClassName('table table-hover');
        link = gecmis
            .map((e) => e.getElementsByTagName("tbody")[0].innerHtml)
            .toList();
        sonGelen = link[0];
        sonGelen = sonGelen.substring(256, 298);
        debugPrint(sonGelen);
      }
    }
  }

  final fb = FirebaseDatabase.instance;
  showData() {
    final ref = fb.reference().child('Durum').child('Calisiyor mu');
    ref.once().then((DataSnapshot dataSnapshot) {
      Calisiyormu = dataSnapshot.value.toString();
      debugPrint(Calisiyormu);
    });
  }

  showTime() {
    final ref = fb.reference().child('KalanSure').child('Zaman');
    ref.once().then((DataSnapshot dataSnapshot) {
      setState(() {
        KalanSure = dataSnapshot.value.toString();
      });
      debugPrint(Calisiyormu);
    });
  }

  void CihazSayisi() {
    FirebaseFirestore.instance
        .collection('Cuzdan')
        .doc('Kod')
        .get()
        .then((gelenVeri2) {
      setState(() {
        gelenCuzdanVeriSayi = gelenVeri2.data().length;
      });
    });
  }

  void initState() {
    super.initState();
    setState(() {
      showData();
      Future.delayed(const Duration(milliseconds: 2000), () async {});
      yaziGetir1();
      Future.delayed(const Duration(milliseconds: 1200), () {
        getirCuzdanVeri();
      });
    });
  }

  void yaziGetir1() {
    FirebaseFirestore.instance
        .collection('Person')
        .doc(getCurrentUser1())
        .get()
        .then((gelenVeri1) {
      setState(() {
        gelenYaziWallet = gelenVeri1.data()['wallet'];
        gelenYaziAd = gelenVeri1.data()['Ad'];
        gelenYaziSoyad = gelenVeri1.data()['Soyad'];
        gelenYaziAboneNo = gelenVeri1.data()['aboneNo'];
        gelenYaziEmail = gelenVeri1.data()['email'];
        gelenYaziBakiye = gelenVeri1.data()['bakiye'];
        gelenYaziImage = gelenVeri1.data()['image'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: StreamBuilder(
          stream: null,
          builder: (context, snapshot) {
            yaziGetir1();
            CihazSayisi();
            showData();
            showTime();
            return Center(
              child: parse == null
                  ? CircularProgressIndicator()
                  : Container(
                      height: size.height * .85,
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
                              height: size.height * 0.00,
                            ),
                            gelenYaziImage == null
                                ? CircularProgressIndicator()
                                : Container(
                                    height: size.height * .27,
                                    width: size.width * .4725,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 3),
                                        color: Colors.white,
                                        image: DecorationImage(
                                            image: NetworkImage(gelenYaziImage),
                                            fit: BoxFit.cover)),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    uploadProfilePhoto()));
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: size.height * 0.2,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.41,
                                              ),
                                              Icon(
                                                Icons.add_a_photo,
                                                size: size.height * .05,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              height: size.height * 0.00,
                            ),
                            Container(
                              width: size.width * .70,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  //color: colorPrimaryShade,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: size.width * .03,
                                  ),
                                  Icon(
                                    Icons.account_circle,
                                    size: size.height * .035,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: size.width * .03,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                        child: Text(
                                      "$gelenYaziAd $gelenYaziSoyad",
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
                              height: size.height * 0.025,
                            ),
                            Container(
                              width: size.width * .70,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  //color: colorPrimaryShade,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: size.width * .03,
                                  ),
                                  Icon(
                                    Icons.home,
                                    size: size.height * .035,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: size.width * .03,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                        child: Text(
                                      "Abone No  :   $gelenYaziAboneNo",
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
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  //color: colorPrimaryShade,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: size.width * .03,
                                  ),
                                  Icon(
                                    Icons.payments,
                                    size: size.height * .035,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: size.width * .03,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                        child: parse == '0 BNB '
                                            ? Text(
                                                "Bakiye   :   $parse",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: size.width * .05,
                                                ),
                                              )
                                            : Text(
                                                "Bakiye   :   $parse BNB ",
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
                              height: size.height * 0.04,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            qrOkumaSayfa(value: sonuc)));
                              },
                              child: Container(
                                width: size.width * .75,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    //color: colorPrimaryShade,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * .03,
                                    ),
                                    Icon(
                                      Icons.qr_code_2,
                                      size: size.height * .035,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: size.width * .11,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                          child: Text(
                                        "QR İşlemleri",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.width * .05,
                                        ),
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.080,
                            ),
                            Calisiyormu == '0'
                                ? Container(
                                    width: size.width * .70,
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        //color: colorPrimaryShade,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: size.width * .08,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Center(
                                              child: Text(
                                            "Aktif İşlem Bulunmamaktadır",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: size.width * .04,
                                            ),
                                          )),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    width: size.width * .70,
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        //color: colorPrimaryShade,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: size.width * .11,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Center(
                                              child: Text(
                                            "Kalan Süre=$KalanSure",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: size.width * .06,
                                            ),
                                          )),
                                        ),
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
            );
          }),
    );
  }
}
