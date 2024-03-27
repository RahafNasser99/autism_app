import 'package:flutter/material.dart';

class StatementCompositionTask extends StatelessWidget {
  const StatementCompositionTask({super.key, required this.statement});

  final List<String> statement;

  Widget _cell(String word) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          border: Border.all(
            color: Colors.blue[50]!,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Text(word,
            style: const TextStyle(
                color: Colors.blue,
                fontSize: 25,
                fontWeight: FontWeight.bold)));
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: statement.length < 4 ? statement.length : 4,
        childAspectRatio: statement.length <= 2 ? 3 : 1.7,
        crossAxisSpacing: statement.length < 4 ? 20.0 : 15.0,
        mainAxisSpacing: statement.length < 4 ? 0.0 : 15.0,
      ),
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: statement.length,
      itemBuilder: (context, index) => _cell(statement[index]),
    );
  }
}
