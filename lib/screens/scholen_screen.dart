import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScholenScreen extends StatefulWidget {
  const ScholenScreen({super.key});

  @override
  State<ScholenScreen> createState() => _ScholenScreenState();
}

class _ScholenScreenState extends State<ScholenScreen> {
  List<dynamic> scholen = [];
  List<dynamic> besturen = [];

  @override
  void initState() {
    super.initState();
    laadBesturen();
    laadScholen();
  }

  Future<void> laadBesturen() async {
    final resultaat = await Supabase.instance.client
        .from('besturen')
        .select();

    setState(() {
      besturen = resultaat;
    });
  }

  Future<void> laadScholen() async {
    final resultaat = await Supabase.instance.client
        .from('scholen')
        .select();

    setState(() {
      scholen = resultaat;
    });
  }

  String bestuurNaam(String? bestuurId) {
    try {
      final bestuur = besturen.firstWhere(
        (b) => b['id'].toString() == bestuurId,
      );

      return bestuur['naam']?.toString() ?? '-';
    } catch (_) {
      return '-';
    }
  }

  Future<void> nieuweSchool() async {
    await toonSchoolDialog();
  }

  Future<void> bewerkSchool(dynamic school) async {
    await toonSchoolDialog(school: school);
  }

  Future<void> toonSchoolDialog({
    dynamic school,
  }) async {
    final naamController = TextEditingController(
      text: school?['naam'] ?? '',
    );

    final plaatsController = TextEditingController(
      text: school?['plaats'] ?? '',
    );

    String? gekozenBestuurId =
        school?['bestuur_id']?.toString();

    final opslaan = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                school == null
                    ? 'Nieuwe school'
                    : 'School bewerken',
              ),
              content: SizedBox(
                width: 450,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: naamController,
                      decoration:
                          const InputDecoration(
                        labelText: 'Schoolnaam',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: plaatsController,
                      decoration:
                          const InputDecoration(
                        labelText: 'Plaats',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: gekozenBestuurId,
                      decoration:
                          const InputDecoration(
                        labelText: 'Bestuur',
                      ),
                      items:
                          besturen.map((bestuur) {
                        return DropdownMenuItem<
                            String>(
                          value: bestuur['id']
                              .toString(),
                          child: Text(
                            bestuur['naam']
                                .toString(),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          gekozenBestuurId =
                              value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      false,
                    );
                  },
                  child: const Text(
                    'Annuleren',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      true,
                    );
                  },
                  child: const Text(
                    'Opslaan',
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (opslaan != true) return;

    if (naamController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Schoolnaam is verplicht',
          ),
        ),
      );
      return;
    }

    if (gekozenBestuurId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Selecteer een bestuur',
          ),
        ),
      );
      return;
    }

    if (school == null) {
      await Supabase.instance.client
          .from('scholen')
          .insert({
        'naam': naamController.text.trim(),
        'plaats':
            plaatsController.text.trim(),
        'bestuur_id': gekozenBestuurId,
        'actief': true,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'School toegevoegd',
          ),
        ),
      );
    } else {
      await Supabase.instance.client
          .from('scholen')
          .update({
        'naam': naamController.text.trim(),
        'plaats':
            plaatsController.text.trim(),
        'bestuur_id': gekozenBestuurId,
      }).eq(
        'id',
        school['id'],
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'School bijgewerkt',
          ),
        ),
      );
    }

    await laadScholen();
  }

  Future<void> verwijderSchool(
    dynamic school,
  ) async {
    final verwijderen =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'School verwijderen',
          ),
          content: Text(
            'Weet je zeker dat je ${school['naam']} wilt verwijderen?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Annuleren',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                'Verwijderen',
              ),
            ),
          ],
        );
      },
    );

    if (verwijderen != true) return;

    await Supabase.instance.client
        .from('scholen')
        .delete()
        .eq(
          'id',
          school['id'],
        );

    await laadScholen();

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'School verwijderd',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scholen'),
      ),
      body: scholen.isEmpty
          ? const Center(
              child: Text(
                'Nog geen scholen toegevoegd',
              ),
            )
          : ListView.builder(
              itemCount: scholen.length,
              itemBuilder:
                  (context, index) {
                final school =
                    scholen[index];

                return Card(
                  margin:
                      const EdgeInsets.all(
                    8,
                  ),
                  child: ListTile(
                    leading:
                        const Icon(
                      Icons.school,
                    ),
                    title: Text(
                      school['naam']
                              ?.toString() ??
                          '',
                    ),
                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          school['plaats']
                                  ?.toString() ??
                              '',
                        ),
                        Text(
                          bestuurNaam(
                            school[
                                    'bestuur_id']
                                ?.toString(),
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        IconButton(
                          icon:
                              const Icon(
                            Icons.edit,
                            color:
                                Colors.blue,
                          ),
                          onPressed: () {
                            bewerkSchool(
                              school,
                            );
                          },
                        ),
                        IconButton(
                          icon:
                              const Icon(
                            Icons.delete,
                            color:
                                Colors.red,
                          ),
                          onPressed: () {
                            verwijderSchool(
                              school,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton:
          FloatingActionButton(
        onPressed: nieuweSchool,
        child: const Icon(Icons.add),
      ),
    );
  }
}