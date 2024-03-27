import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:autism_mobile_app/domain/models/need_expression_models/need_expression.dart';

class NeedExpressionWidget extends StatefulWidget {
  const NeedExpressionWidget({
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
  State<NeedExpressionWidget> createState() => _NeedExpressionWidgetState();
}

class _NeedExpressionWidgetState extends State<NeedExpressionWidget> {
  Widget _needInRow(int numberOfContainer, int needIndex) {
    return Container(
      alignment: Alignment.center,
      width: (widget.width - 44) / numberOfContainer,
      height: 70,
      decoration: (numberOfContainer >= 3 &&
              (needIndex >= 1 && needIndex < numberOfContainer))
          ? BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Colors.blue[200]!,
                ),
              ),
              color: Colors.white,
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
                  color: Colors.white,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              height: 70,
              width: widget.width - 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 2.0, spreadRadius: 1.5, color: Colors.black12)
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
      ],
    );
  }
}
