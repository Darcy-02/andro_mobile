import 'package:flutter/material.dart';
import 'app_colors.dart';

@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color bgPrimary;
  final Color bgSurface;
  final Color bgElevated;
  final Color accent;
  final Color accentMuted;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color success;
  final Color danger;
  final Color goingTint;
  final Color interestedTint;

  const AppThemeColors({
    required this.bgPrimary,
    required this.bgSurface,
    required this.bgElevated,
    required this.accent,
    required this.accentMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.success,
    required this.danger,
    required this.goingTint,
    required this.interestedTint,
  });

  static const dark = AppThemeColors(
    bgPrimary: AppColors.darkBgPrimary,
    bgSurface: AppColors.darkBgSurface,
    bgElevated: AppColors.darkBgElevated,
    accent: AppColors.darkAccent,
    accentMuted: AppColors.darkAccentMuted,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    border: AppColors.darkBorder,
    success: AppColors.darkSuccess,
    danger: AppColors.darkDanger,
    goingTint: AppColors.darkGoingTint,
    interestedTint: AppColors.darkInterestedTint,
  );

  static const light = AppThemeColors(
    bgPrimary: AppColors.lightBgPrimary,
    bgSurface: AppColors.lightBgSurface,
    bgElevated: AppColors.lightBgElevated,
    accent: AppColors.lightAccent,
    accentMuted: AppColors.lightAccentMuted,
    textPrimary: AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
    border: AppColors.lightBorder,
    success: AppColors.lightSuccess,
    danger: AppColors.lightDanger,
    goingTint: AppColors.lightGoingTint,
    interestedTint: AppColors.lightInterestedTint,
  );

  @override
  AppThemeColors copyWith({
    Color? bgPrimary,
    Color? bgSurface,
    Color? bgElevated,
    Color? accent,
    Color? accentMuted,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? success,
    Color? danger,
    Color? goingTint,
    Color? interestedTint,
  }) =>
      AppThemeColors(
        bgPrimary: bgPrimary ?? this.bgPrimary,
        bgSurface: bgSurface ?? this.bgSurface,
        bgElevated: bgElevated ?? this.bgElevated,
        accent: accent ?? this.accent,
        accentMuted: accentMuted ?? this.accentMuted,
        textPrimary: textPrimary ?? this.textPrimary,
        textSecondary: textSecondary ?? this.textSecondary,
        border: border ?? this.border,
        success: success ?? this.success,
        danger: danger ?? this.danger,
        goingTint: goingTint ?? this.goingTint,
        interestedTint: interestedTint ?? this.interestedTint,
      );

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      bgPrimary: Color.lerp(bgPrimary, other.bgPrimary, t)!,
      bgSurface: Color.lerp(bgSurface, other.bgSurface, t)!,
      bgElevated: Color.lerp(bgElevated, other.bgElevated, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentMuted: Color.lerp(accentMuted, other.accentMuted, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      goingTint: Color.lerp(goingTint, other.goingTint, t)!,
      interestedTint: Color.lerp(interestedTint, other.interestedTint, t)!,
    );
  }
}

class AppTheme {
  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBgPrimary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.darkAccent,
          surface: AppColors.darkBgSurface,
          error: AppColors.darkDanger,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
          titleTextStyle: TextStyle(
            color: AppColors.darkTextPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        dividerColor: AppColors.darkBorder,
        extensions: const [AppThemeColors.dark],
      );

  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBgPrimary,
        colorScheme: const ColorScheme.light(
          primary: AppColors.lightAccent,
          surface: AppColors.lightBgSurface,
          error: AppColors.lightDanger,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
          titleTextStyle: TextStyle(
            color: AppColors.lightTextPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        dividerColor: AppColors.lightBorder,
        extensions: const [AppThemeColors.light],
      );
}
