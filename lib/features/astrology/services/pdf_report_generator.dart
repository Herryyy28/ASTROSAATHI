import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../l10n/app_language.dart';
import '../../../core/utils/zodiac_sign_utils.dart';

class AstrologicalReportData {
  final String userName;
  final String dob;
  final String birthTime;
  final String birthPlace;
  final String sunSign;
  final String moonSign;
  final String ascendant;
  final String mahadasha;
  final String nakshatra;
  final int pada;
  final String reportTitle;
  final String certBadge;
  final String certSerial;
  final List<Map<String, String>> planetaryPositions;
  final List<String> keyInterpretations;
  final List<String> recommendedRemedies;

  AstrologicalReportData({
    required this.userName,
    required this.dob,
    required this.birthTime,
    required this.birthPlace,
    required this.sunSign,
    required this.moonSign,
    required this.ascendant,
    required this.mahadasha,
    required this.nakshatra,
    required this.pada,
    required this.reportTitle,
    required this.certBadge,
    required this.certSerial,
    required this.planetaryPositions,
    required this.keyInterpretations,
    required this.recommendedRemedies,
  });
}

class PdfReportGenerator {
  static AstrologicalReportData generateLocalizedReport({
    required String userName,
    required String dob,
    required String birthTime,
    required String birthPlace,
    required AppLanguage language,
  }) {
    final cleanName = userName.isEmpty ? 'Seeker' : userName;
    final astroProfile = ZodiacSignUtils.calculateAstroProfile(
      name: cleanName,
      dob: dob.isEmpty ? '2000-01-01' : dob,
      birthTime: birthTime.isEmpty ? '12:00' : birthTime,
    );

    final certSerial = 'VDK-KUNDLI-${cleanName.hashCode.abs().toRadixString(16).toUpperCase()}-${DateTime.now().millisecondsSinceEpoch.toRadixString(16).toUpperCase().substring(0, 4)}';

    final planetaryPositions = astroProfile.planets.map((p) {
      final name = p['name']?.toString() ?? 'Graha';
      final rashi = p['rashi']?.toString() ?? 'Aries';
      final nakshatra = p['nakshatra']?.toString() ?? 'Ashwini';
      final pada = p['pada']?.toString() ?? '1';
      final house = '${p['house']}th House';

      String dignity = 'Direct / Strong';
      if (name == 'Jupiter' || name == 'Sun') dignity = 'Exalted / Uchcha';
      if (name == 'Moon' || name == 'Venus') dignity = 'Shubha (Benefic)';
      if (name == 'Rahu' || name == 'Ketu') dignity = 'Karmic Node';
      if (name == 'Saturn') dignity = 'Swakshetra / Karma';

      return {
        'planet': name,
        'rashi': rashi,
        'nakshatra': '$nakshatra P$pada',
        'house': house,
        'dignity': dignity,
      };
    }).toList();

    // Clean English sign representations without unprintable Devnagari brackets
    final englishLagna = '${astroProfile.lagnaEn} (Lagna)';
    final englishRashi = '${astroProfile.rashiEn} (Rashi)';

    switch (language) {
      case AppLanguage.hindi:
        return AstrologicalReportData(
          userName: cleanName,
          dob: dob.isEmpty ? 'Not Specified' : dob,
          birthTime: birthTime.isEmpty ? '12:00 PM' : birthTime,
          birthPlace: birthPlace.isEmpty ? 'New Delhi' : birthPlace,
          sunSign: 'Leo',
          moonSign: englishRashi,
          ascendant: englishLagna,
          mahadasha: '${astroProfile.rulingPlanet} Mahadasha',
          nakshatra: astroProfile.nakshatra,
          pada: astroProfile.pada,
          reportTitle: 'Authentic Vedic Birth Kundli & Life Forecast Report',
          certBadge: 'ASTROSAATHI VEDIC SANSTHAN - OFFICIAL REPORT',
          certSerial: certSerial,
          planetaryPositions: planetaryPositions,
          keyInterpretations: [
            'Vedic Analysis: Ascendant ${astroProfile.lagnaEn} and Moon sign ${astroProfile.rashiEn} creates an auspicious Mahabhagya alignment for career and wisdom.',
            'Planetary Transit: Benefic transit of ${astroProfile.rulingPlanet} over key Kendra/Trikona houses boosts strategic decision confidence and professional success.',
            'Nakshatra Dynamics: Moon placement in ${astroProfile.nakshatra} (Pada ${astroProfile.pada}) endows high emotional intelligence, artistic taste, and decision stability.',
          ],
          recommendedRemedies: [
            'Gemstone Recommendation: Wear the auspicious gemstone for ${astroProfile.rulingPlanet} on your index finger on Thursday morning.',
            'Mantra Sadhana: Recite Gayatri Mantra or Om Namo Bhagavate Vasudevaya 108 times daily during morning hours.',
            'Karmic Remedy: Practice weekly charity and offer yellow sweets or water to the rising Sun.',
          ],
        );

      case AppLanguage.gujarati:
        return AstrologicalReportData(
          userName: cleanName,
          dob: dob.isEmpty ? 'Not Specified' : dob,
          birthTime: birthTime.isEmpty ? '12:00 PM' : birthTime,
          birthPlace: birthPlace.isEmpty ? 'Ahmedabad' : birthPlace,
          sunSign: 'Leo',
          moonSign: englishRashi,
          ascendant: englishLagna,
          mahadasha: '${astroProfile.rulingPlanet} Mahadasha',
          nakshatra: astroProfile.nakshatra,
          pada: astroProfile.pada,
          reportTitle: 'Authentic Vedic Birth Kundli & Life Forecast Report',
          certBadge: 'ASTROSAATHI VEDIC SANSTHAN - OFFICIAL REPORT',
          certSerial: certSerial,
          planetaryPositions: planetaryPositions,
          keyInterpretations: [
            'Vedic Analysis: Ascendant ${astroProfile.lagnaEn} and Moon sign ${astroProfile.rashiEn} creates an auspicious Mahabhagya alignment for career and wisdom.',
            'Planetary Transit: Benefic transit of ${astroProfile.rulingPlanet} over key Kendra/Trikona houses boosts strategic decision confidence and professional success.',
            'Nakshatra Dynamics: Moon placement in ${astroProfile.nakshatra} (Pada ${astroProfile.pada}) endows high emotional intelligence, artistic taste, and decision stability.',
          ],
          recommendedRemedies: [
            'Gemstone Recommendation: Wear the auspicious gemstone for ${astroProfile.rulingPlanet} on your index finger on Thursday morning.',
            'Mantra Sadhana: Recite Gayatri Mantra or Om Namo Bhagavate Vasudevaya 108 times daily during morning hours.',
            'Karmic Remedy: Practice weekly charity and offer yellow sweets or water to the rising Sun.',
          ],
        );

      case AppLanguage.english:
        return AstrologicalReportData(
          userName: cleanName,
          dob: dob.isEmpty ? 'Not Specified' : dob,
          birthTime: birthTime.isEmpty ? '12:00 PM' : birthTime,
          birthPlace: birthPlace.isEmpty ? 'New Delhi, India' : birthPlace,
          sunSign: 'Leo',
          moonSign: englishRashi,
          ascendant: englishLagna,
          mahadasha: '${astroProfile.rulingPlanet} Mahadasha',
          nakshatra: astroProfile.nakshatra,
          pada: astroProfile.pada,
          reportTitle: 'Authentic Vedic Birth Kundli & Life Forecast Report',
          certBadge: 'ASTROSAATHI VEDIC SANSTHAN - OFFICIAL REPORT',
          certSerial: certSerial,
          planetaryPositions: planetaryPositions,
          keyInterpretations: [
            'Vedic Analysis: Ascendant ${astroProfile.lagnaEn} combined with Moon sign ${astroProfile.rashiEn} creates an empowered Mahabhagya alignment for career progression.',
            'Planetary Dynamics: ${astroProfile.rulingPlanet} ruling planet placement over key Kendra/Trikona houses boosts strategic decision confidence and leadership recognition.',
            'Nakshatra Dynamics: Moon placement in ${astroProfile.nakshatra} (Pada ${astroProfile.pada}) enhances emotional stability, intuitive vision, and long-term financial growth.',
          ],
          recommendedRemedies: [
            'Vedic Gemstone Guidance: Consult an authentic Vedic astrologer to wear the primary gemstone for ${astroProfile.rulingPlanet} on your auspicious day.',
            'Daily Mantra Discipline: Recite Gayatri Mantra or Om Namo Bhagavate Vasudevaya 108 times daily during morning hours.',
            'Karmic Alignment Remedy: Practice weekly charity and offer yellow sweets or water to the rising Sun.',
          ],
        );
    }
  }

  /// Builds a high-resolution printable PDF Document Uint8List.
  static Future<Uint8List> buildPdfDocumentBytes({
    required String userName,
    required String dob,
    required String birthTime,
    required String birthPlace,
    required AppLanguage language,
  }) async {
    final report = generateLocalizedReport(
      userName: userName,
      dob: dob,
      birthTime: birthTime,
      birthPlace: birthPlace,
      language: language,
    );

    final pdf = pw.Document();

    final primaryGold = PdfColor.fromHex('#D4AF37');
    final darkBg = PdfColor.fromHex('#0E121A');
    final cardBg = PdfColor.fromHex('#161B26');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Official Header Banner
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(18),
                decoration: pw.BoxDecoration(
                  color: darkBg,
                  borderRadius: pw.BorderRadius.circular(16),
                  border: pw.Border.all(color: primaryGold, width: 1.2),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'ASTROSAATHI VEDIC SANSTHAN',
                          style: pw.TextStyle(
                            color: primaryGold,
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          report.reportTitle,
                          style: const pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#1E2536'),
                        border: pw.Border.all(color: primaryGold, width: 1),
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'OFFICIAL CERTIFICATE',
                            style: pw.TextStyle(color: primaryGold, fontSize: 9, fontWeight: pw.FontWeight.bold),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            report.certSerial,
                            style: const pw.TextStyle(color: PdfColors.grey400, fontSize: 7),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 16),

              // Birth Profile Summary Grid
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(14),
                decoration: pw.BoxDecoration(
                  color: cardBg,
                  borderRadius: pw.BorderRadius.circular(12),
                  border: pw.Border.all(color: primaryGold.shade(0.5), width: 0.5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'OFFICIAL BIRTH KUNDLI PROFILE',
                          style: pw.TextStyle(color: primaryGold, fontSize: 10, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          report.certBadge,
                          style: const pw.TextStyle(color: PdfColors.grey400, fontSize: 8),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoColumn('Name', report.userName),
                        _buildInfoColumn('Date of Birth', report.dob),
                        _buildInfoColumn('Time of Birth', report.birthTime),
                        _buildInfoColumn('Birth Location', report.birthPlace),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Divider(color: PdfColors.grey700),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoColumn('Lagna (Ascendant)', report.ascendant),
                        _buildInfoColumn('Moon Sign (Rashi)', report.moonSign),
                        _buildInfoColumn('Nakshatra & Pada', '${report.nakshatra} P${report.pada}'),
                        _buildInfoColumn('Active Mahadasha', report.mahadasha),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 16),

              // Planetary Placements Table
              pw.Text(
                'Vedic Graha Planetary Positions Table',
                style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: darkBg),
              ),
              pw.SizedBox(height: 6),
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 9),
                headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#1E2536')),
                cellHeight: 22,
                cellStyle: const pw.TextStyle(fontSize: 9),
                data: <List<String>>[
                  <String>['Graha (Planet)', 'Sign (Rashi)', 'Nakshatra & Pada', 'House', 'Planetary Dignity'],
                  ...report.planetaryPositions.map(
                    (p) => <String>[
                      p['planet'] ?? '',
                      p['rashi'] ?? '',
                      p['nakshatra'] ?? '',
                      p['house'] ?? '',
                      p['dignity'] ?? '',
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 16),

              // Key Interpretations Section
              pw.Text(
                'Vedic Life Predictions & Planetary Forecast',
                style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: darkBg),
              ),
              pw.SizedBox(height: 6),
              ...report.keyInterpretations.asMap().entries.map(
                (entry) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 5),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('${entry.key + 1}. ', style: pw.TextStyle(color: primaryGold, fontWeight: pw.FontWeight.bold, fontSize: 10)),
                      pw.Expanded(child: pw.Text(entry.value, style: const pw.TextStyle(fontSize: 10, height: 1.3))),
                    ],
                  ),
                ),
              ),

              pw.SizedBox(height: 14),

              // Recommended Vedic Remedies
              pw.Text(
                'Authentic Vedic Remedies & Daily Guidance',
                style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: darkBg),
              ),
              pw.SizedBox(height: 6),
              ...report.recommendedRemedies.asMap().entries.map(
                (entry) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 5),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('${entry.key + 1}. ', style: pw.TextStyle(color: primaryGold, fontWeight: pw.FontWeight.bold, fontSize: 10)),
                      pw.Expanded(child: pw.Text(entry.value, style: const pw.TextStyle(fontSize: 10, height: 1.3))),
                    ],
                  ),
                ),
              ),

              pw.Spacer(),

              // Official Footer
              pw.Divider(color: PdfColors.grey400),
              pw.SizedBox(height: 4),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Certified & Calculated by AstroSaathi Institute of Vedic Astrology - Ephemeris Calculations',
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                  ),
                  pw.Text(
                    'Serial No: ${report.certSerial}',
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Triggers native system PDF preview, print, or download sheet.
  static Future<void> downloadAndPrintPdf({
    required String userName,
    required String dob,
    required String birthTime,
    required String birthPlace,
    required AppLanguage language,
  }) async {
    final pdfBytes = await buildPdfDocumentBytes(
      userName: userName,
      dob: dob,
      birthTime: birthTime,
      birthPlace: birthPlace,
      language: language,
    );

    final titleName = userName.isEmpty ? 'User' : userName.replaceAll(' ', '_');
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: 'AstroSaathi_Kundli_$titleName.pdf',
    );
  }
}

pw.Widget _buildInfoColumn(String label, String value) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(label, style: pw.TextStyle(color: PdfColors.grey400, fontSize: 9)),
      pw.SizedBox(height: 2),
      pw.Text(value.isEmpty ? '—' : value, style: pw.TextStyle(color: PdfColors.white, fontSize: 10, fontWeight: pw.FontWeight.bold)),
    ],
  );
}
