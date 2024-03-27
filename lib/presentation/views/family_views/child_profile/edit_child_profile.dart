import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/presentation/cubits/edit_profile_cubits/cubit/edit_profile_cubit.dart';

class EditChildProfile extends StatefulWidget {
  const EditChildProfile({Key? key}) : super(key: key);

  @override
  State<EditChildProfile> createState() => _EditChildProfileState();
}

class _EditChildProfileState extends State<EditChildProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  File? _image;
  String? _imageUrl;
  String? _phoneNumber;
  bool _isInit = true;
  bool _editImage = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      var data =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      _imageUrl = data['profilePicture'];
      _phoneNumber = data['phoneNumber'];
    }
    print(_imageUrl);
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    await BlocProvider.of<EditProfileCubit>(context).editProfile(
        _phoneNumber, _image?.path, _image?.path.split('/').last, _editImage);
  }

  Future<void> _pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      setState(() {
        _editImage = true;
        _image = img;
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  Widget _iconElevatedButton(String labelText, IconData icon, double width,
      void Function() onPressed) {
    return ElevatedButton.icon(
      label: Text(
        labelText,
        style: const TextStyle(color: Colors.black, fontSize: 18),
      ),
      icon: Icon(
        icon,
        color: Colors.black,
      ),
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Colors.black54)),
          fixedSize: Size(width - 20, 20)),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocConsumer<EditProfileCubit, EditProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 2.0,
            centerTitle: true,
            title: const Text(
              'تعديل الملف الشخصي',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                fontFamily: 'Mirza',
              ),
            ),
          ),
          body: BlocConsumer<EditProfileCubit, EditProfileState>(
            listener: (context, state) {
              if (state is EditProfileFailed) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => ShowDialog(
                      dialogMessage: state.failedMessage,
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                );
              } else if (state is EditProfileError) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => ShowDialog(
                      dialogMessage: state.errorMessage,
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                );
              } else if (state is EditProfileDone) {
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              if (state is EditProfileLoading) {
                return const Loading();
              }
              return SingleChildScrollView(
                child: Container(
                  height: 0.9 * height,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/backgrounds/background1.PNG'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: height / 3 - 30,
                          width: 2 * width / 4 - 30,
                          margin: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5,
                                  color: Colors.lightBlue,
                                  spreadRadius: 0.5)
                            ],
                          ),
                          child: _image != null
                              ? CircleAvatar(
                                  backgroundImage: FileImage(_image!),
                                )
                              : _imageUrl == null
                                  ? const CircleAvatar(
                                      child: Icon(
                                        Icons.person,
                                        size: 70,
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundImage: NetworkImage(_imageUrl!),
                                    ),
                        ),
                        _iconElevatedButton(
                          'إزالة الصورة',
                          Icons.image_not_supported_outlined,
                          width,
                          () {
                            setState(() {
                              _editImage = true;
                              _image = null;
                              _imageUrl = null;
                            });
                          },
                        ),
                        _iconElevatedButton(
                          'التقاط صورة',
                          Icons.camera_alt_outlined,
                          width,
                          () {
                            _pickImage(ImageSource.camera);
                          },
                        ),
                        _iconElevatedButton(
                          'اختيار صورة من الاستديو',
                          Icons.image_outlined,
                          width,
                          () {
                            _pickImage(ImageSource.gallery);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const AutoSizeText(
                          'تعديل رقم الهاتف',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          initialValue: _phoneNumber,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            hintText: 'ابدأ بـِ 09',
                            hintStyle: TextStyle(fontSize: 18),
                            contentPadding:
                                EdgeInsets.only(left: 10.0, top: 10.0),
                          ),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (phoneNumber) {
                            if (phoneNumber != null &&
                                phoneNumber.isNotEmpty &&
                                (phoneNumber.length < 10 ||
                                    phoneNumber.length > 10)) {
                              return 'تأكد من صحة الرقم';
                            } else if (phoneNumber != null &&
                                phoneNumber.isNotEmpty &&
                                (phoneNumber[0] != '0' ||
                                    phoneNumber[1] != '9')) {
                              return 'يجب أن تبدأ بـِ (09)';
                            }
                            return null;
                          },
                          onSaved: (phoneNumber) {
                            _phoneNumber = phoneNumber;
                          },
                          onChanged: (phoneNumber) {
                            _phoneNumber = phoneNumber;
                          },
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              child: const Text(
                                'تأكيد',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(color: Colors.blue)),
                              ),
                              onPressed: _submit,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
