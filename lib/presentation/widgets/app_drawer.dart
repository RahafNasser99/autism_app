import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autism_mobile_app/presentation/widgets/exchange_account.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/presentation/views/child_views/login/login.dart';
import 'package:autism_mobile_app/presentation/cubits/login_cubits/login_cubit.dart';
import 'package:autism_mobile_app/presentation/views/child_views/child_home_page.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key, required this.isChild, required this.width})
      : super(key: key);

  final bool isChild;
  final double width;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.lightBlue[50],
      child: ListView(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          ListTile(
            title: const Text(
              'آمال',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Marhey',
                fontWeight: FontWeight.w700,
                color: Colors.blue,
              ),
            ),
            onTap: () {},
          ),
          (widget.isChild)
              ? ListTile(
                  iconColor: Colors.black,
                  trailing: const Icon(Icons.supervisor_account),
                  title: const Text(
                    'تبديل الحساب',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) => BlocProvider(
                        create: (context) => LoginCubit(),
                        child: const ExchangeAccount(),
                      ),
                    );
                  },
                )
              : ListTile(
                  iconColor: Colors.black,
                  trailing: const Icon(Icons.supervisor_account),
                  title: const Text(
                    'عودة إلى حساب الطفل',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    ChildAccount().setIsAChild(true);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/child-home-page-screen',
                        (route) => route is ChildHomePage);
                  },
                ),
          ListTile(
            iconColor: Colors.red,
            trailing: const Icon(Icons.logout),
            title: const Text(
              'تسجيل الخروج',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                    'تسجيل الخروج',
                    textAlign: TextAlign.center,
                  ),
                  titleTextStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  content: const Text(
                    'هل أنت متأكد أنك تريد تسجيل الخروج',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  contentTextStyle:
                      const TextStyle(color: Colors.black, fontSize: 20),
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  actions: [
                    ElevatedButton(
                      child: const Text(
                        'الغاء',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromWidth(widget.width / 3),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      child: const Text(
                        'حسناً',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        ChildAccount().deleteInstance();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login-screen', (route) => route is Login);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromWidth(widget.width / 3),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
