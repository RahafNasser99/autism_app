import 'package:flutter/material.dart';

import 'package:autism_mobile_app/presentation/widgets/app_drawer.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/presentation/views/shared_views/empty_content.dart';

class ErrorLoginScreen extends StatelessWidget {
  const ErrorLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child:
                Image.asset('assets/images/aamalLogo.png', fit: BoxFit.contain),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'آمال',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontFamily: 'Marhey',
            fontSize: 25,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      resizeToAvoidBottomInset: false,
      endDrawer: AppDrawer(
        isChild: ChildAccount().getIsChild(),
        width: width,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: EmptyContent(
            text: 'حدث خطأ أثناء تسجيل الدخول الرجاء المحاولة مرة أخرى',
            width: width),
      ),
    );
  }
}
