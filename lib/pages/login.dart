import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projeodevi/pages/home.dart';
import 'package:projeodevi/pages/register.dart';
import 'package:projeodevi/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _networkStatus1 = '';

  Connectivity connectivity = Connectivity();

//İnternet Bağlantısı Kontrol
  void checkConnectivity() async {
    var connectivityResult = await connectivity.checkConnectivity();
    var conn = getConnectionValue(connectivityResult);
    setState(() {
      _networkStatus1 = '' + conn;
    });
  }

  //İnternet bağlantı biçimi
  String getConnectionValue(var connectivityResult) {
    String status = '';
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        status = 'Mobile';
        break;
      case ConnectivityResult.wifi:
        status = 'Wi-Fi';
        break;
      case ConnectivityResult.none:
        status = 'None';
        break;
      default:
        status = 'None';
        break;
    }
    return status;
  }

  String yazi;
  AuthService _authService = AuthService();
  DateTime currentBackPressTime;
  @override
  void initState() {
    getValidationData().whenComplete(() async {
      debugPrint(yazi);
      if (yazi == '0') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
      if (yazi == '1' || null) {
        null;
      }
    });
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    yazi = sharedPreferences.getString('sonuc');
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    checkConnectivity();
    if (_networkStatus1 == 'None') {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Container(
          child: AlertDialog(
            title: const Text('Bağlantı Kesildi'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Bağlantınızı kontrol ediniz.'),
                  Text("Tamam'a bastığınızda çıkış gerçekleşecek."),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Tamam'),
                onPressed: () {
                  exit(0);
                },
              ),
            ],
          ),
        ),
      );
    }
    if (_networkStatus1 == 'Wi-Fi' || _networkStatus1 == 'Mobile') {
      if (yazi == '1') {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            body: WillPopScope(
              onWillPop: () => onWillPop(),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: (size.width * .20)),
                  child: Container(
                    height: size.height * .5,
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
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                                controller: _emailController,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                cursorColor: Colors.white,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.mail,
                                    color: Colors.white,
                                  ),
                                  hintText: 'E-Mail',
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
                              height: size.height * 0.02,
                            ),
                            TextField(
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                cursorColor: Colors.white,
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.vpn_key,
                                    color: Colors.white,
                                  ),
                                  hintText: 'Parola',
                                  prefixText: ' ',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                  ),
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
                              height: size.height * 0.08,
                            ),
                            InkWell(
                              onTap: () {
                                _authService
                                    .signIn(_emailController.text,
                                        _passwordController.text)
                                    .then((value) async {
                                  final SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  sharedPreferences.setString('sonuc', '0');
                                  Fluttertoast.showToast(
                                      msg: "Giriş Yapıldı.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()));
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    //color: colorPrimaryShade,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                      child: Text(
                                    "Giriş yap",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.width * .05,
                                    ),
                                  )),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 1,
                                    width: 75,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "Kayıt ol",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Container(
                                    height: 1,
                                    width: 75,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ));
      }
    }
    return Scaffold(
      backgroundColor: Colors.white,
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: "Çıkmak için bir kere daha dokun!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return Future.value(false);
    }
    exit(0);
  }
}
