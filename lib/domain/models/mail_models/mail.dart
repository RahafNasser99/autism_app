import 'dart:convert';

import 'package:autism_mobile_app/utils/date/date.dart';
import 'package:autism_mobile_app/utils/date/time.dart';

MailModel mailFromJson(String str) => MailModel.fromJson(json.decode(str));

class MailModel {
  final String id;
  final Account senderAccount;
  final Account receiverAccount;
  final String? subject;
  final String content;
  final DateTime date;
  final String time;
  final bool isRead;

  MailModel({
    required this.id,
    required this.senderAccount,
    required this.receiverAccount,
    required this.subject,
    required this.content,
    required this.date,
    required this.time,
    required this.isRead,
  });

  String getDate() {
    return '${date.year}/${date.month}/${date.day}';
  }

  factory MailModel.fromJson(Map<String, dynamic> json) => MailModel(
        id: json['id'],
        senderAccount: Account.fromJson(json['sender']),
        receiverAccount: Account.fromJson(json['receiver']),
        subject: json['subject'],
        content: json['content'],
        date: Date(
                comingDate: json['createdAt']
                    .substring(0, json['createdAt'].indexOf('T')))
            .handleDate(),
        time: Time(
                comingDuration: 0,
                comingTime: json['createdAt'].substring(
                    json['createdAt'].indexOf('T') + 1,
                    json['createdAt'].indexOf('.')))
            .handleTimeDisplay(),
        isRead: json['isRead'],
      );

  @override
  String toString() {
    return 'Mail ( \n'
        'id: $id, \n'
        'senderAccount: ${senderAccount.toString()}, \n'
        'receiverAccount: ${receiverAccount.toString()}, \n'
        'subject: $subject, \n'
        'content: $content, \n'
        'date: $date, \n'
        'isRead: $isRead)';
  }
}

Account accountFromJson(String str) => Account.fromJson(json.decode(str));

class Account {
  final int id;
  final String userName;
  final String email;
  final String accountType;

  Account({
    required this.id,
    required this.userName,
    required this.email,
    required this.accountType,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
      id: json['id'],
      userName: json['userName'],
      email: json['email'],
      accountType: json['accountType']);

  @override
  String toString() {
    return 'Account (\n'
        'id: $id, \n'
        'userName: $userName, \n'
        'email: $email, \n'
        'accountType: $accountType\n'
        ')';
  }
}
