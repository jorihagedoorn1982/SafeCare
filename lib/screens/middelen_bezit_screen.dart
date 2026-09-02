import 'package:flutter/material.dart';
import '../main.dart';
import 'controle_screen.dart';

class MiddelenBezitScreen extends StatefulWidget {
  const MiddelenBezitScreen({super.key});

  @override
  State<MiddelenBezitScreen> createState() =>
      _MiddelenBezitScreenState();
}

class _MiddelenBezitScreenState
    extends State<MiddelenBezitScreen> {
  bool alcohol = false;
  bool vape = false;
  bool drugs = false;
  bool medicatie = false;
  bool wapens = false;
  bool handel = false;

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
          "Gebruik, bezit en handel van verboden middelen",
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CheckboxListTile(
            value: alcohol,
            title: const Text("Alcohol"),
            onChanged: (value) {
              setState(() {
                alcohol = value!;
                updateCategorie(
                  alcohol,
                  "Alcohol",
                );
              });
            },
          ),

          CheckboxListTile(
            value: vape,
            title: const Text("Vape"),
            onChanged: (value) {
              setState(() {
                vape = value!;
                updateCategorie(
                  vape,
                  "Vape",
                );
              });
            },
          ),

          CheckboxListTile(
            value: drugs,
            title: const Text("Drugs"),
            onChanged: (value) {
              setState(() {
                drugs = value!;
                updateCategorie(
                  drugs,
                  "Drugs",
                );
              });
            },
          ),

          CheckboxListTile(
            value: medicatie,
            title: const Text("Medicatie"),
            onChanged: (value) {
              setState(() {
                medicatie = value!;
                updateCategorie(
                  medicatie,
                  "Medicatie",
                );
              });
            },
          ),

          CheckboxListTile(
            value: wapens,
            title: const Text("Wapens"),
            onChanged: (value) {
              setState(() {
                wapens = value!;
                updateCategorie(
                  wapens,
                  "Wapens",
                );
              });
            },
          ),

          CheckboxListTile(
            value: handel,
            title: const Text("Handel"),
            onChanged: (value) {
              setState(() {
                handel = value!;
                updateCategorie(
                  handel,
                  "Handel",
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