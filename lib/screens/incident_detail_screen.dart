import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IncidentDetailScreen extends StatefulWidget {
  final int incidentId;

  const IncidentDetailScreen({
    super.key,
    required this.incidentId,
  });

  @override
  State<IncidentDetailScreen> createState() =>
      _IncidentDetailScreenState();
}

class _IncidentDetailScreenState
    extends State<IncidentDetailScreen> {
  String status = 'Geen updates gevonden';
  List<dynamic> tijdlijn = [];

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

    if (updates.isNotEmpty) {
      setState(() {
        tijdlijn = updates;
        status =
            updates.last['status']?.toString() ??
                'Onbekend';
      });
    }
    else {
  setState(() {
    status = 'Geen updates gevonden';
  });
}
  }
Future<void> _wijzigStatus(
  String nieuweStatus,
) async {
  try {
    await Supabase.instance.client
        .from('incident_updates')
        .insert({
      'incident_id': widget.incidentId,
      'status': nieuweStatus,
      'opmerking':
          'Status gewijzigd naar $nieuweStatus',
      'created_at':
          DateTime.now().toIso8601String(),
    });

    print(
      'STATUS OPGESLAGEN: $nieuweStatus',
    );

    await _laadGegevens();
  } catch (e) {
    print('FOUT BIJ OPSLAAN: $e');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Incident #${widget.incidentId}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              'Incidentdetails',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Incidentnummer: ${widget.incidentId}',
            ),

            const SizedBox(height: 20),

            const Text(
              'Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(status),
const SizedBox(height: 20),

Wrap(
  spacing: 10,
  children: [
   ElevatedButton(
  onPressed: () async {
    await _wijzigStatus('Open');
  },
  child: const Text('Open'),
),
    ElevatedButton(
  onPressed: () async {
    await _wijzigStatus('In behandeling');
  },
  child: const Text('In behandeling'),
),
    ElevatedButton(
  onPressed: () async {
    await _wijzigStatus('Afgerond');
  },
  child: const Text('Afgerond'),
),
  ],
),
            const SizedBox(height: 30),

            const Text(
              'Tijdlijn',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            ...tijdlijn.map(
              (item) => ListTile(
                leading:
                    const Icon(Icons.history),
                title: Text(
                  item['opmerking']
                          ?.toString() ??
                      '',
                ),
                subtitle: Text(
                  item['created_at']
                          ?.toString()
                          .split('T')
                          .first ??
                      '',
                ),
                trailing: Text(
                  item['status']
                          ?.toString() ??
                      '',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}