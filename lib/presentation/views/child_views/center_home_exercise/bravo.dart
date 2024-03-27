import 'package:flutter/material.dart';

class Bravo extends StatelessWidget {
  const Bravo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/backgrounds/background.PNG'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              const Text('أحسنت',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 60,
                      fontFamily: 'Marhey',
                      shadows: [
                        Shadow(
                          blurRadius: 8.0,
                          color: Colors.amber,
                        )
                      ])),
              const SizedBox(
                height: 10,
              ),
              Hero(
                tag: 'bravo',
                child: Image.asset(
                  'assets/images/tasks/bravo.jpg',
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ));
  }
}
