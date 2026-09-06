import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CasusAfhandelingScreen extends StatefulWidget {
  final int incidentId;

  const CasusAfhandelingScreen({
    super.key,
    required this.incidentId,
  });

  @override
  State<CasusAfhandelingScreen> createState() =>
      _CasusAfhandelingScreenState();
}

class _CasusAfhandelingScreenState
    extends State<CasusAfhandelingScreen> {
  final actieController =
      TextEditingController();

  final notitieController =
      TextEditingController();

  final vervolgController =
      TextEditingController();
      
Future<void> _opslaanCasus() async {
  print('OPSLAAN GEKLIKT');

  try {
    await Supabase.instance.client
        .from('casus_afhandeling')
        .insert({
      'incident_id': widget.incidentId,
      'actie': actieController.text,
      'notitie': notitieController.text,
      'vervolgactie': vervolgController.text,
      'status': 'In behandeling',
    });
    await Supabase.instance.client
    .from('incident_updates')
    .insert({
  'incident_id': widget.incidentId,
  'status': 'In behandeling',
  'opmerking':
      'Casus in behandeling genomen',
  'created_at':
      DateTime.now().toIso8601String(),
});
await Supabase.instance.client
    .from('incidenten')
    .update({
      'status': 'In behandeling',
    })
    .eq('id', widget.incidentId);
    
print('INCIDENT STATUS BIJGEWERKT');
    print('CASUS OPGESLAGEN');

    if (!mounted) return;

Navigator.pop(context);
  } catch (e) {
    print('FOUT: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Casus #${widget.incidentId}",
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Casusafhandeling",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            "Uitgevoerde actie",
          ),

          const SizedBox(height: 10),

          TextField(
            controller: actieController,
            maxLines: 3,
            decoration:
                const InputDecoration(
              border:
                  OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Notitie",
          ),

          const SizedBox(height: 10),

          TextField(
            controller: notitieController,
            maxLines: 5,
            decoration:
                const InputDecoration(
              border:
                  OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Vervolgactie",
          ),

          const SizedBox(height: 10),

          TextField(
            controller: vervolgController,
            maxLines: 3,
            decoration:
                const InputDecoration(
              border:
                  OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: _opslaanCasus,
            child: const Text(
              "OPSLAAN",
            ),
          ),
        ],
      ),
    );
  }
}