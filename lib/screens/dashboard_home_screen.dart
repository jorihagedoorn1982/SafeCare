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
  String trendMeldingen = "N.v.t.";
  String piekMaand = "Geen data";
  List<MapEntry<String, int>> topScholen = [];
  List<MapEntry<String, int>> topLocaties = [];
  List<MapEntry<String, int>> openDossiersPerSchool = [];

  Map<String, int> meldingenPerMaand = {};
  Map<String, int> locaties = {};
  Map<String, int> openPerSchool = {};
  Map<String, Map<String, int>> categoriePerSchool = {};
  Map<String, int> scholen = {};
  Map<String, String> topCategoriePerSchool = {};

  @override
void initState() {
  super.initState();

  gebruikerEmail =
      Supabase.instance.client.auth.currentUser?.email ?? "";

  laadProfiel();

}
Future<void> laadProfiel() async {
  try {
    final user =
        Supabase.instance.client.auth.currentUser;

    if (user == null) return;

    final resultaat =
        await Supabase.instance.client
            .from('profielen')
            .select()
            .eq('id', user.id);

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
  incidenten =
      await supabase
          .from('incidenten')
          .select()
          .eq(
            'school_id',
            gebruikerSchoolId!,
          );
} else if (gebruikerRol == 'bestuurder') {
  incidenten =
      await supabase
          .from('incidenten')
          .select()
          .eq(
            'bestuur_id',
            gebruikerBestuurId!,
          );
} else {
  incidenten =
      await supabase
          .from('incidenten')
          .select();
}

    final betrokkenen =
        await supabase.from('betrokkenen').select();

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

for (final incident in incidenten) {
  final categorie =
      incident['categorie']?.toString() ?? '';

  final school =
      incident['school']?.toString() ?? '';

  final locatie =
      incident['locatie']?.toString() ?? '';

  if (school.isNotEmpty &&
      categorie.isNotEmpty) {
    categoriePerSchool.putIfAbsent(
      school,
      () => {},
    );

    categoriePerSchool[school]![categorie] =
        (categoriePerSchool[school]![categorie] ?? 0) + 1;
  }

  if (locatie.isNotEmpty) {
    locaties[locatie] =
        (locaties[locatie] ?? 0) + 1;
  }

  if (school.isNotEmpty) {
    scholen[school] =
        (scholen[school] ?? 0) + 1;
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
    openPerSchool[school] =
        (openPerSchool[school] ?? 0) + 1;
  }

  if (meldingsdatum != null) {
    final datum =
        DateTime.parse(meldingsdatum);

    final nu = DateTime.now();

    if (datum.year == nu.year &&
        datum.month == nu.month) {
      dezeMaand++;
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
    final categorieen = {
      "Agressie": agressie,
      "Zorg & Veiligheid": zorg,
      "Digitale Veiligheid": digitaal,
      "Overlast & Strafbaar Gedrag": overlast,
    };

    String grootsteCategorie = "-";
    int hoogsteAantal = 0;
    String hoogsteMaand = "-";
int hoogsteMeldingen = 0;

    categorieen.forEach((naam, aantal) {
      if (aantal > hoogsteAantal) {
        hoogsteAantal = aantal;
        grootsteCategorie = naam;
      }
    });
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
    print(perMaand);
print("Aantal incidenten: ${incidenten.length}");
if (perMaand.length >= 2) {
  final waarden = perMaand.values.toList();

  final laatste = waarden.last;
  final vorige = waarden[waarden.length - 2];

  if (vorige > 0) {
    final verschil =
        ((laatste - vorige) / vorige) * 100;

    trendMeldingen =
        "${verschil.toStringAsFixed(0)}%";
  }
}
final openPerSchoolGesorteerd =
    openPerSchool.entries.toList()
      ..sort(
        (a, b) =>
            b.value.compareTo(a.value),
      );
      Map<String, String> hoogsteCategoriePerSchool = {};

categoriePerSchool.forEach(
  (school, categorieen) {
    String topCategorieSchool = "-";
    int hoogsteAantal = 0;

    categorieen.forEach(
      (categorie, aantal) {
        if (aantal > hoogsteAantal) {
          hoogsteAantal = aantal;
          topCategorieSchool = categorie;
        }
      },
    );

    hoogsteCategoriePerSchool[school] =
        topCategorieSchool;
  },
);
final scholenGesorteerd =
    scholen.entries.toList()
      ..sort(
        (a, b) =>
            b.value.compareTo(a.value),
      );
      final locatiesGesorteerd =
    locaties.entries.toList()
      ..sort(
        (a, b) =>
            b.value.compareTo(a.value),
      );

    setState(() {
      totaalMeldingen = incidenten.length;

      openDossiers = open;
      meldingenDezeMaand = dezeMaand;

      poAantal = po;
      voAantal = vo;
      mboAantal = mbo;

      topCategorie = grootsteCategorie;
      piekMaand = hoogsteMaand;

      meldingenPerMaand = perMaand;
topScholen = scholenGesorteerd;
topLocaties = locatiesGesorteerd;
openDossiersPerSchool =
    openPerSchoolGesorteerd;
    topCategoriePerSchool =
    hoogsteCategoriePerSchool;

      print("Scholen:");
print(scholen);

print("Gesorteerd:");
print(scholenGesorteerd);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    physics:
                        const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 1.8,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      _kaart(
                        "Open dossiers",
                        openDossiers.toString(),
                      ),
                      _kaart(
                        "Deze maand",
                        meldingenDezeMaand.toString(),
                      ),
                      _kaart(
                        "PO",
                        poAantal.toString(),
                      ),
                      _kaart(
                        "VO",
                        voAantal.toString(),
                      ),
                      _kaart(
                        "MBO",
                        mboAantal.toString(),
                      ),
                      _kaart(
                        "Top categorie",
                        topCategorie,
                      ),
                      _kaart(
  "Piekmaand",
  piekMaand,
),
                      _kaart(
  "Trend",
  trendMeldingen,
),
_kaart(
  "Top school",
  topScholen.isEmpty
      ? "-"
      : topScholen.first.key,
),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Meldingen per maand",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ...meldingenPerMaand.entries.map(
  (entry) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
  entry.key == "7-2026"
      ? "Juli 2026"
      : entry.key,
  style: const TextStyle(
    fontWeight: FontWeight.bold,
  ),
),

      const SizedBox(height: 5),

     Row(
  children: [
    Expanded(
      child: Container(
        height: 20,
        color: Colors.blue,
      ),
    ),
    const SizedBox(width: 10),
    Text(
      "${entry.value} meldingen",
    ),
  ],
),

      const SizedBox(height: 15),
    ],
  ),
),
const SizedBox(height: 30),

const Text(
  "Scholen die aandacht vragen",
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 10),
...topScholen.take(5).map(
  (school) => Card(
    child: ListTile(
      leading: const Icon(Icons.school),
      title: Text(school.key),
      trailing: Text(
        "${school.value} meldingen",
      ),
    ),
  ),
),
const SizedBox(height: 30),

const Text(
  "🔥 Hotspots",
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 10),

...topLocaties.take(5).map(
  (locatie) => Card(
    child: ListTile(
      leading: const Icon(Icons.place),
      title: Text(locatie.key),
      trailing: Text(
        "${locatie.value} meldingen",
      ),
    ),
  ),
),
const SizedBox(height: 30),

const Text(
  "🚨 Open dossiers per school",
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 10),

...openDossiersPerSchool.take(5).map(
  (school) => Card(
    child: ListTile(
      leading: const Icon(Icons.warning),
      title: Text(school.key),
      trailing: Text(
        "${school.value} open",
      ),
    ),
  ),
),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _kaart(String titel, String waarde) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              titel,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
