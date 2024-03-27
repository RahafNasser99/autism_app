import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/domain/models/account_models/teacher_specialist_account.dart';
import 'package:autism_mobile_app/presentation/cubits/teachers_specialists_cubits/cubit/teachers_specialists_cubit.dart';
import 'package:autism_mobile_app/presentation/views/family_views/teachers_specialists/teacher_specialist_list_tile.dart';

class TeachersSpecialistsList extends StatefulWidget {
  const TeachersSpecialistsList({Key? key}) : super(key: key);

  @override
  State<TeachersSpecialistsList> createState() =>
      _TeachersSpecialistsListState();
}

class _TeachersSpecialistsListState extends State<TeachersSpecialistsList> {
  bool _loading = true;
  bool _teachersMark = false;
  bool _specialistsMark = true;
  List<TeacherSpecialistAccount> specialists = [];
  List<TeacherSpecialistAccount> teachers = [];

  @override
  Future<void> didChangeDependencies() async {
      if (_loading) {
        specialists = await BlocProvider.of<TeachersSpecialistsCubit>(context)
            .getSpecialists();
        teachers = await BlocProvider.of<TeachersSpecialistsCubit>(context)
            .getTeachers();
      }
      _loading = false;
    super.didChangeDependencies();
  }

  Widget scrollBarList(
      List<TeacherSpecialistAccount> list, int listMark, double width) {
    // when listMark is one the list is specialists list another the list is teachers list
    return Scrollbar(
      child: list.isEmpty
          ? Padding(
              padding: EdgeInsets.only(top: width / 4.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.blue,
                      size: width / 2.0,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      listMark == 1 ? 'لا يوجد أخصائيين' : 'لا يوجد معلمين',
                      style: const TextStyle(fontSize: 30),
                    ),
                  ]),
            )
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, index) => TeacherSpecialistListTile(
                    teacherSpecialistAccount: list[index],
                  )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'المشرفين',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            fontFamily: 'Mirza',
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: Text(
                    'المعلمين',
                    style: TextStyle(
                      fontSize: 22,
                      color: _teachersMark ? Colors.white : Colors.blue,
                      fontFamily: 'Mirza',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _teachersMark ? Colors.blue : Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(5.0), right: Radius.zero),
                    ),
                    fixedSize: Size.fromWidth(width / 2 - 15),
                  ),
                  onPressed: () {
                    setState(() {
                      _specialistsMark = false;
                      _teachersMark = true;
                    });
                  },
                ),
                ElevatedButton(
                  child: Text(
                    'الأخصائيين',
                    style: TextStyle(
                      fontSize: 22,
                      color: _specialistsMark ? Colors.white : Colors.blue,
                      fontFamily: 'Mirza',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _specialistsMark ? Colors.blue : Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.zero, right: Radius.circular(5.0)),
                    ),
                    fixedSize: Size.fromWidth(width / 2 - 15),
                  ),
                  onPressed: () {
                    setState(() {
                      _specialistsMark = true;
                      _teachersMark = false;
                    });
                  },
                ),
              ],
            ),
            Container(
                margin: const EdgeInsets.only(top: 10.0),
                height: height / 1.4,
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
                child: BlocConsumer<TeachersSpecialistsCubit,
                    TeachersSpecialistsState>(
                  listener: (context, state) {
                    if (state is TeachersSpecialistsFailed) {
                      showDialog(
                          context: context,
                          builder: (context) => ShowDialog(
                              dialogMessage: state.failedMessage,
                              onPressed: () {
                                Navigator.of(context).pop();
                              }));
                    }
                    if (state is TeachersSpecialistsError) {
                      showDialog(
                          context: context,
                          builder: (context) => ShowDialog(
                              dialogMessage: state.errorMessage,
                              onPressed: () {
                                Navigator.of(context).pop();
                              }));
                    }
                  },
                  builder: (context, state) {
                    if (state is TeachersSpecialistsLoading) {
                      return const Loading();
                    } else {
                      return _specialistsMark
                          ? scrollBarList(specialists, 1, width)
                          : scrollBarList(teachers, 2, width);
                    }
                  },
                ))
          ],
        ),
      ),
    );
  }
}
