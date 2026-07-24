import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<int> saveIncident({
  required String categorie,
  required String subcategorie,
  required String casustype,
  required String locatie,
  required String omschrijving,
  required String incidentdatum,
  required String school,
  }) async {
    final result = await supabase
        .from('incidenten')
        .insert({
  'categorie': categorie,
  'subcategorie': subcategorie,
  'casustype': casustype,
  'locatie': locatie,
  'omschrijving': omschrijving,
  'school': school,
  'status': 'Open',
  'meldingsdatum': DateTime.now().toIso8601String(),
})
        .select()
        .single();

    return result['id'];
  }

  Future<void> saveBetrokkene({
  required int incidentId,
  required String type,
  required String rol,
  required String naam,
  required String klas,
  required String onderwijsniveau,
}) async {
    await supabase.from('betrokkenen').insert({
      'incident_id': incidentId,
      'type': type,
      'rol': rol,
      'naam': naam,
      'klas': klas,
      'onderwijsniveau': onderwijsniveau,
    });
  }

  Future<void> saveAfhandeling({
  required int incidentId,
  required String maatregel,
  String? netwerkpartner,
}) async {
    await supabase.from('afhandeling').insert({
  'incident_id': incidentId,
  'maatregel': maatregel,
  'netwerkpartner': netwerkpartner,
  'datum': DateTime.now().toIso8601String(),
});
  }
}
