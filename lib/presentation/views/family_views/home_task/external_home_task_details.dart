import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:autism_mobile_app/utils/constant/days_of_week.dart';
import 'package:autism_mobile_app/presentation/widgets/app_drawer.dart';
import 'package:autism_mobile_app/domain/models/task_models/external_task.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/presentation/cubits/task_cubits/external_task_cubits/cubit/external_task_cubit.dart';

class ExternalHomeTaskDetails extends StatefulWidget {
  const ExternalHomeTaskDetails({super.key, required this.externalTask});

  final ExternalTask externalTask;

  @override
  State<ExternalHomeTaskDetails> createState() =>
      _ExternalHomeTaskDetailsState();
}

class _ExternalHomeTaskDetailsState extends State<ExternalHomeTaskDetails> {
  late String _outTaskDate;
  bool _isInit = true;

  String _note = '';

  bool _achieved = false;

  bool _semiAchieved = false;

  bool _notAchieved = false;

  int _evaluation = -1;

  bool _evaluationDone = false;

  bool _noteDone = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _outTaskDate = DaysOfWeek()
              .convert(DateFormat.E().format(widget.externalTask.date)) +
          '   ' +
          DateFormat('yyyy/MM/dd').format(widget.externalTask.date);

      setState(() {
        _achieved = widget.externalTask.getCheckValue('realized');
        _notAchieved = widget.externalTask.getCheckValue('unrealized');
        _semiAchieved = widget.externalTask.getCheckValue('partially realized');
      });

      if (_achieved) {
        setState(() {
          _evaluation = 2;
          _evaluationDone = true;
        });
      } else if (_semiAchieved) {
        setState(() {
          _evaluation = 1;
          _evaluationDone = true;
        });
      } else if (_notAchieved) {
        setState(() {
          _evaluation = 0;
          _evaluationDone = true;
        });
      } else {
        _evaluation = -1;
      }

      if (widget.externalTask.note != null) {
        _noteDone = true;
      }

      _isInit = false;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _sendEvaluation() async {
    BlocProvider.of<ExternalTaskCubit>(context).addNoteAndPerformance(
        widget.externalTask.id,
        _note,
        widget.externalTask.setChildPerformance(_evaluation));
  }

  Widget _addEvaluation(
      String evaluation, bool checkValue, Color color, int mark) {
    return Container(
      height: 30,
      padding: const EdgeInsets.only(right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          AutoSizeText(
            evaluation,
            style: TextStyle(
                fontSize: 18, color: color, fontWeight: FontWeight.w600),
          ),
          Transform.scale(
            scale: 0.9,
            child: Checkbox(
              value: checkValue,
              activeColor: color,
              side: BorderSide(
                color: color,
              ),
              onChanged: (_) {
                if (widget.externalTask.childPerformance == 'لم يتم التقييم' &&
                    !_evaluationDone) {
                  _evaluation = mark;
                  setState(() {
                    if (mark == 2) {
                      _achieved = !_achieved;
                      _semiAchieved = false;
                      _notAchieved = false;
                    } else if (mark == 1) {
                      _semiAchieved = !_semiAchieved;
                      _achieved = false;
                      _notAchieved = false;
                    } else if (mark == 0) {
                      _notAchieved = !_notAchieved;
                      _achieved = false;
                      _semiAchieved = false;
                    }
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'لقد تم التقييم مسبقاً',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      elevation: 4.0,
                      backgroundColor: Colors.red[50]!,
                    ),
                  );
                }
                if (!_achieved && !_semiAchieved && !_notAchieved) {
                  _evaluation = -1;
                }
              },
            ),
          )
        ],
      ),
    );
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
        title: const Text(
          'المهام المنزلية',
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
          child: SizedBox(
            height: 0.8 * height,
            child: BlocListener<ExternalTaskCubit, ExternalTaskState>(
              listener: (context, state) {
                if (state is ExternalTaskEvaluationDone) {
                  if (_evaluation != -1) {
                    setState(() {
                      _evaluationDone = true;
                    });
                  }
                  if (_note.isNotEmpty) {
                    _noteDone = true;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'تم التقييم بنجاح',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      elevation: 4.0,
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
                if (state is ExternalTaskEvaluationFailed) {
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
                if (state is ExternalTaskEvaluationError) {
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
                    child: AutoSizeText(
                      '${widget.externalTask.taskName}  ⚈',
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
                  _addEvaluation('محقق', _achieved, Colors.green, 2),
                  _addEvaluation(
                      'محقق بشكل جزئي', _semiAchieved, Colors.yellow[800]!, 1),
                  _addEvaluation('غير محقق', _notAchieved, Colors.red, 0),
                  const SizedBox(
                    height: 25,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: AutoSizeText(
                      ':ملاحظات ولي الأمر',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            (widget.externalTask.note == null) ? 8.0 : 12.0,
                        vertical: 10.0),
                    child: (widget.externalTask.note == null)
                        ? BlocBuilder<ExternalTaskCubit, ExternalTaskState>(
                            builder: (context, state) {
                              if (state is ExternalTaskEvaluationDone &&
                                  _noteDone) {
                                return AutoSizeText(
                                  _note,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                );
                              } else {
                                return TextFormField(
                                  textAlign: TextAlign.right,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                    hintText: 'إضافة ملاحظة',
                                    hintStyle: TextStyle(
                                        fontSize: 20, color: Colors.black38),
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0))),
                                  ),
                                  onChanged: (note) {
                                    _note = note;
                                  },
                                );
                              }
                            },
                          )
                        : AutoSizeText(
                            _note.isNotEmpty
                                ? _note
                                : widget.externalTask.note!,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        child: Text(
                          'حفظ التقييم',
                          style: TextStyle(
                              color: (_noteDone && _evaluationDone)
                                  ? Colors.black54
                                  : Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: (_noteDone && _evaluationDone)
                                ? Colors.grey[300]
                                : Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 2.0)),
                        onPressed: (_noteDone && _evaluationDone)
                            ? () {}
                            : () {
                                if (widget.externalTask.childPerformance ==
                                    'لم يتم التقييم') {
                                  _sendEvaluation();
                                } else if (_note.isNotEmpty) {
                                  _sendEvaluation();
                                }
                              },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
