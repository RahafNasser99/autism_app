import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import 'package:autism_mobile_app/presentation/widgets/app_drawer.dart';
import 'package:autism_mobile_app/presentation/widgets/reusable_list_tile.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/presentation/cubits/task_cubits/external_task_cubits/cubit/external_task_cubit.dart';
import 'package:autism_mobile_app/presentation/cubits/task_cubits/internal_task_cubits/cubit/internal_task_cubit.dart';
import 'package:autism_mobile_app/presentation/views/family_views/reports/center_home_tasks_report/external_task_report/external_tasks_report.dart';
import 'package:autism_mobile_app/presentation/views/family_views/reports/center_home_tasks_report/internal_task_report/internal_tasks_report.dart';

class CenterTasksReport extends StatelessWidget {
  const CenterTasksReport({Key? key}) : super(key: key);

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
          'تقارير المهام في المركز',
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
                title: 'المهام داخل التطبيق',
                icon: Icons.bookmark,
                onTap: () {
                  Navigator.of(context).push(PageTransition(
                    child: BlocProvider<InternalTaskCubit>(
                      create: (context) => InternalTaskCubit(),
                      child:
                          const InternalTasksReport(taskPlace: 'center-task'),
                    ),
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 500),
                  ));
                },
              ),
              ReUsableListTile(
                title: 'المهام خارج التطبيق',
                icon: Icons.bookmark,
                onTap: () {
                  Navigator.of(context).push(PageTransition(
                    child: BlocProvider<ExternalTaskCubit>(
                      create: (context) => ExternalTaskCubit(),
                      child:
                          const ExternalTasksReport(taskPlace: 'center-task'),
                    ),
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 500),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
