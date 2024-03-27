import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:page_transition/page_transition.dart';

import 'package:autism_mobile_app/presentation/cubits/exercise_cubits/cubit/exercise_cubit.dart';
import 'package:autism_mobile_app/presentation/views/child_views/center_home_exercise/items_matching.dart';
import 'package:autism_mobile_app/presentation/views/child_views/center_home_exercise/numbers_ordering.dart';
import 'package:autism_mobile_app/presentation/views/child_views/center_home_exercise/numbers_comparing.dart';
import 'package:autism_mobile_app/presentation/views/child_views/center_home_exercise/statement_composition.dart';

class InternalExercise extends StatelessWidget {
  const InternalExercise({super.key, required this.placeMark});

  final String placeMark;

  Widget _task(String taskImage, String taskName, double height, double width,
      void Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height / 5.3,
        width: width - 32,
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 3.0,
                color: Colors.black12,
                spreadRadius: 2.0,
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: (width - 32) / 2,
              margin: const EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(taskImage), fit: BoxFit.contain),
              ),
            ),
            Container(
              width: (width - 48) / 2,
              alignment: Alignment.center,
              child: AutoSizeText(taskName,
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          placeMark == 'center-task' ? 'مهام المركز' : ' المهام المنزلية',
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            fontFamily: 'Mirza',
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/background1.PNG'),
            fit: BoxFit.fill,
          )),
          child: ListView(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            children: [
              _task('assets/images/tasks/number-ordering-task.jpg', 'ترتيب الأرقام', height, width,
                  () {
                Navigator.of(context).push(PageTransition(
                  child: BlocProvider<ExerciseCubit>(
                    create: (context) => ExerciseCubit(),
                    child: NumbersOrdering(taskPlace: placeMark),
                  ),
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 500),
                ));
              }),
              _task('assets/images/tasks/statement-composition-task.jpg', 'تركيب الجمل', height, width,
                  () {
                Navigator.of(context).push(PageTransition(
                  child: BlocProvider<ExerciseCubit>(
                    create: (context) => ExerciseCubit(),
                    child: StatementComposition(taskPlace: placeMark),
                  ),
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 500),
                ));
              }),
              _task('assets/images/tasks/number-comparing-task.jpg', 'أيهما أكبر', height, width,
                  () {
                Navigator.of(context).push(PageTransition(
                  child: BlocProvider<ExerciseCubit>(
                    create: (context) => ExerciseCubit(),
                    child: NumbersComparing(taskPlace: placeMark),
                  ),
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 500),
                ));
              }),
              _task('assets/images/tasks/item-matching-task.jpg', 'تشابه الصور', height, width,
                  () {
                Navigator.of(context).push(PageTransition(
                  child: BlocProvider<ExerciseCubit>(
                    create: (context) => ExerciseCubit(),
                    child: ItemsMatching(taskPlace: placeMark),
                  ),
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 500),
                ));
              }),
            ],
          )),
    );
  }
}
