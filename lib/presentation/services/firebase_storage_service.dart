import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  static Future<String> uploadProfilePicture(File image, String userId) async {
    Reference ref = FirebaseStorage.instance.ref().child('profile_pics/$userId.jpg');
    UploadTask uploadTask = ref.putFile(image);

    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
