import 'package:autism_mobile_app/presentation/views/family_views/plan/plan_target_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/domain/models/plan_models/target.dart';
import 'package:autism_mobile_app/domain/models/pep_3_test_models/domain.dart';
import 'package:autism_mobile_app/presentation/views/shared_views/empty_content.dart';
import 'package:autism_mobile_app/presentation/cubits/plan_cubits/cubit/plan_report_cubit.dart';
import 'package:page_transition/page_transition.dart';

class DomainPlanReport extends StatefulWidget {
  const DomainPlanReport({super.key, required this.domain});

  final Domain domain;

  @override
  State<DomainPlanReport> createState() => _DomainPlanReportState();
}

class _DomainPlanReportState extends State<DomainPlanReport> {
  @override
  Future<void> didChangeDependencies() async {
    BlocProvider.of<PlanReportCubit>(context)
        .getPlanReport(widget.domain.domainId);
    super.didChangeDependencies();
  }

  Color _checkColor(Target target) {
    if (target.evaluation == 'لم يتم التقييم') {
      return Colors.grey;
    } else if (target.evaluation == 'غير محقق') {
      return Colors.red;
    } else if (target.evaluation == 'محقق بشكل جزئي') {
      return Colors.yellow[800]!;
    } else {
      return Colors.green;
    }
  }

  Widget _target(double height, Target target) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        alignment: Alignment.centerRight,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: AutoSizeText(
          target.target,
          textAlign: TextAlign.right,
          style: TextStyle(
              color: _checkColor(target),
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          PageTransition(
            child: PlanTargetDetails(target: target),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 500),
          ),
        );
      },
    );
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
        title: Text(
          widget.domain.domainName.substring(
            widget.domain.domainName.indexOf(')') + 1,
            widget.domain.domainName.length,
          ),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
            fontFamily: 'Mirza',
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(8.0),
        height: 0.9 * height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 3.0, spreadRadius: 2.0),
          ],
        ),
        child: BlocConsumer<PlanReportCubit, PlanReportState>(
          listener: (context, state) {
            if (state is PlanReportFailed) {
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
            if (state is PlanReportError) {
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
            if (state is PlanReportLoading) {
              return const Loading();
            } else if (state is PlanReportEmpty) {
              return EmptyContent(text: 'تقرير الخطة فارغ', width: width);
            } else if (state is PlanReportDone) {
              return ListView.builder(
                itemCount: state.report.length,
                itemBuilder: (context, index) =>
                    _target(1.5 * height / 2, state.report[index]),
              );
            } else {
              return const Column();
            }
          },
        ),
      ),
    );
  }
}
