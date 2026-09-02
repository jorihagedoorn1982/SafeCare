import 'package:flutter/material.dart';
import '../main.dart';
import 'controle_screen.dart';

class OverlastStrafbaarScreen extends StatefulWidget {
  const OverlastStrafbaarScreen({super.key});

  @override
  State<OverlastStrafbaarScreen> createState() =>
      _OverlastStrafbaarScreenState();
}

class _OverlastStrafbaarScreenState
    extends State<OverlastStrafbaarScreen> {
  bool diefstal = false;
  bool vernielingVandalisme = false;
  bool mishandeling = false;
  bool bedreiging = false;
  bool brandstichting = false;
  bool overigeStrafbareFeiten = false;

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
      appBar: AppBar(
        title: const Text(
          "Overlast & Strafbaar Gedrag",
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CheckboxListTile(
            value: diefstal,
            title: const Text("Diefstal"),
            onChanged: (value) {
              setState(() {
                diefstal = value!;
                updateCategorie(
                  diefstal,
                  "Diefstal",
                );
              });
            },
          ),

          CheckboxListTile(
            value: vernielingVandalisme,
            title: const Text(
              "Vernieling en vandalisme",
            ),
            onChanged: (value) {
              setState(() {
                vernielingVandalisme = value!;
                updateCategorie(
                  vernielingVandalisme,
                  "Vernieling en vandalisme",
                );
              });
            },
          ),

          CheckboxListTile(
            value: mishandeling,
            title: const Text("Mishandeling"),
            onChanged: (value) {
              setState(() {
                mishandeling = value!;
                updateCategorie(
                  mishandeling,
                  "Mishandeling",
                );
              });
            },
          ),

          CheckboxListTile(
            value: bedreiging,
            title: const Text("Bedreiging"),
            onChanged: (value) {
              setState(() {
                bedreiging = value!;
                updateCategorie(
                  bedreiging,
                  "Bedreiging",
                );
              });
            },
          ),

          CheckboxListTile(
            value: brandstichting,
            title: const Text("Brandstichting"),
            onChanged: (value) {
              setState(() {
                brandstichting = value!;
                updateCategorie(
                  brandstichting,
                  "Brandstichting",
                );
              });
            },
          ),

          CheckboxListTile(
            value: overigeStrafbareFeiten,
            title: const Text(
              "Overige strafbare feiten",
            ),
            onChanged: (value) {
              setState(() {
                overigeStrafbareFeiten = value!;
                updateCategorie(
                  overigeStrafbareFeiten,
                  "Overige strafbare feiten",
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
                      const ControleScreen(),
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