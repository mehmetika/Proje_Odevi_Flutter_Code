import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projeodevi/model/status.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //giriş yap fonksiyonu

  Future<User> signIn(String email, String password) async {
    try {
      var user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return user.user;
    } on FirebaseException catch (e) {
      String hata = e.toString();
      switch (hata) {
        case '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.':
          Fluttertoast.showToast(
              msg: "Hatalı Parola.Lütfen parolanızı kontrol ediniz!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 4,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        case '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.':
          Fluttertoast.showToast(
              msg: "Hatalı E-Posta veya Şifre",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 4,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        case '[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.':
          Fluttertoast.showToast(
              msg:
                  "Birçok kez hatalı giriş tespit edildi.Erişiminiz kısıtlandı.Daha sonra tekrar deneyin.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 4,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;

        case '[firebase_auth/ınvalıd-emaıl] The email address is badly formatted.':
          Fluttertoast.showToast(
              msg: "Hatalı e-posta.Lütfen e-postanızı kontrol ediniz.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 4,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;

        case '[firebase_auth/unknown] Given String is empty or null':
          Fluttertoast.showToast(
              msg: "Hatalı giriş.E-posta veya şifre bölümü boş bırakılamaz.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 4,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
      }
    }
    var user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user;
  }

  //çıkış yap fonksiyonu
  signOut() async {
    return await _auth.signOut();
  }

  Random rnd = new Random();
  randomAboneNo() {
    int min = 10000, max = 100000;
    int randomabonenumarasi = min + rnd.nextInt(max - min);
    return randomabonenumarasi;
  }

  //kayıt ol fonksiyonu
  Future<User> createPerson(String aboneno, String email, String password,
      String name, String surname, String image, String wallet,
      {String bakiye = '0'}) async {
    try {
      var user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseFirestore.instance.collection("Person").doc(user.user.uid).set({
        'Ad': name,
        'Soyad': surname,
        'aboneNo': aboneno,
        'email': email,
        'bakiye': bakiye,
        'image': image,
        'wallet': wallet
      });
      FirebaseFirestore.instance
          .collection("History:${user.user.uid}")
          .doc(user.user.uid)
          .set({
        'bakiyeGecmis': null,
        'odemeZamani': null,
      });

      return user.user;
    } on FirebaseException catch (e) {
      String kayithata = e.toString();
      print(kayithata);
      switch (kayithata) {
        case '[firebase_auth/weak-password] Password should be at least 6 characters':
          Fluttertoast.showToast(
              msg: "Zayıf parola.Parolanız 6 karakterden az olamaz!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 4,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        case '[firebase_auth/email-already-in-use] The email address is already in use by another account.':
          Fluttertoast.showToast(
              msg: "Mevcut e-posta.Lütfen başka e posta deneyiniz!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 4,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;

        case '[firebase_auth/ınvalıd-emaıl] The email address is badly formatted.':
          Fluttertoast.showToast(
              msg: "Hatalı e-posta.Lütfen e-postanızı kontrol ediniz.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 4,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;

        case '[firebase_auth/unknown] Given String is empty or null':
          Fluttertoast.showToast(
              msg: "Hatalı giriş.E-posta veya şifre bölümü boş bırakılamaz.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 4,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
      }
    }
    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    FirebaseFirestore.instance.collection("Person").doc(user.user.uid).set({
      'Ad': name,
      'Soyad': surname,
      'aboneNo': aboneno,
      'email': email,
      'bakiye': bakiye,
      'image': image
    });
    FirebaseFirestore.instance
        .collection("History:${user.user.uid}")
        .doc(user.user.uid)
        .set({
      'bakiyeGecmis': null,
      'odemeZamani': null,
    });

    return user.user;
  }

  Future<void> addStatus(
      String bakiyegecmis, String odemeZamani, String odemeZamaniDoc) async {
    var ref = FirebaseFirestore.instance
        .collection("History:${getCurrentUser()}")
        .doc(odemeZamaniDoc);
    var documentRef = await ref.set({
      'bakiyeGecmis': bakiyegecmis,
      'odemeZamani': odemeZamani,
    });

    return Status(bakiyeGecmis: bakiyegecmis, odemeZamani: odemeZamani);
  }

  Future<void> deleteilkkayit() async {
    FirebaseFirestore.instance
        .collection("History:${getCurrentUser()}")
        .doc(getCurrentUser())
        .delete();
  }

  Stream<QuerySnapshot> getStatus() {
    var ref = FirebaseFirestore.instance
        .collection("History:${getCurrentUser()}")
        .snapshots();

    return ref;
  }

//veri güncelleme
  Future<User> updateBakiye(String bakiye) async {
    FirebaseFirestore.instance
        .collection("Person")
        .doc(getCurrentUser())
        .update({'bakiye': bakiye});
  }

  Future<User> updateWalletData(String wallet) async {
    FirebaseFirestore.instance
        .collection("Person")
        .doc(getCurrentUser())
        .update({'wallet': wallet});
  }

  //veri güncelleme
  Future<User> updateProfilePhoto(String pickedFile) async {
    FirebaseFirestore.instance
        .collection("Person")
        .doc(getCurrentUser())
        .update({'image': pickedFile});
  }

  Future<User> updateEmail(
    String email,
  ) async {
    try {
      User firebaseUser = await _auth.currentUser;
      await firebaseUser.updateEmail(email);
    } on FirebaseException catch (e) {
      String error = e.code;
      print(error);
      switch (error) {
        case 'emaıl-already-ın-use':
          Fluttertoast.showToast(
              msg: "Mevcut e-posta.Lütfen başka e posta deneyiniz!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 4,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;

        case 'ınvalıd-emaıl':
          Fluttertoast.showToast(
              msg: "Hatalı e-posta.Lütfen e-postanızı kontrol ediniz.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 4,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
      }
    }
    User firebaseUser = await _auth.currentUser;
    await firebaseUser.updateEmail(email);
  }

  getCurrentUser() {
    User user = _auth.currentUser;
    var uid = user.uid;
    return uid;
  }
}
