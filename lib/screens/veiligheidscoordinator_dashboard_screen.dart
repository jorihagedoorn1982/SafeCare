import 'package:flutter/material.dart';
import '../widgets/safecare_appbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VeiligheidsCoordinatorDashboardScreen
    extends StatefulWidget {
  const VeiligheidsCoordinatorDashboardScreen({
    super.key,
  });

  @override
  State<VeiligheidsCoordinatorDashboardScreen>
      createState() =>
          _VeiligheidsCoordinatorDashboardScreenState();
}

class _VeiligheidsCoordinatorDashboardScreenState
    extends State<VeiligheidsCoordinatorDashboardScreen> {
      int openDossiers = 0;
      String hotspot = '-';
      @override
void initState() {
  super.initState();
  laadDashboard();
}
Future<void> laadDashboard() async {
  final open = await Supabase.instance.client
      .from('incidenten')
      .select('id')
      .inFilter(
        'status',
        ['Open', 'In behandeling'],
      );
      final locaties =
    await Supabase.instance.client
        .from('incidenten')
        .select('locatie');
        final tellingen = <String, int>{};

for (final item in locaties) {
  final locatie =
      item['locatie']?.toString() ?? '';

  if (locatie.isEmpty) continue;

  tellingen[locatie] =
      (tellingen[locatie] ?? 0) + 1;
}

  setState(() {
    openDossiers = open.length;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SafeCareAppBar(
  titel: 'Veiligheidscoördinator Dashboard',
  actions: [
    IconButton(
      icon: const Icon(Icons.logout),
      tooltip: 'Uitloggen',
      onPressed: () async {
        await Supabase.instance.client.auth.signOut();

        if (!context.mounted) return;

        Navigator.of(context).pushNamedAndRemoveUntil(
          '/',
          (route) => false,
        );
      },
    ),
  ],
),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
  '🛡️ Test Veiligheidsmedewerker',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    Text(
      'Veiligheidsmedewerker',
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
    ),
    Text(
      'veilig2@test.nl',
      style: TextStyle(
        fontSize: 14,
      ),
    ),
  ],
),

            const SizedBox(height: 20),

            GridView.count(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: 2.5,
              children: [
                _DashboardKaart(
                  titel: 'Leerlingen risico',
                  waarde: '0',
                ),
                _DashboardKaart(
                  titel: 'Klassen aandacht',
                  waarde: '0',
                ),
                _DashboardKaart(
  titel: 'Open dossiers',
  waarde: openDossiers.toString(),
),
                _DashboardKaart(
                  titel: 'Hotspots',
                  waarde: '0',
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Top risicoleerlingen',
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Klassenanalyse',
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Hotspots School',
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Preventie Adviezen',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardKaart extends StatelessWidget {
  final String titel;
  final String waarde;

  const _DashboardKaart({
    required this.titel,
    required this.waarde,
  });

@override
Widget build(BuildContext context) {
  return Card(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            waarde,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(titel),
        ],
      ),
    ),
  );
}
}