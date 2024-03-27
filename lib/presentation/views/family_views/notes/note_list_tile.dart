import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:autism_mobile_app/domain/models/note_models/note.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/presentation/cubits/notes_cubits/cubit/crud_note_cubit.dart';
import 'package:autism_mobile_app/presentation/views/family_views/teachers_specialists/teacher_specialist_profile.dart';

class NoteListTile extends StatelessWidget {
  const NoteListTile({
    super.key,
    required this.note,
    required this.width,
    required this.familyMark,
    required this.deleteFunction,
  });

  final Note note;
  final double width;
  final bool familyMark;
  final Function deleteFunction;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CrudNoteCubit, CrudNoteState>(
      listener: (context, state) {
        if (state is CrudNoteFailed) {
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
        if (state is CrudNoteError) {
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
      },
      builder: (context, state) {
        if (state is CrudNoteLoading) {
          return SpinKitThreeInOut(
              itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index.isEven ? Colors.blue : Colors.grey,
              ),
            );
          });
        }
        return Container(
          width: width,
          padding: const EdgeInsets.only(top: 12.0, bottom: 18.0),
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black26))),
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${note.noteDate.year}/${note.noteDate.month}/${note.noteDate.day}',
                    style: TextStyle(fontSize: 15, color: Colors.blue[900]),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Row(
                    children: [
                      TextButton(
                        child: Text(
                          (note.teacherSpecialistAccount == null)
                              ? 'ولي الأمر'
                              : note.teacherSpecialistAccount!
                                  .teacherSpecialistProfile
                                  .getFullName(),
                          style:
                              TextStyle(fontSize: 20, color: Colors.blue[900]),
                        ),
                        onPressed: () {
                          if (note.teacherSpecialistAccount != null) {
                            Navigator.of(context).push(
                              PageTransition(
                                child: TeacherSpecialistProfile(
                                  teacherSpecialistAccount:
                                      note.teacherSpecialistAccount!,
                                ),
                                type: PageTransitionType.rightToLeft,
                                duration: const Duration(milliseconds: 500),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      familyMark
                          ? CircleAvatar(
                              backgroundImage:
                                  (ChildAccount().childProfile != null &&
                                          ChildAccount()
                                                  .childProfile
                                                  ?.profilePicture !=
                                              null)
                                      ? NetworkImage(ChildAccount()
                                          .childProfile!
                                          .profilePicture!)
                                      : null,
                              child: (ChildAccount().childProfile == null ||
                                      ChildAccount()
                                              .childProfile
                                              ?.profilePicture ==
                                          null)
                                  ? const Icon(Icons.person)
                                  : null,
                            )
                          : InkWell(
                              child: CircleAvatar(
                                backgroundImage:
                                    (note.teacherSpecialistAccount != null &&
                                            note
                                                    .teacherSpecialistAccount
                                                    ?.teacherSpecialistProfile
                                                    .profilePicture !=
                                                null)
                                        ? NetworkImage(note
                                            .teacherSpecialistAccount!
                                            .teacherSpecialistProfile
                                            .profilePicture!)
                                        : null,
                                child: (note.teacherSpecialistAccount == null ||
                                        note
                                                .teacherSpecialistAccount
                                                ?.teacherSpecialistProfile
                                                .profilePicture ==
                                            null)
                                    ? const Icon(Icons.person)
                                    : null,
                              ),
                              onTap: () {
                                if (note.teacherSpecialistAccount != null) {
                                  Navigator.of(context).push(
                                    PageTransition(
                                      child: TeacherSpecialistProfile(
                                        teacherSpecialistAccount:
                                            note.teacherSpecialistAccount!,
                                      ),
                                      type: PageTransitionType.rightToLeft,
                                      duration:
                                          const Duration(milliseconds: 500),
                                    ),
                                  );
                                }
                              },
                            ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: familyMark
                  ? const EdgeInsets.only(right: 16.0, top: 10.0)
                  : const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
              child: familyMark
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          alignment: Alignment.topLeft,
                          icon: const Icon(
                            Icons.delete_rounded,
                            size: 40,
                            color: Colors.black26,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                  'حذف الملاحظة',
                                  textAlign: TextAlign.center,
                                ),
                                titleTextStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                content: const Text(
                                  'هل أنت متأكد أنك تريد حذف هذه الملاحظة',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                contentTextStyle: const TextStyle(
                                    color: Colors.black, fontSize: 20),
                                actionsAlignment:
                                    MainAxisAlignment.spaceBetween,
                                actions: [
                                  ElevatedButton(
                                    child: const Text(
                                      'الغاء',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size.fromWidth(width / 3),
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    child: const Text(
                                      'حسناً',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onPressed: () {
                                      deleteFunction(note.id);
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size.fromWidth(width / 3),
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: (3 * width / 4) - 10,
                          child: AutoSizeText(
                            note.noteText,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.blue),
                          ),
                        ),
                      ],
                    )
                  : AutoSizeText(
                      note.noteText,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 20, color: Colors.blue),
                    ),
            ),
          ]),
        );
      },
    );
  }
}
