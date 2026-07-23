import 'package:flutter/material.dart';
import '../main.dart';
import 'netwerkpartners_screen.dart';

class ZorgVeiligheidScreen extends StatefulWidget {
  const ZorgVeiligheidScreen({super.key});

  @override
  State<ZorgVeiligheidScreen> createState() =>
      _ZorgVeiligheidScreenState();
}

class _ZorgVeiligheidScreenState
    extends State<ZorgVeiligheidScreen> {
  @override
  void initState() {
    super.initState();
    incidentData.categorieen.clear();
  }

  bool pesten = false;
  bool cyberpesten = false;
  bool onlineHaatcampagne = false;
  bool roddelcircuit = false;
  bool socialeUitsluiting = false;

  bool crimineleUitbuiting = false;
  bool seksueleUitbuiting = false;
  bool mensenhandel = false;

  bool huiselijkGeweld = false;
  bool eerwraak = false;
  bool stalking = false;
  bool verwaarlozing = false;
  bool huwelijksdwang = false;

  bool psychischWelzijn = false;
  bool verslaving = false;
  bool suicidaliteit = false;

  bool betrokkenheidBende = false;
  bool geldezel = false;
  bool fGame = false;
  bool straatcultuur = false;

  void updateCategorie(
    bool actief,
    String categorie,
  ) {
    if (actief) {
      if (!incidentData.categorieen.contains(categorie)) {
        incidentData.categorieen.add(categorie);
      }
    } else {
      incidentData.categorieen.remove(categorie);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zorg & Veiligheid"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Pestgedrag",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          CheckboxListTile(
            value: pesten,
            title: const Text("Pesten"),
            onChanged: (value) {
              setState(() {
                pesten = value!;
                updateCategorie(pesten, "Pesten");
              });
            },
          ),

          CheckboxListTile(
            value: cyberpesten,
            title: const Text("Cyberpesten"),
            onChanged: (value) {
              setState(() {
                cyberpesten = value!;
                updateCategorie(
                  cyberpesten,
                  "Cyberpesten",
                );
              });
            },
          ),

          CheckboxListTile(
            value: onlineHaatcampagne,
            title: const Text("Online haatcampagne"),
            onChanged: (value) {
              setState(() {
                onlineHaatcampagne = value!;
                updateCategorie(
                  onlineHaatcampagne,
                  "Online haatcampagne",
                );
              });
            },
          ),

          CheckboxListTile(
            value: roddelcircuit,
            title: const Text("Roddelcircuit"),
            onChanged: (value) {
              setState(() {
                roddelcircuit = value!;
                updateCategorie(
                  roddelcircuit,
                  "Roddelcircuit",
                );
              });
            },
          ),

          CheckboxListTile(
            value: socialeUitsluiting,
            title: const Text("Sociale uitsluiting"),
            onChanged: (value) {
              setState(() {
                socialeUitsluiting = value!;
                updateCategorie(
                  socialeUitsluiting,
                  "Sociale uitsluiting",
                );
              });
            },
          ),

          const SizedBox(height: 25),

          const Text(
            "Uitbuiting",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          CheckboxListTile(
            value: crimineleUitbuiting,
            title: const Text("Criminele uitbuiting"),
            onChanged: (value) {
              setState(() {
                crimineleUitbuiting = value!;
                updateCategorie(
                  crimineleUitbuiting,
                  "Criminele uitbuiting",
                );
              });
            },
          ),

          CheckboxListTile(
            value: seksueleUitbuiting,
            title: const Text("Seksuele uitbuiting"),
            onChanged: (value) {
              setState(() {
                seksueleUitbuiting = value!;
                updateCategorie(
                  seksueleUitbuiting,
                  "Seksuele uitbuiting",
                );
              });
            },
          ),

          CheckboxListTile(
            value: mensenhandel,
            title: const Text("Mensenhandel"),
            onChanged: (value) {
              setState(() {
                mensenhandel = value!;
                updateCategorie(
                  mensenhandel,
                  "Mensenhandel",
                );
              });
            },
          ),

          const SizedBox(height: 25),

          const SizedBox(height: 25),

const Text(
  "Achter de voordeur",
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

          CheckboxListTile(
            value: huiselijkGeweld,
            title: const Text("Huiselijk geweld"),
            onChanged: (value) {
              setState(() {
                huiselijkGeweld = value!;
                updateCategorie(
                  huiselijkGeweld,
                  "Huiselijk geweld",
                );
              });
            },
          ),

          CheckboxListTile(
            value: eerwraak,
            title: const Text(
              "Eerwraak / eergerelateerd geweld",
            ),
            onChanged: (value) {
              setState(() {
                eerwraak = value!;
                updateCategorie(
                  eerwraak,
                  "Eerwraak",
                );
              });
            },
          ),

          CheckboxListTile(
            value: stalking,
            title: const Text("Stalking"),
            onChanged: (value) {
              setState(() {
                stalking = value!;
                updateCategorie(
                  stalking,
                  "Stalking",
                );
              });
            },
          ),

          CheckboxListTile(
            value: verwaarlozing,
            title: const Text("Verwaarlozing"),
            onChanged: (value) {
              setState(() {
                verwaarlozing = value!;
                updateCategorie(
                  verwaarlozing,
                  "Verwaarlozing",
                );
              });
            },
          ),

          CheckboxListTile(
            value: huwelijksdwang,
            title: const Text("Huwelijksdwang"),
            onChanged: (value) {
              setState(() {
                huwelijksdwang = value!;
                updateCategorie(
                  huwelijksdwang,
                  "Huwelijksdwang",
                );
              });
            },
          ),

          const SizedBox(height: 25),

          const Text(
            "Achter de voordeur",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          CheckboxListTile(
            value: psychischWelzijn,
            title: const Text(
  "Psychische problematiek",
),
            onChanged: (value) {
              setState(() {
                psychischWelzijn = value!;
                updateCategorie(
  psychischWelzijn,
  "Psychische problematiek",
);
              });
            },
          ),

          CheckboxListTile(
            value: verslaving,
            title: const Text("Verslaving"),
            onChanged: (value) {
              setState(() {
                verslaving = value!;
                updateCategorie(
                  verslaving,
                  "Verslaving",
                );
              });
            },
          ),

          CheckboxListTile(
            value: suicidaliteit,
            title: const Text("Suïcidaliteit"),
            onChanged: (value) {
              setState(() {
                suicidaliteit = value!;
                updateCategorie(
                  suicidaliteit,
                  "Suïcidaliteit",
                );
              });
            },
          ),

          const SizedBox(height: 25),

          const Text(
            "Straatcultuur",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          CheckboxListTile(
            value: betrokkenheidBende,
            title: const Text(
  "Betrokkenheid bij bendevorming / groepsdruk",
),
            onChanged: (value) {
              setState(() {
                betrokkenheidBende = value!;
                updateCategorie(
  betrokkenheidBende,
  "Betrokkenheid bij bendevorming / groepsdruk",
);
              });
            },
          ),

          CheckboxListTile(
            value: geldezel,
            title: const Text(
  "Geldezel / financieel misbruik",
),
            onChanged: (value) {
              setState(() {
                geldezel = value!;
                updateCategorie(
  geldezel,
  "Geldezel / financieel misbruik",
);
              });
            },
          ),

          CheckboxListTile(
            value: fGame,
            title: const Text(
  "F-game / Fraudeconstructie",
),
            onChanged: (value) {
              setState(() {
                fGame = value!;
                updateCategorie(
  fGame,
  "F-game / Fraudeconstructie",
);
              });
            },
          ),

          CheckboxListTile(
  value: fGame,
  title: const Text(
    "F-game (Fraude game)",
  ),
  onChanged: (value) {
    setState(() {
      fGame = value!;
      updateCategorie(
        fGame,
        "F-game (Fraude game)",
      );
    });
  },
),

const SizedBox(height: 30),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const NetwerkpartnersScreen(),
                ),
              );
            },
            child: const Text("VOLGENDE"),
          ),
        ],
      ),
    );
  }
}