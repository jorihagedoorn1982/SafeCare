import 'package:flutter/material.dart';
import 'casus_afronden_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CasusAfrondenScreen extends StatefulWidget {
  final int incidentId;

  const CasusAfrondenScreen({
    super.key,
    required this.incidentId,
  });

  @override
  State<CasusAfrondenScreen> createState() =>
      _CasusAfrondenScreenState();
}

class _CasusAfrondenScreenState
    extends State<CasusAfrondenScreen> {

  final conclusieController =
      TextEditingController();

  bool nazorgNodig = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Casus afronden #${widget.incidentId}',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [

            const Text(
              'Conclusie',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller:
                  conclusieController,
              maxLines: 5,
              decoration:
                  const InputDecoration(
                border:
                    OutlineInputBorder(),
              ),
            ),

            CheckboxListTile(
              title:
                  const Text(
                'Nazorg nodig',
              ),
              value: nazorgNodig,
              onChanged: (value) {
                setState(() {
                  nazorgNodig =
                      value ?? false;
                });
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
  onPressed: () async {
  try {

    await Supabase.instance.client
        .from('casus_afronding')
        .insert({
      'incident_id': widget.incidentId,
      'conclusie': conclusieController.text,
      'nazorg_nodig': nazorgNodig,
      'afgerond_op':
          DateTime.now().toIso8601String(),
    });

    await Supabase.instance.client
        .from('incident_updates')
        .insert({
      'incident_id': widget.incidentId,
      'status': 'Afgerond',
      'opmerking': 'Casus afgerond',
      'created_at':
          DateTime.now().toIso8601String(),
    });
    await Supabase.instance.client
    .from('incidenten')
    .update({
      'status': 'Afgerond',
    })
    .eq('id', widget.incidentId);

    print('AFRONDING OPGESLAGEN');

    if (context.mounted) {
      Navigator.pop(context);
    }

  } catch (e) {
    print('FOUT BIJ AFRONDEN: $e');
  }
},
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
  ),
  child: const Text(
    'DOSSIER AFRONDEN',
  ),
),
          ],
        ),
      ),
    );
  }
}