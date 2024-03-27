import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/app_drawer.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/domain/models/plan_models/plans_for_child.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/presentation/views/shared_views/empty_content.dart';
import 'package:autism_mobile_app/presentation/cubits/plan_cubits/cubit/all_plans_cubit.dart';

class PlanList extends StatefulWidget {
  const PlanList({super.key});

  @override
  State<PlanList> createState() => _PlanListState();
}

class _PlanListState extends State<PlanList> {
  bool _isInit = true;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      await BlocProvider.of<AllPlansCubit>(context).getFirstPage();
      _isInit = false;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget _plan(PlansForChild plan, void Function()? onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(
            color: Colors.black26,
          )),
      child: ListTile(
        style: ListTileStyle.drawer,
        title: Text(
          plan.name,
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
        ),
        subtitle: Text(
          '${plan.date.year}/${plan.date.month}/${plan.date.day}',
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 16),
        ),
        onTap: onTap,
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
        title: const Text(
          'الخطط السابقة',
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
              fit: BoxFit.fill),
        ),
        child: BlocConsumer<AllPlansCubit, AllPlansState>(
          listener: ((context, state) {
            if (state is AllPlansFailed) {
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
            if (state is AllPlansError) {
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
          }),
          builder: (context, state) {
            if (state is AllPlansEmpty) {
              return Center(
                  child: EmptyContent(text: 'لا يوجد خطط', width: width));
            } else if (state is AllPlansLoading) {
              return const Loading();
            } else if (state is AllPlansDone) {
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                child: ListView.builder(
                    controller: context.read<AllPlansCubit>().scrollController,
                    itemCount: context.read<AllPlansCubit>().isLoadingMore
                        ? state.plans.length + 1
                        : state.plans.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index >= state.plans.length) {
                        return SpinKitThreeInOut(
                            itemBuilder: (BuildContext context, int index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index.isEven ? Colors.blue : Colors.grey,
                            ),
                          );
                        });
                      } else {
                        return _plan(
                          state.plans[index],
                          () {
                            Navigator.of(context).pushNamed(
                              '/current-plan-screen',
                              arguments: {
                                'planId': state.plans[index].id,
                                'planName': state.plans[index].name,
                              },
                            );
                          },
                        );
                      }
                    }),
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
