import 'package:flutter/material.dart';

Widget screenRoute(Widget screen, String linkName, BuildContext context) => GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => screen,
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          linkName,
          textAlign: TextAlign.start,
          style: _defaultMenuTextStyle(),
        ),
      ),
    );

TextStyle _defaultMenuTextStyle() => const TextStyle(
      fontSize: 20,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
      color: Colors.black,
      fontWeight: FontWeight.w400,
    );
