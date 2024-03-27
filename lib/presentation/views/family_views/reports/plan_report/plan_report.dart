import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/app_drawer.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/presentation/widgets/reusable_list_tile.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/presentation/cubits/plan_cubits/cubit/plan_report_cubit.dart';
import 'package:autism_mobile_app/presentation/cubits/plan_cubits/cubit/plan_domains_cubit.dart';
import 'package:autism_mobile_app/presentation/views/family_views/reports/plan_report/domain_plan_report.dart';

class PlanReport extends StatefulWidget {
  const PlanReport({super.key});

  @override
  State<PlanReport> createState() => _PlanReportState();
}

class _PlanReportState extends State<PlanReport> {
  bool _isInit = true;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      await BlocProvider.of<PlanDomainsCubit>(context).getDomains();
      _isInit = false;
    }
    _isInit = false;
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
          'تقارير الخطة الحالية',
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
        child: BlocConsumer<PlanDomainsCubit, PlanDomainsState>(
          listener: (context, state) {
            if (state is PlanDomainsFailed) {
              showDialog(
                context: context,
                builder: (context) => ShowDialog(
                  dialogMessage: state.failedMessage,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              );
            }
            if (state is PlanDomainsError) {
              showDialog(
                context: context,
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
            if (state is PlanDomainsLoading) {
              return const Loading();
            } else if (state is PlanDomainsDone) {
              return ListView.builder(
                  itemCount: state.domains.length,
                  itemBuilder: (context, index) => ReUsableListTile(
                      title: state.domains[index].domainName,
                      icon: Icons.list_alt_rounded,
                      onTap: () {
                        Navigator.of(context).push(
                          PageTransition(
                            child: BlocProvider<PlanReportCubit>(
                              create: (context) => PlanReportCubit(),
                              child: DomainPlanReport(
                                  domain: state.domains[index]),
                            ),
                            type: PageTransitionType.rightToLeft,
                            duration: const Duration(milliseconds: 500),
                          ),
                        );
                      }));
            } else {
              return const Column();
            }
          },
        ),
      ),
    );
  }
}
