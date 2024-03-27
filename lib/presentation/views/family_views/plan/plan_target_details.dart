import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:autism_mobile_app/domain/models/plan_models/target.dart';

class PlanTargetDetails extends StatefulWidget {
  const PlanTargetDetails({super.key, required this.target});

  final Target target;

  @override
  State<PlanTargetDetails> createState() => _PlanTargetDetailsState();
}

class _PlanTargetDetailsState extends State<PlanTargetDetails> {
  bool _target = false;

  bool _ways = false;

  bool _evaluate = false;

  bool _motivation = false;

  bool _notes = false;

  Widget _result(double width, bool visible, String text) {
    return Visibility(
      visible: visible,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        alignment: Alignment.topRight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 1.5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: width - (width / 6) - 30,
              child: AutoSizeText(
                text,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.blue[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              width: (width / 8) - 30,
              child: AutoSizeText(
                '⚈',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.blue[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _details(
      double height, bool mark, String title, void Function()? onTap) {
    return SizedBox(
      height: height / 11,
      child: Card(
        color: Colors.blue,
        margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: ListTile(
          iconColor: Colors.white,
          leading: mark
              ? const Icon(Icons.keyboard_arrow_up_rounded)
              : const Icon(Icons.keyboard_arrow_down_rounded),
          title: AutoSizeText(
            title,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          onTap: onTap,
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
            widget.target.domain.domainName.substring(
                widget.target.domain.domainName.indexOf(")") + 1,
                widget.target.domain.domainName.length),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white,
              fontFamily: 'Mirza',
            ),
          ),
        ),
        body: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/backgrounds/background1.PNG'),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              children: <Widget>[
                _details(height, _target, 'الهدف', () {
                  setState(() {
                    _target = !_target;
                  });
                }),
                _result(width, _target, widget.target.target),
                _details(height, _ways, 'الأساليب التعليمية', () {
                  setState(() {
                    _ways = !_ways;
                  });
                }),
                _result(
                  width,
                  _ways,
                  widget.target.technique,
                ),
                _details(height, _evaluate, 'التقييم', () {
                  setState(() {
                    _evaluate = !_evaluate;
                  });
                }),
                _result(
                  width,
                  _evaluate,
                  widget.target.evaluation,
                ),
                _details(height, _motivation, 'التعزيز', () {
                  setState(() {
                    _motivation = !_motivation;
                  });
                }),
                _result(
                    width,
                    _motivation,
                    widget.target.motivation == null
                        ? 'لا يوجد'
                        : widget.target.motivation!),
                _details(height, _notes, 'الملاحظات', () {
                  setState(() {
                    _notes = !_notes;
                  });
                }),
                _result(
                    width,
                    _notes,
                    widget.target.note == null
                        ? 'لا يوجد'
                        : widget.target.note!),
              ],
            ),
          ),
        ));
  }
}
