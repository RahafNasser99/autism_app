import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/presentation/cubits/pep_3_cubits/cubit/pep_3_cubit.dart';
import 'package:autism_mobile_app/presentation/views/family_views/pep_3/development_age_chart.dart';
import 'package:autism_mobile_app/presentation/views/family_views/pep_3/development_age_table.dart';

class Pep3ResultScreen extends StatefulWidget {
  const Pep3ResultScreen(
      {super.key,
      required this.pep3TestId,
      required this.planId,
      required this.planName});

  final int pep3TestId;
  final int? planId;
  final String? planName;

  @override
  State<Pep3ResultScreen> createState() => _Pep3ResultScreenState();
}

class _Pep3ResultScreenState extends State<Pep3ResultScreen> {
  bool _isInit = true;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      await BlocProvider.of<Pep3Cubit>(context)
          .getPep3TestResult(widget.pep3TestId);
      _isInit = false;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'العمر النمائي',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
            fontFamily: 'Mirza',
          ),
        ),
      ),
      body: BlocConsumer<Pep3Cubit, Pep3State>(
        listener: (context, state) {
          if (state is Pep3Failed) {
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
          if (state is Pep3Error) {
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
          if (state is Pep3Loading) {
            return const Center(child: Loading());
          } else if (state is Pep3Done) {
            return SingleChildScrollView(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'مخطط العمر النمائي  ⚈',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue[700],
                    ),
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
                    child: AutoSizeText(
                      'يوضح هذا المخطط مقارنة بين العمر النمائي للطفل وعمره الحقيقي بالأشهر',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                    ),
                  ),
                  SizedBox(
                    height: height / 1.8,
                    child: DevelopmentAgeChart(pep3Test: state.pep3test),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'جدول العمر والمستوى النمائي  ⚈ ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DevelopmentAgeTable(pep3Test: state.pep3test),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Visibility(
                    visible: widget.planId == null ? false : true,
                    child: Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_outward_rounded),
                        label: const AutoSizeText(
                          'عرض خطة الاختبار',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/current-plan-screen', arguments: {
                            'planId': widget.planId,
                            'planName': widget.planName,
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const Column();
          }
        },
      ),
    );
  }
}
