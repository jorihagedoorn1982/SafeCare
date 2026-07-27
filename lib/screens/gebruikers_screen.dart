import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GebruikersScreen extends StatefulWidget {
  const GebruikersScreen({super.key});

  @override
  State<GebruikersScreen> createState() =>
      _GebruikersScreenState();
}

class _GebruikersScreenState
    extends State<GebruikersScreen> {
  List<dynamic> gebruikers = [];
  List<dynamic> besturen = [];
  List<dynamic> scholen = [];

  @override
  void initState() {
    super.initState();
    laadGegevens();
  }

  Future<void> laadGegevens() async {
    await laadGebruikers();
    await laadBesturen();
    await laadScholen();
  }

  Future<void> laadGebruikers() async {
    final resultaat =
        await Supabase.instance.client
            .from('profielen')
            .select();

    setState(() {
      gebruikers = resultaat;
    });
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

  Future<void> laadScholen() async {
    final resultaat =
        await Supabase.instance.client
            .from('scholen')
            .select();

    setState(() {
      scholen = resultaat;
    });
  }

  String bestuurNaam(String? id) {
    try {
      return besturen
          .firstWhere(
            (b) => b['id'].toString() == id,
          )['naam']
          .toString();
    } catch (_) {
      return '-';
    }
  }

  String schoolNaam(String? id) {
    try {
      return scholen
          .firstWhere(
            (s) => s['id'].toString() == id,
          )['naam']
          .toString();
    } catch (_) {
      return '-';
    }
  }

  Future<void> openGebruikerDialog({
    dynamic gebruiker,
  }) async {
    final naamController =
        TextEditingController(
      text: gebruiker?['naam'] ?? '',
    );

    final emailController =
        TextEditingController(
      text: gebruiker?['email'] ?? '',
    );

    String rol =
        gebruiker?['rol']?.toString() ??
            'directeur';

    String? bestuurId =
        gebruiker?['bestuur_id']?.toString();

    String? schoolId =
        gebruiker?['school_id']?.toString();

    final opslaan =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder:
              (context, setDialogState) {
            return AlertDialog(
              title: Text(
                gebruiker == null
                    ? 'Nieuwe gebruiker'
                    : 'Gebruiker bewerken',
              ),
              content: SizedBox(
                width: 450,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      TextField(
                        controller:
                            naamController,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Naam',
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextField(
                        controller:
                            emailController,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Email',
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      DropdownButtonFormField<
                          String>(
                        value: rol,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Rol',
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'admin',
                            child:
                                Text('Admin'),
                          ),
                          DropdownMenuItem(
                            value:
                                'bestuurder',
                            child: Text(
                              'Bestuurder',
                            ),
                          ),
                          DropdownMenuItem(
                            value:
                                'directeur',
                            child:
                                Text(
                              'Directeur',
                            ),
                          ),
                          DropdownMenuItem(
                            value:
                                'veiligheidsmedewerker',
                            child: Text(
                              'Veiligheidsmedewerker',
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setDialogState(() {
                            rol =
                                value!;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      DropdownButtonFormField<
                          String>(
                        value: bestuurId,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Bestuur',
                        ),
                        items: besturen
                            .map(
                              (bestuur) =>
                                  DropdownMenuItem<
                                      String>(
                                value:
                                    bestuur['id']
                                        .toString(),
                                child:
                                    Text(
                                  bestuur[
                                      'naam'],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            bestuurId =
                                value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      DropdownButtonFormField<
                          String>(
                        value: schoolId,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'School',
                        ),
                        items: scholen
                            .map(
                              (school) =>
                                  DropdownMenuItem<
                                      String>(
                                value:
                                    school['id']
                                        .toString(),
                                child:
                                    Text(
                                  school[
                                      'naam'],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            schoolId =
                                value;
                          });
                        },
                      ),
                    ],
                  ),
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
                  child:
                      const Text(
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
                  child:
                      const Text(
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

    if (gebruiker == null) {
      await Supabase.instance.client
          .from('profielen')
          .insert({
        'naam':
            naamController.text,
        'email':
            emailController.text,
        'rol': rol,
        'bestuur_id':
            bestuurId,
        'school_id':
            schoolId,
      });
    } else {
      await Supabase.instance.client
          .from('profielen')
          .update({
        'naam':
            naamController.text,
        'email':
            emailController.text,
        'rol': rol,
        'bestuur_id':
            bestuurId,
        'school_id':
            schoolId,
      })
          .eq(
        'id',
        gebruiker['id'],
      );
    }

    await laadGebruikers();
  }

  Future<void> verwijderGebruiker(
    dynamic gebruiker,
  ) async {
    await Supabase.instance.client
        .from('profielen')
        .delete()
        .eq(
          'id',
          gebruiker['id'],
        );

    await laadGebruikers();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text(
          'Gebruikers',
        ),
      ),
      body: ListView.builder(
        itemCount:
            gebruikers.length,
        itemBuilder:
            (context, index) {
          final gebruiker =
              gebruikers[index];

          return Card(
            margin:
                const EdgeInsets.all(
              8,
            ),
            child: ListTile(
              leading: const Icon(
                Icons.person,
              ),
              title: Text(
                gebruiker['naam']
                        ?.toString() ??
                    '',
              ),
              subtitle: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    gebruiker['email']
                            ?.toString() ??
                        '',
                  ),
                  Text(
                    gebruiker['rol']
                            ?.toString() ??
                        '',
                  ),
                  Text(
                    bestuurNaam(
                      gebruiker[
                              'bestuur_id']
                          ?.toString(),
                    ),
                  ),
                  Text(
                    schoolNaam(
                      gebruiker[
                              'school_id']
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
                      openGebruikerDialog(
                        gebruiker:
                            gebruiker,
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
                      verwijderGebruiker(
                        gebruiker,
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
        onPressed: () {
          openGebruikerDialog();
        },
        child:
            const Icon(Icons.add),
      ),
    );
  }
}