import 'package:flutter/material.dart';
import 'package:go_router_flow/go_router_flow.dart';

Widget screenRoute(
  String path,
  String linkName,
  BuildContext context, {
  void Function()? onReturn,
}) =>
    GestureDetector(
      onTap: () async {
        if (onReturn == null) {
          context.go(path);
        } else {
          final bool? load = await context.push<bool>(path);

          if (load ?? false) {
            onReturn();
          }
        }
      },
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
      fontWeight: FontWeight.w400,
    );
