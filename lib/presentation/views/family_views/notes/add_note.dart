import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/presentation/cubits/notes_cubits/cubit/crud_note_cubit.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _note = '';

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    await BlocProvider.of<CrudNoteCubit>(context).addNote(_note);
  }

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
        if (state is CrudNoteDone) {
          Navigator.of(context).pop();
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
        return Form(
          key: _formKey,
          child: AlertDialog(
              elevation: 2.0,
              title: Text(
                'إضافة ملاحظة',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.blue[700],
                  decoration: TextDecoration.underline,
                ),
              ),
              actions: [
                SizedBox(
                  height: widget.height,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      expands: true,
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'اكتب هنا',
                        hintStyle:
                            TextStyle(fontSize: 20, color: Colors.black38),
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                      ),
                      validator: (note) {
                        if (note != null && note.isEmpty) {
                          return 'لا يمكن إرسال ملاحظة فارغة';
                        }
                        return null;
                      },
                      onSaved: (note) {
                        _note = note!;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    child: const Text(
                      'إضافة',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      elevation: 2.0,
                      fixedSize: Size.fromWidth(widget.width / 3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ]),
        );
      },
    );
  }
}
