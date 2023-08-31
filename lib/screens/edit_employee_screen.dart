import 'dart:io';
import 'package:appwritetest/main.dart';
import 'package:appwritetest/utils/appwrite_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

//Screens
import '../screens/signup_screen.dart';
import '../screens/home_screen.dart';

//Providers
import '../repository/auth_repository.dart';
import '../provider/appwrite_provider.dart';
import '../models/employee_moodel.dart';

class EditEmployeePage extends StatefulWidget {
  final Employee employee;
  final Function(bool) callbak;

  EditEmployeePage({required this.employee, required this.callbak});

  @override
  State<EditEmployeePage> createState() => _EditEmployeePagePageState();
}

class _EditEmployeePagePageState extends State<EditEmployeePage> {
  final _form = GlobalKey<FormState>();
  final ImagePicker imagePicker = ImagePicker();
  final GetStorage storage = GetStorage();
  AppWriteProvider appWriteProvider = AppWriteProvider();
  var imagePath;

  String name = '';
  String department = '';
  String uploadedFileId = '';
  bool isLoading = false;

  void pickImage() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imagePath = image.path;
      });
    } else {
      print('SELECT AN IMAGE');
    }
  }

  //UPLOAD the video
  void editEmployee() async {
    final isValid = _form.currentState!.validate();
    String imageLink = '';

    if (!isValid) return;

    _form.currentState!.save();

    setState(() {
      isLoading = true;
    });

    if (imagePath != null) {
      try {
        await appWriteProvider.uploadEmployeeImage(imagePath.toString()).then(
          (value) async {
            setState(() {
              imageLink =
                  '${AppwriteConstants.endPoint}/storage/buckets/${AppwriteConstants.employeeBucketID}/files/${value.$id}/view?project=${AppwriteConstants.projectID}';
              uploadedFileId = value.$id;
            });
            print('uploadedFileId $imageLink');
            await appWriteProvider.deleteEmployeeImage(widget.employee.image);
            await appWriteProvider.updateEmployee(
              {
                "name": name,
                "department": department,
                "createdBy": storage.read("userId"),
                "image": uploadedFileId,
                'documentId': widget.employee.documentId,
              },
            ).then((value) {
              widget.callbak(true);
              Navigator.of(context).pop();
            });
          },
        );
      } catch (error) {
        await appWriteProvider.deleteEmployeeImage(uploadedFileId);
      }
    } else {
      print('SELECT AN IMAGE');
    }
  }

  @override
  Widget build(BuildContext context) {
    //Get the device Size
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Employee'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (imagePath != null)
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: FileImage(
                        File(imagePath),
                      ),
                    ),
                  ),

                if (imagePath == null)
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.network(
                          '${AppwriteConstants.endPoint}/storage/buckets/${AppwriteConstants.employeeBucketID}/files/${widget.employee.image}/view?project=${AppwriteConstants.projectID}',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                //Email
                const SizedBox(height: 40.0),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: widget.employee.name,
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    if (value.toString().length > 0) {}
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Entre com uma URL.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    name = value.toString();
                  },
                ),
                //Password
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: widget.employee.department,
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    if (value.toString().length > 0) {}
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Entre com uma URL.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    department = value.toString();
                  },
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  height: 60,
                  width: mediaQuery.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.blue.shade300,
                      shape: RoundedRectangleBorder(
                        // Change your radius here
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: pickImage,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : loadingText('Change Employee Image'),
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  height: 60,
                  width: mediaQuery.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.green.shade300,
                      shape: RoundedRectangleBorder(
                        // Change your radius here
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: editEmployee,
                    child: loadingText('Save Employee Changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loadingText(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
