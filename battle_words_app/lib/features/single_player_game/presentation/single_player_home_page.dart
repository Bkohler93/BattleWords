import 'package:flutter/material.dart';

class SinglePlayerHomePage extends StatefulWidget {
  const SinglePlayerHomePage({super.key});

  @override
  State<SinglePlayerHomePage> createState() => SinglePlayerHomePageState();
}

class SinglePlayerHomePageState extends State<SinglePlayerHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Text("Single Player Home Page"),
        ),
      ),
    );
  }
}
