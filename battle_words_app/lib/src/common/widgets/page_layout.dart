import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ScreenLayout extends StatelessWidget {
  const ScreenLayout({super.key, required this.child, required this.menuPage});
  final Widget child;
  final bool menuPage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Padding(
              padding: menuPage
                  ? (SizerUtil.deviceType == DeviceType.mobile
                      ? const EdgeInsets.all(14.0)
                      : const EdgeInsets.all(22.0))
                  : const EdgeInsets.all(0.0),
              child: child),
        ),
      ),
    );
  }
}
