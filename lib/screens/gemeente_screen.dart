import 'package:flutter/material.dart';
import '../main.dart';
import 'afhandeling_screen.dart';
import '../widgets/safecare_appbar.dart';


class GemeenteScreen extends StatefulWidget {
  const GemeenteScreen({super.key});

  @override
  State<GemeenteScreen> createState() =>
      _GemeenteScreenState();
}

class _GemeenteScreenState
    extends State<GemeenteScreen> {
  bool jongerenwerk = false;
  bool halt = false;
  bool pga = false;
  bool iptaCoach = false;

  final TextEditingController overigController =
      TextEditingController();

  void updatePartner(
    bool actief,
    String naam,
  ) {
    if (actief) {
      if (!incidentData.netwerkpartners.contains(naam)) {
        incidentData.netwerkpartners.add(naam);
      }
    } else {
      incidentData.netwerkpartners.remove(naam);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SafeCareAppBar(
  titel: "Gemeente",
),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CheckboxListTile(
            value: jongerenwerk,
            title: const Text("Jongerenwerk"),
            onChanged: (value) {
              setState(() {
                jongerenwerk = value!;
                updatePartner(
                  jongerenwerk,
                  "Jongerenwerk",
                );
              });
            },
          ),

          CheckboxListTile(
            value: halt,
            title: const Text("HALT"),
            onChanged: (value) {
              setState(() {
                halt = value!;
                updatePartner(
                  halt,
                  "HALT",
                );
              });
            },
          ),

          CheckboxListTile(
            value: pga,
            title: const Text("PGA"),
            onChanged: (value) {
              setState(() {
                pga = value!;
                updatePartner(
                  pga,
                  "PGA",
                );
              });
            },
          ),

          CheckboxListTile(
            value: iptaCoach,
            title: const Text("IPTA-coach"),
            onChanged: (value) {
              setState(() {
                iptaCoach = value!;
                updatePartner(
                  iptaCoach,
                  "IPTA-coach",
                );
              });
            },
          ),

          const SizedBox(height: 20),

          TextField(
            controller: overigController,
            decoration: const InputDecoration(
              labelText: "Overig",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: () {
              if (overigController.text.isNotEmpty) {
                if (!incidentData.netwerkpartners
                    .contains(
                  overigController.text,
                )) {
                  incidentData.netwerkpartners.add(
                    overigController.text,
                  );
                }
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const AfhandelingScreen(),
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