import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/domain/models/need_expression_models/need.dart';
import 'package:autism_mobile_app/domain/models/profile_models/child_profile.dart';
import 'package:autism_mobile_app/presentation/views/shared_views/empty_content.dart';
import 'package:autism_mobile_app/presentation/views/child_views/needs/needs_grid.dart';
import 'package:autism_mobile_app/presentation/cubits/need_section_cubits/cubit/need_section_cubit.dart';
import 'package:autism_mobile_app/presentation/cubits/get_child_profile_cubits/cubit/get_child_profile_cubit.dart';
import 'package:autism_mobile_app/presentation/cubits/needs_expression_cubits/cubit/need_expression_handle_cubit.dart';

class NeedsHomePage extends StatefulWidget {
  const NeedsHomePage({Key? key}) : super(key: key);

  @override
  State<NeedsHomePage> createState() => _NeedsHomePageState();
}

class _NeedsHomePageState extends State<NeedsHomePage> {
  bool _isInit = true;
  late ChildProfile childProfile;
  late List<Need> needs;
  List<Need> selectedNeeds = [];

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      childProfile = await BlocProvider.of<GetChildProfileCubit>(context)
          .getProfileInformation();
      needs = await BlocProvider.of<NeedSectionCubit>(context)
          .getNeeds(1, childProfile.childInformation.childNeedLevel);
      _isInit = false;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _getNewNeeds(int parentNeedId) async {
    needs.clear();
    if (selectedNeeds.length == childProfile.childInformation.childNeedLevel) {
      await _postNeedsExpression();
      return;
    }
    needs = await BlocProvider.of<NeedSectionCubit>(context)
        .getNeeds(parentNeedId, childProfile.childInformation.childNeedLevel)
        .whenComplete(() async {
      if (needs.isEmpty) {
        await _postNeedsExpression();
        return;
      }
    });
  }

  Future<void> _postNeedsExpression() async {
    await BlocProvider.of<NeedExpressionHandleCubit>(context)
        .postNeedExpression(selectedNeeds.last.needId)
        .then((_) async {
      _resetSelectedList();
      await _getNewNeeds(1);
    });
  }

  void _resetSelectedList() {
    selectedNeeds.clear();
  }

  void selectNeeds(Need selectedNeed) {
    setState(() {
      selectedNeeds.add(selectedNeed);
    });
  }

  Widget _needTape(Need? need, double size) {
    return Container(
        width: size - 4,
        height: size - 4,
        margin: const EdgeInsets.symmetric(horizontal: 6.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: Colors.black12),
          image: (need != null && need.needContent.content.contains('.'))
              ? DecorationImage(
                  image: NetworkImage(need.needContent.content),
                  fit: BoxFit.fill)
              : null,
        ),
        child: (need != null && !need.needContent.content.contains('.'))
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.blue[50],
                  child: AutoSizeText(
                    need.needContent.content,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
              )
            : null);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'الاحتياجات',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            fontFamily: 'Mirza',
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.blue),
        actions: [
          BlocConsumer<GetChildProfileCubit, GetChildProfileState>(
            listener: (context, state) {
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
            builder: (context, state) {
              if (state is GetChildProfileDone) {
                return ListView.builder(
                  padding: const EdgeInsets.only(right: 6.0),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (context, index) => Icon(
                    Icons.star_rounded,
                    size: 20,
                    color:
                        (index < childProfile.childInformation.childNeedLevel)
                            ? Colors.blue
                            : Colors.black26,
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/background1.PNG'),
            fit: BoxFit.fill,
          ),
        ),
        child: BlocConsumer<NeedSectionCubit, NeedSectionState>(
          listener: (context, state) {
            if (state is NeedSectionFailed) {
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
            if (state is NeedSectionError) {
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
            if (state is NeedSectionNoNeeds) {
              return Center(
                  child: EmptyContent(
                      text: 'لا يوجد احتياجات لعرضها', width: width));
            } else if (state is NeedSectionDone) {
              return BlocListener<NeedExpressionHandleCubit,
                      NeedExpressionHandleState>(
                  listener: (context, state) {
                    if (state is NeedExpressionHandleFailed) {
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
                    if (state is NeedExpressionHandleError) {
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        height: 3.0 * height / 4,
                        child: BlocProvider<NeedExpressionHandleCubit>.value(
                          value: NeedExpressionHandleCubit(),
                          child: NeedsGrid(
                            needs: needs,
                            width: width,
                            selectNeeds: selectNeeds,
                            getNeeds: _getNewNeeds,
                          ),
                        ),
                      ),
                      Container(
                        height: 0.5 * height / 4,
                        width: width,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 2.0,
                                  spreadRadius: 2.0,
                                  color: Colors.black12)
                            ]),
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Center(
                            child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: selectedNeeds.length,
                          itemBuilder: (context, index) =>
                              _needTape(selectedNeeds[index], 0.5 * height / 4),
                        )),
                      ),
                    ],
                  ));
            } else {
              return const Column();
            }
          },
        ),
      ),
    );
  }
}
