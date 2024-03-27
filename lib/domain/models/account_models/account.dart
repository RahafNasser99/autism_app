abstract class Account {
  int? accountId;
  String? email;
  String? userName;
  String? accountType;

  Account({
    this.accountId,
    this.email,
    this.userName,
    this.accountType,
  });

  @override
  String toString() {
    return 'Account [ \n'
        'accountId: $accountId, \n'
        'email: $email, \n'
        'userName: $userName, \n'
        'accountType: $accountType, \n';
  }
}
