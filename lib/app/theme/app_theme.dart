import 'package:flutter/material.dart';

final ThemeData industrialDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF13181C),
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF20A79A),
    onPrimary: Colors.black,
    secondary: Color(0xFF3AAFC4),
    onSecondary: Colors.black,
    surface: Color(0xFF1C2428),
    onSurface: Color(0xFFD3D9DE),
    error: Color(0xFFCC4F4F),
    onError: Colors.black,
    tertiary: Color(0xFF6DBF63),
    onTertiary: Colors.black,
    surfaceContainerHighest: Color(0xFF242E33),
    onSurfaceVariant: Color(0xFFB9C3C9),
    outline: Color(0xFF39464D),
    outlineVariant: Color(0xFF39464D),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFD3D9DE),
    onInverseSurface: Color(0xFF1C2428),
    inversePrimary: Color(0xFF3AAFC4),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1C2428),
    foregroundColor: Color(0xFFD3D9DE),
    elevation: 0,
    centerTitle: false,
  ),
  cardTheme: const CardThemeData(
    color: Color(0xFF1C2428),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      side: BorderSide(color: Color(0xFF39464D), width: 1),
    ),
    elevation: 0,
    margin: EdgeInsets.zero,
  ),
  dataTableTheme: const DataTableThemeData(
    headingRowColor: WidgetStatePropertyAll(Color(0xFF242E33)),
    dataRowColor: WidgetStatePropertyAll(Color(0xFF1C2428)),
    headingTextStyle: TextStyle(
      color: Color(0xFFD3D9DE),
      fontWeight: FontWeight.w600,
    ),
    dataTextStyle: TextStyle(color: Color(0xFFB9C3C9)),
    dividerThickness: .5,
  ),
  chipTheme: const ChipThemeData(
    backgroundColor: Color(0xFF242E33),
    labelStyle: TextStyle(color: Color(0xFFD3D9DE)),
    side: BorderSide(color: Color(0xFF39464D)),
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  ),
elevatedButtonTheme: ElevatedButtonThemeData(
  style: ButtonStyle(
    backgroundColor: const WidgetStatePropertyAll(Color(0xFF1B8F86)),
    foregroundColor: const WidgetStatePropertyAll(Color(0xFFDDE6E6)),
    shape: const WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
    padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    elevation: const WidgetStatePropertyAll(0),
    overlayColor: WidgetStatePropertyAll(
      Color(0xFF16766F),
    ),
  ),
),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1C2428),
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF39464D)),
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF39464D)),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF20A79A), width: 1.2),
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  dividerTheme: const DividerThemeData(color: Color(0xFF39464D), thickness: .6),
  iconTheme: const IconThemeData(color: Color(0xFFB9C3C9)),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontWeight: FontWeight.w700,
      color: Color(0xFFD3D9DE),
    ),
    bodyMedium: TextStyle(color: Color(0xFFB9C3C9)),
    labelLarge: TextStyle(color: Color(0xFF9AA3A9)),
  ),
);
