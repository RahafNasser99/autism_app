// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:autism_mobile_app/presentation/widgets/family_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/presentation/cubits/login_cubits/login_cubit.dart';

class ExchangeAccount extends StatefulWidget {
  const ExchangeAccount();

  @override
  State<ExchangeAccount> createState() => _ExchangeAccountState();
}

class _ExchangeAccountState extends State<ExchangeAccount> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _passwordVisibility = false;
  String _password = '';

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    try {
      await BlocProvider.of<LoginCubit>(context).switchAccount(_password);
    } catch (error) {
      _password = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginFailed) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => ShowDialog(
                  dialogMessage: state.failedMessage,
                  onPressed: () {
                    Navigator.of(context).pop();
                  }));
        } else if (state is LoginError) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => ShowDialog(
                  dialogMessage: state.errorMessage,
                  onPressed: () {
                    Navigator.of(context).pop();
                  }));
        } else if (state is LoginDone) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/family-home-page-screen',
              (route) => route is FamilyBottomNavigationBar);
        }
      },
      builder: (context, state) {
        return Center(
          child: (state is LoginLoading)
              ? const Loading()
              : Wrap(alignment: WrapAlignment.center, children: <Widget>[
                  Form(
                    key: _formKey,
                    child: AlertDialog(
                      elevation: 8.0,
                      backgroundColor: Colors.lightBlue[50],
                      title: const Text(
                        'الرجاء إدخال كلمة المرور',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      actions: [
                        TextFormField(
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                            hintText: 'ادخل كلمة المرور',
                            hintStyle: const TextStyle(fontSize: 20),
                            contentPadding: const EdgeInsets.all(10.0),
                            prefixIcon: InkWell(
                              child: Icon(_passwordVisibility
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onTap: () {
                                setState(() {
                                  _passwordVisibility = !_passwordVisibility;
                                });
                              },
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          obscureText: _passwordVisibility ? false : true,
                          validator: (password) {
                            if (password!.isEmpty) {
                              return 'لا يمكن أن تترك هذا الحقل فارغ';
                            }
                            return null;
                          },
                          onSaved: (password) {
                            _password = password!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: ElevatedButton(
                            child: const Text(
                              'تسجيل الدخول',
                              style: TextStyle(fontSize: 18),
                            ),
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ]),
        );
      },
    );
  }
}
