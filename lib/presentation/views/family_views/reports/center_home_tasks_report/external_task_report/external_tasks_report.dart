import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:page_transition/page_transition.dart';

import 'package:autism_mobile_app/utils/constant/days_of_week.dart';
import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/app_drawer.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/domain/models/task_models/external_task.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/presentation/views/shared_views/empty_content.dart';
import 'package:autism_mobile_app/presentation/views/family_views/home_task/external_home_task_details.dart';
import 'package:autism_mobile_app/presentation/cubits/task_cubits/external_task_cubits/cubit/external_task_cubit.dart';
import 'package:autism_mobile_app/presentation/views/family_views/reports/center_home_tasks_report/external_task_report/external_task_details.dart';

class ExternalTasksReport extends StatefulWidget {
  const ExternalTasksReport({super.key, required this.taskPlace});

  final String taskPlace;

  @override
  State<ExternalTasksReport> createState() => _ExternalTasksReportState();
}

class _ExternalTasksReportState extends State<ExternalTasksReport> {
  bool _isInit = true;
  String day = DaysOfWeek().convert(DateFormat.E().format(DateTime.now()));
  DateTime _selectedDate = DateTime.now();
  late String _selectedDateString;

  @override
  Future<void> didChangeDependencies() async {
    _selectedDateString =
        day + '   ' + DateFormat('yyyy/MM/dd').format(DateTime.now());
    if (_isInit) {
      await BlocProvider.of<ExternalTaskCubit>(context)
          .getTasks(widget.taskPlace, _selectedDate);
      _isInit = false;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _getExternalTasksForDay() async {
    await BlocProvider.of<ExternalTaskCubit>(context)
        .getTasks(widget.taskPlace, _selectedDate);
  }

  Widget _task(double width, double height, ExternalTask externalTask) {
    Color color;
    if (externalTask.childPerformance == 'محقق بشكل جزئي') {
      color = Colors.yellow[800]!;
    } else if (externalTask.childPerformance == 'محقق') {
      color = Colors.green;
    } else if (externalTask.childPerformance == 'غير محقق') {
      color = Colors.red;
    } else {
      color = Colors.grey;
    }
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 3.0),
        width: width - 54,
        height: height / 15,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 2.0,
              spreadRadius: 2.0,
              color: Colors.black12,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              width: 1.5 * (width - 54) / 3,
              alignment: Alignment.center,
              child: AutoSizeText(externalTask.childPerformance,
                  style: TextStyle(
                      color: color, fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              width: 1.5 * (width - 54) / 3,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: Colors.blue)),
              ),
              child: AutoSizeText(
                externalTask.taskName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        if (widget.taskPlace == 'home-task') {
          Navigator.push(
            context,
            PageTransition(
              child: BlocProvider<ExternalTaskCubit>(
                create: (context) => ExternalTaskCubit(),
                child: ExternalHomeTaskDetails(externalTask: externalTask),
              ),
              type: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 500),
            ),
          ).whenComplete(() async => await _getExternalTasksForDay());
        } else {
          Navigator.push(
            context,
            PageTransition(
              child: ExternalTaskDetails(externalTask: externalTask),
              type: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 500),
            ),
          );
        }
      },
    );
  }

  Future<DateTime?> _showDatePicker(BuildContext context) async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2024),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: '',
      confirmText: 'ذهاب إلى اليوم',
      cancelText: 'الغاء',
    ).then((date) {
      if (date != null) {
        _selectedDate = date;
        _getExternalTasksForDay();
        setState(() {
          _updateShownDate(date);
        });
      }
      return null;
    });
  }

  void _updateShownDate(DateTime date) {
    day = DaysOfWeek().convert(DateFormat.E().format(date));
    _selectedDateString = day + '   ' + DateFormat('yyyy/MM/dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.taskPlace == 'home-task'
              ? 'الواجبات المنزلية'
              : 'المهام في المركز',
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
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
        height: height - 110,
        width: width - 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          image: const DecorationImage(
            image: AssetImage('assets/images/backgrounds/background1.PNG'),
            fit: BoxFit.fill,
          ),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 3.0,
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                    onPressed: () {
                      _selectedDate =
                          _selectedDate.add(const Duration(days: 1));
                      setState(() {
                        _updateShownDate(_selectedDate);
                      });
                      _getExternalTasksForDay();
                    },
                    splashColor: Colors.white,
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 20,
                      color: Colors.blue,
                    )),
                TextButton(
                    onPressed: () {
                      _showDatePicker(context);
                    },
                    child: Text(
                      _selectedDateString,
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    )),
                IconButton(
                    onPressed: () {
                      _selectedDate =
                          _selectedDate.subtract(const Duration(days: 1));
                      setState(() {
                        _updateShownDate(_selectedDate);
                      });
                      _getExternalTasksForDay();
                    },
                    splashColor: Colors.white,
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: Colors.blue,
                    ))
              ],
            ),
            Expanded(
              child: BlocConsumer<ExternalTaskCubit, ExternalTaskState>(
                listener: (context, state) {
                  if (state is ExternalTaskFailed) {
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
                  if (state is ExternalTaskError) {
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
                  if (state is ExternalTaskLoading) {
                    return const Loading();
                  } else if (state is ExternalTaskEmpty) {
                    return EmptyContent(
                        text: 'سجل التمارين فارغ', width: width);
                  } else if (state is ExternalTaskDone) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: state.externalTasks.length,
                      itemBuilder: (context, index) => _task(width, height,
                          state.externalTasks[index] as ExternalTask),
                    );
                  } else {
                    return const Column();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
