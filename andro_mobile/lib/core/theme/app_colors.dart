import 'package:flutter/material.dart';

class AppColors {
  // ── Dark mode ─────────────────────────────────────────────────────────────
  static const darkBgPrimary      = Color(0xFF0C0C0C);
  static const darkBgSurface      = Color(0xFF161616);
  static const darkBgElevated     = Color(0xFF202020);
  static const darkAccent         = Color(0xFFD4D4D4);
  static const darkAccentMuted    = Color(0x2AD4D4D4);
  static const darkTextPrimary    = Color(0xFFF5F5F5);
  static const darkTextSecondary  = Color(0xFF666666);
  static const darkBorder         = Color(0xFF2A2A2A);
  static const darkSuccess        = Color(0xFF3FB950);
  static const darkDanger         = Color(0xFFF85149);
  static const darkGoingTint      = Color(0xFF1A2A1A);
  static const darkInterestedTint = Color(0xFF2A2218);

  // ── Light mode ────────────────────────────────────────────────────────────
  static const lightBgPrimary      = Color(0xFFFAFAF9);
  static const lightBgSurface      = Color(0xFFFFFFFF);
  static const lightBgElevated     = Color(0xFFF0EDEA);
  static const lightAccent         = Color(0xFF0A0A0A);
  static const lightAccentMuted    = Color(0x220A0A0A);
  static const lightTextPrimary    = Color(0xFF0A0A0A);
  static const lightTextSecondary  = Color(0xFF9A9A95);
  static const lightBorder         = Color(0xFFE0DDD8);
  static const lightSuccess        = Color(0xFF2D7A3A);
  static const lightDanger         = Color(0xFFC0392B);
  static const lightGoingTint      = Color(0xFFE8F5E9);
  static const lightInterestedTint = Color(0xFFFFF8E1);

  // ── Shortcuts pointing at dark values ─────────────────────────────────────
  // Used by all existing widgets until the full ThemeExtension migration.
  static const bgPrimary      = darkBgPrimary;
  static const bgSurface      = darkBgSurface;
  static const bgElevated     = darkBgElevated;
  static const accent         = darkAccent;
  static const accentMuted    = darkAccentMuted;
  static const textPrimary    = darkTextPrimary;
  static const textSecondary  = darkTextSecondary;
  static const border         = darkBorder;
  static const success        = darkSuccess;
  static const danger         = darkDanger;
  static const goingTint      = darkGoingTint;
  static const interestedTint = darkInterestedTint;
}
