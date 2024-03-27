import 'package:flutter/material.dart';

import 'package:autism_mobile_app/presentation/widgets/app_drawer.dart';
import 'package:autism_mobile_app/presentation/widgets/reusable_list_tile.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';

class Plans extends StatelessWidget {
  const Plans({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          centerTitle: true,
          backgroundColor: Colors.blue,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'الخطة التربوية',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white,
              fontFamily: 'Mirza',
            ),
          ),
        ),
        endDrawer:
            AppDrawer(isChild: ChildAccount().getIsChild(), width: width),
        body: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/backgrounds/background1.PNG'),
                fit: BoxFit.fill),
          ),
          child: Column(
            children: <Widget>[
              ReUsableListTile(
                title: 'الخطة الحالية',
                icon: Icons.list_alt_rounded,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/current-plan-screen',
                    arguments: {
                      'planId': -1,
                      'planName': 'الخطة الحالية',
                    },
                  );
                },
              ),
              ReUsableListTile(
                title: 'الخطط السابقة',
                icon: Icons.list_alt_rounded,
                onTap: () {
                  Navigator.of(context).pushNamed('/all-plans-screen');
                },
              ),
            ],
          ),
        ));
  }
}
