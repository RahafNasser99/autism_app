import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/presentation/views/child_views/child_home_page.dart';
import 'package:autism_mobile_app/presentation/views/shared_views/error_login_screen.dart';
import 'package:autism_mobile_app/presentation/views/child_views/child_profile/child_profile_screen.dart';
import 'package:autism_mobile_app/presentation/cubits/get_child_profile_cubits/cubit/get_child_profile_cubit.dart';
import 'package:autism_mobile_app/presentation/cubits/time_cubits/time_exercise_report/cubit/waiting_time_cubit.dart';

class ChildBottomNavigationBar extends StatefulWidget {
  const ChildBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<ChildBottomNavigationBar> createState() =>
      _ChildBottomNavigationBarState();
}

class _ChildBottomNavigationBarState extends State<ChildBottomNavigationBar> {
  int _selectedIndex = 1;
  bool _isInit = true;
  late List<dynamic> _pages;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      await BlocProvider.of<WaitingTimeCubit>(context).getChildWaitingTime();
      _pages = [
        BlocProvider<GetChildProfileCubit>(
          create: (context) => GetChildProfileCubit(),
          child: const ChildProfileScreen(),
        ),
        const ChildHomePage(),
      ];

      _isInit = false;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget _activeIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(1.5),
      margin: const EdgeInsets.only(bottom: 4.0),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<WaitingTimeCubit, WaitingTimeState>(
        listener: (context, state) {
          if (state is WaitingTimeFailed) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => ShowDialog(
                  dialogMessage: state.failedMessage,
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            );
          }
          if (state is WaitingTimeError) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => ShowDialog(
                  dialogMessage: state.errorMessage,
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            );
          }
        },
        builder: (context, state) {
          if (state is WaitingTimeLoading) {
            return const Loading();
          }
          if (state is WaitingTimeDone) {
            return _pages[_selectedIndex];
          } else {
            return const ErrorLoginScreen();
          }
        },
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.black12, spreadRadius: 2.0, blurRadius: 3.0)
        ]),
        child: BottomNavigationBar(
            selectedIconTheme:
                const IconThemeData(color: Colors.blue, size: 30),
            unselectedIconTheme: const IconThemeData(size: 25),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(color: Colors.black),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.person),
                activeIcon: _activeIcon(Icons.person),
                label: 'الملف الشخصي',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: _activeIcon(Icons.home_outlined),
                label: 'الصفحة الرئيسية',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            }),
      ),
    );
  }
}


//  BlocConsumer<GetChildProfileCubit, GetChildProfileState>(
//         listener: (context, state) {
//           if (state is GetChildProfileFailed) {
//             showDialog(
//               context: context,
//               barrierDismissible: false,
//               builder: (context) => ShowDialog(
//                   dialogMessage: state.failedMessage,
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   }),
//             );
//           }
//           if (state is GetChildProfileError) {
//             showDialog(
//               context: context,
//               barrierDismissible: false,
//               builder: (context) => ShowDialog(
//                   dialogMessage: state.errorMessage,
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   }),
//             );
//           }
//         },
//         builder: ((context, state) {
//           if (state is GetChildProfileLoading) {
//             return const Loading();
//           } else if (state is GetChildProfileDone) {
//             return _pages[_selectedIndex];
//           } else {
//             return const ErrorLoginScreen();
//           }
//         }),
//       ),
//       resizeToAvoidBottomInset: false,
//       bottomNavigationBar: Container(
//         decoration: const BoxDecoration(boxShadow: [
//           BoxShadow(color: Colors.black12, spreadRadius: 2.0, blurRadius: 3.0)
//         ]),
//         child: BottomNavigationBar(
//             selectedIconTheme:
//                 const IconThemeData(color: Colors.blue, size: 30),
//             unselectedIconTheme: const IconThemeData(size: 25),
//             selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
//             unselectedLabelStyle: const TextStyle(color: Colors.black),
//             items: <BottomNavigationBarItem>[
//               BottomNavigationBarItem(
//                 icon: const Icon(Icons.person),
//                 activeIcon: _activeIcon(Icons.person),
//                 label: 'الملف الشخصي',
//               ),
//               BottomNavigationBarItem(
//                 icon: const Icon(Icons.home_outlined),
//                 activeIcon: _activeIcon(Icons.home_outlined),
//                 label: 'الصفحة الرئيسية',
//               ),
//             ],
//             currentIndex: _selectedIndex,
//             onTap: (index) {
//               setState(() {
//                 _selectedIndex = index;
//               });
//             }),
//       ),