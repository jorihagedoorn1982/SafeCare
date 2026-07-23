import 'package:flutter/material.dart';
import '../main.dart';
import 'afhandeling_screen.dart';
import 'gemeente_screen.dart';
import 'intern_screen.dart';
import 'zorgpartner_screen.dart';
import '../widgets/safecare_appbar.dart';

class NetwerkpartnersScreen extends StatefulWidget {
  const NetwerkpartnersScreen({super.key});

  @override
  State<NetwerkpartnersScreen> createState() =>
      _NetwerkpartnersScreenState();
}

class _NetwerkpartnersScreenState
    extends State<NetwerkpartnersScreen> {
  bool nietVanToepassing = false;
  bool politie = false;

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
      appBar: const SafeCareAppBar(
  titel: "Netwerkpartners",
),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CheckboxListTile(
            value: nietVanToepassing,
            title: const Text(
              "Niet van toepassing",
            ),
            onChanged: (value) {
              setState(() {
                nietVanToepassing = value!;
                updatePartner(
                  nietVanToepassing,
                  "Niet van toepassing",
                );
              });
            },
          ),

          CheckboxListTile(
            value: politie,
            title: const Text("Politie"),
            onChanged: (value) {
              setState(() {
                politie = value!;
                updatePartner(
                  politie,
                  "Politie",
                );
              });
            },
          ),

          ListTile(
            title: const Text("Gemeente"),
            trailing: Icon(
              Icons.arrow_forward_ios,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const GemeenteScreen(),
                ),
              );
            },
          ),

          ListTile(
            title: const Text("Intern"),
            trailing: Icon(
              Icons.arrow_forward_ios,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const InternScreen(),
                ),
              );
            },
          ),

          ListTile(
            title: const Text("Zorgpartner"),
            trailing: Icon(
              Icons.arrow_forward_ios,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ZorgpartnerScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: () {
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