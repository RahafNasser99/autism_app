import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/domain/models/need_expression_models/need_expression.dart';
import 'package:autism_mobile_app/presentation/views/family_views/child_needs/mark_need_expression_as_done.dart';
import 'package:autism_mobile_app/presentation/cubits/needs_expression_cubits/cubit/need_expression_handle_cubit.dart';

class ChildNeedWidget extends StatefulWidget {
  const ChildNeedWidget({
    Key? key,
    required this.width,
    required this.childNeedLevel,
    required this.needExpression,
    required this.refreshUnAchievedNeeds,
  }) : super(key: key);

  final double width;
  final int childNeedLevel;
  final NeedExpression needExpression;
  final Function refreshUnAchievedNeeds;

  @override
  State<ChildNeedWidget> createState() => _ChildNeedWidgetState();
}

class _ChildNeedWidgetState extends State<ChildNeedWidget> {
  bool _needCheckValue = false;

  Widget _needInRow(int numberOfContainer, int needIndex) {
    return Container(
      alignment: Alignment.center,
      width: (widget.width - 38) / numberOfContainer,
      height: 70,
      decoration: (numberOfContainer >= 3 &&
              (needIndex >= 1 && needIndex < numberOfContainer))
          ? BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Colors.blue[200]!,
                ),
              ),
              image: widget.needExpression.needs[needIndex].needContent.content
                      .contains('.')
                  ? DecorationImage(
                      image: NetworkImage(widget
                          .needExpression.needs[needIndex].needContent.content),
                      fit: BoxFit.fill)
                  : null,
            )
          : (numberOfContainer == 2 && needIndex == 1)
              ? BoxDecoration(
                  border: const Border(
                    right: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  image: widget
                          .needExpression.needs[needIndex].needContent.content
                          .contains('.')
                      ? DecorationImage(
                          image: NetworkImage(widget.needExpression
                              .needs[needIndex].needContent.content),
                          fit: BoxFit.fill)
                      : null,
                )
              : BoxDecoration(
                  image: widget
                          .needExpression.needs[needIndex].needContent.content
                          .contains('.')
                      ? DecorationImage(
                          image: NetworkImage(widget.needExpression
                              .needs[needIndex].needContent.content),
                          fit: BoxFit.contain)
                      : null,
                ),
      child: !widget.needExpression.needs[needIndex].needContent.content
              .contains('.')
          ? AutoSizeText(
              widget.needExpression.needs[needIndex].needContent.content,
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: (numberOfContainer <= 3) ? 22 : 18,
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NeedExpressionHandleCubit, NeedExpressionHandleState>(
      listener: (context, state) async {
        if (state is NeedExpressionHandleDone) {
          await widget.refreshUnAchievedNeeds();
        } else if (state is NeedExpressionHandleFailed) {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    height: 70,
                    width: widget.width - 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 2.0,
                            spreadRadius: 2.0,
                            color: Colors.black12)
                      ],
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: widget.needExpression.needs.length,
                      itemBuilder: (context, index) =>
                          _needInRow(widget.needExpression.needs.length, index),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider<NeedExpressionHandleCubit>(
                          create: (context) => NeedExpressionHandleCubit(),
                          child: MarkNeedExpressionAsDone(
                            needExpression: widget.needExpression,
                          ),
                        ),
                      ),
                    )
                    .whenComplete(() => widget.refreshUnAchievedNeeds());
              }),
          SizedBox(
            width: 32,
            child: IconButton(
              icon: Icon(
                _needCheckValue
                    ? Icons.check_circle_rounded
                    : Icons.check_circle_outline_rounded,
                color: _needCheckValue ? Colors.green : Colors.black26,
              ),
              onPressed: () async {
                setState(() {
                  _needCheckValue = true;
                });
                Future.delayed(const Duration(milliseconds: 300)).whenComplete(
                    () async =>
                        await BlocProvider.of<NeedExpressionHandleCubit>(
                                context)
                            .markNeedExpressionAsDone(
                                widget.needExpression.needExpressionId)
                            .whenComplete(() {
                          setState(() {
                            _needCheckValue = false;
                          });
                        }));
              },
            ),
          ),
        ],
      ),
    );
  }
}
