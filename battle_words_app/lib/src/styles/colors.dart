import 'package:flutter/material.dart';

/// coolors.co pallette -> https://coolors.co/5db38c-4d3a47-1f2e34-e6f14a-ffeddf
/// mint                   #5DB38C
/// eggplant               #4D3A47
/// gunmetal               #1F2E34
/// maximum green yellow   #E6F14A
/// linen                  #FFEDDF
/// international orange aerospace #FB5012

final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xff1f2334), //gunmetal
    primary: const Color(0xff5db38c),
    primaryContainer: const Color.fromARGB(255, 66, 128, 100), //mint
    background: const Color(0xff1f2e34), //gunmetal
    onBackground: const Color.fromARGB(255, 46, 68, 76),
    secondary: const Color(0xff4d3a47), //eggplant
    onSecondary: const Color.fromARGB(255, 48, 37, 45),
    tertiary: const Color(0xffe6f64a), //maximum green yellow
    surface: const Color(0xffffeddf), //linen
    inverseSurface: const Color(0xffFB5012),
    surfaceVariant: const Color.fromARGB(255, 202, 64, 14));

final additionalColors = {"darkenedPrimary"};
