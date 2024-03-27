import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/presentation/cubits/mails_cubits/cubit/send_mail_cubit.dart';

class AddMail extends StatefulWidget {
  const AddMail(
      {super.key, required this.receiverId, required this.receiverEmail});

  final int receiverId;
  final String receiverEmail;

  @override
  State<AddMail> createState() => _AddMailState();
}

class _AddMailState extends State<AddMail> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _subject = '';
  String _content = '';

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    BlocProvider.of<SendMailCubit>(context)
        .sendMail(widget.receiverId, _subject, _content);
  }

  Widget _textFormField(
      double height,
      String initialValue,
      TextInputType textInputType,
      TextAlign textAlign,
      String? Function(String?)? validator,
      void Function(String?)? onSaved) {
    return TextFormField(
      initialValue: initialValue,
      textAlign: textAlign,
      keyboardType: textInputType,
      maxLines: textInputType == TextInputType.multiline ? 3 : null,
      style: const TextStyle(fontSize: 17, color: Colors.black54),
      decoration: const InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(
              color: Colors.black38,
            )),
        contentPadding: EdgeInsets.all(10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _container(int mark, String text, double width, double height) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0),
      width: width,
      height: height / 17,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black38,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5.0))),
      child: AutoSizeText(
        text,
        style: TextStyle(
            color: mark == 1 ? Colors.blue : Colors.black54, fontSize: 17),
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
          'إرسال رسالة جديدة',
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
        padding: const EdgeInsets.only(
            top: 30.0, left: 12.0, right: 12.0, bottom: 12),
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
        child: BlocConsumer<SendMailCubit, SendMailState>(
          listener: (context, state) {
            if (state is SendMailDone) {
              Navigator.of(context).pop();
            }
            if (state is SendMailFailed) {
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
            if (state is SendMailError) {
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
            if (state is SendMailLoading) {
              return const Loading();
            } else {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          'المرسل',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.w600),
                        ),
                      ),
                      _container(1, ChildAccount().email!, width, height),
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          'المرسل إليه',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.w600),
                        ),
                      ),
                      _container(2, widget.receiverEmail, width, height),
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          'الموضوع',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.w600),
                        ),
                      ),
                      _textFormField(
                          height, _subject, TextInputType.text, TextAlign.right,
                          (_) {
                        return null;
                      }, (subject) {
                        _subject = subject!;
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          'المحتوى',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.w600),
                        ),
                      ),
                      _textFormField(height, _content, TextInputType.multiline,
                          TextAlign.right, (value) {
                        if (value != null && value.isEmpty) {
                          return 'لا يمكن أن تترك هذا الحقل فارغ';
                        }
                        return null;
                      }, (mail) {
                        _content = mail!;
                      }),
                      Padding(
                        padding: EdgeInsets.only(top: height / 6, right: 10.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton.icon(
                            label: const Text(
                              'إرسال',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            icon: Transform.rotate(
                                angle: -45,
                                child: const Icon(
                                  Icons.send_rounded,
                                  size: 15,
                                )),
                            onPressed: _submit,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
