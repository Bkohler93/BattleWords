import 'package:battle_words/src/styles/colors.dart';
import 'package:flutter/material.dart';

final ThemeData themeData = ThemeData(
    appBarTheme: AppBarTheme(
      actionsIconTheme: IconThemeData(
        color: colorScheme.surface,
        opacity: 1.0,
        shadows: null,
        size: null,
      ),
      backgroundColor: colorScheme.secondary,
      centerTitle: false,
      elevation: null,
      scrolledUnderElevation: null,
      foregroundColor: null,
      toolbarHeight: null,
      iconTheme: null,
      shadowColor: null,
      shape: null,
      surfaceTintColor: null,
      titleSpacing: null,
      titleTextStyle: null,
      toolbarTextStyle: null,
    ),
    applyElevationOverlayColor: null,
    bannerTheme: null,
    bottomAppBarTheme: null,
    bottomNavigationBarTheme: null,
    bottomSheetTheme: null,
    brightness: null,
    buttonBarTheme: null,
    buttonTheme: null,
    canvasColor: null,
    cardColor: colorScheme.surface,
    cardTheme: null,
    checkboxTheme: null,
    chipTheme: null,
    colorScheme: colorScheme,
    colorSchemeSeed: null,
    cupertinoOverrideTheme: null,
    dataTableTheme: null,
    dialogBackgroundColor: null,
    dialogTheme: null,
    disabledColor: colorScheme.secondary,
    dividerColor: null,
    dividerTheme: null,
    drawerTheme: null,
    elevatedButtonTheme: null,
    expansionTileTheme: null,
    extensions: null,
    floatingActionButtonTheme: null,
    focusColor: null,
    fontFamily: null,
    highlightColor: null,
    hintColor: null,
    hoverColor: null,
    secondaryHeaderColor: null,
    iconTheme: const IconThemeData(color: Colors.white),
    indicatorColor: null,
    inputDecorationTheme: null,
    listTileTheme: null,
    materialTapTargetSize: null,
    navigationBarTheme: null,
    navigationRailTheme: null,
    outlinedButtonTheme: null,
    pageTransitionsTheme: null,
    platform: null,
    popupMenuTheme: null,
    primaryColor: colorScheme.primary,
    primaryColorDark: null,
    primaryColorLight: null,
    primaryIconTheme: null,
    primarySwatch: null,
    primaryTextTheme: null,
    progressIndicatorTheme: null,
    radioTheme: null,
    scaffoldBackgroundColor: colorScheme.background,
    scrollbarTheme: null,
    shadowColor: colorScheme.primary,
    sliderTheme: null,
    snackBarTheme: null,
    splashColor: null,
    splashFactory: null,
    switchTheme: null,
    tabBarTheme: null,
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(
            fontSize: 16,
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          colorScheme.secondary,
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    ),
    textSelectionTheme: null,
    textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 24),
            displayMedium: TextStyle(fontSize: 16),
            displaySmall: TextStyle(fontSize: 24),
            bodyLarge: TextStyle(fontSize: 24),
            bodyMedium: TextStyle(fontSize: 16),
            bodySmall: TextStyle(fontSize: 12))
        .apply(
      bodyColor: colorScheme.surface,
      displayColor: colorScheme.surface,
    ),
    timePickerTheme: null,
    toggleButtonsTheme: null,
    tooltipTheme: null,
    typography: null,
    unselectedWidgetColor: null,
    useMaterial3: null,
    visualDensity: null);
