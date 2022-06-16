import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:projeodevi/pages/home.dart';

class qrOku extends StatefulWidget {
  @override
  State<qrOku> createState() => _qrOkuState();
}

class _qrOkuState extends State<qrOku> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage())),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Padding(
              padding: EdgeInsets.only(left: (size.width * .20)),
              child: Text('Ödeme Yöntemleri'),
            ),
            leading: new IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
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
                      onTap: () async {
                        await LaunchApp.openApp(
                            androidPackageName: 'io.metamask', openStore: true);
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
                    InkWell(
                      onTap: () async {
                        await LaunchApp.openApp(
                            androidPackageName: 'com.wallet.crypto.trustapp',
                            openStore: true);
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
                            "TrustWallet",
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
  }
}
