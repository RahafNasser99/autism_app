import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/presentation/widgets/profile_list_tile.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/domain/models/profile_models/child_profile.dart';
import 'package:autism_mobile_app/presentation/cubits/get_child_profile_cubits/cubit/get_child_profile_cubit.dart';

class ChildProfileScreen extends StatefulWidget {
  const ChildProfileScreen({Key? key}) : super(key: key);

  @override
  State<ChildProfileScreen> createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends State<ChildProfileScreen> {
  final ChildAccount childAccount = ChildAccount();
  late ChildProfile childProfile;
  File? _image;
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
            fontSize: 25,
            fontFamily: 'Mirza',
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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
                },
              ),
            );
          }
          if (state is GetChildProfileFailed) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => ShowDialog(
                dialogMessage: state.failedMessage,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GetChildProfileLoading) {
            return const Loading();
          } else if (state is GetChildProfileDone) {
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
                            fontSize: 30,
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
                          child: (_image != null)
                              ? CircleAvatar(
                                  backgroundImage: FileImage(_image!),
                                )
                              : (childProfile.profilePicture != null)
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
                          // onTap: () {
                          //   _selectImageSource(context, height, width);
                          // }
                        );
                      }),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
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
                          visible: (childProfile.nationality == null)
                              ? false
                              : true,
                          child: ProfileListTile(
                            title: 'الجنسية: ${childProfile.nationality!}',
                            icon: Icons.home_outlined,
                            iconColor: Colors.black87,
                            iconSize: 22,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            onTap: () {},
                          ),
                        ),
                        Visibility(
                          visible: (childProfile.homeAddress == null)
                              ? false
                              : true,
                          child: ProfileListTile(
                            title:
                                'عنوان السكن: ${childProfile.homeAddress!}',
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
                            title: childProfile.getBirthday().isEmpty
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
                          visible: (childProfile.phoneNumber == null)
                              ? false
                              : true,
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
                        ProfileListTile(
                          title: childAccount.email!,
                          icon: Icons.mail_outlined,
                          iconColor: Colors.black87,
                          iconSize: 22,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          onTap: () {},
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
                )
              ],
            );
          } else {
            return const Column();
          }
        },
      ),
    );
  }
}
