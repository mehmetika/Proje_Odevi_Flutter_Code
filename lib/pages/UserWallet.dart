import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

class userWallet extends StatefulWidget {
  @override
  State<userWallet> createState() => _userWalletState();
}

class _userWalletState extends State<userWallet> {
  String gelenYaziWallet = null;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  getCurrentUser1() {
    User user = _auth.currentUser;
    var uid = user.uid;
    return uid;
  }

  @override
  void yaziGetir1() {
    FirebaseFirestore.instance
        .collection('Person')
        .doc(getCurrentUser1())
        .get()
        .then((gelenVeri1) {
      setState(() {
        gelenYaziWallet = gelenVeri1.data()['wallet'];
      });
    });
  }

  List<String> title = List();
  String url;
  String parse;
  void getirCuzdanVeri() async {
    var url = Uri.parse('https://bscscan.com/address/$gelenYaziWallet');
    var response =
        await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
    dom.Document document = parser.parse(response.body);

    final veri = document.getElementsByClassName('card-body');
    title =
        veri.map((e) => e.getElementsByTagName("div")[2].innerHtml).toList();
    parse = title[0].toString();
    debugPrint(title[0].toString());
  }

  void initState() {
    super.initState();
    setState(() {
      getirCuzdanVeri();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          yaziGetir1();
          return WillPopScope(
              onWillPop: () async {
                Navigator.pop(context);
              },
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  title: Padding(
                    padding: EdgeInsets.only(left: (size.width * .15)),
                    child: Text('Cüzdan'),
                  ),
                  leading: new IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back)),
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
                            height: 45,
                          ),
                          Container(
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
                                "$gelenYaziWallet",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * .05,
                                ),
                              )),
                            ),
                          ),
                          SizedBox(
                            height: 45,
                          ),
                          Container(
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
                                "$parse BNB",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * .05,
                                ),
                              )),
                            ),
                          ),
                          SizedBox(
                            height: 45,
                          ),
                          InkWell(
                            onTap: () async {
                              setState(() {
                                getirCuzdanVeri();
                              });
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
                                  "MetaMask",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.width * .05,
                                  ),
                                )),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 45,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        });
  }
}
