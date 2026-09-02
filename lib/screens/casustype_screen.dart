import 'package:flutter/material.dart';
import '../main.dart';
import 'betrokkenen_screen.dart';

class CasusTypeScreen extends StatelessWidget {
  const CasusTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final casusTypes = [
      "Leerling ↔ Leerling",
      "Leerling ↔ Medewerker",
      "Ouder/Verzorger ↔ Ouder/Verzorger",
      "Ouder/Verzorger ↔ Medewerker",
      "Externe ↔ Medewerker",
      "Medewerker ↔ Medewerker",
      "Overig",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("SafeCare"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Kies het type casus",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: casusTypes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(60),
                      ),
                      onPressed: () {
                        // Nieuwe registratie starten
                        incidentData = IncidentData();

                        // Casustype opslaan
                        incidentData.casusType = casusTypes[index];

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BetrokkenenScreen(),
                          ),
                        );
                      },
                      child: Text(
                        casusTypes[index],
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}