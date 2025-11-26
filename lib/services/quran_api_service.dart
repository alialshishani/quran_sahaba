import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quran_data.dart';

class QuranApiService {
  static const String baseUrl = 'https://api.quran.com/api/v4';

  // Tafseer resource IDs from Quran.com API
  // Verified from: https://api.quran.com/api/v4/resources/tafsirs
  static const Map<String, int> tafseerResourceIds = {
    'ibn_kathir_ar': 14, // Tafsir Ibn Kathir (Arabic)
    'tabari_ar': 15, // Tafsir al-Tabari (Arabic)
    'muyassar_ar': 16, // Tafsir Muyassar (Arabic)
    'qurtubi_ar': 90, // Al-Qurtubi (Arabic)
    'saadi_ar': 91, // Al-Sa'di (Arabic)
    'tantawi_ar': 93, // Al-Tafsir al-Wasit/Tantawi (Arabic)
    'baghawi_ar': 94, // Tafseer Al-Baghawi (Arabic)
    'ibn_kathir_en': 169, // Ibn Kathir (Abridged) (English)
    'maarif_en': 168, // Ma'arif al-Qur'an (English)
  };

  // Fetch tafseer for specific verse keys
  static Future<List<AyahTafseer>> fetchTafseerForVerseKeys({
    required String sourceId,
    required List<String> verseKeys,
  }) async {
    print('Fetching tafseer for ${verseKeys.length} verses from source: $sourceId');

    final resourceId = tafseerResourceIds[sourceId];
    if (resourceId == null) {
      throw Exception('Unknown tafseer source: $sourceId');
    }

    print('Using resource ID: $resourceId');

    final List<AyahTafseer> ayahs = [];

    // Fetch each verse's tafseer
    for (String verseKey in verseKeys) {
      try {
        print('Fetching tafseer for verse: $verseKey');

        // Fetch tafseer using correct endpoint: /tafsirs/{id}/by_ayah/{verse_key}
        final tafseerUrl = Uri.parse('$baseUrl/tafsirs/$resourceId/by_ayah/$verseKey');
        print('Tafseer URL: $tafseerUrl');
        final tafseerResponse = await http.get(tafseerUrl);

        print('Tafseer response status: ${tafseerResponse.statusCode}');

        if (tafseerResponse.statusCode == 200) {
          final tafseerData = jsonDecode(tafseerResponse.body);
          print('Tafseer data keys: ${tafseerData.keys.toList()}');

          // The response structure is: {"tafsir": {...}}
          if (tafseerData['tafsir'] != null) {
            final tafsir = tafseerData['tafsir'];
            print('Got tafsir, text length: ${(tafsir['text'] as String?)?.length ?? 0}');

            // Parse verse key (e.g., "1:1" -> surah 1, ayah 1)
            final parts = verseKey.split(':');
            final surahNumber = int.parse(parts[0]);
            final ayahNumber = int.parse(parts[1]);

            // Fetch verse text
            final verseUrl = Uri.parse('$baseUrl/verses/by_key/$verseKey?fields=text_uthmani');
            final verseResponse = await http.get(verseUrl);

            String verseText = '';
            if (verseResponse.statusCode == 200) {
              final verseData = jsonDecode(verseResponse.body);
              verseText = verseData['verse']['text_uthmani'] as String? ?? '';
              print('Got verse text, length: ${verseText.length}');
            } else {
              print('Failed to fetch verse text: ${verseResponse.statusCode}');
            }

            final ayah = AyahTafseer(
              surahNumber: surahNumber,
              ayahNumber: ayahNumber,
              ayahText: verseText,
              tafseerText: tafsir['text'] as String? ?? '',
            );

            ayahs.add(ayah);
            print('Added ayah $verseKey to list. Total ayahs: ${ayahs.length}');
          } else {
            print('No tafsir found in response for $verseKey');
          }
        } else {
          print('Failed to fetch tafseer for $verseKey: status ${tafseerResponse.statusCode}');
          print('Response body: ${tafseerResponse.body}');
        }

        // Rate limiting - be respectful to the API
        await Future.delayed(const Duration(milliseconds: 150));
      } catch (e, stackTrace) {
        print('Error fetching tafseer for verse $verseKey: $e');
        print('Stack trace: $stackTrace');
        // Continue with other verses even if one fails
      }
    }

    print('Total ayahs fetched: ${ayahs.length}');
    return ayahs;
  }

  // Get verse keys for a specific page (Mushaf Madani)
  static Future<List<String>> getVerseKeysForPage(int page) async {
    try {
      final url = Uri.parse('$baseUrl/verses/by_page/$page?words=false&translations=false');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final verses = data['verses'] as List;

        return verses.map((v) => v['verse_key'] as String).toList();
      }
    } catch (e) {
      print('Error fetching verses for page $page: $e');
    }
    return [];
  }

  // Download complete tafseer for a page
  static Future<TafseerContent> downloadTafseerForPage({
    required String sourceId,
    required int page,
  }) async {
    print('Downloading tafseer for page $page...');

    // Get all verse keys on this page
    final verseKeys = await getVerseKeysForPage(page);

    if (verseKeys.isEmpty) {
      print('No verses found for page $page');
      throw Exception('No verses found for page $page');
    }

    print('Found ${verseKeys.length} verses on page $page: $verseKeys');

    // Fetch tafseer for all verses
    final ayahs = await fetchTafseerForVerseKeys(
      sourceId: sourceId,
      verseKeys: verseKeys,
    );

    print('Downloaded ${ayahs.length} tafseer entries for page $page');

    if (ayahs.isEmpty) {
      print('ERROR: No ayahs downloaded for page $page!');
      print('Verse keys were: $verseKeys');
    }

    return TafseerContent(
      sourceId: sourceId,
      page: page,
      ayahs: ayahs,
    );
  }

  // Download tafseer for multiple pages with progress callback
  static Future<Map<int, TafseerContent>> downloadTafseerForPages({
    required String sourceId,
    required List<int> pages,
    Function(int current, int total)? onProgress,
  }) async {
    print('=== STARTING downloadTafseerForPages ===');
    print('Source: $sourceId, Pages: $pages');

    final Map<int, TafseerContent> result = {};

    for (int i = 0; i < pages.length; i++) {
      print('>>> Processing page ${pages[i]} (${i + 1}/${pages.length})');
      try {
        final content = await downloadTafseerForPage(
          sourceId: sourceId,
          page: pages[i],
        );
        print('<<< Got content for page ${pages[i]}: ${content.ayahs.length} ayahs');
        result[pages[i]] = content;

        if (onProgress != null) {
          onProgress(i + 1, pages.length);
        }
      } catch (e, stackTrace) {
        print('!!! ERROR downloading page ${pages[i]}: $e');
        print('Stack trace: $stackTrace');
      }
    }

    print('=== FINISHED downloadTafseerForPages: ${result.length} pages downloaded ===');
    return result;
  }
}
