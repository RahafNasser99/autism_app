import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:page_transition/page_transition.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/app_drawer.dart';
import 'package:autism_mobile_app/domain/models/plan_models/target.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/presentation/views/shared_views/empty_content.dart';
import 'package:autism_mobile_app/presentation/cubits/plan_cubits/cubit/plan_target_cubit.dart';
import 'package:autism_mobile_app/presentation/views/family_views/plan/plan_target_details.dart';

class PlanTarget extends StatefulWidget {
  const PlanTarget({super.key});

  @override
  State<PlanTarget> createState() => _PlanTargetState();
}

class _PlanTargetState extends State<PlanTarget> {
  bool _done = false;
  late String planName;

  @override
  Future<void> didChangeDependencies() async {
    var data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    int planId = data['planId'];
    planName = data['planName'];
    if (planId.isNegative) {
      BlocProvider.of<PlanTargetCubit>(context).getPlanByChildId().whenComplete(
          () => Future.delayed(const Duration(milliseconds: 200))
              .whenComplete(() => setState(() {
                    _done = true;
                  })));
    } else {
      BlocProvider.of<PlanTargetCubit>(context)
          .getPlanByPlanId(planId)
          .whenComplete(() => Future.delayed(const Duration(milliseconds: 200))
              .whenComplete(() => setState(() {
                    _done = true;
                  })));
    }

    super.didChangeDependencies();
  }

  Widget _target(
      Target target, double width, double height, double top, double left) {
    return AnimatedPositioned(
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 500),
      top: _done ? top : 0.01 * height,
      left: _done ? left : 0.1 * width,
      child: GestureDetector(
        child: Container(
          width: height / 5.2, //width / 2.8,
          height: height / 5.2, //width / 2.8,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  blurRadius: 4.0, color: Colors.blue[400]!, spreadRadius: 3.0)
            ],
          ),
          child: AutoSizeText(
            target.domain.domainName.substring(
                target.domain.domainName.indexOf(")") + 1,
                target.domain.domainName.length),
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.blue),
          ),
        ),
        onTap: () {
          Navigator.of(context).push(PageTransition(
            child: PlanTargetDetails(target: target),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 500),
          ));
        },
      ),
    );
  }

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
        title: Text(
          planName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
            fontFamily: 'Mirza',
          ),
        ),
      ),
      endDrawer: AppDrawer(isChild: ChildAccount().getIsChild(), width: width),
      body: Container(
        margin: const EdgeInsets.all(8.0),
        height: 3.8 * height / 4,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 3.0,
            ),
          ],
        ),
        child: BlocConsumer<PlanTargetCubit, PlanTargetState>(
          listener: (context, state) {
            if (state is PlanTargetFailed) {
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
            if (state is PlanTargetError) {
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
            if (state is PlanTargetEmpty) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
                height: 0.9 * height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      'assets/images/backgrounds/background1.PNG',
                    ),
                  ),
                ),
                child: Center(
                    child: EmptyContent(text: 'لا يوجد خطة', width: width)),
              );
            } else if (state is PlanTargetLoading) {
              return const Loading();
            } else if (state is PlanTargetDone) {
              int leftCycle = (state.plan.targets.length ~/ 2) + 1;
              double leftCycleSize = leftCycle * (height / 5.2);
              double spaceBetweenLeftCycle = leftCycle * 46;

              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15),
                  height: (leftCycleSize + spaceBetweenLeftCycle) >
                          3.4 * (height / 4)
                      ? leftCycleSize + spaceBetweenLeftCycle
                      : 3.4 * (height / 4),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                        'assets/images/backgrounds/background1.PNG',
                      ),
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      // 1
                      state.plan.targets.isNotEmpty
                          ? _target(state.plan.targets[0], width, height,
                              0.01 * height, 0.18 * width)
                          : Container(),
                      // 2
                      state.plan.targets.length >= 2
                          ? _target(state.plan.targets[1], width, height,
                              0.18 * height, 0.5 * width)
                          : Container(),
                      // 3
                      state.plan.targets.length >= 3
                          ? _target(state.plan.targets[2], width, height,
                              0.26 * height, 0.03 * width)
                          : Container(),
                      // 4  (+26)
                      state.plan.targets.length >= 4
                          ? _target(state.plan.targets[3], width, height,
                              0.44 * height, 0.5 * width)
                          : Container(),
                      // 5
                      state.plan.targets.length >= 5
                          ? _target(state.plan.targets[4], width, height,
                              0.52 * height, 0.03 * width)
                          : Container(),
                      // 6  (+26)
                      state.plan.targets.length >= 6
                          ? _target(state.plan.targets[5], width, height,
                              0.70 * height, 0.5 * width)
                          : Container(),
                      // 7
                      state.plan.targets.length == 7
                          ? _target(state.plan.targets[6], width, height,
                              0.78 * height, 0.09 * width)
                          : Container(),
                    ],
                  ),
                ),
              );
            }
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
              height: 0.9 * height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    'assets/images/backgrounds/background1.PNG',
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
