import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  String? accessToken;
  String? childId;

  Future<bool> isLoggedIn() async {
    print('isLoggedIn');
    final storage = FlutterSecureStorage();
    final authToken = await storage.read(key: 'authToken');
    return authToken != null;
  }

  Future<void> getAuthToken() async {
    print('getAuthToken');
    final storage = FlutterSecureStorage();
    accessToken = await storage.read(key: 'authToken');
    childId = await storage.read(key: 'childId');
  }

  Future<void> clearAuthToken() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'authToken');
    await storage.delete(key: 'childId');
  }

  void setAccountAccessToken() {
    ChildAccount().setAccessToken(accessToken!);
    ChildAccount().setChildId(int.parse(childId!));
    ChildAccount().setIsAChild(true);
    print(ChildAccount().accessToken);
  }
}
