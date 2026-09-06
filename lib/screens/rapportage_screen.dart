import 'package:flutter/material.dart';

class RapportageScreen extends StatelessWidget {
  final int incidentId;

  const RapportageScreen({
    super.key,
    required this.incidentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rapportage #$incidentId'),
      ),
      body: Padding(
  padding: const EdgeInsets.all(20),
  child: ListView(
    children: [

      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: const [

              Text(
                'Incidentgegevens',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),

              Text(
                'Gegevens worden hier geladen',
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