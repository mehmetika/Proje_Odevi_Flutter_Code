import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:projeodevi/pages/home.dart';
import 'package:projeodevi/service/auth_service.dart';

class updateWalletAdress extends StatefulWidget {
  @override
  State<updateWalletAdress> createState() => _updateWalletAdressState();
}

class _updateWalletAdressState extends State<updateWalletAdress> {
  TextEditingController _walletController = TextEditingController();
  AuthService _authService = AuthService();

  List<String> title = List();
  List<String> post = List();
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
      _authService.updateWalletData(Cuzdan);
      Fluttertoast.showToast(
          msg: "Cüzdan Adresi Güncellendi.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  Future<void> _showBakiyeDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                "Cüzdan Adresinizi değiştirmek istediğinizden emin misiniz?",
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
                          getirCuzdanVeri();
                        },
                        child: Text(
                          "Evet",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Vazgeç",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )));
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                  height: 45,
                ),
                InkWell(
                  onTap: () {
                    _showBakiyeDialog();
                  },
                  child: Container(
                    height: size.height * .065,
                    width: size.width * .7,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        //color: colorPrimaryShade,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                          child: Text(
                        "Cüzdan Değiştir",
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
  }
}
