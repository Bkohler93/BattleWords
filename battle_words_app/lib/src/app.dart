import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/features/home_screen/presentation/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO with lazy set to false, will have to include some loading mechanism to avoid jank while ObjectBox is being initialized
    // debugPaintSizeEnabled = true;
    return Sizer(builder: (context, orientation, deviceType) {
      return RepositoryProvider(
        lazy: false,
        create: (context) => ObjectBoxStore(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
          ),
          home: HomePage(),
        ),
      );
    });
  }
}
