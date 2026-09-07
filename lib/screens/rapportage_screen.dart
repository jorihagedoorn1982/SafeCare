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
      List<dynamic> afhandelingen = [];

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

final afhandelingData =
    await Supabase.instance.client
        .from('casus_afhandeling')
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
  afhandelingen = afhandelingData;
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
const SizedBox(height: 20),

const Text(
  'Betrokkenen',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 10),

...betrokkenen.map(
  (persoon) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            persoon['naam'] ?? '',
          ),

          Text(
            persoon['klas'] ?? '',
          ),

          Text(
            persoon['onderwijsniveau'] ?? '',
          ),
          const SizedBox(height: 20),

        ],
      ),
    ),
  ),
),
Text(
  'Afhandeling (${afhandelingen.length})',
  style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),
const SizedBox(height: 10),

...afhandelingen.map(
  (item) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            'Uitgevoerde actie',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            item['actie'] ?? '',
          ),

          const SizedBox(height: 10),

          Text(
            'Notitie',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            item['notitie'] ?? '',
          ),

          const SizedBox(height: 10),

          Text(
            'Vervolgactie',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            item['vervolgactie'] ?? '',
          ),

        ],
      ),
    ),
  ),
),
const SizedBox(height: 20),

const Text(
  'Status',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 10),

Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text(
      incident?['status'] ?? '',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
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