import 'package:flutter/material.dart';
import '../main.dart';
import 'controle_screen.dart';
import 'afhandeling_intern_screen.dart';
import '../widgets/safecare_appbar.dart';

class AfhandelingScreen extends StatefulWidget {
  const AfhandelingScreen({super.key});

  @override
  State<AfhandelingScreen> createState() =>
      _AfhandelingScreenState();
}

class _AfhandelingScreenState
    extends State<AfhandelingScreen> {
  String statusDossier = 'Open';

  bool aangifte = false;
  bool zorgtraject = false;
  bool overdrachtKetenpartner = false;
  bool overdrachtBestuur = false;

  void updateAfhandeling(
    bool actief,
    String naam,
  ) {
    if (actief) {
      if (!incidentData.afhandeling.contains(naam)) {
        incidentData.afhandeling.add(naam);
      }
    } else {
      incidentData.afhandeling.remove(naam);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SafeCareAppBar(
        titel: "Afhandeling",
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Status dossier",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          RadioListTile<String>(
            title: const Text("Open"),
            value: "Open",
            groupValue: statusDossier,
            onChanged: (value) {
              setState(() {
                statusDossier = value!;
                incidentData.statusDossier = value;
              });
            },
          ),

          RadioListTile<String>(
            title: const Text("In behandeling"),
            value: "In behandeling",
            groupValue: statusDossier,
            onChanged: (value) {
              setState(() {
                statusDossier = value!;
                incidentData.statusDossier = value;
              });
            },
          ),

          RadioListTile<String>(
            title: const Text("Afgerond"),
            value: "Afgerond",
            groupValue: statusDossier,
            onChanged: (value) {
              setState(() {
                statusDossier = value!;
                incidentData.statusDossier = value;
              });
            },
          ),

          const Divider(),

          ListTile(
            title: const Text("Intern opgepakt"),
            trailing: const Icon(
              Icons.arrow_forward_ios,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const AfhandelingInternScreen(),
                ),
              );
            },
          ),

          CheckboxListTile(
            value: zorgtraject,
            title: const Text("Zorgtraject"),
            onChanged: (value) {
              setState(() {
                zorgtraject = value!;
                updateAfhandeling(
                  zorgtraject,
                  "Zorgtraject",
                );
              });
            },
          ),

          CheckboxListTile(
            value: aangifte,
            title: const Text("Aangifte"),
            onChanged: (value) {
              setState(() {
                aangifte = value!;
                updateAfhandeling(
                  aangifte,
                  "Aangifte",
                );
              });
            },
          ),

          CheckboxListTile(
            value: overdrachtKetenpartner,
            title: const Text(
              "Overdracht aan ketenpartner",
            ),
            onChanged: (value) {
              setState(() {
                overdrachtKetenpartner = value!;
                updateAfhandeling(
                  overdrachtKetenpartner,
                  "Overdracht aan ketenpartner",
                );
              });
            },
          ),

          CheckboxListTile(
            value: overdrachtBestuur,
            title: const Text(
              "Overdracht aan veiligheidsregisseur / bestuur",
            ),
            onChanged: (value) {
              setState(() {
                overdrachtBestuur = value!;
                updateAfhandeling(
                  overdrachtBestuur,
                  "Overdracht aan veiligheidsregisseur / bestuur",
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