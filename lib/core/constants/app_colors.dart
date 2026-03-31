import 'package:flutter/material.dart';

class AppColors {
  /// private constructor a class no koi out side object create na kari sake ane aa class ma normal variable, methods hoy to tene
  /// aa object no used kari koi pon jagya par used kari sakay ane aa class no koi other object create na kari sakay error aapse private constructor se etle.

  AppColors._();
  static const Color primary = Color(0xFF5698DA); // તમારો મેઈન કલર
  static const Color bgColor = Color(0xFFA1C1D0); // તમારો મેઈન કલર
  static const Color primaryLight = Color(0xFF0707EC); // થોડો આછો કલર
  static const Color white = Color(0xFFFFFFFF);
  static const Color prim = Color(0xFF5CB8F1); // તમારો મેઈન કલર
  static const Color primLight = Color(0xFF07CAEC); // થોડો આછો કલર

  static const Color red = Color(0xFFE89B9B);
  static const Color yellow = Color(0xFFFFFF00);
  static const Color green = Color(0xFF4CAF50);
  static const Color black = Color(0xFF000000);
  static const Color gray = Color(0xDB312D2D);

  // ૧. દિવસ માટે (Day)
  static const LinearGradient dayGradient = LinearGradient(
    colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient unSelected = LinearGradient(
    colors: [bgColor, prim],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient selected = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  // ૨. રાત માટે (Night)
  static const LinearGradient nightGradient = LinearGradient(
    colors: [Color(0xFF243b55), Color(0xFF141e30)],
  );

  // ૩. વરસાદ માટે (Rainy)
  static const LinearGradient rainyGradient = LinearGradient(
    colors: [Color(0xFF616161), Color(0xFF9bc5c3)],
  );
}
