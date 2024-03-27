import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/app_drawer.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/presentation/views/shared_views/empty_content.dart';
import 'package:autism_mobile_app/presentation/cubits/pep_3_cubits/cubit/pep_3_cubit.dart';
import 'package:autism_mobile_app/presentation/cubits/pep_3_cubits/cubit/pep_3_tests_cubit.dart';
import 'package:autism_mobile_app/presentation/views/family_views/pep_3/pep_3_result_screen.dart';

class Pep3List extends StatefulWidget {
  const Pep3List({super.key});

  @override
  State<Pep3List> createState() => _Pep3ListState();
}

class _Pep3ListState extends State<Pep3List> {
  bool _isInit = true;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      await BlocProvider.of<Pep3TestsCubit>(context).getChildPep3Tests();
      _isInit = false;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget _pep3Test(String testName, DateTime testDate, void Function()? onTap) {
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
          testName,
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
        ),
        subtitle: Text(
          testDate.year.toString() +
              '/' +
              testDate.month.toString() +
              '/' +
              testDate.day.toString(),
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
          'اختبارات العمر النمائي',
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
        child: BlocConsumer<Pep3TestsCubit, Pep3TestsState>(
          listener: (context, state) {
            if (state is Pep3TestsFailed) {
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
            if (state is Pep3TestsError) {
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
            if (state is Pep3TestsLoading) {
              return const Loading();
            } else if (state is Pep3TestsEmpty) {
              return EmptyContent(text: 'لا يوجد اختبارات للطفل', width: width);
            } else if (state is Pep3TestsDone) {
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                child: ListView.builder(
                    itemCount: state.pep3ListsForChild.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) => _pep3Test(
                          state.pep3ListsForChild[index].pep3Name,
                          state.pep3ListsForChild[index].createdDate,
                          () {
                            Navigator.of(context).push(
                              PageTransition(
                                child: BlocProvider<Pep3Cubit>(
                                  create: (context) => Pep3Cubit(),
                                  child: Pep3ResultScreen(
                                    pep3TestId: state
                                        .pep3ListsForChild[index].pep3TestId,
                                    planId:
                                        state.pep3ListsForChild[index].planId,
                                    planName:
                                        state.pep3ListsForChild[index].planName,
                                  ),
                                ),
                                type: PageTransitionType.rightToLeft,
                                duration: const Duration(milliseconds: 500),
                              ),
                            );
                          },
                        )),
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
