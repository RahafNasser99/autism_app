import 'package:autism_mobile_app/auth_service.dart';
import 'package:autism_mobile_app/domain/models/account_models/account.dart';
import 'package:autism_mobile_app/domain/models/profile_models/child_profile.dart';
import 'package:autism_mobile_app/domain/models/time_learning_models/waiting_time.dart';

class ChildAccount extends Account {
  static final ChildAccount _instance = ChildAccount._internal();
  String? accessToken;
  String? password;
  bool isAChild = false;
  ChildProfile? childProfile;

  factory ChildAccount() {
    return _instance;
  }

  ChildAccount._internal();

  void setAccessToken(String accessToken) {
    this.accessToken = accessToken;
  }

  String getAccessToken() {
    if (accessToken == null) return '';
    return accessToken!;
  }

  void setChildId(int childId) {
    accountId = childId;
  }

  void setChildProfile(ChildProfile childProfile) {
    this.childProfile = childProfile;
  }

  void setIsAChild(bool isAChild) {
    this.isAChild = isAChild;
  }

  bool getIsChild() => isAChild;

  void setAccountData(Map<String, dynamic> json) {
    // accountId = json['id'];
    email = json['email'];
    userName = json['userName'];
    accountType = json['accountType'];
  }

  Future<void> deleteInstance() async {
    accessToken = null;
    accountId = null;
    email = null;
    password = null;
    userName = null;
    accountType = null;
    WaitingTime.deleteWaitingTime();
    await AuthService().clearAuthToken();
  }

  @override
  String toString() {
    return super.toString() +
        'ChildAccount (\n'
            'accessToken: $accessToken, \n'
            'password: $password, \n'
            'isAChild: $isAChild, \n'
            ') \n' +
        ']';
  }
}
