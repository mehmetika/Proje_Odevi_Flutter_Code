import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:projeodevi/pages/login.dart';
import 'package:projeodevi/service/auth_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _abonenoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController =
      TextEditingController();
  final TextEditingController _walletController = TextEditingController();

  AuthService _authService = AuthService();
  List<String> title = List();
  List<String> post = List();
  List<String> link = List();
  String url;
  String parse;
  String Cuzdan = null;
  void getirCuzdanVeri() async {
    debugPrint(_walletController.text);
    Cuzdan = _walletController.text;
    var url = Uri.parse('https://bscscan.com/address/$Cuzdan');
    var response =
        await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
    dom.Document document = parser.parse(response.body);
    final deger = document.getElementsByClassName('mb-3 mb-lg-0');
    post = deger.map((e) => e.getElementsByTagName("h1")[0].innerHtml).toList();
    debugPrint(post[0].toString().length.toString());
    if (post[0].toString().length.toString() == '124') {
      Fluttertoast.showToast(
          msg: "Hatalı Cüzdan Adresi!Lütfen Doğru Bir Adres Girin! ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      if (_passwordController.text == _passwordAgainController.text) {
        _authService
            .createPerson(
                randomAboneNo(),
                _emailController.text,
                _passwordController.text,
                _nameController.text,
                _surnameController.text,
                defaultProfilePhoto,
                _walletController.text)
            .then((value) {
          Fluttertoast.showToast(
              msg: "Kayıt Başarılı.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 4,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          return Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        });
      } else {
        Fluttertoast.showToast(
            msg: "Hatalı eşleşme.Parola ve parola tekrar eşleşmiyor! ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  Random rnd = new Random();
  randomAboneNo() {
    int min = 10000, max = 100000;
    int randomabonenumarasi = min + rnd.nextInt(max - min);
    String randomabonenumarasitext = randomabonenumarasi.toString();
    return randomabonenumarasitext;
  }

  String defaultProfilePhoto =
      'https://firebasestorage.googleapis.com/v0/b/inodya-197b4.appspot.com/o/default-profile-picture1.jpg?alt=media&token=63cc177c-9f2e-4139-894f-8ba0357ec5b8';
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 60),
                child: Container(
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
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Column(
                        children: [
                          TextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z- ]")),
                              ],
                              controller: _nameController,
                              maxLength: 20,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                                hintText: 'Ad',
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
                            height: size.height * 0.00,
                          ),
                          TextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z- ]")),
                              ],
                              maxLength: 20,
                              controller: _surnameController,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                                hintText: 'Soyad',
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
                            height: size.height * 0.00,
                          ),
                          TextField(
                              controller: _emailController,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              maxLength: 25,
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
                            height: size.height * 0.00,
                          ),
                          TextField(
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              maxLength: 20,
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
                            height: size.height * 0.00,
                          ),
                          TextField(
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              maxLength: 20,
                              cursorColor: Colors.white,
                              controller: _passwordAgainController,
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.vpn_key,
                                  color: Colors.white,
                                ),
                                hintText: 'Parola Tekrar',
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
                            height: size.height * 0.00,
                          ),
                          TextField(
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              maxLength: 42,
                              cursorColor: Colors.white,
                              controller: _walletController,
                              obscureText: false,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.white,
                                ),
                                hintText: 'Cüzdan Adresi',
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
                            height: size.height * 0.04,
                          ),
                          InkWell(
                            onTap: () async {
                              if (_emailController.text == '' ||
                                  _passwordController.text == '' ||
                                  _nameController.text == '' ||
                                  _surnameController.text == '' ||
                                  _passwordAgainController == '' ||
                                  _walletController.text == '') {
                                Fluttertoast.showToast(
                                    msg:
                                        "Hatalı giriş.Gerekli alanlar boş bırakılamaz.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 4,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                getirCuzdanVeri();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  //color: colorPrimaryShade,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                    child: Text(
                                  "Kaydet",
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
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: size.height * .06, left: size.width * .02),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Colors.blue.withOpacity(.75),
                        size: 26,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.28,
                    ),
                    Text(
                      "Kayıt ol",
                      style: TextStyle(
                          fontSize: (size.width * .05),
                          color: Colors.blue.withOpacity(.75),
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
