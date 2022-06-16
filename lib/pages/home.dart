import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projeodevi/pages/girisyapildi.dart';
import 'package:projeodevi/pages/hesapbilgileri.dart';
import 'package:projeodevi/pages/login.dart';
import 'package:projeodevi/service/auth_service.dart';
import 'package:projeodevi/service/status_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _networkStatus1 = '';
  String gelenYaziAd = '';
  String gelenYaziSoyad = '';
  String gelenYaziAboneNo = '';
  String gelenYaziEmail = '';
  String gelenYaziBakiye = '';
  String gelenYaziImage = '';
  String gelenYaziWallet = '';
  String yazi;
  Connectivity connectivity = Connectivity();

  AuthService _authService = AuthService();
  StatusService _statusService = StatusService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void Cikis() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('sonuc', '1');
  }

  @override

  //kullanıcı kayit

  //Kullanıcı Kim?
  getCurrentUser() {
    User user = _auth.currentUser;
    var uid = user.uid;
    return uid;
  }

//Veri Çağırma
  void yaziGetir() {
    FirebaseFirestore.instance
        .collection('Person')
        .doc(getCurrentUser())
        .get()
        .then((gelenVeri) {
      setState(() {
        gelenYaziAd = gelenVeri.data()['Ad'];
        gelenYaziSoyad = gelenVeri.data()['Soyad'];
        gelenYaziAboneNo = gelenVeri.data()['aboneNo'];
        gelenYaziEmail = gelenVeri.data()['email'];
        gelenYaziBakiye = gelenVeri.data()['bakiye'];
        gelenYaziImage = gelenVeri.data()['image'];
        gelenYaziWallet = gelenVeri.data()['wallet'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: EdgeInsets.only(left: (size.width * .34)),
                child: Text('Ana Sayfa'),
              ),
            ),
            endDrawer: StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  yaziGetir();
                  return Drawer(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        UserAccountsDrawerHeader(
                          accountName: Text(
                              "$gelenYaziAd $gelenYaziSoyad\nAbone No:$gelenYaziAboneNo"),
                          accountEmail: Text('$gelenYaziEmail'),
                          currentAccountPicture: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: gelenYaziImage.isNotEmpty
                                ? NetworkImage(
                                    "$gelenYaziImage",
                                  )
                                : null,
                          ),
                        ),
                        ListTile(
                          title: Text('Anasayfa'),
                          leading: Icon(Icons.home),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('Hesap Ayarları'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => hesapBilgileri()));
                          },
                          leading: Icon(Icons.person),
                        ),
                        Divider(),
                        ListTile(
                          title: Text('Çıkış yap'),
                          onTap: () {
                            Cikis();
                            _authService.signOut();
                            Fluttertoast.showToast(
                                msg: "Çıkış Yapıldı.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          leading: Icon(Icons.remove_circle),
                        ),
                      ],
                    ),
                  );
                }),
            body: AnaSayfaBody()),
      ),
    );
  }
}
