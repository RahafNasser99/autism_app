import 'package:flutter/material.dart';

import 'package:autism_mobile_app/domain/models/pep_3_test_models/pep_3_test.dart';

class DevelopmentAgeTable extends StatelessWidget {
  const DevelopmentAgeTable({super.key, required this.pep3Test});

  final Pep3Test pep3Test;

  @override
  Widget build(BuildContext context) {
    TableRow _tableRow(
        String domain, String ageInYear, String ageInMonth, double textSize) {
      return TableRow(
        children: [
          Container(
            color: Colors.blue[50],
            padding: const EdgeInsets.all(8.0),
            child: Text(
              domain,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          Table(
            border: const TableBorder(verticalInside: BorderSide(width: 1.3)),
            children: [
              TableRow(children: [
                Text(ageInYear, textAlign: TextAlign.center),
                Text(ageInMonth, textAlign: TextAlign.center),
              ]),
            ],
          ),
        ],
      );
    }

    return Table(
      columnWidths: Map.from({
        0: const FractionColumnWidth(0.6),
        1: const FractionColumnWidth(0.4),
      }),
      border: const TableBorder(
        bottom: BorderSide(width: 2.0),
        top: BorderSide(width: 2.0),
        left: BorderSide(width: 2.0),
        right: BorderSide(width: 2.0),
        verticalInside: BorderSide(width: 2.0),
        horizontalInside: BorderSide(width: 1.0),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      textDirection: TextDirection.rtl,
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.blue[50]),
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'المجال',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'العمر النمائي',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        TableRow(
          decoration: BoxDecoration(
            border: const Border.symmetric(
              horizontal: BorderSide(width: 2.0),
            ),
            color: Colors.blue[50],
          ),
          children: [
            const Text(''),
            Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: const TableBorder(verticalInside: BorderSide(width: 2)),
                children: const [
                  TableRow(children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
                      child: Text(
                        'السنة',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
                      child: Text(
                        'الشهر',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ]),
                ]),
          ],
        ),
        _tableRow(
            pep3Test.developmentAge[0].domain.domainName,
            pep3Test.developmentAge[0].ageInYear.toString(),
            pep3Test.developmentAge[0].ageInMonth.toString(),
            16),
        _tableRow(
            pep3Test.developmentAge[1].domain.domainName,
            pep3Test.developmentAge[1].ageInYear.toString(),
            pep3Test.developmentAge[1].ageInMonth.toString(),
            16),
        _tableRow(
            pep3Test.developmentAge[2].domain.domainName,
            pep3Test.developmentAge[2].ageInYear.toString(),
            pep3Test.developmentAge[2].ageInMonth.toString(),
            16),
        _tableRow(
            pep3Test.developmentAge[3].domain.domainName,
            pep3Test.developmentAge[3].ageInYear.toString(),
            pep3Test.developmentAge[3].ageInMonth.toString(),
            16),
        _tableRow(
            pep3Test.developmentAge[4].domain.domainName,
            pep3Test.developmentAge[4].ageInYear.toString(),
            pep3Test.developmentAge[4].ageInMonth.toString(),
            16),
        _tableRow(
            pep3Test.developmentAge[5].domain.domainName,
            pep3Test.developmentAge[5].ageInYear.toString(),
            pep3Test.developmentAge[5].ageInMonth.toString(),
            16),
        _tableRow(
            pep3Test.developmentAge[6].domain.domainName,
            pep3Test.developmentAge[6].ageInYear.toString(),
            pep3Test.developmentAge[6].ageInMonth.toString(),
            16),
        _tableRow(
            'العمر النمائي في الجانب التواصلي',
            pep3Test.communicativeDevelopmentalAgeInYear.toString(),
            pep3Test.communicativeDevelopmentalAgeInMonth.toString(),
            16),
        _tableRow(
            'العمر النمائي في الجانب الحركي ',
            pep3Test.motorDevelopmentalAgeInYear.toString(),
            pep3Test.motorDevelopmentalAgeInMonth.toString(),
            16),
      ],
    );
  }
}
