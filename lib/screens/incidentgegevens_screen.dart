import 'package:flutter/material.dart';
import '../main.dart';
import 'netwerkpartners_screen.dart';
import '../widgets/safecare_appbar.dart';

class IncidentGegevensScreen extends StatefulWidget {
  const IncidentGegevensScreen({super.key});

  @override
  State<IncidentGegevensScreen> createState() =>
      _IncidentGegevensScreenState();
}

class _IncidentGegevensScreenState
    extends State<IncidentGegevensScreen> {
  final TextEditingController klasController =
      TextEditingController();

  final TextEditingController omschrijvingController =
    TextEditingController();

DateTime? geselecteerdeDatum;

String vestiging = "Hoofdlocatie";
String locatieDuiding = "Aula";
String tijdvak = "Pauze";

  final List<String> vestigingen = [
    "Hoofdlocatie",
    "Locatie Noord",
    "Locatie Zuid",
    "Locatie Oost",
    "Locatie West",
    "Externe locatie",
  ];

  final List<String> locaties = [
    "Entree",
    "Aula",
    "Kantine",
    "Gang",
    "Trapportaal",
    "Toilet",
    "Schoolplein",
    "Fietsenstalling",
    "Gymzaal",
    "Praktijklokaal",
    "Lokaal",
    "Mediatheek",
    "Kantoorruimte",
    "Parkeerterrein",
    "Externe locatie",
    "Online",
    "Overig",
  ];

  final List<String> tijdvakken = [
    "Voor schooltijd",
    "Halen & brengen",
    "Tijdens les",
    "Leswisseling",
    "Pauze",
    "Tussenuren",
    "Praktijkles",
    "Lichamelijke opvoeding",
    "Excursie / activiteit",
    "Na schooltijd",
    "Online",
    "Onbekend",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SafeCareAppBar(
  titel: "Incidentgegevens",
),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextFormField(
  readOnly: true,
  decoration: InputDecoration(
    labelText: "Datum incident *",
    border: const OutlineInputBorder(),
    hintText: geselecteerdeDatum == null
        ? "Selecteer datum"
        : "${geselecteerdeDatum!.day}-${geselecteerdeDatum!.month}-${geselecteerdeDatum!.year}",
  ),
  onTap: () async {
    final datum = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (datum != null) {
      setState(() {
        geselecteerdeDatum = datum;
      });
    }
  },
),
const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: vestiging,
              decoration: const InputDecoration(
                labelText: "Vestiging / locatie",
                border: OutlineInputBorder(),
              ),
              items: vestigingen.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  vestiging = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: locatieDuiding,
              decoration: const InputDecoration(
                labelText: "Locatieduiding",
                border: OutlineInputBorder(),
              ),
              items: locaties.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  locatieDuiding = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: tijdvak,
              decoration: const InputDecoration(
                labelText: "Tijdvak",
                border: OutlineInputBorder(),
              ),
              items: tijdvakken.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  tijdvak = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller: omschrijvingController,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: "Omschrijving",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if (geselecteerdeDatum == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'Selecteer eerst een incidentdatum',
      ),
    ),
  );
  return;
}
incidentData.incidentDatum =
    geselecteerdeDatum!
        .toIso8601String();

incidentData.incidentDatum =
    "${geselecteerdeDatum!.day.toString().padLeft(2, '0')}-"
    "${geselecteerdeDatum!.month.toString().padLeft(2, '0')}-"
    "${geselecteerdeDatum!.year}";
    
                incidentData.vestiging =
                    vestiging;

                incidentData.locatieDuiding =
                    locatieDuiding;

                incidentData.tijdvak =
                    tijdvak;

                incidentData.omschrijving =
                    omschrijvingController.text;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const NetwerkpartnersScreen(),
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