import 'package:flutter/material.dart';

import 'package:autism_mobile_app/domain/models/exercise_models/items_matching.dart';

class ItemsMatchingTask extends StatelessWidget {
  const ItemsMatchingTask({super.key, required this.exercise});

  final ItemsMatchingExercise exercise;

  Widget _image(String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        SizedBox(
          width: width / 4.1,
          height: width / 4.1,
          child: _image(exercise.mainItem),
        ),
        const SizedBox(
          height: 20.0,
        ),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 25.0,
          ),
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: exercise.itemsUrl.length,
          itemBuilder: (context, index) => _image(exercise.itemsUrl[index]),
        ),
      ],
    );
  }
}
