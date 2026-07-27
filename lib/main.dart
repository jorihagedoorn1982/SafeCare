import 'package:flutter/material.dart';
import 'screens/incidentcategorie_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/welcome_screen.dart';

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

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF10212D),
    foregroundColor: Colors.black,
    centerTitle: true,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF22415B),
      foregroundColor: Colors.white,
    ),
  ),

  checkboxTheme: CheckboxThemeData(
    fillColor:
        WidgetStateProperty.all(
      const Color(0xFF68A09F),
    ),
  ),

  dropdownMenuTheme: const DropdownMenuThemeData(),
),

      home: const WelcomeScreen(),
    );
  }
}