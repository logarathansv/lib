import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF2F4757);

const kSecondaryColor = Color(0xFF34495E);

const kHighLightColor = Color(0xFFE8F5E9);

const kAccentColor = Color(0xFFF4C345);

const kTextColor = Color(0xFF2C3E50);

const kSecondaryAccent = Color(0xFF95A5A6);

const kTextFieldStyle = TextStyle(
  fontSize: 14.5,
  fontWeight: FontWeight.w500,
  height: 1.4,
  color: kTextColor,
);

const kLabelStyle = TextStyle(
  color: kSecondaryAccent,
  fontSize: 13.0,
  fontWeight: FontWeight.bold,
);

const kSectionHeaderStyle = TextStyle(
  fontSize: 17.0,
  fontWeight: FontWeight.bold,
  color: kPrimaryColor,
);

const kSubTitleStyle = TextStyle(
  color: kSecondaryAccent,
  fontSize: 13.0,
  fontWeight: FontWeight.w500,
);

final kCustomThemeData = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: kPrimaryColor,
    secondary: kSecondaryColor,
    surface: Colors.white,
    background: kHighLightColor,
    error: Colors.red.shade700,
  ),
  iconTheme: IconThemeData(color: kSecondaryColor),
  navigationBarTheme: NavigationBarThemeData(
    elevation: 10.0,
    height: 70.0,
    iconTheme: WidgetStatePropertyAll(
      IconThemeData(color: kSecondaryColor),
    ),
    indicatorColor: kAccentColor,
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
  ),
  tabBarTheme: TabBarTheme(
    labelColor: kPrimaryColor,
    indicatorColor: kAccentColor,
    dividerColor: kHighLightColor,
    labelStyle: TextStyle(fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    prefixIconColor: kSecondaryAccent,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: kSecondaryAccent),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: kSecondaryAccent),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: kPrimaryColor, width: 2),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kPrimaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: kPrimaryColor,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
);
