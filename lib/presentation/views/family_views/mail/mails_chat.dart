import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/domain/models/mail_models/mail.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/presentation/views/family_views/mail/add_mail.dart';
import 'package:autism_mobile_app/presentation/cubits/mails_cubits/cubit/chats_cubit.dart';
import 'package:autism_mobile_app/presentation/cubits/mails_cubits/cubit/send_mail_cubit.dart';

class MailsChat extends StatefulWidget {
  const MailsChat(
      {super.key, required this.id, required this.name, required this.email});

  final int id;
  final String name;
  final String email;

  @override
  State<MailsChat> createState() => _MailsChatState();
}

class _MailsChatState extends State<MailsChat> {
  bool _isInit = true;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      await BlocProvider.of<ChatsCubit>(context).getFirstPage(widget.id);
      _isInit = false;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget _addMail(double width, double height) {
    return Container(
      height: 0.3 * height / 4,
      width: width,
      padding: const EdgeInsets.only(bottom: 6.0),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Transform.rotate(
              angle: -45,
              child: const Icon(
                Icons.send_rounded,
                size: 20,
                color: Colors.blue,
              )),
          TextButton(
            child: const Text(
              'إنشاء رسالة جديدة',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(
                    PageTransition(
                      child: BlocProvider(
                        create: (context) => SendMailCubit(),
                        child: AddMail(
                            receiverId: widget.id, receiverEmail: widget.email),
                      ),
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 500),
                    ),
                  )
                  .whenComplete(() async =>
                      await BlocProvider.of<ChatsCubit>(context)
                          .getFirstPage(widget.id));
            },
          ),
        ],
      ),
    );
  }

  Widget _mail(double width, MailModel mail) {
    return Column(
      crossAxisAlignment: (mail.senderAccount.id == ChildAccount().accountId)
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 20),
          child: Row(
            mainAxisAlignment:
                (mail.senderAccount.id == ChildAccount().accountId)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
            children: <Widget>[
              Visibility(
                  visible:
                      ((mail.senderAccount.id != ChildAccount().accountId) &&
                          !mail.isRead),
                  child: const Icon(Icons.mark_email_unread_outlined,
                      color: Colors.green)),
              const SizedBox(
                width: 8,
              ),
              AutoSizeText(
                '${mail.getDate()}  ${mail.time}',
                style: TextStyle(
                    color:
                        ((mail.senderAccount.id != ChildAccount().accountId) &&
                                !mail.isRead)
                            ? Colors.green
                            : Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: 5.0,
              bottom: 10.0,
              left: (mail.senderAccount.id == ChildAccount().accountId)
                  ? width / 4
                  : 10.0,
              right: (mail.senderAccount.id == ChildAccount().accountId)
                  ? 10.0
                  : width / 4),
          padding: const EdgeInsets.only(
              top: 6.0, bottom: 8.0, right: 10.0, left: 20.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: (mail.senderAccount.id == ChildAccount().accountId)
                    ? Colors.grey[200]!
                    : Colors.blue[100]!),
            color: (mail.senderAccount.id == ChildAccount().accountId)
                ? Colors.grey[200]
                : Colors.blue[100],
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              AutoSizeText(
                (mail.senderAccount.id == ChildAccount().accountId)
                    ? ChildAccount().childProfile!.getFullName()
                    : widget.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: AutoSizeText(
                  'الموضوع: ' +
                      (mail.subject == null ? 'بلا عنوان' : mail.subject!),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              AutoSizeText(
                mail.content,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ],
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
        title: Text(
          widget.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            fontFamily: 'Mirza',
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: 3.18 * height / 4,
            child: BlocConsumer<ChatsCubit, ChatsState>(
              listener: (context, state) {
                if (state is ChatsFailed) {
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
                if (state is ChatsError) {
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
                if (state is ChatsLoading) {
                  return const Loading();
                } else if (state is ChatsDone) {
                  return ListView.builder(
                    itemCount: context.read<ChatsCubit>().isLoadingMore
                        ? state.mails.length + 1
                        : state.mails.length,
                    reverse: true,
                    controller: context.read<ChatsCubit>().scrollController,
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
                        return _mail(width, state.mails[index]);
                      }
                    },
                  );
                } else {
                  return const Column();
                }
              },
            ),
          ),
          _addMail(width, height),
        ],
      ),
    );
  }
}
