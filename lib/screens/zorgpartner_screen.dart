import 'package:flutter/material.dart';
import '../main.dart';
import 'afhandeling_screen.dart';
import '../widgets/safecare_appbar.dart';

class ZorgpartnerScreen extends StatefulWidget {
  const ZorgpartnerScreen({super.key});

  @override
  State<ZorgpartnerScreen> createState() =>
      _ZorgpartnerScreenState();
}

class _ZorgpartnerScreenState
    extends State<ZorgpartnerScreen> {
  bool jeugdEnGezinshulp = false;
  bool jeugdbescherming = false;
  bool veiligThuis = false;
  bool leerplicht = false;

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
    titel: "Zorgpartner",
  ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CheckboxListTile(
            value: jeugdEnGezinshulp,
            title: const Text(
              "Jeugd- en gezinshulp",
            ),
            onChanged: (value) {
              setState(() {
                jeugdEnGezinshulp = value!;
                updatePartner(
                  jeugdEnGezinshulp,
                  "Jeugd- en gezinshulp",
                );
              });
            },
          ),

          CheckboxListTile(
            value: jeugdbescherming,
            title: const Text(
              "Jeugdbescherming",
            ),
            onChanged: (value) {
              setState(() {
                jeugdbescherming = value!;
                updatePartner(
                  jeugdbescherming,
                  "Jeugdbescherming",
                );
              });
            },
          ),

          CheckboxListTile(
            value: veiligThuis,
            title: const Text("Veilig Thuis"),
            onChanged: (value) {
              setState(() {
                veiligThuis = value!;
                updatePartner(
                  veiligThuis,
                  "Veilig Thuis",
                );
              });
            },
          ),

          CheckboxListTile(
            value: leerplicht,
            title: const Text("Leerplicht"),
            onChanged: (value) {
              setState(() {
                leerplicht = value!;
                updatePartner(
                  leerplicht,
                  "Leerplicht",
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