import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RapportageScreen extends StatefulWidget {
  final int incidentId;

  const RapportageScreen({
    super.key,
    required this.incidentId,
  });

  @override
  State<RapportageScreen> createState() =>
      _RapportageScreenState();
}

class _RapportageScreenState
    extends State<RapportageScreen> {
      Map<String, dynamic>? incident;
      List<dynamic> betrokkenen = [];

@override
void initState() {
  super.initState();
  _laadRapportage();
}

Future<void> _laadRapportage() async {
  final data =
      await Supabase.instance.client
          .from('incidenten')
          .select()
          .eq('id', widget.incidentId)
          .single();

final betrokkenenData =
    await Supabase.instance.client
        .from('betrokkenen')
        .select()
        .eq(
          'incident_id',
          widget.incidentId,
        );

  debugPrint('RAPPORTAGE DATA:');
debugPrint(data.toString());
debugPrint('BETROKKENEN DATA:');
debugPrint(betrokkenenData.toString());

  setState(() {
  incident = data;
  betrokkenen = betrokkenenData;
});
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Rapportage #${widget.incidentId}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [

            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

const SizedBox(height: 20),

Text(
  'Betrokkenen (${betrokkenen.length})',
  style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),
                    Text(
                      'Incidentgegevens',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
  'Categorie: ${incident?['categorie'] ?? ''}',
),

const SizedBox(height: 10),

Text(
  'Subcategorie: ${incident?['subcategorie'] ?? ''}',
),

const SizedBox(height: 10),

Text(
  'Casustype: ${incident?['casustype'] ?? ''}',
),

const SizedBox(height: 10),

Text(
  'Locatie: ${incident?['locatie'] ?? ''}',
),

const SizedBox(height: 10),

Text(
  'Omschrijving: ${incident?['omschrijving'] ?? ''}',
),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}