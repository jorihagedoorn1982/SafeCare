import 'package:flutter/material.dart';

import 'incidentcategorie_screen.dart';
import 'dashboard_screen.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/SCI-logo_SCI stack logo zeeblauw.png',
                  height: 260,
                ),

                const SizedBox(height: 30),

                const Text(
                  'Welkom bij het incidenten registratiesysteem',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF10212D),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Samen werken aan een veilige leer- en werkomgeving.\n\n'
                  'Registreer incidenten, verkrijg inzicht in trends '
                  'en versterk de samenwerking met netwerkpartners.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF10212D),
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: 300,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          const IncidentCategorieScreen(),
    ),
  );
},
                    child: const Text(
                      'START NIEUWE MELDING',
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: 300,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'DASHBOARD',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}