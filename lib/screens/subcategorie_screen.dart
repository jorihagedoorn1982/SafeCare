import 'package:flutter/material.dart';
import '../main.dart';
import 'betrokkenen_screen.dart';
import '../widgets/safecare_appbar.dart';
import 'zorgveiligheid_detail_screen.dart';

class SubcategorieScreen extends StatefulWidget {
  const SubcategorieScreen({super.key});

  @override
  State<SubcategorieScreen> createState() =>
      _SubcategorieScreenState();
}

class _SubcategorieScreenState
    extends State<SubcategorieScreen> {
  final TextEditingController overigController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    incidentData.categorieen.clear();
  }

  void updateCategorie(
    bool actief,
    String categorie,
  ) {
    if (actief) {
      if (!incidentData.categorieen.contains(categorie)) {
        incidentData.categorieen.add(categorie);
      }
    } else {
      incidentData.categorieen.remove(categorie);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categorie = incidentData.hoofdCategorie;

    return Scaffold(
      appBar: SafeCareAppBar(
  titel: "Subcategorie",
),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              categorie == "Verboden middelen"
                  ? "Verboden middelen (gebruik, bezit en handel)"
                  : categorie,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ...bouwOpties(),

            if (incidentData.hoofdCategorie ==
                "Giftigheid op de werkvloer") ...[
              const SizedBox(height: 20),

              TextField(
                controller: overigController,
                decoration: const InputDecoration(
                  labelText:
                      "Overig (indien van toepassing)",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
if (incidentData.hoofdCategorie !=
    "Zorg & Veiligheid") ...[
  const SizedBox(height: 30),

  ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const BetrokkenenScreen(),
        ),
      );
    },
    child: const Text(
      "VOLGENDE",
    ),
  ),
],
            
          ],
        ),
      ),
    );
  }

  List<Widget> bouwOpties() {
    switch (incidentData.hoofdCategorie) {
      case "Agressie":
  return [
    checkbox(
      "A-gedrag (stelselmatig zeuren en begrip vragen om een doel te bereiken)",
    ),
    checkbox(
      "B-gedrag (structureel oneens met de regels, 'jullie zijn allemaal tegen mij')",
    ),
    checkbox(
      "C-gedrag (verbale agressie, schelden, beledigen, dreigen zoals 'jij wordt...' of vergelijkbare uitingen)",
    ),
    checkbox(
      "D-gedrag (fysieke agressie, intimidatie, spugen, slaan, schoppen of vergelijkbaar gedrag)",
    ),
  ];

      case "Digitale Veiligheid":
        return [
          checkbox(
            "Doxing (het opzettelijk en zonder toestemming verzamelen en openbaar maken van iemands persoonlijke gegevens)",
          ),
          checkbox(
            "Deepfake (een zeer realistisch gemanipuleerde video, foto of geluidsopname gemaakt met behulp van kunstmatige intelligentie)",
          ),
          checkbox("Hacken account"),
          checkbox("Identiteitsfraude"),
          checkbox("Privacyschending"),
          checkbox(
            "Sexting (het versturen of ontvangen van seksueel getinte teksten, foto's of video's)",
          ),
          checkbox(
            "Sextortion (online afpersing met seksueel getint beeldmateriaal)",
          ),
        ];

      case "Verboden middelen":
        return [
          checkbox("Alcohol"),
          checkbox("Vape"),
          checkbox("Drugs"),
          checkbox("Medicatie"),
          checkbox("Wapens"),
          checkbox("Handel"),
        ];

      case "Overlast & Strafbaar Gedrag":
        return [
          checkbox("Diefstal"),
          checkbox("Vernieling en vandalisme"),
          checkbox("Mishandeling"),
          checkbox("Bedreiging"),
          checkbox("Brandstichting"),
          checkbox("Overige strafbare feiten"),
        ];

      case "Zorg & Veiligheid":
  return [
    keuze("Pestgedrag"),
    keuze("Uitbuiting"),
    keuze("Achter de voordeur"),
    keuze("Straatcultuur"),
  ];
      case "Giftigheid op de werkvloer":
        return [
          checkbox("Pesten"),
          checkbox("Intimidatie"),
          checkbox("Uitsluiting"),
          checkbox("Roddelvorming"),
          checkbox("Discriminatie"),
          checkbox("Machtmisbruik"),
          checkbox("Onprofessionele bejegening"),
          checkbox("Integriteitskwestie"),
          checkbox("Arbeidsconflict"),
        ];

      default:
        return [];
    }
  }

  Widget checkbox(String naam) {
  final actief =
      incidentData.categorieen.contains(naam);

  return CheckboxListTile(
    value: actief,
    title: Text(naam),
    onChanged: (value) {
      setState(() {
        updateCategorie(
          value ?? false,
          naam,
        );
      });
    },
  );
}

Widget keuze(String naam) {
  return ListTile(
    title: Text(naam),
    trailing: const Icon(Icons.arrow_forward_ios),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ZorgVeiligheidDetailScreen(
            categorie: naam,
          ),
        ),
      );
    },
  );
}

}