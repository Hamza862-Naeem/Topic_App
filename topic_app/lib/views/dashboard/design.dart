import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../app_constants/string_constants.dart';

class Avatar {
  final String id;
  final String title;
  final String description;
  final String userId;

  Avatar({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
  });
}

class Design extends StatefulWidget {
  const Design({Key? key}) : super(key: key);

  @override
  DesignState createState() => DesignState();
}

class DesignState extends State<Design> {
  String? title;
  String? description;
  String? userId; // User ID

  File? _image;
  List<Avatar> selectedTopics = [];
//List to store selected topics

  // List of dummy topics for demonstration
  List<Avatar> topics = [
    Avatar(id: '1', title: 'Topic 1', description: 'Description 1', userId: 'userId1'),
    Avatar(id: '2', title: 'Topic 2', description: 'Description 2', userId: 'userId2'),
    Avatar(id: '3', title: 'Topic 3', description: 'Description 3', userId: 'userId3'),
  ];

  // Function to pick image from gallery
  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }// Function to upload image to Firebase Storage
  Future<void> _uploadImage() async {
    print('Upload image function called');

    if (_image == null) return;

    try {
      // Upload image to Firebase Storage
      String fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.png';
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      await ref.putFile(_image!);

      // Get download URL
      String downloadURL = await ref.getDownloadURL();

      // Get user ID from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userData = prefs.getString(Strings().prefUserData);

      if (userData != null) {
        final data = json.decode(userData);
        userId = data['uuid'];

        // Generate a unique ID for the avatar
        String avatarId = FirebaseFirestore.instance.collection('topics').doc().id;

        // Create a list of topic IDs
        List<String> topicIds = selectedTopics.map((topic) => topic.id).toList();

        // Save Avatar data to Firestore in 'topics' collection
        await FirebaseFirestore.instance.collection('topics').doc(avatarId).set({
        //  'url': downloadURL,
          'title': title,
          'description': description,
          'userId': userId,
          'topicIds': topicIds, // Store the selected topic IDs
          'parentId': null,
        //  'avatarId': avatarId, // Store the avatar ID
        });

        // Clear the image and text fields after upload
        setState(() {
          title = null;
          description = null;
          _image = null;
          selectedTopics.clear();
        });
      } else {
        print('User data not found in SharedPreferences');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login_bg.png'), // Replace with your asset path
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Container(
                      height: 150,
                      width: 150,
                      padding: EdgeInsets.only(top: 0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 5),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 120,
                        backgroundColor: Colors.white,
                        backgroundImage: _image != null ? FileImage(_image!) : null,
                        child: GestureDetector(
                          onTap: () {
                            _pickImage(ImageSource.gallery);
                          },
                          child: _image == null
                              ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: Icon(
                              Icons.add_photo_alternate,
                              size: 40,
                              color: Colors.blue,
                            ),
                          )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 180, left: 20, right: 20),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          title = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          description = value;
                        });
                      },
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    MultiSelectDialogField<Avatar>(
                      items: topics
                          .map((topic) => MultiSelectItem<Avatar>(topic, topic.title))
                          .toList(),
                      initialValue: selectedTopics,
                      title: Text('Related Topics'),
                      selectedColor: Colors.blue,
                      buttonText: Text('Select'),
                      onConfirm: (values) {
                        setState(() {
                          selectedTopics = values ?? []; // Ensure selectedTopics is not null
                        });
                      },
                      chipDisplay: MultiSelectChipDisplay<Avatar>(
                        onTap: (item) {
                          setState(() {
                            selectedTopics.remove(item);
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _uploadImage,
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
