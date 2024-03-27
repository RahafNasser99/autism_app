import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/app_drawer.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/domain/models/task_models/internal_task.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/presentation/views/shared_views/empty_content.dart';
import 'package:autism_mobile_app/presentation/widgets/reusable_elevated_button.dart';
import 'package:autism_mobile_app/presentation/cubits/task_cubits/internal_task_cubits/cubit/internal_task_cubit.dart';
import 'package:autism_mobile_app/presentation/cubits/task_cubits/internal_task_cubits/cubit/internal_task_details_cubit.dart';
import 'package:autism_mobile_app/presentation/views/family_views/reports/center_home_tasks_report/internal_task_report/internal_task_details.dart';

class InternalTasksReport extends StatefulWidget {
  const InternalTasksReport({Key? key, required this.taskPlace})
      : super(key: key);

  final String taskPlace;

  @override
  State<InternalTasksReport> createState() => _InternalTasksReportState();
}

class _InternalTasksReportState extends State<InternalTasksReport> {
  bool _achievedTasks = true;
  bool _initState = true;

  @override
  Future<void> didChangeDependencies() async {
    if (_initState) {
      await BlocProvider.of<InternalTaskCubit>(context)
          .getFirstPage(widget.taskPlace, 'true');
      _initState = false;
    }
    _initState = false;
    super.didChangeDependencies();
  }

  Future<void> getAchievedTasks() async {
    await BlocProvider.of<InternalTaskCubit>(context)
        .getFirstPage(widget.taskPlace, 'true');
  }

  Future<void> getUnAchievedTasks() async {
    await BlocProvider.of<InternalTaskCubit>(context)
        .getFirstPage(widget.taskPlace, 'false');
  }

  Widget _text(String text, Color color) {
    return AutoSizeText(
      text,
      textAlign: TextAlign.right,
      style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget _task(InternalTask internalTask, double height, double width,
      void Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120,
        width: width - 30,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: (width - 30) / 2.3,
              margin: const EdgeInsets.only(bottom: 8.0, top: 8.0, left: 8.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(internalTask.getTaskImage()),
                    fit: BoxFit.contain),
              ),
            ),
            Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                width: (width - 30) / 1.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    AutoSizeText(
                      internalTask.taskName,
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 6.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        _text(internalTask.attempts.toString(), Colors.green),
                        _text('  :عدد مرات المحاولة', Colors.blue[800]!),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        _text('ثانية', Colors.green),
                        _text('${internalTask.duration.toString()} ',
                            Colors.green),
                        _text('  :المدة', Colors.blue[800]!),
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ),
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
          widget.taskPlace == 'center-task'
              ? 'المهام داخل التطبيق'
              : 'تقرير المهام المنزلية',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
            fontFamily: 'Mirza',
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      endDrawer: AppDrawer(isChild: ChildAccount().getIsChild(), width: width),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ReUsableElevatedButton(
                  width: width,
                  title: 'لم يتم إنجازها',
                  mark: !_achievedTasks,
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(5.0), right: Radius.zero),
                  onPressed: () {
                    if (!_achievedTasks) {
                      return;
                    } else {
                      setState(() {
                        _achievedTasks = false;
                      });
                      getUnAchievedTasks();
                    }
                  },
                ),
                ReUsableElevatedButton(
                  width: width,
                  title: 'تم إنجازها',
                  mark: _achievedTasks,
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.zero, right: Radius.circular(5.0)),
                  onPressed: () {
                    if (_achievedTasks) {
                      return;
                    } else {
                      setState(() {
                        _achievedTasks = true;
                      });
                      getAchievedTasks();
                    }
                  },
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
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
              child: BlocConsumer<InternalTaskCubit, InternalTaskState>(
                listener: (context, state) {
                  if (state is InternalTaskFailed) {
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
                  }
                  if (state is InternalTaskError) {
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
                  if (state is InternalTaskLoading) {
                    return const Loading();
                  } else if (state is InternalTaskEmpty) {
                    return EmptyContent(
                        text: 'سجل التمارين فارغ', width: width);
                  } else if (state is InternalTaskDone) {
                    return ListView.builder(
                        shrinkWrap: true,
                        controller:
                            context.read<InternalTaskCubit>().scrollController,
                        physics: const ScrollPhysics(),
                        itemCount:
                            context.read<InternalTaskCubit>().isLoadingMore
                                ? state.internalTasks.length + 1
                                : state.internalTasks.length,
                        itemBuilder: (context, index) {
                          if (index >= state.internalTasks.length) {
                            return SpinKitThreeInOut(
                                itemBuilder: (BuildContext context, int index) {
                              return DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      index.isEven ? Colors.blue : Colors.grey,
                                ),
                              );
                            });
                          } else {
                            return _task(
                                state.internalTasks[index] as InternalTask,
                                height,
                                width, () {
                              Navigator.of(context).push(PageTransition(
                                child: BlocProvider<InternalTaskDetailsCubit>(
                                  create: (context) =>
                                      InternalTaskDetailsCubit(),
                                  child: InternalTaskDetailsScreen(
                                    internalTask: state.internalTasks[index]
                                        as InternalTask,
                                    taskPlace: widget.taskPlace,
                                  ),
                                ),
                                type: PageTransitionType.rightToLeft,
                                duration: const Duration(milliseconds: 500),
                              ));
                            });
                          }
                        });
                  } else {
                    return const Column();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
