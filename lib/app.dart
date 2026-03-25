import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'prototype_page.dart';

class FMateApp extends StatelessWidget {
  const FMateApp({super.key, this.startInHome = false});

  final bool startInHome;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F8F43),
      primary: const Color(0xFF0F8F43),
      secondary: const Color(0xFFFF8A2A),
      surface: const Color(0xFFFFFCF6),
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'F-MATE Prototype',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF2EAD9),
        textTheme: GoogleFonts.notoSansKrTextTheme(ThemeData.light().textTheme)
            .apply(
              bodyColor: const Color(0xFF1A201A),
              displayColor: const Color(0xFF1A201A),
            ),
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: const Color(0xFFD7F2DD),
          backgroundColor: Colors.white.withValues(alpha: 0.92),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Color(0xFF0F8F43));
            }
            return const IconThemeData(color: Color(0xFF72806E));
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            return GoogleFonts.notoSansKr(
              fontWeight: FontWeight.w700,
              color: states.contains(WidgetState.selected)
                  ? const Color(0xFF0F8F43)
                  : const Color(0xFF72806E),
            );
          }),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          labelStyle: GoogleFonts.notoSansKr(
            color: const Color(0xFF61705F),
            fontWeight: FontWeight.w600,
          ),
          hintStyle: GoogleFonts.notoSansKr(color: const Color(0xFF93A091)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0x14000000)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0x14000000)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFF0F8F43), width: 1.6),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.white,
          selectedColor: const Color(0xFF152217),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          labelStyle: GoogleFonts.notoSansKr(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF516050),
          ),
          secondaryLabelStyle: GoogleFonts.notoSansKr(
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
          side: const BorderSide(color: Color(0x12000000)),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: PrototypePage(startInHome: startInHome),
    );
  }
}
