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
  primary: const Color(0xff5db38c), //mint
  background: const Color(0xff1f2e34), //gunmetal
  secondary: const Color(0xff4d3a47), //eggplant
  tertiary: const Color(0xffe6f64a), //maximum green yellow
  surface: const Color(0xffffeddf), //linen
  inverseSurface: const Color(0xffFB5012),
);
