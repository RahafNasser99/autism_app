import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import 'package:autism_mobile_app/presentation/widgets/app_drawer.dart';
import 'package:autism_mobile_app/presentation/widgets/reusable_list_tile.dart';
import 'package:autism_mobile_app/domain/models/profile_models/child_profile.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/presentation/cubits/task_cubits/external_task_cubits/cubit/external_task_cubit.dart';
import 'package:autism_mobile_app/presentation/views/family_views/reports/center_home_tasks_report/external_task_report/external_tasks_report.dart';

class FamilyHomePage extends StatefulWidget {
  const FamilyHomePage({Key? key, required this.childProfile})
      : super(key: key);

  final ChildProfile childProfile;

  @override
  State<FamilyHomePage> createState() => _FamilyHomePageState();
}

class _FamilyHomePageState extends State<FamilyHomePage> {
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
      endDrawer: AppDrawer(isChild: ChildAccount().getIsChild(), width: width),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ReUsableListTile(
              title: 'الاحتياجات',
              icon: Icons.sentiment_very_dissatisfied,
              onTap: () {
                Navigator.of(context)
                    .pushNamed('/child-needs-screen', arguments: {
                  'childNeedLevel':
                      widget.childProfile.childInformation.childNeedLevel,
                });
              },
            ),
            ReUsableListTile(
              title: 'العمر النمائي للطفل',
              icon: Icons.sentiment_very_satisfied_rounded,
              onTap: () {
                Navigator.of(context).pushNamed('/pep-3-list-screen');
              },
            ),
            ReUsableListTile(
              title: 'الخطة التربوية',
              icon: Icons.list_alt_rounded,
              onTap: () {
                Navigator.of(context).pushNamed('/plan-screen');
              },
            ),
            ReUsableListTile(
              title: 'البرنامج المنزلي',
              icon: Icons.receipt_long,
              onTap: () {
                Navigator.of(context).pushNamed('/daily-program-screen');
              },
            ),
            ReUsableListTile(
              title: 'الواجبات المنزلية',
              icon: Icons.menu_book_rounded,
              onTap: () {
                Navigator.of(context).push(PageTransition(
                  child: BlocProvider<ExternalTaskCubit>(
                    create: (context) => ExternalTaskCubit(),
                    child: const ExternalTasksReport(taskPlace: 'home-task'),
                  ),
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 500),
                ));
              },
            ),
            ReUsableListTile(
              title: 'الملاحظات',
              icon: Icons.note_rounded,
              onTap: () {
                Navigator.of(context).pushNamed('/notes-screen');
              },
            ),
            ReUsableListTile(
              title: 'المشرفين',
              icon: Icons.groups_2_rounded,
              onTap: () {
                Navigator.of(context)
                    .pushNamed('/teachers-specialists-list-screen');
              },
            ),
            ReUsableListTile(
              title: 'التقارير',
              icon: Icons.summarize_rounded,
              onTap: () {
                Navigator.of(context).pushNamed('/reports-screen',
                    arguments: widget.childProfile);
              },
            ),
          ],
        ),
      ),
    );
  }
}
