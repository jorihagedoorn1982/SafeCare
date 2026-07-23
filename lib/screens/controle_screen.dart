import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/safecare_appbar.dart';
import '../services/supabase_service.dart';
import 'eindscherm.dart';


class ControleScreen extends StatelessWidget {
  const ControleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SafeCareAppBar(
  titel: "Controle & Opslaan",
),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "Samenvatting",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Betrokkenenrelatie",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              incidentData.casusType.isEmpty
                  ? "Niet ingevuld"
                  : incidentData.casusType,
            ),

            const SizedBox(height: 20),

            const Text(
              "Betrokkenen",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              incidentData.betrokkenen.isEmpty
                  ? "Niet ingevuld"
                  : incidentData.betrokkenen.join("\n"),
            ),

            const SizedBox(height: 20),

            const Text(
  "Incidentgegevens",
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),

Text(
  (
    incidentData.tijdvak.isEmpty &&
    incidentData.locatieDuiding.isEmpty &&
    incidentData.omschrijving.isEmpty
  )
      ? "Niet ingevuld"
      : """
Datum incident: ${incidentData.incidentDatum}

Tijdvak: ${incidentData.tijdvak}

Locatieduiding: ${incidentData.locatieDuiding}

Omschrijving:
${incidentData.omschrijving}
""",
),

const SizedBox(height: 20),

            const SizedBox(height: 20),

            const Text(
              "Melding",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              incidentData.hoofdCategorie.isEmpty
                  ? "Niet ingevuld"
                  : incidentData.hoofdCategorie,
            ),

            const SizedBox(height: 20),

            const Text(
              "Subcategorie",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              incidentData.categorieen.isEmpty
                  ? "Geen subcategorie geselecteerd"
                  : incidentData.categorieen.join(", "),
            ),

            const SizedBox(height: 20),

            const Text(
              "Netwerkpartners",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              incidentData.netwerkpartners.isEmpty
                  ? "Geen netwerkpartners geselecteerd"
                  : incidentData.netwerkpartners.join(", "),
            ),

            const SizedBox(height: 20),

            const Text(
              "Afhandeling",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              incidentData.afhandeling.isEmpty
                  ? "Geen afhandeling geselecteerd"
                  : incidentData.afhandeling.join(", "),
            ),

                        const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () async {
                try {
                  final incidentId =
    await SupabaseService().saveIncident(
  categorie: incidentData.hoofdCategorie,
  subcategorie: incidentData.categorieen.join(', '),
  casustype: incidentData.casusType,
  locatie: incidentData.locatieDuiding,
  omschrijving: incidentData.omschrijving,
  incidentdatum: incidentData.incidentDatum,
);
for (final item in incidentData.betrokkenen) {
  final delen = item.split(' - ');

  String onderwijsniveau = "VO";

  if (delen.length >= 5) {
    onderwijsniveau = delen[4];
  }

  if (delen.length >= 4) {
    await SupabaseService().saveBetrokkene(
      incidentId: incidentId,
      type: delen[0],
      naam: delen[1],
      klas: delen[2],
      rol: delen[3],
      onderwijsniveau: onderwijsniveau,
    );
  }
}

for (final maatregel in incidentData.afhandeling) {
  await SupabaseService().saveAfhandeling(
    incidentId: incidentId,
    maatregel: maatregel,
    netwerkpartner:
        incidentData.netwerkpartners.join(', '),
  );
}

                  Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) =>
        const Eindscherm(),
  ),
);
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        'Fout: $e',
                      ),
                    ),
                  );
                }
              },
              child: const Text('OPSLAAN'),
            ),
          ],
        ),
      ),
    );
  }
}