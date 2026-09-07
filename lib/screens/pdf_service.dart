import 'package:pdf/widgets.dart' as pw;

class PdfService {
  static Future<pw.Document> createPdf() async {
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
  'SAFECARE PDF WERKT',
),

            ],
          );
        },
      ),
    );

    return pdf;
  }
}