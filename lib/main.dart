import 'package:flutter/material.dart';
import 'screens/incidentcategorie_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/welcome_screen.dart';
import 'screens/auth_gate.dart';
import 'package:google_fonts/google_fonts.dart';

class IncidentData {
  // Algemeen
  String casusType = "";
  String incidentDatum = "";

  // Betrokkenen
  List<String> betrokkenen = [];

  // Incidentgegevens
  String school = "";
  String schoolId = "";
  String bestuurId = "";

  String vestiging = "";
  String tijdvak = "";
  String locatieDuiding = "";
  String klas = "";
  String omschrijving = "";

  // Melding
  String hoofdCategorie = "";
  List<String> categorieen = [];

  // Afhandeling
  List<String> netwerkpartners = [];
  List<String> afhandeling = [];
  String statusDossier = 'Open';

  // Melder
  String melderEmail = "";
}

IncidentData incidentData = IncidentData();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dslznaomhkcrzeugvyja.supabase.co',
    anonKey: 'sb_publishable_6PMrwOMG-T5RzWFCY4G6bA_2Eh6Obu7',
  );

  runApp(const SafeCareApp());
}

class SafeCareApp extends StatelessWidget {
  const SafeCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'SafeCare',
  theme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF10212D),
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
    textTheme: GoogleFonts.robotoTextTheme().copyWith(
      displayLarge: GoogleFonts.sourceSerif4(
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.sourceSerif4(
        fontWeight: FontWeight.bold,
      ),
      displaySmall: GoogleFonts.sourceSerif4(
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: GoogleFonts.sourceSerif4(
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: GoogleFonts.sourceSerif4(
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: GoogleFonts.sourceSerif4(
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.sourceSerif4(
        fontWeight: FontWeight.bold,
      ),
      titleMedium: GoogleFonts.sourceSerif4(
        fontWeight: FontWeight.w600,
      ),
      titleSmall: GoogleFonts.sourceSerif4(
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.roboto(
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontWeight: FontWeight.normal,
      ),
      bodySmall: GoogleFonts.roboto(
        fontWeight: FontWeight.normal,
      ),
      labelLarge: GoogleFonts.roboto(
        fontWeight: FontWeight.w500,
      ),
      labelMedium: GoogleFonts.roboto(
        fontWeight: FontWeight.w500,
      ),
      labelSmall: GoogleFonts.roboto(
        fontWeight: FontWeight.w500,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF10212D),
      foregroundColor: Colors.white,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF22415B),
        foregroundColor: Colors.white,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(
        const Color(0xFF68A09F),
      ),
    ),
    dropdownMenuTheme: const DropdownMenuThemeData(),
  ),
  home: const WelcomeScreen(),
);
  }
}