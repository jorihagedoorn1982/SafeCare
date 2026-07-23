import 'package:flutter/material.dart';
import '../main.dart';
import 'afhandeling_screen.dart';
import '../widgets/safecare_appbar.dart';

class InternScreen extends StatefulWidget {
  const InternScreen({super.key});

  @override
  State<InternScreen> createState() =>
      _InternScreenState();
}

class _InternScreenState
    extends State<InternScreen> {
  bool iberMentor = false;
  bool antiPestcoordinator = false;
  bool aandachtsfunctionarisHG = false;
  bool veiligheidscoordinator = false;
  bool hr = false;
  bool zatTafel = false;
  bool bestuur = false;

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
    titel: "Intern",
  ),
  body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CheckboxListTile(
            value: iberMentor,
            title: const Text("IB'er / Mentor"),
            onChanged: (value) {
              setState(() {
                iberMentor = value!;
                updatePartner(
                  iberMentor,
                  "IB'er / Mentor",
                );
              });
            },
          ),

          CheckboxListTile(
            value: antiPestcoordinator,
            title: const Text(
              "Anti-pestcoördinator",
            ),
            onChanged: (value) {
              setState(() {
                antiPestcoordinator = value!;
                updatePartner(
                  antiPestcoordinator,
                  "Anti-pestcoördinator",
                );
              });
            },
          ),

          CheckboxListTile(
            value: aandachtsfunctionarisHG,
            title: const Text(
              "Aandachtsfunctionaris HG",
            ),
            onChanged: (value) {
              setState(() {
                aandachtsfunctionarisHG = value!;
                updatePartner(
                  aandachtsfunctionarisHG,
                  "Aandachtsfunctionaris HG",
                );
              });
            },
          ),

          CheckboxListTile(
            value: veiligheidscoordinator,
            title: const Text(
              "Veiligheidscoördinator",
            ),
            onChanged: (value) {
              setState(() {
                veiligheidscoordinator = value!;
                updatePartner(
                  veiligheidscoordinator,
                  "Veiligheidscoördinator",
                );
              });
            },
          ),

          CheckboxListTile(
            value: hr,
            title: const Text("HR"),
            onChanged: (value) {
              setState(() {
                hr = value!;
                updatePartner(
                  hr,
                  "HR",
                );
              });
            },
          ),

          CheckboxListTile(
            value: zatTafel,
            title: const Text("ZAT-tafel"),
            onChanged: (value) {
              setState(() {
                zatTafel = value!;
                updatePartner(
                  zatTafel,
                  "ZAT-tafel",
                );
              });
            },
          ),

          CheckboxListTile(
            value: bestuur,
            title: const Text("Bestuur"),
            onChanged: (value) {
              setState(() {
                bestuur = value!;
                updatePartner(
                  bestuur,
                  "Bestuur",
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
                incidentData.netwerkpartners.add(
                  overigController.text,
                );
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