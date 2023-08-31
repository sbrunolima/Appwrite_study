import 'package:appwritetest/main.dart';
import 'package:appwritetest/screens/login_screen.dart';
import 'package:appwritetest/utils/appwrite_constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

//Screens
import '../screens/add_employee_screen.dart';
import '../screens/edit_employee_screen.dart';

//Providers
import '../repository/auth_repository.dart';
import '../provider/appwrite_provider.dart';
import '../models/employee_moodel.dart';

class HomePage extends StatefulWidget {
  static const pageRoute = '/home-screen';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppWriteProvider appWriteProvider = AppWriteProvider();
  final GetStorage storage = GetStorage();
  bool isInit = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<AppWriteProvider>(context, listen: false)
          .loadVideos()
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }

    isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    //Get the device Size
    final mediaQuery = MediaQuery.of(context).size;
    //Gett the server data
    final employeeData = Provider.of<AppWriteProvider>(context, listen: false);
    final employee = employeeData.employee;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              appWriteProvider.logout(storage.read('sessionId'));
              storage.erase();
              Navigator.of(context).pushReplacementNamed(LoginPage.pageRoute);
            },
            child: const Icon(
              Icons.logout,
            ),
          ),
          const SizedBox(width: 20.0),
        ],
      ),
      body: ListView.builder(
          itemCount: employee.length,
          itemBuilder: (context, index) {
            if (isLoading) return CircularProgressIndicator();
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.network(
                            '${AppwriteConstants.endPoint}/storage/buckets/${AppwriteConstants.employeeBucketID}/files/${employee[index].image}/view?project=${AppwriteConstants.projectID}',
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(employee[index].name),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => EditEmployeePage(
                                employee: employee[index],
                                callbak: (value) {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  Future.delayed(const Duration(seconds: 2))
                                      .then((value) {
                                    appWriteProvider.loadVideos().then((value) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    });
                                  });
                                },
                              ),
                              transition: Transition.rightToLeftWithFade,
                            );
                          },
                          child: Icon(Icons.edit),
                        ),
                        const SizedBox(width: 40),
                        GestureDetector(
                          onTap: () async {
                            await appWriteProvider.deleteEmployee(
                              {
                                'documentId': employee[index].documentId,
                              },
                            ).then((value) async {
                              await appWriteProvider
                                  .deleteEmployeeImage(employee[index].image);
                              setState(() {
                                isInit = true;
                              });
                            });
                          },
                          child: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Get.to(
            () => AddEmployeePage(),
            transition: Transition.rightToLeftWithFade,
          );
        },
        child: Icon(Icons.add),
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
