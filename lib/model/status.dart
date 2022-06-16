import 'package:cloud_firestore/cloud_firestore.dart';

class Status {
  String bakiyeGecmis;
  String odemeZamani;

  Status({this.bakiyeGecmis, this.odemeZamani});

  factory Status.fromSnapshot(DocumentSnapshot snapshot) {
    return Status(
        bakiyeGecmis: snapshot['bakiyeGecmis'],
        odemeZamani: snapshot['odemeZamani']);
  }
}
