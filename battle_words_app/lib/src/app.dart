import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/api/shared_preferences/cubit/settings_cubit.dart';
import 'package:battle_words/src/features/home_screen/home.dart';
import 'package:battle_words/src/features/multiplayer/data/repository.dart';
import 'package:battle_words/src/routes.dart';
import 'package:battle_words/src/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // debugPaintSizeEnabled = true;
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            lazy: false,
            create: (context) => ObjectBoxStore.createSync(),
          ),
        ],
        child: BlocProvider<SettingsCubit>(
          lazy: false,
          //change to `..resetSettings()` if needing to test single player tutorial
          create: (context) => SettingsCubit()..loadSettings(),
          child: MaterialApp.router(
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            theme: themeData,
            // home: HomeScreen(),
          ),
        ),
      );
    });
  }
}
