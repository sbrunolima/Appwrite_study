import 'package:appwrite/models.dart' as models;

//Providers
import '../provider/appwrite_provider.dart';

class AuthRepository {
  final AppWriteProvider appWriteProvider;
  AuthRepository(this.appWriteProvider);

  Future<models.Account> signup(Map map) => appWriteProvider.signup(map);
  Future<models.Session> login(Map map) => appWriteProvider.login(map);
  Future<dynamic> logout(String sessionId) =>
      appWriteProvider.logout(sessionId);
  Future<models.File> uploadEmployeeImage(String imagePath) =>
      appWriteProvider.uploadEmployeeImage(imagePath);
  Future<dynamic> deleteEmployeeImage(String fileId) =>
      appWriteProvider.deleteEmployeeImage(fileId);
  Future<models.Document> createEmployee(Map map) =>
      appWriteProvider.createEmployee(map);
  Future<models.DocumentList> getEmployees() => appWriteProvider.getEmployees();
}
