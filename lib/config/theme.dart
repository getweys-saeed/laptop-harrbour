import 'package:flutter/material.dart';
import 'package:laptop_harbour/config/colors.dart';
import 'package:laptop_harbour/config/fonts.dart';

var lightTheme = ThemeData(
    useMaterial3: true,
    textTheme: lightFont,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
        surface: surface,
        onSurface: onSurface,
        primary: primaryColor,
        onPrimary: onPrimaryColor,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondaryColor,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer));

var darkTheme = ThemeData(
    useMaterial3: true,
    textTheme: darkFont,
    // brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
        surface: surfaceDark,
        onSurface: onSurfaceDark,
        primary: primaryColorDark,
        onPrimary: onPrimaryColorDark,
        primaryContainer: primaryContainerDark,
        onPrimaryContainer: onPrimaryContainerDark,
        secondary: secondaryColorDark,
        onSecondary: onSecondaryDark,
        secondaryContainer: secondaryContainerDark,
        onSecondaryContainer: onSecondaryContainerDark));
