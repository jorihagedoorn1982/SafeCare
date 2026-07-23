import 'package:flutter/material.dart';
import '../main.dart';
import 'netwerkpartners_screen.dart';
import '../widgets/safecare_appbar.dart';

class AgressieScreen extends StatefulWidget {
  const AgressieScreen({super.key});

  @override
  State<AgressieScreen> createState() =>
      _AgressieScreenState();
}

class _AgressieScreenState
    extends State<AgressieScreen> {
  bool aGedrag = false;
  bool bGedrag = false;
  bool cGedrag = false;
  bool dGedrag = false;

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
    return Scaffold(
      appBar: SafeCareAppBar(
  titel: "Titel van de pagina",
),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CheckboxListTile(
            value: aGedrag,
            title: const Text(
              "A-gedrag (stelselmatig zeuren om een doel te bereiken)",
            ),
            onChanged: (value) {
              setState(() {
                aGedrag = value!;
                updateCategorie(
                  aGedrag,
                  "A-gedrag",
                );
              });
            },
          ),

          CheckboxListTile(
            value: bGedrag,
            title: const Text(
              "B-gedrag (structureel oneens met regels)",
            ),
            onChanged: (value) {
              setState(() {
                bGedrag = value!;
                updateCategorie(
                  bGedrag,
                  "B-gedrag",
                );
              });
            },
          ),

          CheckboxListTile(
            value: cGedrag,
            title: const Text(
              "C-gedrag (agressie gericht op de persoon)",
            ),
            onChanged: (value) {
              setState(() {
                cGedrag = value!;
                updateCategorie(
                  cGedrag,
                  "C-gedrag",
                );
              });
            },
          ),

          CheckboxListTile(
            value: dGedrag,
            title: const Text(
              "D-gedrag (fysiek, intimidatie, spugen, gooien)",
            ),
            onChanged: (value) {
              setState(() {
                dGedrag = value!;
                updateCategorie(
                  dGedrag,
                  "D-gedrag",
                );
              });
            },
          ),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const NetwerkpartnersScreen(),
                ),
              );
            },
            child: const Text("VOLGENDE"),
          ),
        ],
      ),
    );
  }
}