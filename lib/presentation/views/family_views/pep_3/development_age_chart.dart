import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:autism_mobile_app/domain/models/pep_3_test_models/pep_3_test.dart';
import 'package:autism_mobile_app/domain/models/pep_3_test_models/development_age.dart';

class DevelopmentAgeChart extends StatelessWidget {
  DevelopmentAgeChart({super.key, required this.pep3Test});

  final Pep3Test pep3Test;

  final List<String> _domains = [
    'الإدراك' '\n' 'اللفظي' '\n' ' وغير اللفظي' '\n' '(CVP)',
    'اللغة' '\n' ' التعبيرية' '\n' '(EL)',
    'اللغة' '\n' ' الاستقبالية' '\n' '(RL)',
    'المهارات' '\n' ' الحركية' '\n' ' الدقيقة' '\n' '(FM)',
    'المهارات' '\n' ' الحركية' '\n' ' الكبيرة' '\n' '(GM)',
    'التقليد' '\n' ' الحركي' '\n' ' البصري' '\n' '(VMI)',
    'العناية' '\n' ' بالذات' '\n' '(PSC)',
  ];

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      // isTransposed: true,
      primaryXAxis: CategoryAxis(
        // labelRotation: 90,
        labelStyle: const TextStyle(fontSize: 10),
      ),
      primaryYAxis: NumericAxis(
        interval: 10,
        maximum: 100,
      ),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
      ),
      title: ChartTitle(
        text: 'العمر النمائي',
        textStyle: const TextStyle(fontSize: 12),
      ),
      series: <ChartSeries<DevelopmentAge, String>>[
        ColumnSeries<DevelopmentAge, String>(
          name: 'العمر الحقيقي',
          dataSource: pep3Test.developmentAge,
          xValueMapper: (DevelopmentAge developmentAge, _) =>
              (developmentAge.domain.domainId == 11)
                  ? _domains[6]
                  : _domains[developmentAge.domain.domainId - 1],
          // developmentAge.domain.domainName,
          yValueMapper: (DevelopmentAge developmentAge, _) => pep3Test.realAge,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
        ColumnSeries<DevelopmentAge, String>(
          name: 'العمر النمائي',
          color: Colors.red[400],
          dataSource: pep3Test.developmentAge,
          xValueMapper: (DevelopmentAge developmentAge, _) =>
              (developmentAge.domain.domainId == 11)
                  ? _domains[6]
                  : _domains[developmentAge.domain.domainId - 1],
          // developmentAge.domain.domainName,
          yValueMapper: (DevelopmentAge developmentAge, _) =>
              developmentAge.age,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}
