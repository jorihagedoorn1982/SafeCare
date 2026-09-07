import 'package:pdf/widgets.dart' as pw;

class PdfService {
 static Future<pw.Document> createPdf({
  required Map<String, dynamic> incident,
  required List<dynamic> betrokkenen,
  required List<dynamic> afhandelingen,
}) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment:
                pw.CrossAxisAlignment.start,
            children: [

              pw.Text(
                'Rapportage',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight:
                      pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 20),

              pw.Text(
  'Incidentgegevens',
  style: pw.TextStyle(
    fontWeight: pw.FontWeight.bold,
  ),
),

pw.SizedBox(height: 10),

pw.Text(
  'Categorie: ${incident['categorie'] ?? ''}',
),

pw.Text(
  'Subcategorie: ${incident['subcategorie'] ?? ''}',
),

pw.Text(
  'Casustype: ${incident['casustype'] ?? ''}'
      .replaceAll('↔', '<->'),
),

pw.Text(
  'Locatie: ${incident['locatie'] ?? ''}',
),

pw.Text(
  'Status: ${incident['status'] ?? ''}',
),

            ],
          );
        },
      ),
    );

    return pdf;
  }
}