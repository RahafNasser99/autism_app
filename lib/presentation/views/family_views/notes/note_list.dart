import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/app_drawer.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/presentation/widgets/reusable_elevated_button.dart';
import 'package:autism_mobile_app/presentation/views/shared_views/empty_content.dart';
import 'package:autism_mobile_app/presentation/views/family_views/notes/add_note.dart';
import 'package:autism_mobile_app/presentation/views/family_views/notes/note_list_tile.dart';
import 'package:autism_mobile_app/presentation/cubits/notes_cubits/cubit/crud_note_cubit.dart';
import 'package:autism_mobile_app/presentation/cubits/notes_cubits/cubit/notes_list_cubit.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  bool _isInit = true;
  bool _familyNotes = false;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      await BlocProvider.of<NotesListCubit>(context).getFirstPage('center');
      _isInit = false;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> getFamilyNotes() async {
    await BlocProvider.of<NotesListCubit>(context).getFirstPage('family');
  }

  Future<void> getCenterNotes() async {
    await BlocProvider.of<NotesListCubit>(context).getFirstPage('center');
  }

  Future<void> deleteNote(int noteId) async {
    await BlocProvider.of<CrudNoteCubit>(context)
        .deleteNote(noteId)
        .whenComplete(() => getFamilyNotes());
  }

  Widget _addNote(double width, double height) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.15 * height / 4),
      height: 0.5 * height / 4,
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black26))),
      child: Center(
        child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(fixedSize: Size.fromWidth(width - 40)),
            child: const Text(
              'إضافة ملاحظة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => BlocProvider<CrudNoteCubit>(
                  create: (context) => CrudNoteCubit(),
                  child: AddNote(width: width, height: height / 4),
                ),
              ).whenComplete(
                () => getFamilyNotes(),
              );
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'ملاحظات عامة',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
            fontFamily: 'Mirza',
          ),
        ),
      ),
      endDrawer: AppDrawer(isChild: ChildAccount().getIsChild(), width: width),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ReUsableElevatedButton(
                  width: width,
                  title: 'ولي الأمر',
                  mark: _familyNotes,
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(5.0), right: Radius.zero),
                  onPressed: () {
                    if (_familyNotes) {
                      return;
                    } else {
                      setState(() {
                        // _teachersNotes = false;
                        _familyNotes = true;
                      });
                      getFamilyNotes();
                    }
                  },
                ),
                ReUsableElevatedButton(
                  width: width,
                  title: 'المشرفين',
                  mark: !_familyNotes,
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.zero, right: Radius.circular(5.0)),
                  onPressed: () {
                    if (!_familyNotes) {
                      return;
                    } else {
                      setState(() {
                        _familyNotes = false;
                      });
                      getCenterNotes();
                    }
                  },
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              height: 3 * height / 4,
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
              child: BlocConsumer<NotesListCubit, NotesListState>(
                listener: (context, state) {
                  if (state is NotesListFailed) {
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
                  if (state is NotesListError) {
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
                  if (state is NotesListLoading) {
                    return const Loading();
                  } else if (state is NotesListIsEmpty) {
                    return Column(
                      children: <Widget>[
                        SizedBox(
                          height:
                              _familyNotes ? 2.5 * height / 4 : 3 * height / 4,
                          child: EmptyContent(
                            text: (_familyNotes)
                                ? 'أضف بعض الملاحظات'
                                : 'لا يوجد ملاحظات لعرضها',
                            width: width,
                          ),
                        ),
                        Visibility(
                            visible: _familyNotes,
                            child: _addNote(width, height)),
                      ],
                    );
                  } else {
                    return Column(
                      children: <Widget>[
                        SizedBox(
                          height:
                              _familyNotes ? 2.5 * height / 4 : 3 * height / 4,
                          child: ListView.builder(
                              controller: context
                                  .read<NotesListCubit>()
                                  .scrollController,
                              itemCount:
                                  context.read<NotesListCubit>().isLoadingMore
                                      ? state.notes.length + 1
                                      : state.notes.length,
                              itemBuilder: (context, index) {
                                if (index >= state.notes.length) {
                                  return SpinKitThreeInOut(itemBuilder:
                                      (BuildContext context, int index) {
                                    return DecoratedBox(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: index.isEven
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                    );
                                  });
                                } else {
                                  return BlocProvider<CrudNoteCubit>(
                                    create: (context) => CrudNoteCubit(),
                                    child: NoteListTile(
                                      note: state.notes[index],
                                      width: width,
                                      familyMark: _familyNotes,
                                      deleteFunction: deleteNote,
                                    ),
                                  );
                                }
                              }),
                        ),
                        Visibility(
                            visible: _familyNotes,
                            child: _addNote(width, height)),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
