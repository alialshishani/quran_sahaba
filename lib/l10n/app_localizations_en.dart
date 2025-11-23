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
}
