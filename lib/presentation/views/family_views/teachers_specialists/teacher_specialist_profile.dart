import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:page_transition/page_transition.dart';

import 'package:autism_mobile_app/presentation/views/family_views/mail/add_mail.dart';
import 'package:autism_mobile_app/presentation/cubits/mails_cubits/cubit/send_mail_cubit.dart';
import 'package:autism_mobile_app/domain/models/account_models/teacher_specialist_account.dart';

class TeacherSpecialistProfile extends StatelessWidget {
  final TeacherSpecialistAccount teacherSpecialistAccount;
  const TeacherSpecialistProfile(
      {Key? key, required this.teacherSpecialistAccount})
      : super(key: key);

  Widget _listTile(String title, String value) {
    return ListTile(
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: const TextStyle(
            fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
      ),
      subtitle: AutoSizeText(
        value,
        textAlign: TextAlign.right,
        style: const TextStyle(fontSize: 20, color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'الملف الشخصي',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            fontFamily: 'Mirza',
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        height: 3.8 * (height / 4),
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 3.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: height / 4,
              padding: const EdgeInsets.only(top: 30.0),
              child: teacherSpecialistAccount
                          .teacherSpecialistProfile.profilePicture ==
                      null
                  ? CircleAvatar(
                      child: Icon(
                        Icons.person,
                        size: width / 5,
                      ),
                      radius: width / 5,
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(teacherSpecialistAccount
                          .teacherSpecialistProfile.profilePicture!),
                      radius: width / 5,
                    ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton.icon(
                  label: const Text(
                    'اتصال',
                    style: TextStyle(fontSize: 22),
                  ),
                  icon: const Icon(Icons.call),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0)),
                      fixedSize: Size.fromWidth(width / 2.5)),
                  onPressed: () async {
                    if (teacherSpecialistAccount
                            .teacherSpecialistProfile.phoneNumber !=
                        null) {
                      await launchUrl(Uri.parse(
                          'tel://${teacherSpecialistAccount.teacherSpecialistProfile.phoneNumber!}'));
                    }
                  },
                ),
                ElevatedButton.icon(
                  label: const Text(
                    'مراسلة',
                    style: TextStyle(fontSize: 22),
                  ),
                  icon: const Icon(Icons.send_rounded),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0)),
                      fixedSize: Size.fromWidth(width / 2.5)),
                  onPressed: () {
                    Navigator.of(context).push(
                      PageTransition(
                        child: BlocProvider(
                          create: (context) => SendMailCubit(),
                          child: AddMail(
                              receiverId: teacherSpecialistAccount.accountId!,
                              receiverEmail: teacherSpecialistAccount.email!),
                        ),
                        type: PageTransitionType.rightToLeft,
                        duration: const Duration(milliseconds: 500),
                      ),
                    );
                  },
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _listTile(
                      'اسم المشرف',
                      teacherSpecialistAccount.teacherSpecialistProfile
                          .getFullName(),
                    ),
                    Visibility(
                      visible: teacherSpecialistAccount
                                  .teacherSpecialistProfile.nationality ==
                              null
                          ? false
                          : true,
                      child: _listTile(
                        'الجنسية',
                        teacherSpecialistAccount
                                    .teacherSpecialistProfile.nationality ==
                                null
                            ? ' '
                            : teacherSpecialistAccount
                                .teacherSpecialistProfile.nationality!,
                      ),
                    ),
                    Visibility(
                      visible: teacherSpecialistAccount
                                  .teacherSpecialistProfile.homeAddress ==
                              null
                          ? false
                          : true,
                      child: _listTile(
                        'عنوان السكن',
                        teacherSpecialistAccount
                                    .teacherSpecialistProfile.homeAddress ==
                                null
                            ? ' '
                            : teacherSpecialistAccount
                                .teacherSpecialistProfile.homeAddress!,
                      ),
                    ),
                    _listTile(
                      'البريد الالكتروني',
                      teacherSpecialistAccount.email!,
                    ),
                    Visibility(
                      visible: teacherSpecialistAccount
                                  .teacherSpecialistProfile.phoneNumber ==
                              null
                          ? false
                          : true,
                      child: _listTile(
                        'رقم الهاتف',
                        teacherSpecialistAccount
                                    .teacherSpecialistProfile.phoneNumber ==
                                null
                            ? ' '
                            : teacherSpecialistAccount
                                .teacherSpecialistProfile.phoneNumber!,
                      ),
                    ),
                    Visibility(
                      visible: teacherSpecialistAccount
                                  .teacherSpecialistProfile.birthday ==
                              null
                          ? false
                          : true,
                      child: _listTile(
                        'تاريخ الميلاد',
                        teacherSpecialistAccount
                                    .teacherSpecialistProfile.birthday ==
                                null
                            ? ' '
                            : DateFormat.yMMMMd().format(
                                teacherSpecialistAccount
                                    .teacherSpecialistProfile.birthday!),
                      ),
                    )
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
