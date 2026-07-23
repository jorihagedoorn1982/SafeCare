import 'package:flutter/material.dart';
import 'screens/zorg_veiligheid_screen.dart';
import 'screens/agressie_screen.dart';
import 'screens/digitale_veiligheid_screen.dart';
import 'screens/middelen_bezit_screen.dart';
import 'screens/overlast_strafbaar_screen.dart';
import 'screens/netwerkpartners_screen.dart';

class IncidentData {
  String casusType = "";

  List<String> betrokkenen = [];

  String locatie = "";
  String klas = "";
  String omschrijving = "";

  List<String> categorieen = [];

  String ernst = "";

  List<String> netwerkpartners = [];

  List<String> afhandeling = [];
}

IncidentData incidentData = IncidentData();
void main() {
  runApp(const SafeCareApp());
}

class SafeCareApp extends StatelessWidget {
  const SafeCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SafeCare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CasusTypeScreen(),
    );
  }
}

class CasusTypeScreen extends StatelessWidget {
  const CasusTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final casusTypes = [
      "Leerling ↔ Leerling",
      "Leerling ↔ Medewerker",
      "Ouder/Verzorger ↔ Ouder/Verzorger",
      "Ouder/Verzorger ↔ Medewerker",
      "Externe ↔ Medewerker",
      "Medewerker ↔ Medewerker",
      "Overig",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("SafeCare"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Kies het type casus",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: casusTypes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(60),
                      ),
                     onPressed: () {
  incidentData = IncidentData();

  incidentData.casusType = casusTypes[index];

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const BetrokkenenScreen(),
    ),
  );
}
)
                        );
                      },
                      child: Text(
                        casusTypes[index],
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BetrokkenenScreen extends StatefulWidget {
  const BetrokkenenScreen({super.key});

  @override
  State<BetrokkenenScreen> createState() =>
      _BetrokkenenScreenState();
}

class _BetrokkenenScreenState extends State<BetrokkenenScreen> {
  final TextEditingController controller =
      TextEditingController();

  String type = "Leerling";
  String rol = "Dader";

  final List<String> betrokkenen = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Betrokkenen"),
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

            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Nummer of Initial + Achternaam",
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
                if (controller.text.isNotEmpty) {
                  setState(() {
                    betrokkenen.add(
                      "$type - ${controller.text} - $rol",
                    );
                    controller.clear();
                  });
                }
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
                    title: Text(betrokkenen[index]),
                  );
                },
              ),
            ),const SizedBox(height: 15),

SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IncidentGegevensScreen(),
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
class IncidentGegevensScreen extends StatelessWidget {
  const IncidentGegevensScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Incidentgegevens"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Locatie",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              decoration: const InputDecoration(
                labelText: "Klas",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: "Omschrijving",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

           ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IncidentCategorieScreen(),
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
}
class IncidentCategorieScreen extends StatelessWidget {
  const IncidentCategorieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Incidentcategorie"),
      ),
     body: Padding(
  padding: const EdgeInsets.all(20),
  child: ListView(
    children: [
      Text(
        "Hoofdcategorie",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),

      SizedBox(height: 20),

      ListTile(
  title: Text("Agressie"),
  trailing: const Icon(Icons.arrow_forward_ios),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgressieScreen(),
      ),
    );
  },
),

   ListTile(
  title: const Text("Zorg & Veiligheid"),
  trailing: const Icon(Icons.arrow_forward_ios),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ZorgVeiligheidScreen(),
      ),
    );
  },
),

    ListTile(
  title: const Text("Digitale Veiligheid"),
  trailing: const Icon(Icons.arrow_forward_ios),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const DigitaleVeiligheidScreen(),
      ),
    );
  },
),

      ListTile(
  title: const Text("Middelen & Bezit"),
  trailing: const Icon(Icons.arrow_forward_ios),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const MiddelenBezitScreen(),
      ),
    );
  },
),

      ListTile(
  title: const Text("Overlast & Strafbaar Gedrag"),
  trailing: const Icon(Icons.arrow_forward_ios),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const OverlastStrafbaarScreen(),
      ),
    );
  },
),

            ListTile(
        title: Text("Overig"),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    ],
  ),
),
    );
  }
}