import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  String belangrijksteHotspot = '-';

  @override
  void initState() {
    super.initState();
    _laadDashboard();
  }

  Future<void> _laadDashboard() async {
    const schoolId =
        'c9d24fc9-156f-4d53-894f-d58287d5615d';

    final incidenten =
        await Supabase.instance.client
            .from('incidenten')
            .select('id')
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

    setState(() {
      totaalIncidenten = incidenten.length;
      incidentenDezeMaand = dezeMaand.length;
      openDossiers = open.length;
      belangrijksteHotspot = hotspotNaam;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Directeur Dashboard'),
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