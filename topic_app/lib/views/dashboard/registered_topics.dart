import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:topic_app/app_constants/color_constants.dart';
import 'package:topic_app/model/request/topics.dart';
import 'package:topic_app/provider/auth/topic_provider.dart';

import '../../app_constants/images_constants.dart';
import '../../enum/states.dart';
import '../../repository/main_repository.dart';
import '../../routes/app_routes.dart';
import '../../utils/response_states.dart';
import 'design.dart';
import 'my_drawer_header.dart';

class RegisteredTopics extends ConsumerStatefulWidget {
  const RegisteredTopics({Key? key}) : super(key: key);

  @override
  RegisteredTopicsState createState() => RegisteredTopicsState();
  // Implement the updateDrawerImage function
  void updateDrawerImage(File image) {
  }
}

class RegisteredTopicsState extends ConsumerState<RegisteredTopics> {
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  File? _image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String parentId = '';
  bool isVisible = true;
  // ParentId? parentId= FirebaseAuth.instance.currentParentId;
  List<TopicRequestModel> getTopicsByParentId(List<TopicRequestModel> allTopics, String? parentId) {
    return allTopics.where((topic) => topic.parentId == parentId).toList();

  }


  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(topicProvider.notifier).getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ResponseStatesModel>(topicProvider,
        (previous, responseStatesModel) async {
      switch (responseStatesModel.states) {
        case States.LOADING:
          EasyLoading.show(
            status: 'Loading...',
            maskType: EasyLoadingMaskType.black,
          );
          break;
        case States.ERROR:
          EasyLoading.dismiss();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseStatesModel
                  .message), // Error: SnackBar is not imported
            ),
          );
          break;
        case States.DATA:
          EasyLoading.dismiss();
          if (responseStatesModel.data is String) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(responseStatesModel
                    .message), // Error: SnackBar is not imported
              ),
            );
            Navigator.of(context).pop();
          } else if (responseStatesModel.data is List<TopicRequestModel>) {
            final topics = responseStatesModel.data as List<TopicRequestModel>;
            ref.read(listOFTopics.notifier).state = topics;
          }
          break;
        default:
          EasyLoading.dismiss();
          break;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Topic_App'),
        centerTitle: true,
        backgroundColor: AppColors().secondaryColor,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      endDrawer: Drawer(
     child:  Container(
       child: Column(
         children: [
           // Pass the updateDrawerImage function to the MyDrawerHeader widget
           MyDrawerHeader(updateDrawerImage: updateDrawerImage, userEmail: 'mhamzanaeem862@gmail.com',),


         ]
        ),
     ),
      ),


      body: SafeArea(
        child: Container(
          // Error: child is not a named parameter for Scaffold
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Images().loginBg,
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white,
                      backgroundImage: _image != null ? FileImage(_image!) : null,
                      child: GestureDetector(
                        onTap: () async {
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
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: title,
                      decoration: InputDecoration(
                        hintText: 'Enter title',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: description,
                      decoration: InputDecoration(
                        hintText: 'Enter description',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: MultiSelectDialogField<TopicRequestModel>(
                      items: ref
                          .watch(listOFTopics)
                          .map((topic) => MultiSelectItem<TopicRequestModel>(
                              topic, topic.title))
                          .toList(),
                      title: Text('Related Topics'),
                      selectedColor: Colors.blue,
                      buttonText: Text('Select'),
                      onConfirm: (values) {
                        ref.read(selectedTopics.notifier).state = values ?? [];
                      },
                      chipDisplay: MultiSelectChipDisplay<TopicRequestModel>(
                        onTap: (item) {
                          // setState(() {
                          //   selectedTopics.remove(item);
                          // });
                        },

                      ),
                      validator: (values) {
                        if (values == null || values.isEmpty) {
                          return 'Please select at least one topic';
                        }
                        return null;
                      },


                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  /*     ListView.builder(
                    itemCount: topics.length,
                    itemBuilder: (BuildContext context, int index) {
                      final filteredTopics = getTopicsByParentId(ref.read(listOFTopics), parentId);
                      return Visibility(
                        visible: isVisible,
                        child: DropdownButton<TopicRequestModel>(
                          value: null, // Set the initial value or use a state variable
                          items: filteredTopics
                              .map((topic) => DropdownMenuItem<TopicRequestModel>(
                            value: topic,
                            child: Text(topic.title),
                          ))
                              .toList(),
                          onChanged: (TopicRequestModel? value) {
                            setState(() {
                              parentId = value!.id;
                            });
                          },
                          hint: Text('Select a topic'), // Add a hint for the dropdown
                        ),
                      );
                    },
                  ),
                   */
                  Visibility(
                    visible: isVisible,
                    child: DropdownButton<TopicRequestModel>(
                      value: null, // Set the initial value or use a state variable
                      items: getTopicsByParentId(ref.watch(listOFTopics), parentId)
                          .map((topic) => DropdownMenuItem<TopicRequestModel>(
                        value: topic,
                        child: Text(topic.title),
                      ))
                          .toList(),
                      onChanged: (TopicRequestModel? selectedParentIdProvider) {
                        setState(() {
                          parentId =selectedParentIdProvider!.id;
                        });
                      },
                      hint: Text('Select a topic'), // Add a hint for the dropdown
                    ),
                  ),




                  SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_image == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please select an image'),
                            ),
                          );
                          return;
                        }
                        // Print selected topics
                        final List<TopicRequestModel> selectedTopic =
                            ref.watch(selectedTopics);

                        // Extract IDs from selected topics and register topic
                        String ids = "";
                        for (final topic in selectedTopic) {
                          if (ids.isEmpty) {
                            ids = ids + topic.id;
                          } else {
                            ids = ids + "," + topic.id;
                          }
                        }

                        print(ids);
                        // Register topic with selected topic IDs
                        ref.read(topicProvider.notifier).registerTopic(
                              title.text,
                              description.text,
                              _image,
                              null,
                              ids// Pass selected topic IDs here
                            );

                        // Reset form after registration
                        _resetForm();
                      }
                    },
                    child: Text('Submit'),
                  ),



                ],


              ),
            ),
          ),
        ),
      ),
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

      // Call the function to update the drawer image
      // Update the image in the drawer's header
      widget.updateDrawerImage(_image!);

    }
  }

// Call this method when you want to update the drawer image with a new file
  void updateDrawerImage(File image) {
    setState(() {
      _image = image;
    });
  }

  void _resetForm() {
    title.clear();
    description.clear();
    ref.read(selectedTopics.notifier).state = [];
    setState(() {
      // Error: setState is not defined in a StatefulWidget
      _image = null;
     // selectedTopics;
    });


  }
}

