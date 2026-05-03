import 'package:flutter/material.dart';

class WPTheme {
  static const Color black = Color(0xFF0D0D0D);
  static const Color white = Color(0xFFFAFAF7);
  static const Color offWhite = Color(0xFFF2F2ED);
  static const Color lightGrey = Color(0xFFE8E8E3);
  static const Color midGrey = Color(0xFFB0B0A8);
  static const Color darkGrey = Color(0xFF4A4A44);
  static const Color bamboo = Color(0xFF8B9B6B); // subtle bamboo accent
  static const Color bambooLight = Color(0xFFD4DDB8);
  static const Color urgencyLow = Color(0xFF6B9B6B);
  static const Color urgencyMid = Color(0xFFB8860B);
  static const Color urgencyHigh = Color(0xFFB84040);

  static Color urgencyColor(String urgency) {
    switch (urgency) {
      case 'Medium':
        return urgencyMid;
      case 'Priority':
        return urgencyHigh;
      default:
        return urgencyLow;
    }
  }

  static TextStyle display(double size,
      {Color color = black, FontWeight weight = FontWeight.w900}) {
    return TextStyle(
      fontFamily: 'serif',
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: -0.5,
    );
  }

  static TextStyle label(double size,
      {Color color = darkGrey, FontWeight weight = FontWeight.w600}) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: 1.5,
    );
  }

  static TextStyle body(double size, {Color color = black}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: color,
      height: 1.5,
    );
  }
}
