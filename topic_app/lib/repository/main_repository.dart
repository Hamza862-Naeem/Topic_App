import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../model/request/topics.dart';



class CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String id = FirebaseFirestore.instance.collection('Add Category').doc().id;
  Future<void> saveCategory(String title, String imageUrl) async {
    try {
      // Use add() method without specifying document ID to let Firestore generate it
      await _firestore.collection('Add Category').add({
        'title': title,
        'imageUrl': imageUrl,
        'id':id,
        // Add any other relevant fields
      });

      print('Category added successfully');
    } catch (e) {
      print('Error occurred while adding category: $e');
      throw e;
    }
  }
}





final registeredRepository = StateProvider((ref) => _RegisteredRepository(ref));
FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;

class _RegisteredRepository {
  Ref ref;
  _RegisteredRepository(this.ref);



  Future<String> registerTopics(String title, String description, File? avatarImage, String? parentId, String relatedTopics) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not authenticated");
      }

      // Upload the avatar image to Firebase Storage
      String? avatarUrl;
      if (avatarImage != null) {
        final avatarRef = storage.ref().child('avatars/${user.uid}');
        await avatarRef.putFile(avatarImage);
        avatarUrl = await avatarRef.getDownloadURL();
      }
      String id = FirebaseFirestore.instance.collection('topics').doc().id;
      // Create a document for the registered topic in Firestore
      await db.collection('topics').add({
        'id':id,
        'title': title,
        'description': description,
        'userId': user.uid,
        'avatarUrl': avatarUrl,
        'parentId' : parentId,
        'relatedTopics' : relatedTopics// Set parentId to the provided value or null
        // Add any other relevant fields
      });


      return "topic registered Successfully";
    } catch (e) {
      // Handle any errors that occur during registration
      print('Error registering topics: $e');
      throw e;
    }
  }


  Future<List<TopicRequestModel>> getData() async {
    try {
      // Fetch topic data from Firestore
      final snapshot = await db.collection('topics').get();

      // Convert the snapshot to a list of maps
      final List<Map<String, dynamic>> topicsData = snapshot.docs.map((
          doc) => doc.data()).toList();

      print(topicsData);

      return convertToTopicRequestModelList(topicsData);
    } catch (e) {
      // Handle any errors that occur during data fetching
      print('Error fetching topics data: $e');
      throw e; // Throw the error to ensure that the method always completes with an error
    }
  }




  List<TopicRequestModel> convertToTopicRequestModelList(
      List<Map<String, dynamic>> topicsData) {
    return topicsData.map((map) =>
        TopicRequestModel(
          id: map['id'] ?? '',
          // Replace 'id' with the actual key for the id field in your data
          title: map['title'] ?? '',
          // Replace 'title' with the actual key for the title field in your data
          detail: map['description'] ??
              '', // Replace 'detail' with the actual key for the detail field in your data
       parentId: map['parentId'] ?? '',
        )).toList();
  }
  Stream<List<TopicRequestModel>> getDataStream() {
    try {
      return db.collection('topics').snapshots().map((snapshot) {
        // Convert the snapshot to a list of maps
        final List<Map<String, dynamic>> topicsData = snapshot.docs.map((doc) => doc.data()).toList();
        // Convert the list of maps to a list of TopicRequestModel objects
        return convertToTopicRequestModelList(topicsData);
      });
    } catch (e) {
      // Handle any errors that occur during data fetching
      print('Error fetching topics data: $e');
      throw e;
    }
  }
}


