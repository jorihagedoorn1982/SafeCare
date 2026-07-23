import 'package:flutter/material.dart';
import '../main.dart';
import 'controle_screen.dart';
import 'protocol_schorsing_verwijdering_screen.dart';
import '../widgets/safecare_appbar.dart';

class AfhandelingInternScreen extends StatefulWidget {
  const AfhandelingInternScreen({super.key});

  @override
  State<AfhandelingInternScreen> createState() =>
      _AfhandelingInternScreenState();
}

class _AfhandelingInternScreenState
    extends State<AfhandelingInternScreen> {
  bool formeleWaarschuwing = false;
  bool oudergesprek = false;
  bool correctiegesprek = false;

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
  appBar: const SafeCareAppBar(
titel: "Intern",
),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            title: const Text(
              "Protocol schorsing & verwijdering",
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ProtocolSchorsingVerwijderingScreen(),
                ),
              );
            },
          ),

          CheckboxListTile(
            value: formeleWaarschuwing,
            title: const Text(
              "Formele waarschuwing",
            ),
            onChanged: (value) {
              setState(() {
                formeleWaarschuwing = value!;
                updateAfhandeling(
                  formeleWaarschuwing,
                  "Formele waarschuwing",
                );
              });
            },
          ),

          CheckboxListTile(
            value: oudergesprek,
            title: const Text(
              "Oudergesprek",
            ),
            onChanged: (value) {
              setState(() {
                oudergesprek = value!;
                updateAfhandeling(
                  oudergesprek,
                  "Oudergesprek",
                );
              });
            },
          ),

          CheckboxListTile(
            value: correctiegesprek,
            title: const Text(
              "Correctiegesprek",
            ),
            onChanged: (value) {
              setState(() {
                correctiegesprek = value!;
                updateAfhandeling(
                  correctiegesprek,
                  "Correctiegesprek",
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