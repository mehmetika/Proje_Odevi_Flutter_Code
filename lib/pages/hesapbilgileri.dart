import 'package:flutter/material.dart';
import 'package:projeodevi/pages/resetemailadress.dart';
import 'package:projeodevi/pages/resetpassword.dart';
import 'package:projeodevi/pages/updateWalletAddress.dart';
import 'package:projeodevi/pages/uploadprofilephoto.dart';

class hesapBilgileri extends StatefulWidget {
  @override
  _hesapBilgileriState createState() => _hesapBilgileriState();
}

class _hesapBilgileriState extends State<hesapBilgileri> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Padding(
                padding: EdgeInsets.only(left: (size.width * .20)),
                child: Text('Hesap Bilgileri'),
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
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => uploadProfilePhoto()));
                        },
                        child: Container(
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
                              "Profil Fotoğrafı Yükle",
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
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => resetPassword()));
                        },
                        child: Container(
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
                              "Parola Değiştir",
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
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => resetEmail()));
                        },
                        child: Container(
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
                              "E-posta Değiştir",
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
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => updateWalletAdress()));
                        },
                        child: Container(
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
                              "Cüzdan Adresi Değiştir",
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
