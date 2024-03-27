import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/domain/models/profile_models/child_profile.dart';
import 'package:autism_mobile_app/presentation/views/family_views/mail/all_mails.dart';
import 'package:autism_mobile_app/domain/models/mail_models/un_read_mails_number.dart';
import 'package:autism_mobile_app/presentation/views/family_views/family_home_page.dart';
import 'package:autism_mobile_app/presentation/views/shared_views/error_login_screen.dart';
import 'package:autism_mobile_app/presentation/cubits/mails_cubits/cubit/inbox_cubit.dart';
import 'package:autism_mobile_app/presentation/cubits/mails_cubits/cubit/get_un_read_messages_cubit.dart';
import 'package:autism_mobile_app/presentation/views/family_views/child_profile/child_profile_family_control.dart';
import 'package:autism_mobile_app/presentation/cubits/get_child_profile_cubits/cubit/get_child_profile_cubit.dart';

class FamilyBottomNavigationBar extends StatefulWidget {
  const FamilyBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<FamilyBottomNavigationBar> createState() =>
      _FamilyBottomNavigationBarState();
}

class _FamilyBottomNavigationBarState extends State<FamilyBottomNavigationBar> {
  int _selectedIndex = 1;
  bool _isInit = true;
  late ChildProfile childProfile;
  late List<dynamic> _pages;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      childProfile = await BlocProvider.of<GetChildProfileCubit>(context)
          .getProfileInformation();
      _pages = [
        BlocProvider<GetChildProfileCubit>(
          create: (context) => GetChildProfileCubit(),
          child: const ChildProfileFamilyControl(),
        ),
        FamilyHomePage(childProfile: childProfile),
        BlocProvider<InboxCubit>(
          create: (context) => InboxCubit(),
          child: const AllMails(),
        ),
      ];

      _isInit = false;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget _activeIcon(Widget icon) {
    return Container(
      padding: const EdgeInsets.all(3.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<GetChildProfileCubit, GetChildProfileState>(
        listener: (context, state) async {
          if (state is GetChildProfileDone) {
            await BlocProvider.of<GetUnReadMessagesCubit>(context)
                .getNumberOfUnreadMessage();
          }
          if (state is GetChildProfileFailed) {
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
          if (state is GetChildProfileError) {
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
        builder: ((context, state) {
          if (state is GetChildProfileLoading) {
            return const Loading();
          } else if (state is GetChildProfileDone) {
            return _pages[_selectedIndex];
          } else {
            return const ErrorLoginScreen();
          }
        }),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar:
          BlocConsumer<GetUnReadMessagesCubit, GetUnReadMessagesState>(
        listener: (context, state) {
          if (state is GetUnReadMessagesFailed) {
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
          if (state is GetUnReadMessagesError) {
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
          if (state is GetUnReadMessagesDone) {
            return BottomNavigationBar(
                elevation: 20.0,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.grey[200],
                selectedIconTheme:
                    const IconThemeData(color: Colors.blue, size: 35),
                unselectedIconTheme: const IconThemeData(size: 30),
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(color: Colors.black),
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.person),
                    activeIcon: _activeIcon(
                      Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    label: 'الملف الشخصي',
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.home_outlined),
                    activeIcon: _activeIcon(
                      Icon(
                        Icons.home_outlined,
                        color: Colors.white,
                      ),
                    ),
                    label: 'الصفحة الرئيسية',
                  ),
                  BottomNavigationBarItem(
                    icon: badges.Badge(
                      showBadge: UnreadMailsNumber.unreadMailsNumber > 0,
                      child: const Icon(Icons.mail_rounded),
                      badgeStyle: badges.BadgeStyle(
                        badgeColor: (UnreadMailsNumber.unreadMailsNumber > 0)
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      badgeContent: Text(
                          UnreadMailsNumber.unreadMailsNumber.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                    activeIcon: _activeIcon(
                      Icon(Icons.mail_rounded, color: Colors.white),
                    ),
                    label: 'البريد',
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: (index) async {
                  setState(() {
                    _selectedIndex = index;
                  });
                  if (_selectedIndex == 1 || _selectedIndex == 2) {
                    await BlocProvider.of<GetUnReadMessagesCubit>(context)
                        .getNumberOfUnreadMessage()
                        .then((value) => setState(() {}));
                  }
                });
          } else {
            return BottomNavigationBar(
                elevation: 20.0,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.grey[200],
                selectedIconTheme:
                    const IconThemeData(color: Colors.blue, size: 35),
                unselectedIconTheme: const IconThemeData(size: 30),
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(color: Colors.black),
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.person),
                    activeIcon: _activeIcon(
                      Icon(
                        Icons.home_outlined,
                        color: Colors.white,
                      ),
                    ),
                    label: 'الملف الشخصي',
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.home_outlined),
                    activeIcon: _activeIcon(
                      Icon(
                        Icons.home_outlined,
                        color: Colors.white,
                      ),
                    ),
                    label: 'الصفحة الرئيسية',
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.mail_rounded),
                    activeIcon: _activeIcon(
                      Icon(
                        Icons.mail_rounded,
                        color: Colors.white,
                      ),
                    ),
                    label: 'البريد',
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                });
          }
        },
      ),
    );
  }
}
