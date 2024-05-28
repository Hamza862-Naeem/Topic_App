import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:topic_app/repository/main_repository.dart';
import '../../app_constants/color_constants.dart';
import 'add_categories.dart';




class MyDrawerHeader extends ConsumerStatefulWidget {
  final void Function(File) updateDrawerImage;
  final String userEmail;

  const MyDrawerHeader({Key? key, required this.updateDrawerImage, required this.userEmail}) : super(key: key);

  @override
  _MyDrawerHeaderState createState() => _MyDrawerHeaderState();
}

class _MyDrawerHeaderState extends ConsumerState<MyDrawerHeader> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors().secondaryColor,
          width: double.infinity,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: GestureDetector(
                  onTap: () async {
                    await _pickImage(ImageSource.gallery);
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
              SizedBox(height: 10),
              Text(
                widget.userEmail,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 4,
          color: Colors.grey[400], // Set the color of the divider
          height: 2,
        ),
        SizedBox(height: 15,),
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddCategory()), // Replace AddCategoryScreen with your actual screen widget
            );
          },
          leading: Icon(Icons.add),
          title: Text('Add Category'),

        ),
        SizedBox(height: 10),
        ListTile(
          onTap: () {
            // Handle "Logout" button press
          },
          leading: Icon(Icons.logout),
          title: Text('Logout'),

        ),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50,
    );

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
      widget.updateDrawerImage(_image!);
    }
  }
}
