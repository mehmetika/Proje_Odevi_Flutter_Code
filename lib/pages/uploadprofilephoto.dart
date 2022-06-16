import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeodevi/pages/home.dart';
import 'package:projeodevi/service/Storage%20Service.dart';
import 'package:projeodevi/service/auth_service.dart';

class uploadProfilePhoto extends StatefulWidget {
  @override
  _uploadProfilePhotoState createState() => _uploadProfilePhotoState();
}

class _uploadProfilePhotoState extends State<uploadProfilePhoto> {
  AuthService _authService = AuthService();
  ImagePicker _picker = ImagePicker();
  StorageService _storageService = StorageService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String imagePath = null;
  bool galerimi = true;
  File _image;
  File _cropped;
  bool _inprocess;
  String gelenYaziImage;
  Future resmiCagir() async {
    if (galerimi == true) {
      final galeriveri = await _picker.getImage(source: ImageSource.gallery);
      _image = File(galeriveri.path);
      _cropped = await ImageCropper().cropImage(
          cropStyle: CropStyle.circle,
          sourcePath: galeriveri.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
              toolbarColor: Colors.blue,
              toolbarTitle: 'Kırpma Aracı',
              statusBarColor: Colors.blue,
              backgroundColor: Colors.white));
      return _cropped;
    } else {
      final cameraveri = await _picker.getImage(source: ImageSource.camera);
      _image = File(cameraveri.path);
      _cropped = await ImageCropper().cropImage(
          cropStyle: CropStyle.circle,
          sourcePath: cameraveri.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
              toolbarColor: Colors.blue,
              toolbarTitle: 'Kırpma Aracı',
              statusBarColor: Colors.red,
              backgroundColor: Colors.white));
      return _cropped;
    }
  }

  getCurrentUser4() {
    User user = _auth.currentUser;
    var uid = user.uid;
    return uid;
  }

  void yaziGetir4() {
    FirebaseFirestore.instance
        .collection('Person')
        .doc(getCurrentUser4())
        .get()
        .then((gelenVeri4) {
      setState(() {
        gelenYaziImage = gelenVeri4.data()['image'];
      });
    });
  }

  Future<void> _showChoiseDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          yaziGetir4();
          return AlertDialog(
              title: Text(
                "Profil fotoğrafınızı değiştirmek istediğinizden emin misiniz?",
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
                          _storageService
                              .deleteImageFromStorage(gelenYaziImage);
                          _authService.updateProfilePhoto(imagePath);
                          Fluttertoast.showToast(
                              msg: "Profil Fotoğrafı Değiştirildi!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 4,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        },
                        child: Text(
                          "Evet",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _storageService.deleteImageFromStorage(imagePath);
                          Navigator.of(context).pop();
                          setState(() {
                            imagePath = null;
                          });
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(left: 60),
              child: Text('Profil Fotoğrafı Yükle'),
            ),
            leading: new IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  _storageService.deleteImageFromStorage(imagePath);
                },
                icon: Icon(Icons.arrow_back)),
          ),
          body: Center(
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
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * .04,
                  ),
                  (imagePath != null)
                      ? Container(
                          height: size.height * .4,
                          width: size.width * .70,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                              ),
                              color: Colors.white,
                              image: DecorationImage(
                                  image: NetworkImage(imagePath),
                                  fit: BoxFit.cover)),
                        )
                      : Container(
                          child: Center(
                              child: Text(
                            'Yüklediğiniz Fotoğraf Burada Görüntülenecek!',
                            style: TextStyle(
                              fontSize: size.width * .027,
                            ),
                          )),
                          height: size.height * .4,
                          width: size.width * .70,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white),
                              color: Colors.white)),
                  SizedBox(
                    height: size.height * .03,
                  ),
                  InkWell(
                    onTap: () async {
                      galerimi = true;
                      File file = await resmiCagir();
                      imagePath = await _storageService.uploadImage(file);
                      setState(() {});
                    },
                    child: Container(
                      width: size.width * .60,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          //color: colorPrimaryShade,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Row(
                        children: [
                          SizedBox(
                            width: size.width * .05,
                          ),
                          Icon(
                            Icons.image,
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
                              "Galeriden Yükle ",
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
                    height: size.height * .03,
                  ),
                  InkWell(
                    onTap: () async {
                      galerimi = false;
                      File file = await resmiCagir();
                      imagePath = await _storageService.uploadImage(file);
                      setState(() {});
                    },
                    child: Container(
                      width: size.width * .60,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          //color: colorPrimaryShade,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Row(
                        children: [
                          SizedBox(
                            width: size.width * .05,
                          ),
                          Icon(
                            Icons.photo_camera,
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
                              "Kamera İle Yükle ",
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
                    height: size.height * .09,
                  ),
                  InkWell(
                    onTap: () {
                      if (imagePath != null) {
                        _showChoiseDialog(context);
                        setState(() {});
                      }
                      if (imagePath == null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Profil Fotoğrafı Seçilmedi!'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: const <Widget>[
                                    Text('Önce fotoğraf seçiniz.'),
                                    Text(''),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Tamam'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      width: size.width * .75,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          //color: colorPrimaryShade,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Row(
                        children: [
                          SizedBox(
                            width: size.width * .05,
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
                              "Profil Fotoğrafını Değiştir",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
