import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BesturenScreen extends StatefulWidget {
  const BesturenScreen({super.key});

  @override
  State<BesturenScreen> createState() => _BesturenScreenState();
}

class _BesturenScreenState extends State<BesturenScreen> {
  List<dynamic> besturen = [];

  @override
  void initState() {
    super.initState();
    laadBesturen();
  }

  Future<void> laadBesturen() async {
    final resultaat =
        await Supabase.instance.client
            .from('besturen')
            .select();

    setState(() {
      besturen = resultaat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Besturen'),
      ),
      body: ListView.builder(
        itemCount: besturen.length,
        itemBuilder: (context, index) {
          final bestuur = besturen[index];

          return Card(
            child: ListTile(
              leading: const Icon(Icons.account_balance),
              title: Text(
                bestuur['naam'] ?? '',
              ),
              subtitle: Text(
                bestuur['plaats'] ?? '',
              ),
            ),
          );
        },
      ),
            floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final naamController = TextEditingController();
          final plaatsController = TextEditingController();
          final contactController = TextEditingController();
          final emailController = TextEditingController();
          final telefoonController = TextEditingController();

          final opslaan = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Nieuw bestuur'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: naamController,
                        decoration: const InputDecoration(
                          labelText: 'Naam bestuur',
                        ),
                      ),
                      TextField(
                        controller: plaatsController,
                        decoration: const InputDecoration(
                          labelText: 'Plaats',
                        ),
                      ),
                      TextField(
                        controller: contactController,
                        decoration: const InputDecoration(
                          labelText: 'Contactpersoon',
                        ),
                      ),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                        ),
                      ),
                      TextField(
                        controller: telefoonController,
                        decoration: const InputDecoration(
                          labelText: 'Telefoon',
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('Annuleren'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Opslaan'),
                  ),
                ],
              );
            },
          );

          if (opslaan == true) {
            await Supabase.instance.client
                .from('besturen')
                .insert({
              'naam': naamController.text,
              'plaats': plaatsController.text,
              'contactpersoon': contactController.text,
              'email': emailController.text,
              'telefoon': telefoonController.text,
            });

            laadBesturen();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}