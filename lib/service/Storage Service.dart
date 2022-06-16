import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class StorageService {
  Future<String> uploadImage(File imageFile) async {
    String fileName = basename(imageFile.path);
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(fileName);
    firebase_storage.UploadTask task = ref.putFile(imageFile);
    firebase_storage.TaskSnapshot snapshot = await task;

    return snapshot.ref.getDownloadURL();
  }

  Future<void> deleteImageFromStorage(String Url) async {
    String fileName = Url.replaceAll("/o/", "*");
    fileName = fileName.replaceAll("?", "*");
    fileName = fileName.split("*")[1];
    if (fileName == 'default-profile-picture1.jpg') {
    } else {
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);
      return ref.delete();
    }
  }
}
