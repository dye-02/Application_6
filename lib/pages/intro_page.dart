import 'package:flutter/material.dart';
import 'package:flutter_application_6/main.dart';

class IntroPage extends StatelessWidget{
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Intro Page")),
      body: Center(
        child: ElevatedButton(
          child: const Text("Go home"),
          onPressed: () {
            //go to home page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieListScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}