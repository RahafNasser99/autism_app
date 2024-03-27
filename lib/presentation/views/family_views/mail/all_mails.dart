import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/app_drawer.dart';
import 'package:autism_mobile_app/domain/models/mail_models/mails.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/presentation/views/shared_views/empty_content.dart';
import 'package:autism_mobile_app/presentation/views/family_views/mail/mails_chat.dart';
import 'package:autism_mobile_app/presentation/cubits/mails_cubits/cubit/inbox_cubit.dart';
import 'package:autism_mobile_app/presentation/cubits/mails_cubits/cubit/chats_cubit.dart';

class AllMails extends StatefulWidget {
  const AllMails({Key? key}) : super(key: key);

  @override
  State<AllMails> createState() => _AllMailsState();
}

class _AllMailsState extends State<AllMails> {
  bool _isInit = true;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      await BlocProvider.of<InboxCubit>(context).getFirstPage();
      _isInit = false;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget _mailListTile(double width, MailsModel mail) {
    return Container(
      padding: const EdgeInsets.only(top: 2.0, bottom: 4.0),
      child: ListTile(
        trailing: CircleAvatar(
          radius: width / 15,
          backgroundImage: (mail.teacherSpecialistAccount
                      .teacherSpecialistProfile.profilePicture !=
                  null)
              ? NetworkImage(mail.teacherSpecialistAccount
                  .teacherSpecialistProfile.profilePicture!)
              : null,
          child: (mail.teacherSpecialistAccount.teacherSpecialistProfile
                      .profilePicture ==
                  null)
              ? const Icon(Icons.person)
              : null,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              mail.getDate(),
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[800]),
            ),
            Row(
              children: <Widget>[
                Visibility(
                    visible: (mail.count > 0) ? true : false,
                    child: const Icon(Icons.mark_email_unread_outlined,
                        color: Colors.green)),
                const SizedBox(
                  width: 8,
                ),
                AutoSizeText(
                  mail.teacherSpecialistAccount.teacherSpecialistProfile
                      .getFullName(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context)
              .push(
                PageTransition(
                  child: BlocProvider(
                    create: (context) => ChatsCubit(),
                    child: MailsChat(
                      id: mail.teacherSpecialistAccount.accountId!,
                      name: mail
                          .teacherSpecialistAccount.teacherSpecialistProfile
                          .getFullName(),
                      email: mail.teacherSpecialistAccount.email!,
                    ),
                  ),
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 500),
                ),
              )
              .whenComplete(() async =>
                  await BlocProvider.of<InboxCubit>(context).getFirstPage());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'البريد',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            fontFamily: 'Mirza',
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      endDrawer: AppDrawer(isChild: ChildAccount().getIsChild(), width: width),
      body: BlocConsumer<InboxCubit, InboxState>(
        listener: (context, state) {
          if (state is InboxFailed) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => ShowDialog(
                dialogMessage: state.failedMessage,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            );
          }
          if (state is InboxError) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => ShowDialog(
                dialogMessage: state.errorMessage,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is InboxLoading) {
            return const Loading();
          } else if (state is InboxEmpty) {
            return Center(
                child:
                    EmptyContent(text: 'لا يوجد رسائل لعرضها', width: width));
          } else if (state is InboxDone) {
            return ListView.builder(
              itemCount: context.read<InboxCubit>().isLoadingMore
                  ? state.mails.length + 1
                  : state.mails.length,
              controller: context.read<InboxCubit>().scrollController,
              itemBuilder: (context, index) {
                if (index >= state.mails.length) {
                  return SpinKitThreeInOut(
                      itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index.isEven ? Colors.blue : Colors.grey,
                      ),
                    );
                  });
                } else {
                  return _mailListTile(width, state.mails[index]);
                }
              },
            );
          } else {
            return const Column();
          }
        },
      ),
    );
  }
}
