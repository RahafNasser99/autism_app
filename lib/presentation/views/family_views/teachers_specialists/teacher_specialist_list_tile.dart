import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:page_transition/page_transition.dart';

import 'package:autism_mobile_app/presentation/views/family_views/mail/add_mail.dart';
import 'package:autism_mobile_app/presentation/cubits/mails_cubits/cubit/send_mail_cubit.dart';
import 'package:autism_mobile_app/domain/models/account_models/teacher_specialist_account.dart';
import 'package:autism_mobile_app/presentation/views/family_views/teachers_specialists/teacher_specialist_profile.dart';

class TeacherSpecialistListTile extends StatelessWidget {
  const TeacherSpecialistListTile({
    Key? key,
    required this.teacherSpecialistAccount,
  }) : super(key: key);

  final TeacherSpecialistAccount teacherSpecialistAccount;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing:
          teacherSpecialistAccount.teacherSpecialistProfile.profilePicture !=
                  null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(teacherSpecialistAccount
                      .teacherSpecialistProfile.profilePicture!))
              : const CircleAvatar(child: Icon(Icons.person)),
      title: AutoSizeText(
        teacherSpecialistAccount.teacherSpecialistProfile.getFullName(),
        style: const TextStyle(
          fontSize: 20,
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.end,
      ),
      leading: ElevatedButton.icon(
        label: const Text(
          'مراسلة',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        icon: Transform.rotate(
            angle: -45,
            child: const Icon(
              Icons.send_rounded,
              size: 15,
            )),
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
      ),
      contentPadding: const EdgeInsets.all(10.0),
      onTap: () {
        Navigator.of(context).push(
          PageTransition(
            child: TeacherSpecialistProfile(
              teacherSpecialistAccount: teacherSpecialistAccount,
            ),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 500),
          ),
        );
      },
    );
  }
}
