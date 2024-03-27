import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import 'package:autism_mobile_app/presentation/widgets/app_drawer.dart';
import 'package:autism_mobile_app/presentation/widgets/reusable_list_tile.dart';
import 'package:autism_mobile_app/domain/models/profile_models/child_profile.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/presentation/cubits/task_cubits/internal_task_cubits/cubit/internal_task_cubit.dart';
import 'package:autism_mobile_app/presentation/views/family_views/reports/center_home_tasks_report/internal_task_report/internal_tasks_report.dart';

class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  late ChildProfile childProfile;
  final ChildAccount childAccount = ChildAccount();

  @override
  void didChangeDependencies() {
    childProfile = ModalRoute.of(context)?.settings.arguments as ChildProfile;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'التقارير',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
            fontFamily: 'Mirza',
          ),
        ),
      ),
      endDrawer: AppDrawer(isChild: ChildAccount().getIsChild(), width: width),
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/background1.PNG'),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ReUsableListTile(
                title: 'تقرير الخطة',
                icon: Icons.bookmark,
                onTap: () {
                  Navigator.of(context).pushNamed('/plan-report-screen');
                },
              ),
              ReUsableListTile(
                title: 'تقرير الاحتياجات',
                icon: Icons.bookmark,
                onTap: () {
                  Navigator.of(context)
                      .pushNamed('/need-expression-report-screen', arguments: {
                    'accountId': childAccount.accountId,
                    'childNeedLevel':
                        childProfile.childInformation.childNeedLevel,
                  });
                },
              ),
              ReUsableListTile(
                title: 'تقارير المهام في المركز',
                icon: Icons.bookmark,
                onTap: () {
                  Navigator.of(context)
                      .pushNamed('/center-tasks-report-screen');
                },
              ),
              ReUsableListTile(
                title: 'تقرير المهام المنزلية',
                icon: Icons.bookmark,
                onTap: () {
                  Navigator.of(context).push(PageTransition(
                    child: BlocProvider<InternalTaskCubit>(
                      create: (context) => InternalTaskCubit(),
                      child: const InternalTasksReport(taskPlace: 'home-task'),
                    ),
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 500),
                  ));
                },
              ),
              ReUsableListTile(
                title: 'تقرير تمارين الوقت',
                icon: Icons.bookmark,
                onTap: () {
                  Navigator.of(context)
                      .pushNamed('/time-exercise-report-screen');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
