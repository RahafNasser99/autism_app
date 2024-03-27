import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/presentation/cubits/login_cubits/login_cubit.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _passwordVisibility = false;
  var childAccountJson = {
    'email': '',
    'password': '',
  };

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    try {
      await BlocProvider.of<LoginCubit>(context).login(
          childAccountJson['email'].toString(),
          childAccountJson['password'].toString());
    } catch (error) {
      childAccountJson['password'] = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
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
            Navigator.of(context)
                .pushReplacementNamed('/child-home-page-screen');
          }
        },
        builder: (context, state) {
          if (state is LoginLoading) {
            return const Loading();
          } else {
            return SingleChildScrollView(
              child: Container(
                height: height,
                padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage('assets/images/backgrounds/background1.PNG'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: height / 6),
                      const Text(
                        'تسجيل دخول',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Marhey',
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'مرحباً بك في عالم آمال',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 23,
                          fontFamily: 'Marhey',
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'البريد الالكتروني أو اسم المستخدم',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 22),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          hintText: 'example@aamal.com',
                          hintStyle: TextStyle(
                            fontSize: 22,
                            fontFamily: 'Mirza',
                          ),
                          contentPadding:
                              EdgeInsets.only(left: 10.0, top: 10.0),
                        ),
                        style: const TextStyle(fontSize: 20),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: (email) {
                          if (email!.isEmpty) {
                            return 'لا يمكن أن تترك هذا الحقل فارغ';
                          }
                          return null;
                        },
                        onSaved: (email) {
                          childAccountJson['email'] = email!;
                        },
                        onChanged: (email) {
                          childAccountJson['email'] = email;
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'كلمة المرور',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 22),
                      ),
                      TextFormField(
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          hintText: 'ادخل كلمة المرور',
                          hintStyle: const TextStyle(fontSize: 20),
                          contentPadding:
                              const EdgeInsets.only(right: 10.0, top: 10.0),
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
                        style: const TextStyle(fontSize: 20),
                        textInputAction: TextInputAction.done,
                        obscureText: _passwordVisibility ? false : true,
                        validator: (password) {
                          if (password!.isEmpty) {
                            return 'لا يمكن أن تترك هذا الحقل فارغ';
                          }
                          return null;
                        },
                        onSaved: (password) {
                          childAccountJson['password'] = password!;
                        },
                        onChanged: (password) {
                          childAccountJson['password'] = password;
                        },
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            child: const Text('تسجيل الدخول'),
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              fixedSize: Size.fromWidth(width - 20),
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
