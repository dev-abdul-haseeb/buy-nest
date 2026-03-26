import 'package:flutter/material.dart';
enum appColors{
  primaryColor,
  accentColor,
  appBGColor,
  cardColor,
  errorColor,
  incomeColor,
  textPrimaryColor,
  textSecondaryColor,
}

class AppColors {
  static const Map<appColors, Color> lightTheme = {
    appColors.primaryColor       : Color(0xFF5D7ADD),          //Navy: For appbar, icons, main UI
    appColors.accentColor        : Color(0xFFD4AF37),           //Gold: Buttons, highlights, active tabs
    appColors.appBGColor         : Color(0xFFE1E4E8),            //Light grey: For background
    appColors.cardColor          : Color(0xFFFFFFFF),             //White: For cards and containers
    appColors.errorColor         : Colors.red,          //Soft red: For expense
    appColors.incomeColor        : Color(0xFF22C55E),           //Fresh green: For income
    appColors.textPrimaryColor   : Color(0xFF0F172A),
    appColors.textSecondaryColor : Color(0xFF64748B),
  };

  static const Map<appColors, Color> darkTheme = {
    appColors.primaryColor       : Color(0xFF3B5FCC),
    appColors.accentColor        : Color(0xFFD4AF37),
    appColors.appBGColor         : Color(0xFF0F172A),
    appColors.cardColor          : Color(0xFF1E293B),
    appColors.errorColor         : Colors.red,
    appColors.incomeColor        : Color(0xFF4ADE80),
    appColors.textPrimaryColor   : Color(0xFFF1F5F9),
    appColors.textSecondaryColor : Color(0xFF94A3B8),
  };
}