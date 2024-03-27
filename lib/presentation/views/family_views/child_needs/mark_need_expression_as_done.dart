import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/domain/models/need_expression_models/need_expression.dart';
import 'package:autism_mobile_app/presentation/cubits/needs_expression_cubits/cubit/need_expression_handle_cubit.dart';

class MarkNeedExpressionAsDone extends StatelessWidget {
  const MarkNeedExpressionAsDone({super.key, required this.needExpression});

  final NeedExpression needExpression;

  Widget _needView(NeedExpression needExpression, int needIndex, double size) {
    return GridTile(
        header: CircleAvatar(
          radius: 18,
          backgroundColor: Colors.black12,
          child: CircleAvatar(
            radius: 17.3,
            backgroundColor: Colors.white,
            child: Text(
              (needIndex + 1).toString(),
              style: const TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
          height: size,
          width: size,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(blurRadius: 5.0, color: Colors.black12)
            ],
            borderRadius: const BorderRadius.all(Radius.circular(7.0)),
            color: Colors.white,
            image: needExpression.needs[needIndex].needContent.content
                    .contains('.')
                ? DecorationImage(
                    image: NetworkImage(
                        needExpression.needs[needIndex].needContent.content),
                    fit: BoxFit.fill)
                : null,
          ),
          child:
              !needExpression.needs[needIndex].needContent.content.contains('.')
                  ? AutoSizeText(
                      needExpression.needs[needIndex].needContent.content,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    )
                  : null,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          centerTitle: true,
          backgroundColor: Colors.blue,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'أنا أريد',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white,
              fontFamily: 'Mirza',
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
              top: 15.0, left: 10.0, right: 10.0, bottom: 10.0),
          child: Column(
            children: [
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.check_circle,
                  ),
                  label: const Text(
                    'تحديد كمحقق',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.all(10.0),
                    alignment: Alignment.topCenter,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    fixedSize: Size.fromWidth(width - 40),
                  ),
                  onPressed: () async {
                    await BlocProvider.of<NeedExpressionHandleCubit>(context)
                        .markNeedExpressionAsDone(
                            needExpression.needExpressionId);
                  },
                ),
              ),
              BlocConsumer<NeedExpressionHandleCubit,
                  NeedExpressionHandleState>(
                listener: (context, state) {
                  if (state is NeedExpressionHandleFailed) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => ShowDialog(
                          dialogMessage: state.failedMessage,
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    );
                  } else if (state is NeedExpressionHandleError) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => ShowDialog(
                          dialogMessage: state.errorMessage,
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    );
                  } else if (state is NeedExpressionHandleDone) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'تم تحديد الحاجة كمحقق',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: GridView.builder(
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        needExpression.needs.length > 1 ? 2 : 1,
                                    crossAxisSpacing: 10.0,
                                    childAspectRatio: 1),
                            itemCount: needExpression.needs.length,
                            itemBuilder: (context, index) =>
                                _needView(needExpression, index, width - 80),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
