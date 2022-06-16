import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projeodevi/pages/home.dart';
import 'package:projeodevi/pages/odemeyontemleri.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class qrOkumaSayfa extends StatefulWidget {
  int value;
  qrOkumaSayfa({this.value});
  @override
  State<qrOkumaSayfa> createState() => _qrOkumaSayfaState(value);
}

class _qrOkumaSayfaState extends State<qrOkumaSayfa> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;
  int value;
  _qrOkumaSayfaState(this.value);

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  Future qrDogruMu(BuildContext context) {}
  String gelenCuzdanVeri = '';
  void CihazSayisi() {
    if (result != null) {
      FirebaseFirestore.instance
          .collection('Cuzdan')
          .doc('Kod')
          .get()
          .then((gelenVeri2) {
        gelenCuzdanVeri = gelenVeri2.data()['Cihaz1'];
        debugPrint(gelenCuzdanVeri);
        if (value == 0) {
          if (gelenCuzdanVeri != result.code) {
            Fluttertoast.showToast(
                msg: "Ç O K M E M N U N O L D U M F E R H A T Y I L M A Z!!!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            value = 1;
            debugPrint('ali:${result.code}');
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          }
          if (gelenCuzdanVeri == result.code) {
            Fluttertoast.showToast(
                msg: "Cüzdan Adresi Kopyalandı.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            value = 1;
            Clipboard.setData(ClipboardData(text: '${result.code}'));
            result = null;
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => qrOku()));
          }
        }
      });
    }
  }

  int sonuc = 0;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          debugPrint(value.toString());
          return Scaffold(
            body: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      cutOutSize: MediaQuery.of(context).size.width * 0.8,
                      borderColor: Theme.of(context).accentColor,
                      borderRadius: 10,
                      borderLength: 20,
                      borderWidth: 10,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!mounted) return;
      result = scanData;
      CihazSayisi();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
