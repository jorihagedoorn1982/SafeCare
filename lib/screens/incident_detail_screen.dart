import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'casus_afhandeling_screen.dart';
import 'casus_afronden_screen.dart';
import 'rapportage_screen.dart';
import '../widgets/safecare_appbar.dart';

class IncidentDetailScreen extends StatefulWidget {
  final int incidentId;

  const IncidentDetailScreen({super.key, required this.incidentId});

  @override
  State<IncidentDetailScreen> createState() => _IncidentDetailScreenState();
}

class _IncidentDetailScreenState extends State<IncidentDetailScreen> {
  String status = 'Geen updates gevonden';

  Map<String, dynamic>? incident;

  List<dynamic> tijdlijn = [];
  List<dynamic> afhandelingen = [];
  List<dynamic> betrokkenen = [];
  List<dynamic> bijlagen = [];

  final TextEditingController notitieController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _laadGegevens();
  }

  Future<void> _laadGegevens() async {
    final updates = await Supabase.instance.client
        .from('incident_updates')
        .select()
        .eq('incident_id', widget.incidentId)
        .order('created_at');

    final afhandelingData = await Supabase.instance.client
        .from('casus_afhandeling')
        .select()
        .eq('incident_id', widget.incidentId)
        .order('created_at');

    final incidentData = await Supabase.instance.client
        .from('incidenten')
        .select()
        .eq('id', widget.incidentId)
        .single();

    final betrokkenenData = await Supabase.instance.client
        .from('betrokkenen')
        .select()
        .eq('incident_id', widget.incidentId);
       
    final bijlagenData = await Supabase.instance.client
    .from('incident_bijlagen')
    .select()
    .eq('incident_id', widget.incidentId);

    if (updates.isNotEmpty) {
      setState(() {
        incident = incidentData;
        tijdlijn = updates;
        afhandelingen = afhandelingData;
        betrokkenen = betrokkenenData;
        bijlagen = bijlagenData;

        status = incidentData['status']?.toString() ?? 'Onbekend';
      });
    } else {
      setState(() {
        status = 'Geen updates gevonden';
      });
    }
  }

  Future<void> _wijzigStatus(String nieuweStatus) async {
    try {
      await Supabase.instance.client.from('incident_updates').insert({
        'incident_id': widget.incidentId,
        'status': nieuweStatus,
        'opmerking': 'Status gewijzigd naar $nieuweStatus',
        'created_at': DateTime.now().toIso8601String(),
      });

      print('STATUS OPGESLAGEN: $nieuweStatus');

      await _laadGegevens();
    } catch (e) {
      print('FOUT BIJ OPSLAAN: $e');
    }
  }

  Future<void> _opslaanNotitie() async {
    if (notitieController.text.trim().isEmpty) {
      return;
    }

    await Supabase.instance.client.from('incident_updates').insert({
      'incident_id': widget.incidentId,
      'status': status,
      'opmerking': notitieController.text.trim(),
      'created_at': DateTime.now().toIso8601String(),
    });

    notitieController.clear();

    await _laadGegevens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SafeCareAppBar(
  titel: 'Incident #${widget.incidentId}',
),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Incidentgegevens',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Categorie',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),

                    Text(
                      incident?['categorie'] ?? '',
                      style: const TextStyle(
                        color: Color(0xFF234767),
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Subcategorie',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),

                    Text(
                      incident?['subcategorie'] ?? '',
                      style: const TextStyle(
                        color: Color(0xFF234767),
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Casustype',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),

                    Text(
                      incident?['casustype'] ?? '',
                      style: const TextStyle(
                        color: Color(0xFF234767),
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Locatie',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),

                    Text(
                      incident?['locatie'] ?? '',
                      style: const TextStyle(
                        color: Color(0xFF234767),
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Omschrijving',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),

                    Text(
                      incident?['omschrijving'] ?? '',
                      style: const TextStyle(
                        color: Color(0xFF234767),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
Card(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          'Bijlagen',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text(
              'BIJLAGE TOEVOEGEN',
            ),
          ),
        ),

        const SizedBox(height: 10),

        bijlagen.isEmpty
            ? const Text(
                'Nog geen bijlagen',
              )
            : Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: bijlagen
                    .map<Widget>(
                      (bestand) => Text(
                        '📎 ${bestand['bestandsnaam']}',
                      ),
                    )
                    .toList(),
              ),

      ],
    ),
  ),
),
const SizedBox(height: 10),
          
            ...betrokkenen.map<Widget>(
              (persoon) => 
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
              'Betrokkenen',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
                      const Text(
                        'Naam',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      
                      Text(
                        persoon['naam'] ?? '',
                        style: const TextStyle(color: Color(0xFF234767)),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Klas',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        persoon['klas'] ?? '',
                        style: const TextStyle(color: Color(0xFF234767)),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Onderwijsniveau',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        persoon['onderwijsniveau'] ?? '',
                        style: const TextStyle(color: Color(0xFF234767)),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Rol',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        persoon['rol'] ?? '',
                        style: const TextStyle(color: Color(0xFF234767)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
Card(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
            const Text(
              'Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: status == 'Afgerond'
                      ? Colors.green
                      : status == 'In behandeling'
                      ? Colors.orange
                      : Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (status != 'Afgerond')
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CasusAfhandelingScreen(incidentId: widget.incidentId),
                    ),
                  );

                  await _laadGegevens();
                },
                child: Text(
                  status == 'In behandeling'
                      ? 'CASUS AANVULLEN'
                      : 'CASUS IN BEHANDELING NEMEN',
                ),
              ),
            const SizedBox(height: 10),
           
           if (status == 'Afgerond')
  Align(
    alignment: Alignment.centerLeft,
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RapportageScreen(
              incidentId: widget.incidentId,
            ),
          ),
        );
      },
      child: const Text('RAPPORTAGE'),
    ),
  ),
            const SizedBox(height: 10),

            ...afhandelingen.map(
              (item) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Uitgevoerde actie',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),

                      Text(
                        item['actie'] ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF234767),
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Notitie',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),

                      Text(
                        item['notitie'] ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF234767),
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Vervolgactie',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),

                      Text(
                        item['vervolgactie'] ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF234767),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        item['created_at']?.toString().split('T').first ?? '',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
