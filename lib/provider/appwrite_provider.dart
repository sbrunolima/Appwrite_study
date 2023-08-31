import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//Utils
import '../utils/appwrite_constant.dart';
import '../models/employee_moodel.dart';

class AppWriteProvider with ChangeNotifier {
  List<Employee> _employee = [];

  List<Employee> get employee {
    return [..._employee];
  }

  Client client = Client();

  //Create instances ACCOUNT, STORAGE, DATABASE
  Account? account;
  Storage? storage;
  Databases? databases;

  AppWriteProvider() {
    client
        .setEndpoint(AppwriteConstants.endPoint)
        .setProject(AppwriteConstants.projectID)
        .setSelfSigned(status: true);

    account = Account(client);
    storage = Storage(client);
    databases = Databases(client);
  }

  //Cria o usuario
  Future<models.Account> signup(Map map) async {
    final response = account!.create(
      userId: map['userId'],
      email: map['email'],
      password: map['password'],
      name: map['name'],
    );

    return response;
  }

  //Login usuario
  Future<models.Session> login(Map map) async {
    final response = account!.createEmailSession(
      email: map['email'],
      password: map['password'],
    );

    print('MESSAGE ${response}');

    return response;
  }

  //Logout usuario
  Future<dynamic> logout(String sessionId) async {
    final response = account!.deleteSession(
      sessionId: sessionId,
    );

    return response;
  }

  //ADD Files
  Future<models.File> uploadEmployeeImage(String imagePath) async {
    String fileName =
        '${DateTime.now().millisecondsSinceEpoch}.${imagePath.split(".").last}';

    final response = storage!.createFile(
      bucketId: AppwriteConstants.employeeBucketID,
      fileId: ID.unique(),
      file: InputFile(path: imagePath, filename: fileName),
    );

    return response;
  }

  //Delete Files
  Future<dynamic> deleteEmployeeImage(String fileId) async {
    final response = storage!.deleteFile(
      bucketId: AppwriteConstants.employeeBucketID,
      fileId: fileId,
    );

    return response;
  }

  //Create a Database
  Future<models.Document> createEmployee(Map map) async {
    final response = databases!.createDocument(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.employeeCollectionID,
      documentId: ID.unique(),
      data: {
        "name": map["name"],
        "department": map["department"],
        "createdBy": map["createdBy"],
        "image": map["image"],
        "createdAt": map["createdAt"],
      },
    );

    return response;
  }

  //Get employees
  Future<models.DocumentList> getEmployees() async {
    final response = databases!.listDocuments(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.employeeCollectionID,
    );

    print('response $response');

    return response;
  }

  //Update employee
  Future<models.Document> updateEmployee(Map map) async {
    final response = databases!.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.employeeCollectionID,
        documentId: map['documentId'],
        data: {
          "name": map["name"],
          "department": map["department"],
          "createdBy": map["createdBy"],
          "image": map["image"],
        });

    return response;
  }

  //Delete employee
  Future<dynamic> deleteEmployee(Map map) async {
    final response = databases!.deleteDocument(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.employeeCollectionID,
      documentId: map['documentId'],
    );

    print('deleted');

    return response;
  }

  Future<void> loadVideos() async {
    print('response => ${1}');

    try {
      List<Employee> loadedVideos = [];
      await getEmployees().then((value) {
        Map<String, dynamic> data = value.toMap();
        List d = data['documents'].toList();

        //print('response => ${d}');

        loadedVideos = d
            .map(
              (e) => Employee.formMap(e['data']),
            )
            .toList();

        _employee = loadedVideos.toList();

        notifyListeners();
      });
    } catch (error) {
      print('ERRO $error');
    }
  }
}
