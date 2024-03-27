import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:autism_mobile_app/presentation/cubits/update_password_cubits/cubit/update_password_cubit.dart';

class UpdatePasswords extends StatefulWidget {
  const UpdatePasswords({Key? key}) : super(key: key);

  @override
  State<UpdatePasswords> createState() => _UpdatePasswordsState();
}

class _UpdatePasswordsState extends State<UpdatePasswords> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _passwordVisibility = false;
  bool _updateChildPassword = false;
  bool _updateFamilyPassword = false;
  String _oldPassword = '';
  String _newPassword1 = '';
  String _newPassword2 = '';
  late bool _childPassword;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    try {
      setState(() {
        _passwordVisibility = false;
        _updateChildPassword = false;
        _updateFamilyPassword = false;
      });
      await BlocProvider.of<UpdatePasswordCubit>(context)
          .updatePassword(_oldPassword, _newPassword2, _childPassword);
    } catch (error) {
      _oldPassword = '';
      _newPassword1 = '';
      _newPassword2 = '';
      _childPassword = false;
      _passwordVisibility = false;
      _updateChildPassword = false;
      _updateFamilyPassword = false;
    }
  }

  Widget _passwordTextFormField(
      int mark,
      String hintText,
      String? Function(String? password) validator,
      void Function(String? password) onSaved) {
    return TextFormField(
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        hintText: hintText,
        contentPadding: const EdgeInsets.only(left: 10.0, top: 10.0),
        prefixIcon: InkWell(
          child: Icon(
              _passwordVisibility ? Icons.visibility : Icons.visibility_off),
          onTap: () {
            setState(() {
              _passwordVisibility = !_passwordVisibility;
            });
          },
        ),
      ),
      style: const TextStyle(fontSize: 20),
      textInputAction: TextInputAction.next,
      obscureText: _passwordVisibility ? false : true,
      onChanged: (password) {
        if (mark == 1) {
          _oldPassword = password;
        } else if (mark == 2) {
          _newPassword1 = password;
        } else if (mark == 3) {
          _newPassword2 = password;
        }
      },
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _viewChangePasswordWidgets(int value) {
    return Visibility(
        // 1 is meaning we are updating child password
        visible: value == 1 ? _updateChildPassword : _updateFamilyPassword,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 1.5,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                const AutoSizeText(
                  'كلمة المرور الحالية',
                  style: TextStyle(fontSize: 22),
                ),
                _passwordTextFormField(1, 'ادخل كلمة المرور الحالية',
                    (password) {
                  if (password!.isEmpty) {
                    return 'لا يمكن أن تترك هذا الحقل فارغ';
                  }
                  return null;
                }, (password) {
                  _oldPassword = password!;
                }),
                const SizedBox(
                  height: 10,
                ),
                const AutoSizeText(
                  'كلمة المرور الجديدة',
                  style: TextStyle(fontSize: 22),
                ),
                _passwordTextFormField(2, 'ادخل كلمة المرور الجديدة',
                    (password) {
                  if (password!.isEmpty) {
                    return 'لا يمكن أن تترك هذا الحقل فارغ';
                  } else if (_newPassword2.isNotEmpty &&
                      _newPassword1 != _newPassword2) {
                    return 'كلمة المرور غير متطابقة';
                  }
                  return null;
                }, (password) {
                  _newPassword1 = password!;
                }),
                const SizedBox(
                  height: 10,
                ),
                const AutoSizeText(
                  'تأكيد المرور الجديدة',
                  style: TextStyle(fontSize: 22),
                ),
                _passwordTextFormField(3, 'ادخل كلمة المرور الجديدة',
                    (password) {
                  if (password!.isEmpty) {
                    return 'لا يمكن أن تترك هذا الحقل فارغ';
                  } else if (_newPassword1.isNotEmpty &&
                      _newPassword1 != _newPassword2) {
                    return 'كلمة المرور غير متطابقة';
                  }
                  return null;
                }, (password) {
                  _newPassword2 = password!;
                }),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text(
                    'تأكيد',
                    style: TextStyle(color: Colors.blue, fontSize: 22),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(top: 10.0),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.blue)),
                  ),
                  onPressed: () {
                    if (value == 1) {
                      _childPassword = true;
                    } else {
                      _childPassword = false;
                    }
                    _submit();
                  },
                ),
              ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdatePasswordCubit, UpdatePasswordState>(
      listener: (context, state) {
        if (state is UpdatePasswordFailed) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => ShowDialog(
                dialogMessage: state.failedMessage,
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          );
        } else if (state is UpdatePasswordError) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => ShowDialog(
                dialogMessage: state.errorMessage,
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          );
        } else if (state is UpdatePasswordDone) {
          Fluttertoast.showToast(
            msg: state.doneMessage,
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue[300],
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 2.0,
            centerTitle: true,
            title: const Text(
              'الخصوصية والأمان',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                fontFamily: 'Mirza',
              ),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                      child: ListTile(
                        title: const AutoSizeText(
                          'تعديل كلمة مرور حساب الطفل',
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 20),
                        ),
                        trailing: const Icon(
                          Icons.manage_accounts_rounded,
                          size: 30,
                          color: Colors.blue,
                        ),
                        leading: _updateChildPassword
                            ? const Icon(Icons.keyboard_arrow_up_rounded)
                            : const Icon(Icons.keyboard_arrow_down_rounded),
                        onTap: () {
                          setState(() {
                            _updateChildPassword = !_updateChildPassword;
                          });
                        },
                      ),
                    ),
                    _viewChangePasswordWidgets(1),
                    SizedBox(
                      height: 50,
                      child: ListTile(
                        title: const AutoSizeText(
                          'تعديل كلمة مرور حساب الآباء',
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 20),
                        ),
                        trailing: const Icon(
                          Icons.manage_accounts_rounded,
                          size: 30,
                          color: Colors.green,
                        ),
                        leading: _updateFamilyPassword
                            ? const Icon(Icons.keyboard_arrow_up_rounded)
                            : const Icon(Icons.keyboard_arrow_down_rounded),
                        onTap: () {
                          setState(() {
                            _updateFamilyPassword = !_updateFamilyPassword;
                          });
                        },
                      ),
                    ),
                    _viewChangePasswordWidgets(2),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
