import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/presentation/views/shared_views/empty_content.dart';
import 'package:autism_mobile_app/domain/models/need_expression_models/need_expression.dart';
import 'package:autism_mobile_app/presentation/views/family_views/child_needs/child_need_widget.dart';
import 'package:autism_mobile_app/presentation/cubits/needs_expression_cubits/cubit/need_expression_handle_cubit.dart';
import 'package:autism_mobile_app/presentation/cubits/needs_expression_cubits/cubit/need_expression_report_cubit.dart';

class ChildNeeds extends StatefulWidget {
  const ChildNeeds({Key? key}) : super(key: key);

  @override
  State<ChildNeeds> createState() => _ChildNeedsState();
}

class _ChildNeedsState extends State<ChildNeeds> {
  late int childNeedLevel;
  bool _isInit = true;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      var data =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      childNeedLevel = data['childNeedLevel'];

      await BlocProvider.of<NeedExpressionReportCubit>(context)
          .getNeedExpressionReport('false');

      _isInit = false;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> getUnAchievedNeeds() async {
    await BlocProvider.of<NeedExpressionReportCubit>(context)
        .getNeedExpressionReport('false');
  }

  Future<void> markAllNeedsAsDone() async {
    await BlocProvider.of<NeedExpressionHandleCubit>(context)
        .markAllNeedExpressionAsDone()
        .whenComplete(() async => await getUnAchievedNeeds());
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
          'الاحتياجات',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
            fontFamily: 'Mirza',
          ),
        ),
        actions: <Widget>[
          PopupMenuButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.check_circle,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'تحديد الكل كمحقق',
                        ),
                      ],
                    ),
                    textStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ];
              },
              onSelected: (int choice) {
                switch (choice) {
                  case 1:
                    markAllNeedsAsDone();
                    break;
                }
              }),
        ],
      ),
      body: BlocListener<NeedExpressionHandleCubit, NeedExpressionHandleState>(
        listener: (context, state) {
          if (state is NeedExpressionHandleFailed) {
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
          } else if (state is NeedExpressionHandleError) {
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
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                return Center(
                    child: EmptyContent(
                        text: 'سجل الاحتياجات فارغ', width: width));
              } else if (state is NeedExpressionReportDone) {
                List<NeedExpression> needsExpression = state.needsExpression;
                return ListView.builder(
                    shrinkWrap: true,
                    controller: context
                        .read<NeedExpressionReportCubit>()
                        .scrollController,
                    physics: const ScrollPhysics(),
                    itemCount:
                        context.read<NeedExpressionReportCubit>().isLoadingMore
                            ? needsExpression.length + 1
                            : needsExpression.length,
                    itemBuilder: (context, index) {
                      if (index >= needsExpression.length) {
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
                        return BlocProvider(
                          create: (context) => NeedExpressionHandleCubit(),
                          child: ChildNeedWidget(
                            width: width - 32,
                            childNeedLevel: childNeedLevel,
                            needExpression: needsExpression[index],
                            refreshUnAchievedNeeds: getUnAchievedNeeds,
                          ),
                        );
                      }
                    });
              } else {
                return const Column();
              }
            },
          ),
        ),
      ),
    );
  }
}
