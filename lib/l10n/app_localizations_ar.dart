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
  String get khetmehPlan4Title => 'ختمة الصحابة';

  @override
  String get khetmehPlan4Subtitle => 'دورة 7 أيام على أساس السور';

  @override
  String get khetmehPlan4Range => 'سور يومية خاصة';

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

  @override
  String sahabaKhetmehDay(Object day, Object surah) {
    return 'اليوم $day: $surah';
  }

  @override
  String get totalCompletions => 'إجمالي الإكمالات';

  @override
  String get start => 'ابدأ';

  @override
  String get complete => 'أكمل';

  @override
  String get end => 'أنهِ';

  @override
  String get viewCompletionHistory => 'عرض سجل الإكمالات';

  @override
  String get aheadOfSchedule => 'متقدم على الجدول';

  @override
  String get behindSchedule => 'متأخر عن الجدول';

  @override
  String get onTrack => 'على المسار الصحيح';

  @override
  String todaysSurah(Object surah) {
    return 'سورة اليوم: $surah';
  }

  @override
  String completionHistory(Object title) {
    return '$title - السجل';
  }

  @override
  String get noCompletionHistory => 'لا يوجد سجل إكمالات بعد.';

  @override
  String completedInDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أيام',
      one: 'يوم',
    );
    return 'تم الإكمال في $count $_temp0';
  }

  @override
  String started(Object date) {
    return 'البداية: $date';
  }

  @override
  String finished(Object date) {
    return 'الانتهاء: $date';
  }

  @override
  String get onTarget => 'على الهدف!';

  @override
  String daysAhead(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أيام',
      one: 'يوم',
    );
    return '$count $_temp0 متقدم';
  }

  @override
  String daysOver(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أيام',
      one: 'يوم',
    );
    return '$count $_temp0 تأخير';
  }

  @override
  String get close => 'إغلاق';

  @override
  String get bookmarks => 'الإشارات المرجعية';

  @override
  String get addBookmark => 'إضافة إشارة مرجعية';

  @override
  String get removeBookmark => 'إزالة الإشارة المرجعية';

  @override
  String get bookmarkAdded => 'تمت إضافة الإشارة المرجعية';

  @override
  String get bookmarkRemoved => 'تمت إزالة الإشارة المرجعية';

  @override
  String get noBookmarks =>
      'لا توجد إشارات مرجعية حتى الآن. اضغط على أيقونة الإشارة المرجعية أثناء القراءة لحفظ صفحة.';

  @override
  String get bookmarkNote => 'ملاحظة (اختياري)';

  @override
  String get bookmarkLabel => 'تسمية (اختياري)';

  @override
  String get saveBookmark => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get editBookmark => 'تعديل الإشارة المرجعية';

  @override
  String get deleteBookmark => 'حذف الإشارة المرجعية';

  @override
  String get page => 'صفحة';

  @override
  String get readingSessions => 'جلسات القراءة';

  @override
  String get currentSession => 'الجلسة الحالية';

  @override
  String get totalReadingTime => 'إجمالي وقت القراءة';

  @override
  String get averageSessionTime => 'متوسط وقت الجلسة';

  @override
  String get longestSession => 'أطول جلسة';

  @override
  String get statsSessionsToday => 'الجلسات اليوم';

  @override
  String get statsReadingTimeToday => 'وقت القراءة اليوم';

  @override
  String minutes(Object count) {
    return '$count دقيقة';
  }

  @override
  String hours(Object count, Object minutes) {
    return '$countس $minutesد';
  }

  @override
  String get tasbihCounter => 'عداد التسبيح';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get count => 'العدد';

  @override
  String get showTasbih => 'إظهار عداد التسبيح';

  @override
  String get tasbihCounterDescription => 'عرض عداد التسبيح في القارئ';

  @override
  String get tafseer => 'التفسير';

  @override
  String get tafseerLibrary => 'مكتبة التفسير';

  @override
  String get downloadTafseer => 'تحميل التفسير';

  @override
  String get deleteTafseer => 'حذف التفسير';

  @override
  String get tafseerDownloaded => 'تم تحميل التفسير';

  @override
  String get tafseerDeleted => 'تم حذف التفسير';

  @override
  String get downloadingTafseer => 'جاري تحميل التفسير...';

  @override
  String get noTafseerAvailable => 'لا يوجد تفسير متاح لهذه الصفحة';

  @override
  String get noTafseerDownloaded =>
      'لم يتم تحميل أي تفسير بعد. قم بالتحميل من مكتبة التفسير.';

  @override
  String get selectTafseer => 'اختر التفسير';

  @override
  String get availableTafseers => 'التفاسير المتاحة';

  @override
  String get downloadedTafseers => 'التفاسير المحملة';

  @override
  String tafseerSize(Object size) {
    return 'الحجم: $size';
  }

  @override
  String get download => 'تحميل';

  @override
  String get delete => 'حذف';

  @override
  String get viewing => 'عرض';

  @override
  String get showTafseer => 'إظهار التفسير';

  @override
  String get hideTafseer => 'إخفاء التفسير';

  @override
  String tafseerForPage(Object page) {
    return 'تفسير الصفحة $page';
  }

  @override
  String get ayah => 'الآية';

  @override
  String get tafseerIbnKathir => 'تفسير ابن كثير';

  @override
  String get tafseerJalalayn => 'تفسير الجلالين';

  @override
  String get tafseerSaadi => 'تفسير السعدي';

  @override
  String get tafseerMuyassar => 'التفسير الميسر';

  @override
  String get englishTranslation => 'الترجمة الإنجليزية';

  @override
  String get downloading => 'جاري التحميل...';

  @override
  String get downloaded => 'تم التحميل';

  @override
  String get notDownloaded => 'غير محمل';
}
