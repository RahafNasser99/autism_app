import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/presentation/views/shared_views/empty_content.dart';
import 'package:autism_mobile_app/presentation/widgets/reusable_elevated_button.dart';
import 'package:autism_mobile_app/domain/models/need_expression_models/need_expression.dart';
import 'package:autism_mobile_app/presentation/views/family_views/reports/needs_report/need_expression_widget.dart';
import 'package:autism_mobile_app/presentation/cubits/needs_expression_cubits/cubit/need_expression_report_cubit.dart';

class NeedExpressionReport extends StatefulWidget {
  const NeedExpressionReport({Key? key}) : super(key: key);

  @override
  State<NeedExpressionReport> createState() => _NeedExpressionReportState();
}

class _NeedExpressionReportState extends State<NeedExpressionReport> {
  bool _achievedNeeds = false;
  late int accountId;
  late int childNeedLevel;
  bool _isInit = true;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      var data =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      accountId = data['accountId'];
      childNeedLevel = data['childNeedLevel'];

      await BlocProvider.of<NeedExpressionReportCubit>(context)
          .getNeedExpressionReport('false');

      _isInit = false;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> getAchievedNeeds() async {
    await BlocProvider.of<NeedExpressionReportCubit>(context)
        .getNeedExpressionReport('true');
  }

  Future<void> getUnAchievedNeeds() async {
    await BlocProvider.of<NeedExpressionReportCubit>(context)
        .getNeedExpressionReport('false');
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'تقرير الاحتياجات',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
            fontFamily: 'Mirza',
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ReUsableElevatedButton(
                    width: width,
                    title: 'محققة',
                    mark: _achievedNeeds,
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(5.0), right: Radius.zero),
                    onPressed: () {
                      if (_achievedNeeds) {
                        return;
                      } else {
                        setState(() {
                          _achievedNeeds = true;
                        });
                        getAchievedNeeds();
                      }
                    }),
                ReUsableElevatedButton(
                  width: width,
                  title: 'غير محققة',
                  mark: !_achievedNeeds,
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.zero, right: Radius.circular(5.0)),
                  onPressed: () {
                    if (!_achievedNeeds) {
                      return;
                    } else {
                      setState(() {
                        _achievedNeeds = false;
                      });
                      getUnAchievedNeeds();
                    }
                  },
                ),
              ],
            ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                margin:
                    const EdgeInsets.only(top: 10.0, left: 12.0, right: 12.0),
                height: 1.5 * height / 2,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3.0,
                        spreadRadius: 2.0),
                  ],
                ),
                child: BlocConsumer<NeedExpressionReportCubit,
                    NeedExpressionReportState>(
                  listener: (context, state) {
                    if (state is NeedExpressionReportFailed) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => ShowDialog(
                          dialogMessage: state.failedMessage,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    } else if (state is NeedExpressionReportError) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
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
                    if (state is NeedExpressionReportLoading) {
                      return const Loading();
                    } else if (state is NeedExpressionReportIsEmpty) {
                      return EmptyContent(
                          text: 'سجل الاحتياجات فارغ', width: width);
                    } else if (state is NeedExpressionReportDone) {
                      List<NeedExpression> needsExpression =
                          state.needsExpression;
                      return ListView.builder(
                          controller: context
                              .read<NeedExpressionReportCubit>()
                              .scrollController,
                          physics: const ScrollPhysics(),
                          itemCount: context
                                  .read<NeedExpressionReportCubit>()
                                  .isLoadingMore
                              ? needsExpression.length + 1
                              : needsExpression.length,
                          itemBuilder: (context, index) {
                            if (index >= needsExpression.length) {
                              return SpinKitThreeInOut(itemBuilder:
                                  (BuildContext context, int index) {
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index.isEven
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                );
                              });
                            } else {
                              return NeedExpressionWidget(
                                width: width,
                                childNeedLevel: childNeedLevel,
                                needExpression: needsExpression[index],
                                refreshUnAchievedNeeds: getUnAchievedNeeds,
                              );
                            }
                          });
                    } else {
                      return const Column();
                    }
                  },
                ))
          ],
        ),
      ),
    );
  }
}
