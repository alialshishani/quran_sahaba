import 'package:quran_sahaba/l10n/app_localizations.dart';
import 'package:quran_sahaba/models/surah_names_ar.dart';

class KhetmehPlan {
  final String id;
  final String title;
  final String subtitle;
  final String rangeDescription;
  final int startPage;
  final int endPage;
  final int durationInDays;

  const KhetmehPlan({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.rangeDescription,
    required this.startPage,
    required this.endPage,
    required this.durationInDays,
  });
}

class SurahInfo {
  final int number;
  final String nameEn;
  final String nameAr;
  final int page;

  const SurahInfo({
    required this.number,
    required this.nameEn,
    required this.nameAr,
    required this.page,
  });
}

class JuzInfo {
  final int number;
  final int page;

  const JuzInfo({required this.number, required this.page});
}

List<KhetmehPlan> getKhetmehPlans(AppLocalizations l) {
  return [
    KhetmehPlan(
      id: 'plan1',
      title: l.khetmehPlan1Title,
      subtitle: l.khetmehPlan1Subtitle,
      rangeDescription: l.khetmehPlan1Range,
      startPage: 1,
      endPage: 604,
      durationInDays: 30,
    ),
    KhetmehPlan(
      id: 'plan2',
      title: l.khetmehPlan2Title,
      subtitle: l.khetmehPlan2Subtitle,
      rangeDescription: l.khetmehPlan2Range,
      startPage: 1,
      endPage: 604,
      durationInDays: 15,
    ),
    KhetmehPlan(
      id: 'plan3',
      title: l.khetmehPlan3Title,
      subtitle: l.khetmehPlan3Subtitle,
      rangeDescription: l.khetmehPlan3Range,
      startPage: 1,
      endPage: 604,
      durationInDays: 7,
    ),
    KhetmehPlan(
      id: 'plan5',
      title: l.khetmehPlan5Title,
      subtitle: l.khetmehPlan5Subtitle,
      rangeDescription: l.khetmehPlan5Range,
      startPage: 1,
      endPage: 604,
      durationInDays: 0,
    ),
  ];
}

final List<SurahInfo> surahInfos = [
  SurahInfo(number: 1, nameEn: "Al-Fatihah", nameAr: surahNamesAr[0], page: 1),
  SurahInfo(number: 2, nameEn: "Al-Baqarah", nameAr: surahNamesAr[1], page: 2),
  SurahInfo(number: 3, nameEn: "Ali 'Imran", nameAr: surahNamesAr[2], page: 50),
  SurahInfo(number: 4, nameEn: "An-Nisa", nameAr: surahNamesAr[3], page: 77),
  SurahInfo(number: 5, nameEn: "Al-Ma'idah", nameAr: surahNamesAr[4], page: 106),
  SurahInfo(number: 6, nameEn: "Al-An'am", nameAr: surahNamesAr[5], page: 128),
  SurahInfo(number: 7, nameEn: "Al-A'raf", nameAr: surahNamesAr[6], page: 151),
  SurahInfo(number: 8, nameEn: "Al-Anfal", nameAr: surahNamesAr[7], page: 177),
  SurahInfo(number: 9, nameEn: "At-Tawbah", nameAr: surahNamesAr[8], page: 187),
  SurahInfo(number: 10, nameEn: "Yunus", nameAr: surahNamesAr[9], page: 208),
  SurahInfo(number: 11, nameEn: "Hud", nameAr: surahNamesAr[10], page: 221),
  SurahInfo(number: 12, nameEn: "Yusuf", nameAr: surahNamesAr[11], page: 235),
  SurahInfo(number: 13, nameEn: "Ar-Ra'd", nameAr: surahNamesAr[12], page: 249),
  SurahInfo(number: 14, nameEn: "Ibrahim", nameAr: surahNamesAr[13], page: 255),
  SurahInfo(number: 15, nameEn: "Al-Hijr", nameAr: surahNamesAr[14], page: 262),
  SurahInfo(number: 16, nameEn: "An-Nahl", nameAr: surahNamesAr[15], page: 267),
  SurahInfo(number: 17, nameEn: "Al-Isra", nameAr: surahNamesAr[16], page: 282),
  SurahInfo(number: 18, nameEn: "Al-Kahf", nameAr: surahNamesAr[17], page: 293),
  SurahInfo(number: 19, nameEn: "Maryam", nameAr: surahNamesAr[18], page: 305),
  SurahInfo(number: 20, nameEn: "Taha", nameAr: surahNamesAr[19], page: 312),
  SurahInfo(number: 21, nameEn: "Al-Anbya", nameAr: surahNamesAr[20], page: 322),
  SurahInfo(number: 22, nameEn: "Al-Hajj", nameAr: surahNamesAr[21], page: 332),
  SurahInfo(number: 23, nameEn: "Al-Mu'minun", nameAr: surahNamesAr[22], page: 342),
  SurahInfo(number: 24, nameEn: "An-Nur", nameAr: surahNamesAr[23], page: 350),
  SurahInfo(number: 25, nameEn: "Al-Furqan", nameAr: surahNamesAr[24], page: 359),
  SurahInfo(number: 26, nameEn: "Ash-Shu'ara", nameAr: surahNamesAr[25], page: 367),
  SurahInfo(number: 27, nameEn: "An-Naml", nameAr: surahNamesAr[26], page: 377),
  SurahInfo(number: 28, nameEn: "Al-Qasas", nameAr: surahNamesAr[27], page: 385),
  SurahInfo(number: 29, nameEn: "Al-'Ankabut", nameAr: surahNamesAr[28], page: 396),
  SurahInfo(number: 30, nameEn: "Ar-Rum", nameAr: surahNamesAr[29], page: 404),
  SurahInfo(number: 31, nameEn: "Luqman", nameAr: surahNamesAr[30], page: 411),
  SurahInfo(number: 32, nameEn: "As-Sajdah", nameAr: surahNamesAr[31], page: 415),
  SurahInfo(number: 33, nameEn: "Al-Ahzab", nameAr: surahNamesAr[32], page: 418),
  SurahInfo(number: 34, nameEn: "Saba", nameAr: surahNamesAr[33], page: 428),
  SurahInfo(number: 35, nameEn: "Fatir", nameAr: surahNamesAr[34], page: 434),
  SurahInfo(number: 36, nameEn: "Ya-Sin", nameAr: surahNamesAr[35], page: 440),
  SurahInfo(number: 37, nameEn: "As-Saffat", nameAr: surahNamesAr[36], page: 446),
  SurahInfo(number: 38, nameEn: "Sad", nameAr: surahNamesAr[37], page: 453),
  SurahInfo(number: 39, nameEn: "Az-Zumar", nameAr: surahNamesAr[38], page: 458),
  SurahInfo(number: 40, nameEn: "Ghafir", nameAr: surahNamesAr[39], page: 467),
  SurahInfo(number: 41, nameEn: "Fussilat", nameAr: surahNamesAr[40], page: 477),
  SurahInfo(number: 42, nameEn: "Ash-Shuraa", nameAr: surahNamesAr[41], page: 483),
  SurahInfo(number: 43, nameEn: "Az-Zukhruf", nameAr: surahNamesAr[42], page: 489),
  SurahInfo(number: 44, nameEn: "Ad-Dukhan", nameAr: surahNamesAr[43], page: 496),
  SurahInfo(number: 45, nameEn: "Al-Jathiyah", nameAr: surahNamesAr[44], page: 499),
  SurahInfo(number: 46, nameEn: "Al-Ahqaf", nameAr: surahNamesAr[45], page: 502),
  SurahInfo(number: 47, nameEn: "Muhammad", nameAr: surahNamesAr[46], page: 507),
  SurahInfo(number: 48, nameEn: "Al-Fath", nameAr: surahNamesAr[47], page: 511),
  SurahInfo(number: 49, nameEn: "Al-Hujurat", nameAr: surahNamesAr[48], page: 515),
  SurahInfo(number: 50, nameEn: "Qaf", nameAr: surahNamesAr[49], page: 518),
  SurahInfo(number: 51, nameEn: "Adh-Dhariyat", nameAr: surahNamesAr[50], page: 520),
  SurahInfo(number: 52, nameEn: "At-Tur", nameAr: surahNamesAr[51], page: 523),
  SurahInfo(number: 53, nameEn: "An-Najm", nameAr: surahNamesAr[52], page: 526),
  SurahInfo(number: 54, nameEn: "Al-Qamar", nameAr: surahNamesAr[53], page: 528),
  SurahInfo(number: 55, nameEn: "Ar-Rahman", nameAr: surahNamesAr[54], page: 531),
  SurahInfo(number: 56, nameEn: "Al-Waqi'ah", nameAr: surahNamesAr[55], page: 534),
  SurahInfo(number: 57, nameEn: "Al-Hadid", nameAr: surahNamesAr[56], page: 537),
  SurahInfo(number: 58, nameEn: "Al-Mujadila", nameAr: surahNamesAr[57], page: 542),
  SurahInfo(number: 59, nameEn: "Al-Hashr", nameAr: surahNamesAr[58], page: 545),
  SurahInfo(number: 60, nameEn: "Al-Mumtahanah", nameAr: surahNamesAr[59], page: 549),
  SurahInfo(number: 61, nameEn: "As-Saf", nameAr: surahNamesAr[60], page: 551),
  SurahInfo(number: 62, nameEn: "Al-Jumu'ah", nameAr: surahNamesAr[61], page: 553),
  SurahInfo(number: 63, nameEn: "Al-Munafiqun", nameAr: surahNamesAr[62], page: 554),
  SurahInfo(number: 64, nameEn: "At-Taghabun", nameAr: surahNamesAr[63], page: 556),
  SurahInfo(number: 65, nameEn: "At-Talaq", nameAr: surahNamesAr[64], page: 558),
  SurahInfo(number: 66, nameEn: "At-Tahrim", nameAr: surahNamesAr[65], page: 560),
  SurahInfo(number: 67, nameEn: "Al-Mulk", nameAr: surahNamesAr[66], page: 562),
  SurahInfo(number: 68, nameEn: "Al-Qalam", nameAr: surahNamesAr[67], page: 564),
  SurahInfo(number: 69, nameEn: "Al-Haqqah", nameAr: surahNamesAr[68], page: 566),
  SurahInfo(number: 70, nameEn: "Al-Ma'arij", nameAr: surahNamesAr[69], page: 568),
  SurahInfo(number: 71, nameEn: "Nuh", nameAr: surahNamesAr[70], page: 570),
  SurahInfo(number: 72, nameEn: "Al-Jinn", nameAr: surahNamesAr[71], page: 572),
  SurahInfo(number: 73, nameEn: "Al-Muzzammil", nameAr: surahNamesAr[72], page: 574),
  SurahInfo(number: 74, nameEn: "Al-Muddaththir", nameAr: surahNamesAr[73], page: 575),
  SurahInfo(number: 75, nameEn: "Al-Qiyamah", nameAr: surahNamesAr[74], page: 577),
  SurahInfo(number: 76, nameEn: "Al-Insan", nameAr: surahNamesAr[75], page: 578),
  SurahInfo(number: 77, nameEn: "Al-Mursalat", nameAr: surahNamesAr[76], page: 580),
  SurahInfo(number: 78, nameEn: "An-Naba", nameAr: surahNamesAr[77], page: 582),
  SurahInfo(number: 79, nameEn: "An-Nazi'at", nameAr: surahNamesAr[78], page: 583),
  SurahInfo(number: 80, nameEn: "'Abasa", nameAr: surahNamesAr[79], page: 585),
  SurahInfo(number: 81, nameEn: "At-Takwir", nameAr: surahNamesAr[80], page: 586),
  SurahInfo(number: 82, nameEn: "Al-Infitar", nameAr: surahNamesAr[81], page: 587),
  SurahInfo(number: 83, nameEn: "Al-Mutaffifin", nameAr: surahNamesAr[82], page: 587),
  SurahInfo(number: 84, nameEn: "Al-Inshiqaq", nameAr: surahNamesAr[83], page: 589),
  SurahInfo(number: 85, nameEn: "Al-Buruj", nameAr: surahNamesAr[84], page: 590),
  SurahInfo(number: 86, nameEn: "At-Tariq", nameAr: surahNamesAr[85], page: 591),
  SurahInfo(number: 87, nameEn: "Al-A'la", nameAr: surahNamesAr[86], page: 591),
  SurahInfo(number: 88, nameEn: "Al-Ghashiyah", nameAr: surahNamesAr[87], page: 592),
  SurahInfo(number: 89, nameEn: "Al-Fajr", nameAr: surahNamesAr[88], page: 593),
  SurahInfo(number: 90, nameEn: "Al-Balad", nameAr: surahNamesAr[89], page: 594),
  SurahInfo(number: 91, nameEn: "Ash-Shams", nameAr: surahNamesAr[90], page: 595),
  SurahInfo(number: 92, nameEn: "Al-Layl", nameAr: surahNamesAr[91], page: 595),
  SurahInfo(number: 93, nameEn: "Ad-Duhaa", nameAr: surahNamesAr[92], page: 596),
  SurahInfo(number: 94, nameEn: "Ash-Sharh", nameAr: surahNamesAr[93], page: 596),
  SurahInfo(number: 95, nameEn: "At-Tin", nameAr: surahNamesAr[94], page: 597),
  SurahInfo(number: 96, nameEn: "Al-'Alaq", nameAr: surahNamesAr[95], page: 597),
  SurahInfo(number: 97, nameEn: "Al-Qadr", nameAr: surahNamesAr[96], page: 598),
  SurahInfo(number: 98, nameEn: "Al-Bayyinah", nameAr: surahNamesAr[97], page: 598),
  SurahInfo(number: 99, nameEn: "Az-Zalzalah", nameAr: surahNamesAr[98], page: 599),
  SurahInfo(number: 100, nameEn: "Al-'Adiyat", nameAr: surahNamesAr[99], page: 599),
  SurahInfo(number: 101, nameEn: "Al-Qari'ah", nameAr: surahNamesAr[100], page: 600),
  SurahInfo(number: 102, nameEn: "At-Takathur", nameAr: surahNamesAr[101], page: 600),
  SurahInfo(number: 103, nameEn: "Al-'Asr", nameAr: surahNamesAr[102], page: 601),
  SurahInfo(number: 104, nameEn: "Al-Humazah", nameAr: surahNamesAr[103], page: 601),
  SurahInfo(number: 105, nameEn: "Al-Fil", nameAr: surahNamesAr[104], page: 601),
  SurahInfo(number: 106, nameEn: "Quraysh", nameAr: surahNamesAr[105], page: 602),
  SurahInfo(number: 107, nameEn: "Al-Ma'un", nameAr: surahNamesAr[106], page: 602),
  SurahInfo(number: 108, nameEn: "Al-Kawthar", nameAr: surahNamesAr[107], page: 602),
  SurahInfo(number: 109, nameEn: "Al-Kafirun", nameAr: surahNamesAr[108], page: 603),
  SurahInfo(number: 110, nameEn: "An-Nasr", nameAr: surahNamesAr[109], page: 603),
  SurahInfo(number: 111, nameEn: "Al-Masad", nameAr: surahNamesAr[110], page: 603),
  SurahInfo(number: 112, nameEn: "Al-Ikhlas", nameAr: surahNamesAr[111], page: 604),
  SurahInfo(number: 113, nameEn: "Al-Falaq", nameAr: surahNamesAr[112], page: 604),
  SurahInfo(number: 114, nameEn: "An-Nas", nameAr: surahNamesAr[113], page: 604),
];

const List<JuzInfo> juzInfos = [
  JuzInfo(number: 1, page: 1),
  JuzInfo(number: 2, page: 22),
  JuzInfo(number: 3, page: 42),
  JuzInfo(number: 4, page: 62),
  JuzInfo(number: 5, page: 82),
  JuzInfo(number: 6, page: 102),
  JuzInfo(number: 7, page: 121),
  JuzInfo(number: 8, page: 142),
  JuzInfo(number: 9, page: 162),
  JuzInfo(number: 10, page: 182),
  JuzInfo(number: 11, page: 201),
  JuzInfo(number: 12, page: 222),
  JuzInfo(number: 13, page: 242),
  JuzInfo(number: 14, page: 262),
  JuzInfo(number: 15, page: 282),
  JuzInfo(number: 16, page: 302),
  JuzInfo(number: 17, page: 322),
  JuzInfo(number: 18, page: 342),
  JuzInfo(number: 19, page: 362),
  JuzInfo(number: 20, page: 382),
  JuzInfo(number: 21, page: 402),
  JuzInfo(number: 22, page: 422),
  JuzInfo(number: 23, page: 442),
  JuzInfo(number: 24, page: 462),
  JuzInfo(number: 25, page: 482),
  JuzInfo(number: 26, page: 502),
  JuzInfo(number: 27, page: 522),
  JuzInfo(number: 28, page: 542),
  JuzInfo(number: 29, page: 562),
  JuzInfo(number: 30, page: 582),
];