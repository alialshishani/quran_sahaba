// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'قرآن الصحابة';

  @override
  String get helloWorld => 'أهلاً بالعالم!';

  @override
  String get reader => 'القارئ';

  @override
  String get khetmeh => 'ختمة';

  @override
  String get navigate => 'تصفح';

  @override
  String get statistics => 'إحصائيات';

  @override
  String get settings => 'إعدادات';

  @override
  String get navigateBySurah => 'التنقل حسب السورة';

  @override
  String startsOnPage(Object page) {
    return 'تبدأ في صفحة $page';
  }

  @override
  String get goToSurah => 'اذهب إلى السورة';

  @override
  String get navigateByJuz => 'التنقل حسب الجزء';

  @override
  String get juz => 'الجزء';

  @override
  String get goToJuz => 'اذهب إلى الجزء';

  @override
  String get navigateByPage => 'التنقل حسب الصفحة';

  @override
  String get pageNumber => 'رقم الصفحة';

  @override
  String get enterPageNumber => 'أدخل صفحة بين 1 و 604';

  @override
  String get goToPage => 'اذهب إلى الصفحة';

  @override
  String invalidPageNumber(Object totalPages) {
    return 'يرجى إدخال صفحة صالحة بين 1 و $totalPages';
  }

  @override
  String get khetmehPlan1Title => '30 يومًا';

  @override
  String get khetmehPlan1Subtitle => '1 جزء في اليوم';

  @override
  String get khetmehPlan1Range => 'صفحات 1-604';

  @override
  String get khetmehPlan2Title => '15 يومًا';

  @override
  String get khetmehPlan2Subtitle => '2 جزء في اليوم';

  @override
  String get khetmehPlan2Range => 'صفحات 1-604 مقسمة إلى نصفين';

  @override
  String get khetmehPlan3Title => 'أسبوعيًا';

  @override
  String get khetmehPlan3Subtitle => '~ 4 أجزاء في اليوم';

  @override
  String get khetmehPlan3Range => 'إنهاء كل يوم جمعة';

  @override
  String get statsPagesReadToday => 'الصفحات المقروءة اليوم';

  @override
  String get statsWeeklyAverage => 'متوسط الصفحات في اليوم (آخر 7 أيام)';

  @override
  String get statsOverallAverage => 'المتوسط اليومي الإجمالي';

  @override
  String get statsRecentActivity => 'النشاط الأخير';

  @override
  String statsPages(Object count) {
    return '$count صفحات';
  }

  @override
  String get statsNoActivity =>
      'لم يتم تسجيل أي نشاط قراءة حتى الآن. ابدأ القراءة لترى الإحصائيات!';

  @override
  String get aboutText =>
      'مرر عبر صفحات القرآن بتنسيق PNG باستخدام علامة تبويب القارئ.\nاستخدم الأسهم أو علامات التبويب في الأسفل للتنقل.';

  @override
  String get surah => 'سورة';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'السمة';

  @override
  String get khetmehPlan5Title => 'تجوال حر';

  @override
  String get khetmehPlan5Subtitle => 'اقرأ بالسرعة التي تناسبك';

  @override
  String get khetmehPlan5Range => 'لا توجد خطة محددة ، فقط اقرأ.';

  @override
  String pagesRemaining(Object count) {
    return '$count صفحات متبقية';
  }

  @override
  String expectedCompletionDate(Object date) {
    return 'التاريخ المتوقع للانتهاء: $date';
  }

  @override
  String pagesToReadToday(Object count) {
    return '$count صفحات للقراءة اليوم';
  }

  @override
  String khetmehCompletions(Object count) {
    return '$count إكمالات';
  }
}
