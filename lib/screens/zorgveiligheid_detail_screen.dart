import 'package:flutter/material.dart';
import '../main.dart';
import 'betrokkenen_screen.dart';
import '../widgets/safecare_appbar.dart';

class ZorgVeiligheidDetailScreen extends StatefulWidget {
  final String categorie;

  const ZorgVeiligheidDetailScreen({
    super.key,
    required this.categorie,
  });

  @override
  State<ZorgVeiligheidDetailScreen> createState() =>
      _ZorgVeiligheidDetailScreenState();
}

class _ZorgVeiligheidDetailScreenState
    extends State<ZorgVeiligheidDetailScreen> {
  @override
  Widget build(BuildContext context) {
    List<String> opties = [];

    switch (widget.categorie) {
      case 'Pestgedrag':
        opties = [
          'Pesten',
          'Cyberpesten',
          'Online haatcampagne',
          'Roddelcircuit',
          'Sociale uitsluiting',
        ];
        break;

      case 'Uitbuiting':
        opties = [
          'Criminele uitbuiting',
          'Seksuele uitbuiting',
          'Mensenhandel',
        ];
        break;

      case 'Achter de voordeur':
        opties = [
          'Huiselijk geweld',
          'Eerwraak / eergerelateerd geweld',
          'Stalking',
          'Verwaarlozing',
          'Huwelijksdwang',
          'Psychische problematiek',
          'Verslaving',
          'Suïcidaliteit',
        ];
        break;

      case 'Straatcultuur':
        opties = [
          'Betrokkenheid bij bendevorming / groepsdruk',
          'Geldezel / financieel misbruik',
          'F-game / Fraudeconstructie',
        ];
        break;
    }

    return Scaffold(
      appBar: SafeCareAppBar(
  titel: widget.categorie,
),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: opties.length,
              itemBuilder: (context, index) {
                final optie = opties[index];

                return CheckboxListTile(
                  value: incidentData.categorieen.contains(
                    optie,
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        if (!incidentData.categorieen.contains(
                          optie,
                        )) {
                          incidentData.categorieen.add(
                            optie,
                          );
                        }
                      } else {
                        incidentData.categorieen.remove(
                          optie,
                        );
                      }
                    });
                  },
                  title: Text(optie),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const BetrokkenenScreen(),
                    ),
                  );
                },
                child: const Text(
                  'VOLGENDE',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}