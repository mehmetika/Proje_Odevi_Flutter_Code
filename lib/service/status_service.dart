import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatusService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String mediaUrl = '';
  //

  //veri cagirma
  Stream<QuerySnapshot> getStatus() {
    var ref = _firestore.collection("Person").snapshots();
    return ref;
  }

  Stream<QuerySnapshot> getImages() {
    var ref1 = _firestore.collection("ProfilePhoto").snapshots();
    return ref1;
  }

  getCurrentUser() {
    User user = _auth.currentUser;
    var uid = user.uid;
    return uid;
  }
}
