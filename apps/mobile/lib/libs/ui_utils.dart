import 'package:flutter/material.dart';

Size getScreenSize(BuildContext context) => MediaQuery.sizeOf(context);

ColorScheme getColorScheme(BuildContext context) =>
    Theme.of(context).colorScheme;

TextTheme getTextTheme(BuildContext context) => Theme.of(context).textTheme;
