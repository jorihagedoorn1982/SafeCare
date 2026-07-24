import 'package:flutter/material.dart';
import '../main.dart';
import 'subcategorie_screen.dart';
import '../widgets/safecare_appbar.dart';

class IncidentCategorieScreen extends StatelessWidget {
  const IncidentCategorieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SafeCareAppBar(
        titel: "Melding",
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "Melding",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ListTile(
              title: const Text("Agressie"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                incidentData.hoofdCategorie = "Agressie";

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const SubcategorieScreen(),
                  ),
                );
              },
            ),

            ListTile(
              title: const Text("Zorg & Veiligheid"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                incidentData.hoofdCategorie =
                    "Zorg & Veiligheid";

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const SubcategorieScreen(),
                  ),
                );
              },
            ),

            ListTile(
              title: const Text("Digitale Veiligheid"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                incidentData.hoofdCategorie =
                    "Digitale Veiligheid";

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const SubcategorieScreen(),
                  ),
                );
              },
            ),

            ListTile(
              title: const Text("Verboden middelen"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                incidentData.hoofdCategorie =
                    "Verboden middelen";

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const SubcategorieScreen(),
                  ),
                );
              },
            ),

            ListTile(
              title: const Text(
                "Overlast & Strafbaar Gedrag",
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                incidentData.hoofdCategorie =
                    "Overlast & Strafbaar Gedrag";

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const SubcategorieScreen(),
                  ),
                );
              },
            ),

            ListTile(
              title: const Text(
                "Giftigheid op de werkvloer",
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                incidentData.hoofdCategorie =
                    "Giftigheid op de werkvloer";

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const SubcategorieScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}