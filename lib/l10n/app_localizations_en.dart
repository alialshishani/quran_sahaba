// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Quran Sahaba';

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get reader => 'Reader';

  @override
  String get khetmeh => 'Khetmeh';

  @override
  String get navigate => 'Navigate';

  @override
  String get statistics => 'Statistics';

  @override
  String get settings => 'Settings';

  @override
  String get navigateBySurah => 'Navigate by Surah';

  @override
  String startsOnPage(Object page) {
    return 'Starts on page $page';
  }

  @override
  String get goToSurah => 'Go to Surah';

  @override
  String get navigateByJuz => 'Navigate by Juz';

  @override
  String get juz => 'Juz';

  @override
  String get goToJuz => 'Go to Juz';

  @override
  String get navigateByPage => 'Navigate by Page';

  @override
  String get pageNumber => 'Page number';

  @override
  String get enterPageNumber => 'Enter a page between 1 and 604';

  @override
  String get goToPage => 'Go to Page';

  @override
  String invalidPageNumber(Object totalPages) {
    return 'Please enter a valid page between 1 and $totalPages';
  }

  @override
  String get khetmehPlan1Title => '30 Days';

  @override
  String get khetmehPlan1Subtitle => '1 juz per day';

  @override
  String get khetmehPlan1Range => 'Pages 1-604';

  @override
  String get khetmehPlan2Title => '15 Days';

  @override
  String get khetmehPlan2Subtitle => '2 juz per day';

  @override
  String get khetmehPlan2Range => 'Pages 1-604 split in half';

  @override
  String get khetmehPlan3Title => 'Weekly';

  @override
  String get khetmehPlan3Subtitle => '~4 juz per day';

  @override
  String get khetmehPlan3Range => 'Finish every Friday';

  @override
  String get statsPagesReadToday => 'Pages read today';

  @override
  String get statsWeeklyAverage => 'Average pages per day (last 7 days)';

  @override
  String get statsOverallAverage => 'Overall daily average';

  @override
  String get statsRecentActivity => 'Recent activity';

  @override
  String statsPages(Object count) {
    return '$count pages';
  }

  @override
  String get statsNoActivity =>
      'No reading activity recorded yet. Start reading to see stats!';

  @override
  String get aboutText =>
      'Swipe through the Quran PNG pages using the Reader tab.\nUse the arrows or tabs at the bottom to navigate.';

  @override
  String get surah => 'Surah';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get khetmehPlan4Title => 'Sahaba Khetmeh';

  @override
  String get khetmehPlan4Subtitle => '7-day surah-based cycle';

  @override
  String get khetmehPlan4Range => 'Special daily surahs';

  @override
  String get khetmehPlan5Title => 'Free Roam';

  @override
  String get khetmehPlan5Subtitle => 'Read at your own pace';

  @override
  String get khetmehPlan5Range => 'No specific plan, just read.';

  @override
  String pagesRemaining(Object count) {
    return '$count pages remaining';
  }

  @override
  String expectedCompletionDate(Object date) {
    return 'Expected completion: $date';
  }

  @override
  String pagesToReadToday(Object count) {
    return '$count pages to read today';
  }

  @override
  String khetmehCompletions(Object count) {
    return '$count completions';
  }

  @override
  String sahabaKhetmehDay(Object day, Object surah) {
    return 'Day $day: $surah';
  }

  @override
  String get totalCompletions => 'Total Completions';

  @override
  String get start => 'Start';

  @override
  String get complete => 'Complete';

  @override
  String get end => 'End';

  @override
  String get viewCompletionHistory => 'View completion history';

  @override
  String get aheadOfSchedule => 'Ahead of schedule';

  @override
  String get behindSchedule => 'Behind schedule';

  @override
  String get onTrack => 'On track';

  @override
  String todaysSurah(Object surah) {
    return 'Today\'s surah: $surah';
  }

  @override
  String completionHistory(Object title) {
    return '$title - History';
  }

  @override
  String get noCompletionHistory => 'No completion history yet.';

  @override
  String completedInDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return 'Completed in $count $_temp0';
  }

  @override
  String started(Object date) {
    return 'Started: $date';
  }

  @override
  String finished(Object date) {
    return 'Finished: $date';
  }

  @override
  String get onTarget => 'On target!';

  @override
  String daysAhead(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$count $_temp0 ahead';
  }

  @override
  String daysOver(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$count $_temp0 over';
  }

  @override
  String get close => 'Close';

  @override
  String get bookmarks => 'Bookmarks';

  @override
  String get addBookmark => 'Add Bookmark';

  @override
  String get removeBookmark => 'Remove Bookmark';

  @override
  String get bookmarkAdded => 'Bookmark added';

  @override
  String get bookmarkRemoved => 'Bookmark removed';

  @override
  String get noBookmarks =>
      'No bookmarks yet. Tap the bookmark icon while reading to save a page.';

  @override
  String get bookmarkNote => 'Note (optional)';

  @override
  String get bookmarkLabel => 'Label (optional)';

  @override
  String get saveBookmark => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get editBookmark => 'Edit Bookmark';

  @override
  String get deleteBookmark => 'Delete Bookmark';

  @override
  String get page => 'Page';

  @override
  String get readingSessions => 'Reading Sessions';

  @override
  String get currentSession => 'Current Session';

  @override
  String get totalReadingTime => 'Total Reading Time';

  @override
  String get averageSessionTime => 'Average Session Time';

  @override
  String get longestSession => 'Longest Session';

  @override
  String get statsSessionsToday => 'Sessions today';

  @override
  String get statsReadingTimeToday => 'Reading time today';

  @override
  String minutes(Object count) {
    return '$count min';
  }

  @override
  String hours(Object count, Object minutes) {
    return '${count}h ${minutes}m';
  }

  @override
  String get tasbihCounter => 'Tasbih Counter';

  @override
  String get reset => 'Reset';

  @override
  String get count => 'Count';

  @override
  String get showTasbih => 'Show Tasbih Counter';

  @override
  String get tasbihCounterDescription => 'Display tasbih counter in reader';

  @override
  String get tafseer => 'Tafseer';

  @override
  String get tafseerLibrary => 'Tafseer Library';

  @override
  String get downloadTafseer => 'Download Tafseer';

  @override
  String get deleteTafseer => 'Delete Tafseer';

  @override
  String get tafseerDownloaded => 'Tafseer downloaded';

  @override
  String get tafseerDeleted => 'Tafseer deleted';

  @override
  String get downloadingTafseer => 'Downloading tafseer...';

  @override
  String get noTafseerAvailable => 'No tafseer available for this page';

  @override
  String get noTafseerDownloaded =>
      'No tafseer downloaded yet. Download from Tafseer Library.';

  @override
  String get selectTafseer => 'Select Tafseer';

  @override
  String get availableTafseers => 'Available Tafseers';

  @override
  String get downloadedTafseers => 'Downloaded Tafseers';

  @override
  String tafseerSize(Object size) {
    return 'Size: $size';
  }

  @override
  String get download => 'Download';

  @override
  String get delete => 'Delete';

  @override
  String get viewing => 'Viewing';

  @override
  String get showTafseer => 'Show Tafseer';

  @override
  String get hideTafseer => 'Hide Tafseer';

  @override
  String tafseerForPage(Object page) {
    return 'Tafseer for Page $page';
  }

  @override
  String get ayah => 'Ayah';

  @override
  String get tafseerIbnKathir => 'Tafsir Ibn Kathir';

  @override
  String get tafseerJalalayn => 'Tafsir al-Jalalayn';

  @override
  String get tafseerSaadi => 'Tafsir al-Sa\'di';

  @override
  String get tafseerMuyassar => 'Tafsir al-Muyassar';

  @override
  String get englishTranslation => 'English Translation';

  @override
  String get downloading => 'Downloading...';

  @override
  String get downloaded => 'Downloaded';

  @override
  String get notDownloaded => 'Not Downloaded';
}
