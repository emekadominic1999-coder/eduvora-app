import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Global colour palette, typography and component styling for Eduvora.
///
/// The palette is fixed by the Eduvora brand specification:
///   Primary    #2563EB  Royal Blue
///   Accent     #F97316  Bright Orange
///   Background #F8FAFC  Slate Mist
///   Text       #1E293B  Deep Slate
class AppColours {
  const AppColours._();

  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryDeep = Color(0xFF1E3A8A);
  static const Color primarySoft = Color(0xFFDBEAFE);
  static const Color primaryTint = Color(0xFFEFF6FF);

  static const Color accent = Color(0xFFF97316);
  static const Color accentDark = Color(0xFFEA580C);
  static const Color accentSoft = Color(0xFFFFEDD5);

  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF1F5F9);

  static const Color text = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textFaint = Color(0xFF94A3B8);

  static const Color border = Color(0xFFE2E8F0);
  static const Color borderStrong = Color(0xFFCBD5E1);

  static const Color success = Color(0xFF16A34A);
  static const Color successSoft = Color(0xFFDCFCE7);
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerSoft = Color(0xFFFEE2E2);
  static const Color warning = Color(0xFFCA8A04);
  static const Color warningSoft = Color(0xFFFEF9C3);
  static const Color info = Color(0xFF0891B2);
  static const Color infoSoft = Color(0xFFCFFAFE);

  /// Signature gradient used on the landing hero and auth panel.
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[primaryDeep, primary, Color(0xFF3B82F6)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[accent, Color(0xFFFB923C)],
  );
}

/// Shared spacing, radius and elevation tokens.
class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  static const double screenPadding = 20;
}

class AppRadii {
  const AppRadii._();

  static const BorderRadius sm = BorderRadius.all(Radius.circular(10));
  static const BorderRadius md = BorderRadius.all(Radius.circular(14));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(20));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(28));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
}

class AppShadows {
  const AppShadows._();

  static const List<BoxShadow> card = <BoxShadow>[
    BoxShadow(color: Color(0x0F1E293B), blurRadius: 18, offset: Offset(0, 6)),
  ];

  static const List<BoxShadow> raised = <BoxShadow>[
    BoxShadow(color: Color(0x1A1E293B), blurRadius: 28, offset: Offset(0, 12)),
  ];

  static const List<BoxShadow> subtle = <BoxShadow>[
    BoxShadow(color: Color(0x0A1E293B), blurRadius: 10, offset: Offset(0, 3)),
  ];
}

class AppTheme {
  const AppTheme._();

  static const SystemUiOverlayStyle lightOverlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: AppColours.surface,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static ThemeData get light {
    const ColorScheme scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColours.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColours.primarySoft,
      onPrimaryContainer: AppColours.primaryDeep,
      secondary: AppColours.accent,
      onSecondary: Colors.white,
      secondaryContainer: AppColours.accentSoft,
      onSecondaryContainer: Color(0xFF7C2D12),
      tertiary: AppColours.info,
      onTertiary: Colors.white,
      error: AppColours.danger,
      onError: Colors.white,
      errorContainer: AppColours.dangerSoft,
      onErrorContainer: Color(0xFF7F1D1D),
      surface: AppColours.surface,
      onSurface: AppColours.text,
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: AppColours.background,
      surfaceContainer: AppColours.surfaceMuted,
      surfaceContainerHigh: Color(0xFFE8EDF3),
      surfaceContainerHighest: AppColours.border,
      onSurfaceVariant: AppColours.textMuted,
      outline: AppColours.borderStrong,
      outlineVariant: AppColours.border,
      shadow: Color(0x141E293B),
      scrim: Color(0x801E293B),
      inverseSurface: AppColours.text,
      onInverseSurface: Colors.white,
      inversePrimary: Color(0xFF93C5FD),
    );

    final TextTheme textTheme = _buildTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColours.background,
      canvasColor: AppColours.background,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColours.surface,
        foregroundColor: AppColours.text,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        systemOverlayStyle: lightOverlay,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
        iconTheme: const IconThemeData(color: AppColours.text, size: 22),
      ),
      cardTheme: const CardThemeData(
        color: AppColours.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.lg),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColours.border,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColours.surface,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColours.textFaint),
        labelStyle: textTheme.bodyMedium?.copyWith(color: AppColours.textMuted),
        floatingLabelStyle: textTheme.bodyMedium?.copyWith(
          color: AppColours.primary,
        ),
        prefixIconColor: AppColours.textMuted,
        suffixIconColor: AppColours.textMuted,
        border: _fieldBorder(AppColours.border),
        enabledBorder: _fieldBorder(AppColours.border),
        focusedBorder: _fieldBorder(AppColours.primary, width: 1.6),
        errorBorder: _fieldBorder(AppColours.danger),
        focusedErrorBorder: _fieldBorder(AppColours.danger, width: 1.6),
        disabledBorder: _fieldBorder(AppColours.border),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColours.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColours.borderStrong,
          disabledForegroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.md),
          textStyle: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColours.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(54),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.md),
          textStyle: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColours.text,
          minimumSize: const Size.fromHeight(54),
          side: const BorderSide(color: AppColours.border, width: 1.4),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.md),
          textStyle: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColours.primary,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColours.surfaceMuted,
        selectedColor: AppColours.primary,
        disabledColor: AppColours.surfaceMuted,
        checkmarkColor: Colors.white,
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColours.textMuted,
        ),
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.pill),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColours.surface,
        selectedItemColor: AppColours.primary,
        unselectedItemColor: AppColours.textFaint,
        selectedLabelStyle: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColours.surface,
        indicatorColor: AppColours.primaryTint,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((Set<WidgetState> s) {
          final bool selected = s.contains(WidgetState.selected);
          return textTheme.labelSmall!.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColours.primary : AppColours.textFaint,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((Set<WidgetState> s) {
          final bool selected = s.contains(WidgetState.selected);
          return IconThemeData(
            size: 23,
            color: selected ? AppColours.primary : AppColours.textFaint,
          );
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColours.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.lg),
        titleTextStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: textTheme.bodyMedium,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColours.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        showDragHandle: true,
        dragHandleColor: AppColours.borderStrong,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColours.text,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.md),
        insetPadding: const EdgeInsets.all(AppSpacing.lg),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColours.primary,
        unselectedLabelColor: AppColours.textMuted,
        indicatorColor: AppColours.primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: AppColours.border,
        labelStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        unselectedLabelStyle: textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColours.primary,
        linearTrackColor: AppColours.border,
        circularTrackColor: AppColours.border,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColours.primary,
        inactiveTrackColor: AppColours.border,
        thumbColor: AppColours.primary,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> s) =>
              s.contains(WidgetState.selected) ? Colors.white : Colors.white,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> s) => s.contains(WidgetState.selected)
              ? AppColours.primary
              : AppColours.borderStrong,
        ),
        trackOutlineColor: const WidgetStatePropertyAll<Color>(
          Colors.transparent,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColours.textMuted,
        titleTextStyle: TextStyle(
          color: AppColours.text,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        subtitleTextStyle: TextStyle(color: AppColours.textMuted, fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
      ),
      iconTheme: const IconThemeData(color: AppColours.textMuted, size: 22),
      tooltipTheme: TooltipThemeData(
        decoration: const BoxDecoration(
          color: AppColours.text,
          borderRadius: AppRadii.sm,
        ),
        textStyle: textTheme.bodySmall?.copyWith(color: Colors.white),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  static OutlineInputBorder _fieldBorder(Color colour, {double width = 1.2}) {
    return OutlineInputBorder(
      borderRadius: AppRadii.md,
      borderSide: BorderSide(color: colour, width: width),
    );
  }

  static TextTheme _buildTextTheme() {
    const Color body = AppColours.text;
    return const TextTheme(
      displayLarge: TextStyle(
        fontSize: 40,
        height: 1.14,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.1,
        color: body,
      ),
      displayMedium: TextStyle(
        fontSize: 34,
        height: 1.16,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.9,
        color: body,
      ),
      displaySmall: TextStyle(
        fontSize: 29,
        height: 1.2,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.7,
        color: body,
      ),
      headlineMedium: TextStyle(
        fontSize: 25,
        height: 1.22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: body,
      ),
      headlineSmall: TextStyle(
        fontSize: 21,
        height: 1.26,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.35,
        color: body,
      ),
      titleLarge: TextStyle(
        fontSize: 19,
        height: 1.3,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        color: body,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 1.35,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.1,
        color: body,
      ),
      titleSmall: TextStyle(
        fontSize: 15,
        height: 1.35,
        fontWeight: FontWeight.w600,
        color: body,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.55,
        fontWeight: FontWeight.w400,
        color: body,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.5,
        height: 1.55,
        fontWeight: FontWeight.w400,
        color: body,
      ),
      bodySmall: TextStyle(
        fontSize: 13,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: AppColours.textMuted,
      ),
      labelLarge: TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.w600,
        color: body,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: body,
      ),
      labelSmall: TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: body,
      ),
    );
  }
}
