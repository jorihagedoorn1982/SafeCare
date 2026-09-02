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

    setState(() {
      totaalIncidenten = incidenten.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Directeur Dashboard'),
      ),
      body: Padding(
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
                  '0',
                  'Incidenten deze maand',
                ),
                _dashboardKaart(
                  '0',
                  'Open dossiers',
                ),
                _dashboardKaart(
                  '-',
                  'Belangrijkste hotspot',
                ),
              ],
            ),
          ],
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