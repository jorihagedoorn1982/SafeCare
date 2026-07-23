import 'package:flutter/material.dart';
import '../main.dart';
import 'incidentgegevens_screen.dart';
import '../widgets/safecare_appbar.dart';

class BetrokkenenScreen extends StatefulWidget {
  const BetrokkenenScreen({super.key});

  @override
  State<BetrokkenenScreen> createState() =>
      _BetrokkenenScreenState();
}

class _BetrokkenenScreenState
    extends State<BetrokkenenScreen> {
  final TextEditingController nummerController =
      TextEditingController();

  final TextEditingController klasController =
      TextEditingController();

  final TextEditingController melderNaamController =
      TextEditingController();

  final TextEditingController melderFunctieController =
      TextEditingController();

  final TextEditingController melderAfdelingController =
      TextEditingController();

  final TextEditingController tegenpartijNaamController =
      TextEditingController();

  final TextEditingController tegenpartijFunctieController =
      TextEditingController();

  final TextEditingController tegenpartijAfdelingController =
      TextEditingController();

  String type = "Leerling";
  String onderwijsniveau = "VO";
  String rol = "Betrokkene";

  final List<String> betrokkenen = [];

  void bepaalCasustype() {
    final types = <String>{};

    for (final item in incidentData.betrokkenen) {
      if (item.startsWith("Leerling")) {
        types.add("Leerling");
      }

      if (item.startsWith("Medewerker")) {
        types.add("Medewerker");
      }

      if (item.startsWith("Ouder/Verzorger")) {
        types.add("Ouder/Verzorger");
      }

      if (item.startsWith("Externe")) {
        types.add("Externe");
      }
    }

    if (types.isEmpty) {
      incidentData.casusType = "";
    } else if (types.length == 1) {
      final type = types.first;
      incidentData.casusType = "$type ↔ $type";
    } else if (types.length == 2) {
      final list = types.toList();
      incidentData.casusType =
          "${list[0]} ↔ ${list[1]}";
    } else {
      incidentData.casusType = "Overig";
    }
  }

  bool bevatVerplichteBetrokkene() {
    for (final item in incidentData.betrokkenen) {
      if (item.startsWith("Leerling")) {
        return true;
      }

      if (item.startsWith("Medewerker")) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (incidentData.hoofdCategorie ==
        "Giftigheid op de werkvloer") {
      return _buildWerkvloerScreen();
    }

    return _buildStandaardScreen();
  }

  Widget _buildWerkvloerScreen() {
    return Scaffold(
     appBar: const SafeCareAppBar(
  titel: "Betrokkenen",
),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "Melder",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: melderNaamController,
              decoration: const InputDecoration(
                labelText: "Naam *",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: melderFunctieController,
              decoration: const InputDecoration(
                labelText: "Functie",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: melderAfdelingController,
              decoration: const InputDecoration(
                labelText: "Afdeling / Team",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Tegenpartij",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: tegenpartijNaamController,
              decoration: const InputDecoration(
                labelText: "Naam *",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: tegenpartijFunctieController,
              decoration: const InputDecoration(
                labelText: "Functie",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: tegenpartijAfdelingController,
              decoration: const InputDecoration(
                labelText: "Afdeling / Team",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                if (melderNaamController
                        .text.isEmpty ||
                    tegenpartijNaamController
                        .text.isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Naam van melder en tegenpartij zijn verplicht.",
                      ),
                    ),
                  );
                  return;
                }

                incidentData.betrokkenen.clear();

                incidentData.betrokkenen.add(
                  "Melder - ${melderNaamController.text} - ${melderFunctieController.text} - ${melderAfdelingController.text}",
                );

                incidentData.betrokkenen.add(
                  "Tegenpartij - ${tegenpartijNaamController.text} - ${tegenpartijFunctieController.text} - ${tegenpartijAfdelingController.text}",
                );

                incidentData.casusType =
                    "Medewerker ↔ Medewerker";

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const IncidentGegevensScreen(),
                  ),
                );
              },
              child: const Text("VOLGENDE"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStandaardScreen() {
    return Scaffold(
      appBar: const SafeCareAppBar(
  titel: "Betrokkenen",
),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: type,
              decoration: const InputDecoration(
                labelText: "Type",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Leerling",
                  child: Text("Leerling"),
                ),
                DropdownMenuItem(
                  value: "Medewerker",
                  child: Text("Medewerker"),
                ),
                DropdownMenuItem(
                  value: "Ouder/Verzorger",
                  child: Text("Ouder/Verzorger"),
                ),
                DropdownMenuItem(
                  value: "Externe",
                  child: Text("Externe"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  type = value!;
                });
              },
            ),

            const SizedBox(height: 15),
DropdownButtonFormField<String>(
  value: onderwijsniveau,
  decoration: const InputDecoration(
    labelText: "Onderwijsniveau",
    border: OutlineInputBorder(),
  ),
  items: const [
    DropdownMenuItem(
      value: "PO",
      child: Text("Primair Onderwijs (PO)"),
    ),
    DropdownMenuItem(
      value: "VO",
      child: Text("Voortgezet Onderwijs (VO)"),
    ),
    DropdownMenuItem(
      value: "MBO",
      child: Text("MBO"),
    ),
  ],
  onChanged: (value) {
    setState(() {
      onderwijsniveau = value!;
    });
  },
),

const SizedBox(height: 15),
            TextField(
              controller: nummerController,
              decoration: const InputDecoration(
                labelText:
                    "Leerlingnummer / personeelsnummer / naam",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: klasController,
              decoration: const InputDecoration(
                labelText: "Klas",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: rol,
              decoration: const InputDecoration(
                labelText: "Rol",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Dader",
                  child: Text("Dader"),
                ),
                DropdownMenuItem(
                  value: "Slachtoffer",
                  child: Text("Slachtoffer"),
                ),
                DropdownMenuItem(
                  value: "Getuige",
                  child: Text("Getuige"),
                ),
                DropdownMenuItem(
                  value: "Betrokkene",
                  child: Text("Betrokkene"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  rol = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {
                if (nummerController.text.isEmpty) {
                  return;
                }

                setState(() {
                 final item =
    "$type - ${nummerController.text} - ${klasController.text} - $rol - $onderwijsniveau";
                  betrokkenen.add(item);
                  incidentData.betrokkenen.add(item);

                  nummerController.clear();
                  klasController.clear();
                });
              },
              child: const Text("TOEVOEGEN"),
            ),

            const SizedBox(height: 20),

            const Text(
              "Betrokkenen",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: betrokkenen.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      betrokkenen[index],
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (!bevatVerplichteBetrokkene()) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Voeg minimaal één leerling of medewerker toe.",
                        ),
                      ),
                    );
                    return;
                  }

                  bepaalCasustype();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const IncidentGegevensScreen(),
                    ),
                  );
                },
                child: const Text("VOLGENDE"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}