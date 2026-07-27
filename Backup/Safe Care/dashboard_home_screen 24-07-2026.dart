import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/safecare_appbar.dart';

class DashboardHomeScreen extends StatefulWidget {
  const DashboardHomeScreen({super.key});

  @override
  State<DashboardHomeScreen> createState() =>
      _DashboardHomeScreenState();
}

class _DashboardHomeScreenState
    extends State<DashboardHomeScreen> {
  String gebruikerEmail = "";

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

  Map<String, int> meldingenPerMaand = {};
  Map<String, int> scholen = {};

  @override
  void initState() {
    super.initState();

    gebruikerEmail =
        Supabase.instance.client.auth.currentUser?.email ?? "";

    laadDashboard();
  }

  Future<void> laadDashboard() async {
    final supabase = Supabase.instance.client;

    final incidenten =
        await supabase.from('incidenten').select();

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
  print(incident);
      final categorie =
          incident['categorie']?.toString() ?? '';
final school =
    incident['school']?.toString() ?? '';

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
final scholenGesorteerd =
    scholen.entries.toList()
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
            Text(
              "Ingelogd als: $gebruikerEmail",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  GridView.count(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  crossAxisCount: 3,
  childAspectRatio: 0.9,
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
                      Card(
  child: Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: Text(
              topCategorie,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Top categorie",
          textAlign: TextAlign.center,
        ),
      ],
    ),
  ),
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
          Container(
            height: 20,
            width: entry.value.toDouble(),
            color: Colors.blue,
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
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  waarde,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            titel,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    ),
  );
}