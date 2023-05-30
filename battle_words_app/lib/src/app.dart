import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/api/shared_preferences/cubit/settings_cubit.dart';
import 'package:battle_words/src/routes.dart';
import 'package:battle_words/src/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // debugPaintSizeEnabled = true;
    final store = ref.watch(objectBoxStoreProvider);
    store.initialize(); //initialize store to be used throughout main isolate

    return Sizer(
      builder: (context, orientation, deviceType) {
        return BlocProvider<SettingsCubit>(
          lazy: false,
          //change to `..resetSettings()` if needing to test single player tutorial
          create: (context) => SettingsCubit()..loadSettings(),
          child: MaterialApp.router(
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            theme: themeData,
            // home: HomeScreen(),
          ),
        );
      },
    );
  }
}
