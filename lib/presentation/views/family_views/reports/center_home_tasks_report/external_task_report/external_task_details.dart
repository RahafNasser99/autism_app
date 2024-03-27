import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:autism_mobile_app/utils/constant/days_of_week.dart';
import 'package:autism_mobile_app/presentation/widgets/app_drawer.dart';
import 'package:autism_mobile_app/domain/models/task_models/external_task.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';

class ExternalTaskDetails extends StatelessWidget {
  const ExternalTaskDetails({super.key, required this.externalTask});

  final ExternalTask externalTask;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String _outTaskDate =
        DaysOfWeek().convert(DateFormat.E().format(externalTask.date)) +
            '   ' +
            DateFormat('yyyy/MM/dd').format(externalTask.date);

    Color _checkColor() {
      if (externalTask.childPerformance == 'محقق بشكل جزئي') {
        return Colors.yellow[800]!;
      } else if (externalTask.childPerformance == 'محقق') {
        return Colors.green;
      } else if (externalTask.childPerformance == 'غير محقق') {
        return Colors.red;
      } else {
        return Colors.grey;
      }
    }

    IconData _checkIcon() {
      if (externalTask.childPerformance == 'محقق بشكل جزئي') {
        return Icons.change_circle_rounded;
      } else if (externalTask.childPerformance == 'محقق') {
        return Icons.check_circle_rounded;
      } else if (externalTask.childPerformance == 'غير محقق') {
        return Icons.cancel_rounded;
      } else {
        return Icons.remove_circle_rounded;
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'المهام خارج التطبيق',
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
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        height: 0.9 * height,
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
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: AutoSizeText(_outTaskDate,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              Hero(
                tag: 'task-name',
                transitionOnUserGestures: true,
                child: AutoSizeText(
                  '${externalTask.taskName}  ⚈',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[700],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Hero(
                tag: 'task-evaluation',
                transitionOnUserGestures: true,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: AutoSizeText(
                          externalTask.childPerformance,
                          style: TextStyle(
                            fontSize: 20,
                            color: _checkColor(),
                          ),
                        ),
                      ),
                      Icon(_checkIcon(), color: _checkColor(), size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Visibility(
                visible: externalTask.note == null ? false : true,
                child: const Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: AutoSizeText(
                    ':ملاحظات المشرفين',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: externalTask.note == null ? false : true,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: AutoSizeText(
                    externalTask.note == null ? '' : externalTask.note!,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
