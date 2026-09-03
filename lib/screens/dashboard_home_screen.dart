import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/safecare_appbar.dart';
import 'besturen_screen.dart';
import 'scholen_screen.dart';
import 'gebruikers_screen.dart';

class DashboardHomeScreen extends StatefulWidget {
  const DashboardHomeScreen({super.key});

  @override
  State<DashboardHomeScreen> createState() =>
      _DashboardHomeScreenState();
}

class _DashboardHomeScreenState
    extends State<DashboardHomeScreen> {

  String gebruikerEmail = "";
  String gebruikerNaam = "";
  String gebruikerRol = "";
  String? gebruikerBestuurId;
String? gebruikerSchoolId;

  int totaalMeldingen = 0;
  int openDossiers = 0;
  int meldingenDezeMaand = 0;

  int poAantal = 0;
  int voAantal = 0;
  int mboAantal = 0;

  String topCategorie = "-";
List<MapEntry<String, int>> topSubcategorieen = [];

String trendMeldingen = "N.v.t.";
String piekMaand = "Geen data";

String piekDagDezeMaand = "Geen data";
int piekDagAantalDezeMaand = 0;

String topTijdvakDezeMaand = "Geen data";
List<MapEntry<String, int>> tijdvakkenDezeMaand = [];

List<MapEntry<String, int>> topScholen = [];
List<MapEntry<String, int>> topLocaties = [];

Map<String, int> meldingenPerMaand = {};
Map<String, int> locaties = {};

Map<String, Map<String, int>> categoriePerSchool = {};
Map<String, String> topCategoriePerSchool = {};

Map<String, Map<String, int>> incidenttypenPerCategorie = {};
Map<String, Map<String, int>> locatiesPerSchool = {};
List<Map<String, dynamic>> alleIncidenten = [];

  @override
void initState() {
  super.initState();

  print('DASHBOARD HOME SCREEN GELADEN');

  gebruikerEmail =
      Supabase.instance.client.auth.currentUser?.email ?? "";

  laadProfiel();
}

Future<void> laadProfiel() async {
  try {
    final user =
        Supabase.instance.client.auth.currentUser;

    if (user == null) return;
    
print('AUTH USER ID: ${user.id}');

    final resultaat =
        await Supabase.instance.client
            .from('profielen')
            .select()
            .eq('email', user.email!);

    if (resultaat.isEmpty) {
      print("Geen profiel gevonden");
      return;
    }

    final profiel = resultaat.first;

    setState(() {
  gebruikerNaam =
      profiel['naam']?.toString() ?? '';

  gebruikerRol =
      profiel['rol']?.toString() ?? '';

  gebruikerBestuurId =
      profiel['bestuur_id']?.toString();

  gebruikerSchoolId =
      profiel['school_id']?.toString();
});
await laadDashboard();

    print("Profiel geladen:");
    print(profiel);
  } catch (e) {
    print("Fout bij laden profiel:");
    print(e);
  }
}
  Future<void> laadDashboard() async {
  final supabase = Supabase.instance.client;

  dynamic incidenten;

  if (gebruikerRol == 'directeur') {
    incidenten = await supabase
        .from('incidenten')
        .select()
        .eq(
          'school_id',
          gebruikerSchoolId!,
        );
  } else if (gebruikerRol == 'bestuurder') {
    incidenten = await supabase
        .from('incidenten')
        .select()
        .eq(
          'bestuur_id',
          gebruikerBestuurId!,
        );
  } else {
    incidenten = await supabase
        .from('incidenten')
        .select();
  }

  final betrokkenen =
      await supabase.from('betrokkenen').select();

  int verwerkteIncidenten = 0;

  int po = 0;
  int vo = 0;
  int mbo = 0;

  int agressie = 0;
  int zorg = 0;
  int digitaal = 0;
  int overlast = 0;

  int open = 0;
  int dezeMaand = 0;

  Map<String, int> perMaand = {};
Map<String, int> subcategorieen = {};
Map<String, Map<String, int>> subcategorieenPerCategorie = {};
Map<String, Map<String, int>> locatiesPerSchoolTemp = {};

Map<String, int> perDagDezeMaand = {};
Map<String, int> tijdvakkenTemp = {};

Map<String, int> locatiesTemp = {};
Map<String, int> openPerSchoolTemp = {};
Map<String, Map<String, int>> categoriePerSchoolTemp = {};
Map<String, int> scholenTemp = {};
List<Map<String, dynamic>> geldigeIncidenten = [];

print('ROL: $gebruikerRol');
print('BESTUUR ID: $gebruikerBestuurId');
print('INCIDENTEN GEVONDEN: ${incidenten.length}');

  for (final incident in incidenten) {
    final categorie =
        incident['categorie']?.toString() ?? '';

    if (categorie == 'Test') {
  continue;
}

geldigeIncidenten.add(Map<String, dynamic>.from(incident));

verwerkteIncidenten++;

    final subcategorie =
        incident['subcategorie']?.toString() ?? '';

    final incidentTypes =
        _incidentTypesUitSubcategorie(subcategorie);

    for (final incidentType in incidentTypes) {
      if (incidentType.isNotEmpty &&
          incidentType != 'Testsubcategorie' &&
          categorie.isNotEmpty) {
        subcategorieen[incidentType] =
            (subcategorieen[incidentType] ?? 0) + 1;

        subcategorieenPerCategorie.putIfAbsent(
          categorie,
          () => {},
        );

        subcategorieenPerCategorie[categorie]![incidentType] =
            (subcategorieenPerCategorie[categorie]![incidentType] ?? 0) + 1;
      }
    }

    final school =
        incident['school']?.toString() ?? '';

    final locatie =
    incident['locatie']?.toString() ?? '';

    final tijdvak =
    incident['tijdvak']?.toString() ?? '';
        

    if (school.isNotEmpty && locatie.isNotEmpty) {
      locatiesPerSchoolTemp.putIfAbsent(
        school,
        () => {},
      );

      locatiesPerSchoolTemp[school]![locatie] =
          (locatiesPerSchoolTemp[school]![locatie] ?? 0) + 1;
    }

    if (locatie.isNotEmpty) {
      locatiesTemp[locatie] =
          (locatiesTemp[locatie] ?? 0) + 1;
    }

    if (school.isNotEmpty) {
      scholenTemp[school] =
          (scholenTemp[school] ?? 0) + 1;
    }

    if (school.isNotEmpty &&
        categorie.isNotEmpty) {
      categoriePerSchoolTemp.putIfAbsent(
        school,
        () => {},
      );

      categoriePerSchoolTemp[school]![categorie] =
          (categoriePerSchoolTemp[school]![categorie] ?? 0) + 1;
    }

    final status =
        incident['status']?.toString() ?? '';

    final meldingsdatum =
        incident['meldingsdatum'];

    if (status != 'Afgerond') {
      open++;
    }

    if (status != 'Afgerond' &&
        school.isNotEmpty) {
      openPerSchoolTemp[school] =
          (openPerSchoolTemp[school] ?? 0) + 1;
    }

    if (meldingsdatum != null) {
      final datum =
          DateTime.parse(meldingsdatum);

      final nu = DateTime.now();

      if (datum.year == nu.year &&
    datum.month == nu.month) {
  dezeMaand++;

  final dagKey =
      "${datum.day}-${datum.month}-${datum.year}";

  perDagDezeMaand[dagKey] =
      (perDagDezeMaand[dagKey] ?? 0) + 1;

  if (tijdvak.isNotEmpty) {
    tijdvakkenTemp[tijdvak] =
        (tijdvakkenTemp[tijdvak] ?? 0) + 1;
  }
}

      final maand =
          "${datum.month}-${datum.year}";

      perMaand[maand] =
          (perMaand[maand] ?? 0) + 1;
    }

    if (categorie == 'Agressie') agressie++;
    if (categorie == 'Zorg & Veiligheid') zorg++;
    if (categorie == 'Digitale Veiligheid') digitaal++;

    if (categorie ==
        'Overlast & Strafbaar Gedrag') {
      overlast++;
    }
  }

  for (final persoon in betrokkenen) {
    final niveau =
        persoon['onderwijsniveau']?.toString() ?? '';

    if (niveau == 'PO') po++;
    if (niveau == 'VO') vo++;
    if (niveau == 'MBO') mbo++;
  }

  String grootsteCategorie = "-";
  int hoogsteAantal = 0;
  String hoogsteMaand = "-";
  int hoogsteMeldingen = 0;

  subcategorieen.forEach((naam, aantal) {
    if (aantal > hoogsteAantal) {
      hoogsteAantal = aantal;
      grootsteCategorie = naam;
    }
  });

  final subcategorieenGesorteerd =
      subcategorieen.entries.toList()
        ..sort(
          (a, b) => b.value.compareTo(a.value),
        );

  const maanden = {
    "1": "Januari",
    "2": "Februari",
    "3": "Maart",
    "4": "April",
    "5": "Mei",
    "6": "Juni",
    "7": "Juli",
    "8": "Augustus",
    "9": "September",
    "10": "Oktober",
    "11": "November",
    "12": "December",
  };

  perMaand.forEach((maand, aantal) {
    if (aantal > hoogsteMeldingen) {
      hoogsteMeldingen = aantal;

      final delen = maand.split('-');

      hoogsteMaand =
          "${maanden[delen[0]]} ${delen[1]}";
    }
  });
String hoogsteDag = "Geen data";
int hoogsteDagAantal = 0;

perDagDezeMaand.forEach((dag, aantal) {
  if (aantal > hoogsteDagAantal) {
    hoogsteDagAantal = aantal;

    final delen = dag.split('-');

    const maandenKort = {
      "1": "januari",
      "2": "februari",
      "3": "maart",
      "4": "april",
      "5": "mei",
      "6": "juni",
      "7": "juli",
      "8": "augustus",
      "9": "september",
      "10": "oktober",
      "11": "november",
      "12": "december",
    };

    hoogsteDag =
        "${delen[0]} ${maandenKort[delen[1]]} ${delen[2]}";
  }
});

final tijdvakkenGesorteerd =
    tijdvakkenTemp.entries.toList()
      ..sort(
        (a, b) => b.value.compareTo(a.value),
      );

final hoogsteTijdvak =
    tijdvakkenGesorteerd.isEmpty
        ? "Geen data"
        : tijdvakkenGesorteerd.first.key;

  final trendMaanden =
      perMaand.entries.toList()
        ..sort(
          (a, b) {
            final aSplit = a.key.split('-');
            final bSplit = b.key.split('-');

            final aDatum = DateTime(
              int.parse(aSplit[1]),
              int.parse(aSplit[0]),
            );

            final bDatum = DateTime(
              int.parse(bSplit[1]),
              int.parse(bSplit[0]),
            );

            return aDatum.compareTo(bDatum);
          },
        );

  if (trendMaanden.length >= 2) {
    final laatste = trendMaanden.last.value;

    final vorige =
        trendMaanden[trendMaanden.length - 2].value;

    if (vorige > 0) {
      final verschil =
          ((laatste - vorige) / vorige) * 100;

      trendMeldingen =
          "${verschil.toStringAsFixed(0)}%";
    }
  }

  final openPerSchoolGesorteerd =
      openPerSchoolTemp.entries.toList()
        ..sort(
          (a, b) => b.value.compareTo(a.value),
        );

  Map<String, String> hoogsteCategoriePerSchool = {};

  categoriePerSchoolTemp.forEach(
    (school, categorieen) {
      String topCategorieSchool = "-";
      int hoogsteAantalSchool = 0;

      categorieen.forEach(
        (categorie, aantal) {
          if (aantal > hoogsteAantalSchool) {
            hoogsteAantalSchool = aantal;
            topCategorieSchool = categorie;
          }
        },
      );

      hoogsteCategoriePerSchool[school] =
          topCategorieSchool;
    },
  );

  final scholenGesorteerd =
      scholenTemp.entries.toList()
        ..sort(
          (a, b) => b.value.compareTo(a.value),
        );

  final locatiesGesorteerd =
      locatiesTemp.entries.toList()
        ..sort(
          (a, b) => b.value.compareTo(a.value),
        );

  setState(() {
  totaalMeldingen = verwerkteIncidenten;
  alleIncidenten = geldigeIncidenten;
  print("Aantal alleIncidenten: ${alleIncidenten.length}");
  openDossiers = open;

  meldingenDezeMaand = dezeMaand;

  poAantal = po;
  voAantal = vo;
  mboAantal = mbo;

  topCategorie = grootsteCategorie;
  piekMaand = hoogsteMaand;

  piekDagDezeMaand = hoogsteDag;
  piekDagAantalDezeMaand = hoogsteDagAantal;
  topTijdvakDezeMaand = hoogsteTijdvak;
  tijdvakkenDezeMaand = tijdvakkenGesorteerd;

  meldingenPerMaand = perMaand;

  topScholen = scholenGesorteerd;
  topLocaties = locatiesGesorteerd;

  locatiesPerSchool = locatiesPerSchoolTemp;

  topCategoriePerSchool =
      hoogsteCategoriePerSchool;

  topSubcategorieen =
      subcategorieenGesorteerd;

  incidenttypenPerCategorie =
      subcategorieenPerCategorie;
});
}

  @override
  Widget build(BuildContext context) {
    final gesorteerdeMaanden =
    meldingenPerMaand.entries.toList()
      ..sort(
        (a, b) {
          final aSplit = a.key.split('-');
          final bSplit = b.key.split('-');

          final aDatum = DateTime(
            int.parse(aSplit[1]),
            int.parse(aSplit[0]),
          );

          final bDatum = DateTime(
            int.parse(bSplit[1]),
            int.parse(bSplit[0]),
          );

          return aDatum.compareTo(bDatum);
        },
      );
    return Scaffold(
      appBar: SafeCareAppBar(
        titel: "Dashboard",
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();

              if (!mounted) return;

              Navigator.popUntil(
                context,
                (route) => route.isFirst,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      gebruikerNaam,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    Text(
      gebruikerRol,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
    ),
    Text(
      gebruikerEmail,
      style: const TextStyle(
        fontSize: 14,
      ),
    ),
  ],
),

            const SizedBox(height: 20),

            if (gebruikerRol == 'admin')
  Wrap(
    spacing: 10,
    runSpacing: 10,
    children: [
      ElevatedButton.icon(
        onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const BesturenScreen(),
    ),
  );
},
        icon: const Icon(Icons.account_balance),
        label: const Text('Besturen'),
      ),
      ElevatedButton.icon(
        onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ScholenScreen(),
    ),
  );
},
        icon: const Icon(Icons.school),
        label: const Text('Scholen'),
      ),
      ElevatedButton.icon(
        onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          const GebruikersScreen(),
    ),
  );
},
        icon: const Icon(Icons.people),
        label: const Text('Gebruikers'),
      ),
    ],
  ),
  const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  GridView.count(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  crossAxisCount: 3,
  childAspectRatio:3.2,
  crossAxisSpacing: 15,
  mainAxisSpacing: 15,
  children: [
  _kaartKlikbaar(
  "Totaal incidenten",
  totaalMeldingen.toString(),
  () {
    _toonTotaalIncidentenDetails(context);
  },
),
  _kaartKlikbaar(
  "Incidenten deze maand",
  meldingenDezeMaand.toString(),
  () {
    _toonDezeMaandDetails(context);
  },
),
  _kaartKlikbaar(
  "Trend",
  trendMeldingen,
  () {
    _toonTrendDetails(context);
  },
),
  _kaart(
    "Aandachtsschool",
    topScholen.isEmpty
        ? "-"
        : "${topScholen.first.key}\n${topScholen.first.value} meldingen",
  ),
  _kaart(
    "Piekmaand",
    piekMaand,
  ),
],
),


const SizedBox(height: 30),


                  const Text(
  "Verdeling meldingen per maand",
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 10),

_maandDiagram(context, gesorteerdeMaanden),

const SizedBox(height: 30),

const Text(
  "🔥 Incidenttypen per categorie",
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 10),

_incidenttypenPerCategorieDiagram(
  incidenttypenPerCategorie,
),

const SizedBox(height: 30),


const Text(
  "🏫 Scholen en hotspots",
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 10),

_scholenMetLocatiesDiagram(
  topScholen,
  locatiesPerSchool,
),

const SizedBox(height: 30),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  IconData _icoonVoorCategorie(String categorieNaam) {
  switch (categorieNaam) {
    case "Agressie":
      return Icons.warning_amber_rounded;

    case "Digitale Veiligheid":
      return Icons.security;

    case "Zorg & Veiligheid":
      return Icons.health_and_safety;

    case "Overlast & Strafbaar Gedrag":
      return Icons.gavel;

    case "Gebruik, bezit en handel van verboden middelen":
      return Icons.medication_liquid;

    default:
      return Icons.category;
  }
}
  String _kortIncidentType(String waarde) {
  final schoon = waarde.trim();

  if (schoon.isEmpty) {
    return "";
  }

  if (schoon.contains('(')) {
    return schoon.split('(').first.trim();
  }

  return schoon;
}
Widget _incidenttypenPerCategorieDiagram(
  Map<String, Map<String, int>> data,
) {
  final volgordeCategorieen = [
    "Agressie",
    "Digitale Veiligheid",
    "Zorg & Veiligheid",
    "Overlast & Strafbaar Gedrag",
    "Gebruik, bezit en handel van verboden middelen",
  ];

  final totaalAlleIncidenttypen = data.values.fold<int>(
    0,
    (som, subtypes) =>
        som +
        subtypes.values.fold<int>(
          0,
          (subSom, aantal) => subSom + aantal,
        ),
  );

  if (totaalAlleIncidenttypen == 0) {
    return const Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Nog geen betrouwbare subcategorie-data beschikbaar.",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  return Card(
    elevation: 1,
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Verdeling incidenttypen",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Klik op een categorie om de subcategorieën te bekijken.",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),

          ...volgordeCategorieen.map((categorieNaam) {
            final subtypesMap = data[categorieNaam] ?? {};

            final subtypes = subtypesMap.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));

            final totaalCategorie = subtypes.fold<int>(
              0,
              (som, item) => som + item.value,
            );

            if (totaalCategorie == 0) {
              return const SizedBox.shrink();
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 0,
              color: const Color(0xFFF4F7FA),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 0,
                ),
                childrenPadding: const EdgeInsets.only(
                  left: 14,
                  right: 14,
                  bottom: 10,
                ),
                leading: Icon(
  _icoonVoorCategorie(categorieNaam),
  color: const Color(0xFF22415B),
),
                title: Text(
                  categorieNaam,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  "${totaalCategorie}x",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: subtypes.take(6).map((item) {
                  final subtypePercentage =
                      totaalCategorie == 0
                          ? 0.0
                          : item.value / totaalCategorie;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 190,
                          child: Text(
                            item.key,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: subtypePercentage,
                              minHeight: 6,
                              backgroundColor: const Color(0xFFE7ECEF),
valueColor:
    const AlwaysStoppedAnimation<Color>(
  Color(0xFF22415B),
),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 38,
                          child: Text(
                            "${item.value}x",
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    ),
  );
}
Widget _scholenMetLocatiesDiagram(
  List<MapEntry<String, int>> scholenData,
  Map<String, Map<String, int>> locatiesData,
) {
  final top5Scholen = scholenData.take(5).toList();

  if (top5Scholen.isEmpty) {
    return const Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Geen schoolgegevens beschikbaar.",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  return Card(
    elevation: 1,
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: top5Scholen.map((schoolEntry) {
          final schoolNaam = schoolEntry.key;
          final schoolAantal = schoolEntry.value;

          final locaties = (locatiesData[schoolNaam] ?? {})
              .entries
              .toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            elevation: 0,
            color: const Color(0xFFF4F7FA),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 0,
              ),
              childrenPadding: const EdgeInsets.only(
                left: 14,
                right: 14,
                bottom: 10,
              ),
              leading: const Icon(
                Icons.school,
                color: Color(0xFF10212D),
              ),
              title: Text(
                schoolNaam,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                "$schoolAantal meldingen",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: locaties.isEmpty
                  ? [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Geen locatiegegevens beschikbaar.",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ]
                  : locaties.take(5).map((locatieEntry) {
                      final hoogsteLocatieAantal =
                          locaties.first.value == 0
                              ? 1
                              : locaties.first.value;

                      final locatiePercentage =
                          locatieEntry.value / hoogsteLocatieAantal;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 190,
                              child: Text(
                                locatieEntry.key,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: locatiePercentage,
                                  minHeight: 6,
                                  backgroundColor: const Color(0xFFE7ECEF),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    Color(0xFF68A09F),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 52,
                              child: Text(
                                "${locatieEntry.value}x",
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
            ),
          );
        }).toList(),
      ),
    ),
  );
}
  Widget _maandDiagram(
  BuildContext context,
  List<MapEntry<String, int>> maandenData,
) {

  final totaal = maandenData.fold<int>(
    0,
    (som, item) => som + item.value,
  );

  final kleuren = [
  Color(0xFF22415B),
  Color(0xFF68A09F),
  Color(0xFFCFB233),
  Color(0xFFB56664),
  Color(0xFF9EC9CB),
  Color(0xFFEFDA89),
  Color(0xFF934745),
  Color(0xFFDA907E),
  Color(0xFFEDAFA2),
  Color(0xFFF4E7B9),
  Color(0xFFECD2CA),
  Color(0xFF10212D),
];

  return Card(
    elevation: 1,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          SizedBox(
            width: 220,
            height: 220,
            child: CustomPaint(
              painter: MaandCirkelPainter(
                waarden: maandenData.map((e) => e.value).toList(),
                kleuren: kleuren,
              ),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: maandenData.asMap().entries.map(
                (entry) {
                  final index = entry.key;
                  final maand = entry.value;
                  final percentage =
                      totaal == 0 ? 0 : (maand.value / totaal) * 100;

                  return InkWell(
  onTap: () {
    _toonMaandDetails(context, maand.key);
  },
  borderRadius: BorderRadius.circular(8),
  child: Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: kleuren[index % kleuren.length],
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            _maandNaam(maand.key),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          "${maand.value} meldingen (${percentage.toStringAsFixed(0)}%)",
        ),
      ],
    ),
  ),
);
                },
              ).toList(),
            ),
          ),
        ],
      ),
    ),
  );
}

String _maandNaam(String maandKey) {
  final delen = maandKey.split('-');

  const maanden = {
    "1": "Januari",
    "2": "Februari",
    "3": "Maart",
    "4": "April",
    "5": "Mei",
    "6": "Juni",
    "7": "Juli",
    "8": "Augustus",
    "9": "September",
    "10": "Oktober",
    "11": "November",
    "12": "December",
  };

  if (delen.length < 2) {
    return maandKey;
  }

  return "${maanden[delen[0]] ?? delen[0]} ${delen[1]}";
}
Widget _topIncidenttypenDiagram(
  List<MapEntry<String, int>> incidenttypen,
) {
  final top5 = incidenttypen.take(5).toList();

  if (top5.isEmpty) {
    return const Text("Geen incidenttypen beschikbaar");
  }

  final hoogsteAantal = top5.first.value;

  return Card(
    elevation: 1,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: top5.map((item) {
          final percentage =
              hoogsteAantal == 0 ? 0.0 : item.value / hoogsteAantal;

          final korteNaam = item.key.contains('(')
              ? item.key.split('(').first.trim()
              : item.key;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        korteNaam,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      "${item.value}x",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: percentage,
                    minHeight: 14,
                    backgroundColor: const Color(0xFFE5EAF0),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF1E88E5),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    ),
  );
}
void _toonMaandDetails(BuildContext context, String maandKey) {
  final delen = maandKey.split('-');

  if (delen.length < 2) {
    return;
  }

  final maand = int.tryParse(delen[0]);
  final jaar = int.tryParse(delen[1]);

  if (maand == null || jaar == null) {
    return;
  }

  final incidentenDezeMaand = alleIncidenten.where((incident) {
    final meldingsdatum = incident['meldingsdatum'];

    if (meldingsdatum == null) {
      return false;
    }

    try {
      final datum = DateTime.parse(meldingsdatum.toString());
      return datum.month == maand && datum.year == jaar;
    } catch (_) {
      return false;
    }
  }).toList();

  final Map<String, int> perSchool = {};
  final Map<String, int> incidenttypen = {};

  for (final incident in incidentenDezeMaand) {
    final school = incident['school']?.toString() ?? '';
    final categorie = incident['categorie']?.toString() ?? '';
    final subcategorie = incident['subcategorie']?.toString() ?? '';

    if (school.isNotEmpty) {
      perSchool[school] = (perSchool[school] ?? 0) + 1;
    }

    final types = _incidentTypesUitSubcategorie(subcategorie);

    if (types.isNotEmpty) {
      for (final type in types) {
        if (type.trim().isNotEmpty) {
          incidenttypen[type] = (incidenttypen[type] ?? 0) + 1;
        }
      }
    } else if (categorie.isNotEmpty) {
      incidenttypen[categorie] = (incidenttypen[categorie] ?? 0) + 1;
    }
  }

  final scholenGesorteerd = perSchool.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  final incidenttypenGesorteerd = incidenttypen.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  final hoogsteSchoolAantal =
      scholenGesorteerd.isEmpty ? 1 : scholenGesorteerd.first.value;

  final hoogsteIncidenttypeAantal =
      incidenttypenGesorteerd.isEmpty ? 1 : incidenttypenGesorteerd.first.value;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(_maandNaam(maandKey)),
        content: SizedBox(
          width: 650,
          height: 520,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${incidentenDezeMaand.length} meldingen in ${_maandNaam(maandKey)}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  "Verdeling per school",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                if (scholenGesorteerd.isEmpty)
                  const Text(
                    "Geen schoolgegevens beschikbaar.",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )
                else
                  ...scholenGesorteerd.map((school) {
                    final percentage = school.value / hoogsteSchoolAantal;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 170,
                            child: Text(
                              school.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: percentage,
                                minHeight: 8,
                                backgroundColor: const Color(0xFFE7ECEF),
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF22415B),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 80,
                            child: Text(
                              "${school.value}x",
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                const SizedBox(height: 24),

                const Text(
                  "Meest voorkomende incidenttypen",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                if (incidenttypenGesorteerd.isEmpty)
                  const Text(
                    "Geen incidenttypegegevens beschikbaar.",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )
                else
                  ...incidenttypenGesorteerd.take(8).map((item) {
                    final percentage =
                        item.value / hoogsteIncidenttypeAantal;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 230,
                            child: Text(
                              item.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: percentage,
                                minHeight: 8,
                                backgroundColor: const Color(0xFFE7ECEF),
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF68A09F),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 80,
                            child: Text(
                              "${item.value}x",
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Sluiten"),
          ),
        ],
      );
    },
  );
}
void _toonTrendDetails(BuildContext context) {
  final trendData = meldingenPerMaand.entries.toList()
    ..sort(
      (a, b) {
        final aSplit = a.key.split('-');
        final bSplit = b.key.split('-');

        final aDatum = DateTime(
          int.parse(aSplit[1]),
          int.parse(aSplit[0]),
        );

        final bDatum = DateTime(
          int.parse(bSplit[1]),
          int.parse(bSplit[0]),
        );

        return aDatum.compareTo(bDatum);
      },
    );

  if (trendData.isEmpty) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Trend"),
          content: const Text(
            "Geen maandgegevens beschikbaar.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Sluiten"),
            ),
          ],
        );
      },
    );

    return;
  }

  final hoogsteAantal = trendData
      .map((item) => item.value)
      .reduce((a, b) => a > b ? a : b);

  final laatsteMaand = trendData.last;
  final vorigeMaand =
      trendData.length >= 2 ? trendData[trendData.length - 2] : null;

  String onderbouwing = "Er is nog geen vorige maand beschikbaar om mee te vergelijken.";

  if (vorigeMaand != null && vorigeMaand.value > 0) {
    final verschil =
        ((laatsteMaand.value - vorigeMaand.value) / vorigeMaand.value) * 100;

    final richting = verschil >= 0 ? "stijging" : "daling";

    onderbouwing =
        "De trend is gebaseerd op ${_maandNaam(vorigeMaand.key)} (${vorigeMaand.value} meldingen) "
        "vergeleken met ${_maandNaam(laatsteMaand.key)} (${laatsteMaand.value} meldingen). "
        "Dat is een $richting van ${verschil.abs().toStringAsFixed(0)}%.";
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Trend onderbouwing"),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Trend: $trendMeldingen",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                onderbouwing,
                style: const TextStyle(
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                "Ontwikkeling per maand",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              ...trendData.map((item) {
                final percentage =
                    hoogsteAantal == 0 ? 0.0 : item.value / hoogsteAantal;

                final isLaatsteMaand =
                    item.key == laatsteMaand.key;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          _maandNaam(item.key),
                          style: TextStyle(
                            fontWeight: isLaatsteMaand
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: percentage,
                            minHeight: 8,
                            backgroundColor: const Color(0xFFE7ECEF),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(
                              isLaatsteMaand
                                  ? const Color(0xFF22415B)
                                  : const Color(0xFF68A09F),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 88,
                        child: Text(
                          "${item.value} meldingen",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: isLaatsteMaand
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Sluiten"),
          ),
        ],
      );
    },
  );
}
void _toonTotaalIncidentenDetails(BuildContext context) {
  final scholenData = topScholen;
  final hoogsteAantal = scholenData.isEmpty ? 1 : scholenData.first.value;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Totaal incidenten"),
        content: SizedBox(
          width: 520,
          height: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$totaalMeldingen incidenten totaal",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Verdeling per school",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                if (scholenData.isEmpty)
                  const Text(
                    "Geen schoolgegevens beschikbaar.",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )
                else
                  ...scholenData.map((school) {
                    final percentage = hoogsteAantal == 0
                        ? 0.0
                        : school.value / hoogsteAantal;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 160,
                            child: Text(
                              school.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: percentage,
                                minHeight: 8,
                                backgroundColor: const Color(0xFFE7ECEF),
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF22415B),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 90,
                            child: Text(
                              "${school.value} incidenten",
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Sluiten"),
          ),
        ],
      );
    },
  );
}
void _toonDezeMaandDetails(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Incidenten deze maand"),
        content: SizedBox(
          width: 460,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$meldingenDezeMaand incidenten deze maand",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "Piekdag",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                piekDagAantalDezeMaand == 0
                    ? "Geen daggegevens beschikbaar"
                    : "$piekDagDezeMaand · $piekDagAantalDezeMaand incidenten",
              ),

              const SizedBox(height: 18),

              const Text(
                "Meest voorkomend tijdvak",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(topTijdvakDezeMaand),

              const SizedBox(height: 18),

              const Text(
                "Verdeling per tijdvak",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              if (tijdvakkenDezeMaand.isEmpty)
                const Text(
                  "Geen tijdvakdata beschikbaar.",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                )
              else
                ...tijdvakkenDezeMaand.map((item) {
                  final hoogsteAantal =
                      tijdvakkenDezeMaand.first.value == 0
                          ? 1
                          : tijdvakkenDezeMaand.first.value;

                  final percentage =
                      item.value / hoogsteAantal;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 150,
                          child: Text(item.key),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: percentage,
                              minHeight: 7,
                              backgroundColor: const Color(0xFFE7ECEF),
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(
                                Color(0xFF22415B),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 42,
                          child: Text(
                            "${item.value}x",
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Sluiten"),
          ),
        ],
      );
    },
  );
}
Widget _kaartKlikbaar(
  String titel,
  String waarde,
  VoidCallback onTap,
) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: _kaart(titel, waarde),
  );
}
   Widget _kaart(String titel, String waarde) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                waarde,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B1F24),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              titel,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MaandCirkelPainter extends CustomPainter {
  final List<int> waarden;
  final List<Color> kleuren;

  MaandCirkelPainter({
    required this.waarden,
    required this.kleuren,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final totaal = waarden.fold<int>(
      0,
      (som, waarde) => som + waarde,
    );

    if (totaal == 0) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 38
      ..strokeCap = StrokeCap.butt;

    final rect = Rect.fromLTWH(
      20,
      20,
      size.width - 40,
      size.height - 40,
    );

    double startAngle = -math.pi / 2;

    for (int i = 0; i < waarden.length; i++) {
      final sweepAngle =
          (waarden[i] / totaal) * 2 * math.pi;

      paint.color = kleuren[i % kleuren.length];

      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant MaandCirkelPainter oldDelegate) {
    return oldDelegate.waarden != waarden ||
        oldDelegate.kleuren != kleuren;
  }
}
List<String> _incidentTypesUitSubcategorie(String waarde) {
  final schoon = waarde.trim();

  if (schoon.isEmpty) {
    return [];
  }

  final bekendeTypes = [
    "A-gedrag",
    "B-gedrag",
    "C-gedrag",
    "D-gedrag",

    "Doxing",
    "Deepfake",
    "Hacken account",
    "Identiteitsfraude",
    "Privacyschending",
    "Sexting",
    "Sextortion",

    "Alcohol",
    "Vape",
    "Drugs",
    "Medicatie",
    "Wapens",
    "Handel",

    "Diefstal",
    "Vernieling en vandalisme",
    "Mishandeling",
    "Bedreiging",
    "Brandstichting",
    "Overige strafbare feiten",

    "Pesten",
    "Cyberpesten",
    "Online haatcampagne",
    "Roddelcircuit",
    "Sociale uitsluiting",
    "Criminele uitbuiting",
    "Seksuele uitbuiting",
    "Mensenhandel",
    "Huiselijk geweld",
    "Eerwraak",
    "Stalking",
    "Verwaarlozing",
    "Huwelijksdwang",
    "Psychische problematiek",
    "Verslaving",
    "Suïcidaliteit",
    "Betrokkenheid bij bendevorming / groepsdruk",
    "Geldezel / financieel misbruik",
    "F-game / Fraudeconstructie",
    "F-game (Fraude game)",
  ];

  final gevondenTypes = <String>[];

  for (final type in bekendeTypes) {
    if (schoon.contains(type)) {
      gevondenTypes.add(type);
    }
  }

  if (gevondenTypes.isNotEmpty) {
    return gevondenTypes;
  }

  return schoon
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();
}