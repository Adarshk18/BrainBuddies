import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseFirestoreService {
  static Future<void> storeUserProfilePicture(String userId, String imageUrl) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'profilePicture': imageUrl,
    }, SetOptions(merge: true));
  }

  static Future<String?> getUserProfilePicture(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;
        return data['profilePicture'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user profile picture: $e');
      return null;
    }
  }

  static Future<void> createUserDocument(String userId, String email, String name) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'email': email,
        'name': name,
        // Add other fields as needed
      });
    } catch (e) {
      print('Error creating user document: $e');
    }
  }

  static Future<String> uploadProfilePicture(File image, String userId) async {
    Reference ref = FirebaseStorage.instance.ref().child('profile_pics/$userId.jpg');
    UploadTask uploadTask = ref.putFile(image);

    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
