import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/presentation/widgets/profile_list_tile.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/domain/models/profile_models/child_profile.dart';
import 'package:autism_mobile_app/presentation/cubits/get_child_profile_cubits/cubit/get_child_profile_cubit.dart';

class ChildProfileFamilyControl extends StatefulWidget {
  const ChildProfileFamilyControl({Key? key}) : super(key: key);

  @override
  State<ChildProfileFamilyControl> createState() =>
      _ChildProfileFamilyControlState();
}

class _ChildProfileFamilyControlState extends State<ChildProfileFamilyControl> {
  final ChildAccount childAccount = ChildAccount();
  late ChildProfile childProfile;

  var _isInit = true;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      childProfile = await BlocProvider.of<GetChildProfileCubit>(context)
          .getProfileInformation();
      _isInit = false;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'الملف الشخصي',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Mirza',
            fontSize: 25,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: <Widget>[
          PopupMenuButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.account_circle,
                          color: Colors.orange,
                        ),
                        Text(
                          'تعديل الملف الشخصي',
                        ),
                      ],
                    ),
                    textStyle: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.verified_user_rounded,
                          color: Colors.greenAccent[400],
                        ),
                        const Text(
                          'الخصوصية والأمان',
                        ),
                      ],
                    ),
                    textStyle:
                        const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ];
              },
              onSelected: (int choice) {
                switch (choice) {
                  case 1:
                    Navigator.of(context)
                        .pushNamed('/edit-child-profile-screen', arguments: {
                      'profilePicture': childProfile.profilePicture,
                      'phoneNumber': childProfile.phoneNumber,
                    }).then(
                      (_) async => childProfile =
                          await BlocProvider.of<GetChildProfileCubit>(context)
                              .getProfileInformation(),
                    );
                    break;
                  case 2:
                    Navigator.of(context).pushNamed('/update-passwords-screen');
                    break;
                }
              }),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<GetChildProfileCubit, GetChildProfileState>(
        listener: (context, state) {
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
        builder: (context, state) {
          if (state is GetChildProfileLoading) {
            return const Loading();
          }
          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: height / 4 - 20,
                    width: 3 * width / 5 - 20,
                    padding: EdgeInsets.only(top: (height / 16)),
                    child: ListTile(
                      title: AutoSizeText(
                        childProfile.getFullName(),
                        style: const TextStyle(
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Mirza',
                        ),
                        textAlign: TextAlign.right,
                        maxLines: 2,
                      ),
                      subtitle: AutoSizeText(
                        childAccount.userName!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          fontFamily: 'Mirza',
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  Container(
                    height: height / 4 - 30,
                    width: 2 * width / 5 - 30,
                    margin: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 5.0,
                            color: Colors.lightBlue,
                            spreadRadius: 0.5)
                      ],
                    ),
                    child: Builder(builder: (context) {
                      return GestureDetector(
                          child: (childProfile.profilePicture != null)
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      childProfile.profilePicture!),
                                )
                              : const CircleAvatar(
                                  child: Icon(
                                    Icons.person,
                                    size: 60,
                                  ),
                                ),
                          onTap: () {
                            // view image
                          });
                    }),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        ProfileListTile(
                          title:
                              'اسم ولي الأمر: ${childProfile.childInformation.fatherName}',
                          icon: Icons.group_outlined,
                          iconColor: Colors.black87,
                          iconSize: 22,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          onTap: () {},
                        ),
                        ProfileListTile(
                          title:
                              'اسم الأم: ${childProfile.childInformation.motherName}',
                          icon: Icons.group_outlined,
                          iconColor: Colors.black87,
                          iconSize: 22,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          onTap: () {},
                        ),
                        Visibility(
                          visible:
                              (childProfile.nationality == null) ? false : true,
                          child: ProfileListTile(
                            title: 'الجنسية ${childProfile.nationality!}',
                            icon: Icons.home_outlined,
                            iconColor: Colors.black87,
                            iconSize: 22,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            onTap: () {},
                          ),
                        ),
                        Visibility(
                          visible:
                              (childProfile.homeAddress == null) ? false : true,
                          child: ProfileListTile(
                            title: 'عنوان السكن: ${childProfile.homeAddress!}',
                            icon: Icons.location_city_outlined,
                            iconColor: Colors.black87,
                            iconSize: 22,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            onTap: () {},
                          ),
                        ),
                        Visibility(
                          visible: (childProfile.getBirthday().isEmpty)
                              ? false
                              : true,
                          child: ProfileListTile(
                            title: (childProfile.getBirthday().isEmpty)
                                ? ''
                                : 'تاريخ الميلاد: ${childProfile.getBirthday()}',
                            icon: Icons.date_range_outlined,
                            iconColor: Colors.black87,
                            iconSize: 22,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            onTap: () {},
                          ),
                        ),
                        Visibility(
                          visible:
                              (childProfile.phoneNumber == null) ? false : true,
                          child: ProfileListTile(
                            title: childProfile.phoneNumber == null
                                ? ''
                                : childProfile.phoneNumber!,
                            icon: Icons.phone_enabled_outlined,
                            iconColor: Colors.black87,
                            iconSize: 22,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            onTap: () {},
                          ),
                        ),
                        Visibility(
                          visible: (childAccount.email == null) ? false : true,
                          child: ProfileListTile(
                            title: childAccount.email!,
                            icon: Icons.mail_outlined,
                            iconColor: Colors.black87,
                            iconSize: 22,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            onTap: () {},
                          ),
                        ),
                        ProfileListTile(
                          title:
                              'مستوى التعبير عن الاحتياجات: ${childProfile.childInformation.getNeedsLevel()}',
                          icon: Icons.star_border_rounded,
                          iconColor: Colors.black87,
                          iconSize: 22,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
