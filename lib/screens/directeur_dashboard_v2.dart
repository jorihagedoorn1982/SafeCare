import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'incident_detail_screen.dart';


class DirecteurDashboardV2 extends StatefulWidget {
  const DirecteurDashboardV2({super.key});

  @override
  State<DirecteurDashboardV2> createState() =>
      _DirecteurDashboardV2State();
}

class _DirecteurDashboardV2State
    extends State<DirecteurDashboardV2> {
  int totaalIncidenten = 0;
  int incidentenDezeMaand = 0;
  int openDossiers = 0;
  List<dynamic> laatsteIncidenten = [];

  String belangrijksteHotspot = '-';

  @override
  void initState() {
    super.initState();
    _laadDashboard();
  }

  Future<void> _laadDashboard() async {
    const schoolId =
        '75d629d5-07f4-4b93-a1dc-518d262c323c';

    final incidenten =
        await Supabase.instance.client
            .from('incidenten')
            .select()
            .eq('school_id', schoolId);

    final dezeMaand =
        await Supabase.instance.client
            .from('incidenten')
            .select('id')
            .eq('school_id', schoolId)
            .gte(
              'meldingsdatum',
              DateTime(
                DateTime.now().year,
                DateTime.now().month,
                1,
              ).toIso8601String(),
            );

    final open =
        await Supabase.instance.client
            .from('incidenten')
            .select('id')
            .eq('school_id', schoolId)
            .inFilter(
              'status',
              ['Open', 'In behandeling'],
            );

    final hotspot =
        await Supabase.instance.client
            .from('incidenten')
            .select('locatie')
            .eq('school_id', schoolId);

    final locatieTellingen = <String, int>{};

    for (final item in hotspot) {
      final locatie =
          item['locatie']?.toString() ?? '';

      if (locatie.isEmpty) continue;

      locatieTellingen[locatie] =
          (locatieTellingen[locatie] ?? 0) + 1;
    }

    String hotspotNaam = '-';

    if (locatieTellingen.isNotEmpty) {
  hotspotNaam = locatieTellingen.entries
      .reduce(
        (a, b) => a.value > b.value ? a : b,
      )
      .key;
}

final laatste = List.from(incidenten);

laatste.sort((a, b) {
  return DateTime.parse(
    b['meldingsdatum'],
  ).compareTo(
    DateTime.parse(
      a['meldingsdatum'],
    ),
  );
});

setState(() {
  totaalIncidenten = incidenten.length;
  incidentenDezeMaand = dezeMaand.length;
  openDossiers = open.length;
  belangrijksteHotspot = hotspotNaam;

  laatsteIncidenten =
      laatste.take(5).toList();
});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text('Directeur Dashboard'),
  actions: [
    IconButton(
      icon: const Icon(Icons.logout),
      tooltip: 'Uitloggen',
      onPressed: () async {
        await Supabase.instance.client.auth.signOut();

        if (!mounted) return;

        Navigator.of(context).pushNamedAndRemoveUntil(
          '/',
          (route) => false,
        );
      },
    ),
  ],
),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Directeur Dashboard',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              GridView.count(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 2.2,
                children: [
                  _dashboardKaart(
                    totaalIncidenten.toString(),
                    'Totaal incidenten',
                  ),
                  _dashboardKaart(
                    incidentenDezeMaand.toString(),
                    'Incidenten deze maand',
                  ),
                  _dashboardKaart(
                    openDossiers.toString(),
                    'Open dossiers',
                  ),
                  _dashboardKaart(
                    belangrijksteHotspot,
                    'Belangrijkste hotspot',
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                '🔥 Incidenttypen',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(20),
                  child: Column(
                    children: const [
                      ListTile(
                        title: Text(
                          'Overlast & Strafbaar Gedrag',
                        ),
                        trailing: Text('14'),
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Agressie'),
                        trailing: Text('14'),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Zorg & Veiligheid',
                        ),
                        trailing: Text('11'),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Digitale Veiligheid',
                        ),
                        trailing: Text('8'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
const Text(
  '📈 Meldingen per maand',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),
Card(
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: const [
        ListTile(
          leading: Icon(Icons.calendar_month),
          title: Text('April'),
          subtitle: Text('2026'),
          trailing: Text('14'),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.calendar_month),
          title: Text('Mei'),
          subtitle: Text('2026'),
          trailing: Text('15'),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.calendar_month),
          title: Text('Juni'),
          subtitle: Text('2026'),
          trailing: Text('10'),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.calendar_month),
          title: Text('Juli'),
          subtitle: Text('2026'),
          trailing: Text('8'),
        ),
      ],
    ),
  ),
),
const SizedBox(height: 30),
const SizedBox(height: 30),

const Text(
  '🚨 Laatste incidenten',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

Card(
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: laatsteIncidenten.map((incident) {
        return Column(
          children: [
            ListTile(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IncidentDetailScreen(
          incidentId: incident['id'],
        ),
      ),
    );
  },
  leading: const Icon(
    Icons.warning_amber_rounded,
  ),
              title: Text(
                incident['categorie']?.toString() ??
                    'Onbekend',
              ),
              subtitle: Text(
                incident['meldingsdatum']
                        ?.toString()
                        .split('T')
                        .first ??
                    '',
              ),
              trailing: Text(
                incident['status']?.toString() ??
                    'Open',
              ),
            ),
            const Divider(),
          ],
        );
      }).toList(),
    ),
  ),
),

            ],
          ),
        ),
      ),
    );
  }

  Widget _dashboardKaart(
    String waarde,
    String titel,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Text(
              waarde,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(titel),
          ],
        ),
      ),
    );
  }
}