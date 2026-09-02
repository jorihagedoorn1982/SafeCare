import 'package:flutter/material.dart';
import '../main.dart';
import 'controle_screen.dart';

class DigitaleVeiligheidScreen extends StatefulWidget {
  const DigitaleVeiligheidScreen({super.key});

  @override
  State<DigitaleVeiligheidScreen> createState() =>
      _DigitaleVeiligheidScreenState();
}

class _DigitaleVeiligheidScreenState
    extends State<DigitaleVeiligheidScreen> {
  bool doxing = false;
  bool deepfake = false;
  bool hackenAccount = false;
  bool identiteitsfraude = false;
  bool privacyschending = false;
  bool sexting = false;
  bool sextortion = false;

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
        title: const Text("Digitale Veiligheid"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CheckboxListTile(
            value: doxing,
            title: const Text("Doxing"),
            onChanged: (value) {
              setState(() {
                doxing = value!;
                updateCategorie(
                  doxing,
                  "Doxing",
                );
              });
            },
          ),

          CheckboxListTile(
            value: deepfake,
            title: const Text("Deepfake"),
            onChanged: (value) {
              setState(() {
                deepfake = value!;
                updateCategorie(
                  deepfake,
                  "Deepfake",
                );
              });
            },
          ),

          CheckboxListTile(
            value: hackenAccount,
            title: const Text("Hacken account"),
            onChanged: (value) {
              setState(() {
                hackenAccount = value!;
                updateCategorie(
                  hackenAccount,
                  "Hacken account",
                );
              });
            },
          ),

          CheckboxListTile(
            value: identiteitsfraude,
            title: const Text("Identiteitsfraude"),
            onChanged: (value) {
              setState(() {
                identiteitsfraude = value!;
                updateCategorie(
                  identiteitsfraude,
                  "Identiteitsfraude",
                );
              });
            },
          ),

          CheckboxListTile(
            value: privacyschending,
            title: const Text("Privacyschending"),
            onChanged: (value) {
              setState(() {
                privacyschending = value!;
                updateCategorie(
                  privacyschending,
                  "Privacyschending",
                );
              });
            },
          ),

          CheckboxListTile(
            value: sexting,
            title: const Text("Sexting"),
            onChanged: (value) {
              setState(() {
                sexting = value!;
                updateCategorie(
                  sexting,
                  "Sexting",
                );
              });
            },
          ),

          CheckboxListTile(
            value: sextortion,
            title: const Text("Sextortion"),
            onChanged: (value) {
              setState(() {
                sextortion = value!;
                updateCategorie(
                  sextortion,
                  "Sextortion",
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