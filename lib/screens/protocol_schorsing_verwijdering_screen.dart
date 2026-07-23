import 'package:flutter/material.dart';
import '../main.dart';
import 'controle_screen.dart';

class ProtocolSchorsingVerwijderingScreen
    extends StatefulWidget {
  const ProtocolSchorsingVerwijderingScreen({
    super.key,
  });

  @override
  State<ProtocolSchorsingVerwijderingScreen>
      createState() =>
          _ProtocolSchorsingVerwijderingScreenState();
}

class _ProtocolSchorsingVerwijderingScreenState
    extends State<
        ProtocolSchorsingVerwijderingScreen> {
  bool verwijderingLeerling = false;
  bool interneSchorsingLeerling = false;
  bool externeSchorsingLeerling = false;
  bool timeOutLeerling = false;

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
      appBar: AppBar(
        title: const Text(
          "Protocol schorsing & verwijdering",
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CheckboxListTile(
            value: verwijderingLeerling,
            title: const Text(
              "Verwijdering leerling",
            ),
            onChanged: (value) {
              setState(() {
                verwijderingLeerling = value!;
                updateAfhandeling(
                  verwijderingLeerling,
                  "Verwijdering leerling",
                );
              });
            },
          ),

          CheckboxListTile(
            value: interneSchorsingLeerling,
            title: const Text(
              "Interne schorsing leerling",
            ),
            onChanged: (value) {
              setState(() {
                interneSchorsingLeerling = value!;
                updateAfhandeling(
                  interneSchorsingLeerling,
                  "Interne schorsing leerling",
                );
              });
            },
          ),

          CheckboxListTile(
            value: externeSchorsingLeerling,
            title: const Text(
              "Externe schorsing leerling",
            ),
            onChanged: (value) {
              setState(() {
                externeSchorsingLeerling = value!;
                updateAfhandeling(
                  externeSchorsingLeerling,
                  "Externe schorsing leerling",
                );
              });
            },
          ),

          CheckboxListTile(
            value: timeOutLeerling,
            title: const Text(
              "Time-out leerling (1 dag)",
            ),
            onChanged: (value) {
              setState(() {
                timeOutLeerling = value!;
                updateAfhandeling(
                  timeOutLeerling,
                  "Time-out leerling (1 dag)",
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