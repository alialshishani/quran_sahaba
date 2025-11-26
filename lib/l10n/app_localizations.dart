import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Quran Sahaba'**
  String get appTitle;

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @reader.
  ///
  /// In en, this message translates to:
  /// **'Reader'**
  String get reader;

  /// No description provided for @khetmeh.
  ///
  /// In en, this message translates to:
  /// **'Khetmeh'**
  String get khetmeh;

  /// No description provided for @navigate.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigate;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @navigateBySurah.
  ///
  /// In en, this message translates to:
  /// **'Navigate by Surah'**
  String get navigateBySurah;

  /// No description provided for @startsOnPage.
  ///
  /// In en, this message translates to:
  /// **'Starts on page {page}'**
  String startsOnPage(Object page);

  /// No description provided for @goToSurah.
  ///
  /// In en, this message translates to:
  /// **'Go to Surah'**
  String get goToSurah;

  /// No description provided for @navigateByJuz.
  ///
  /// In en, this message translates to:
  /// **'Navigate by Juz'**
  String get navigateByJuz;

  /// No description provided for @juz.
  ///
  /// In en, this message translates to:
  /// **'Juz'**
  String get juz;

  /// No description provided for @goToJuz.
  ///
  /// In en, this message translates to:
  /// **'Go to Juz'**
  String get goToJuz;

  /// No description provided for @navigateByPage.
  ///
  /// In en, this message translates to:
  /// **'Navigate by Page'**
  String get navigateByPage;

  /// No description provided for @pageNumber.
  ///
  /// In en, this message translates to:
  /// **'Page number'**
  String get pageNumber;

  /// No description provided for @enterPageNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a page between 1 and 604'**
  String get enterPageNumber;

  /// No description provided for @goToPage.
  ///
  /// In en, this message translates to:
  /// **'Go to Page'**
  String get goToPage;

  /// No description provided for @invalidPageNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid page between 1 and {totalPages}'**
  String invalidPageNumber(Object totalPages);

  /// No description provided for @khetmehPlan1Title.
  ///
  /// In en, this message translates to:
  /// **'30 Days'**
  String get khetmehPlan1Title;

  /// No description provided for @khetmehPlan1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'1 juz per day'**
  String get khetmehPlan1Subtitle;

  /// No description provided for @khetmehPlan1Range.
  ///
  /// In en, this message translates to:
  /// **'Pages 1-604'**
  String get khetmehPlan1Range;

  /// No description provided for @khetmehPlan2Title.
  ///
  /// In en, this message translates to:
  /// **'15 Days'**
  String get khetmehPlan2Title;

  /// No description provided for @khetmehPlan2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'2 juz per day'**
  String get khetmehPlan2Subtitle;

  /// No description provided for @khetmehPlan2Range.
  ///
  /// In en, this message translates to:
  /// **'Pages 1-604 split in half'**
  String get khetmehPlan2Range;

  /// No description provided for @khetmehPlan3Title.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get khetmehPlan3Title;

  /// No description provided for @khetmehPlan3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'~4 juz per day'**
  String get khetmehPlan3Subtitle;

  /// No description provided for @khetmehPlan3Range.
  ///
  /// In en, this message translates to:
  /// **'Finish every Friday'**
  String get khetmehPlan3Range;

  /// No description provided for @statsPagesReadToday.
  ///
  /// In en, this message translates to:
  /// **'Pages read today'**
  String get statsPagesReadToday;

  /// No description provided for @statsWeeklyAverage.
  ///
  /// In en, this message translates to:
  /// **'Average pages per day (last 7 days)'**
  String get statsWeeklyAverage;

  /// No description provided for @statsOverallAverage.
  ///
  /// In en, this message translates to:
  /// **'Overall daily average'**
  String get statsOverallAverage;

  /// No description provided for @statsRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get statsRecentActivity;

  /// No description provided for @statsPages.
  ///
  /// In en, this message translates to:
  /// **'{count} pages'**
  String statsPages(Object count);

  /// No description provided for @statsNoActivity.
  ///
  /// In en, this message translates to:
  /// **'No reading activity recorded yet. Start reading to see stats!'**
  String get statsNoActivity;

  /// No description provided for @aboutText.
  ///
  /// In en, this message translates to:
  /// **'Swipe through the Quran PNG pages using the Reader tab.\nUse the arrows or tabs at the bottom to navigate.'**
  String get aboutText;

  /// No description provided for @surah.
  ///
  /// In en, this message translates to:
  /// **'Surah'**
  String get surah;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @khetmehPlan4Title.
  ///
  /// In en, this message translates to:
  /// **'Sahaba Khetmeh'**
  String get khetmehPlan4Title;

  /// No description provided for @khetmehPlan4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'7-day surah-based cycle'**
  String get khetmehPlan4Subtitle;

  /// No description provided for @khetmehPlan4Range.
  ///
  /// In en, this message translates to:
  /// **'Special daily surahs'**
  String get khetmehPlan4Range;

  /// No description provided for @khetmehPlan5Title.
  ///
  /// In en, this message translates to:
  /// **'Free Roam'**
  String get khetmehPlan5Title;

  /// No description provided for @khetmehPlan5Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Read at your own pace'**
  String get khetmehPlan5Subtitle;

  /// No description provided for @khetmehPlan5Range.
  ///
  /// In en, this message translates to:
  /// **'No specific plan, just read.'**
  String get khetmehPlan5Range;

  /// No description provided for @pagesRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} pages remaining'**
  String pagesRemaining(Object count);

  /// No description provided for @expectedCompletionDate.
  ///
  /// In en, this message translates to:
  /// **'Expected completion: {date}'**
  String expectedCompletionDate(Object date);

  /// No description provided for @pagesToReadToday.
  ///
  /// In en, this message translates to:
  /// **'{count} pages to read today'**
  String pagesToReadToday(Object count);

  /// No description provided for @khetmehCompletions.
  ///
  /// In en, this message translates to:
  /// **'{count} completions'**
  String khetmehCompletions(Object count);

  /// No description provided for @sahabaKhetmehDay.
  ///
  /// In en, this message translates to:
  /// **'Day {day}: {surah}'**
  String sahabaKhetmehDay(Object day, Object surah);

  /// No description provided for @totalCompletions.
  ///
  /// In en, this message translates to:
  /// **'Total Completions'**
  String get totalCompletions;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @viewCompletionHistory.
  ///
  /// In en, this message translates to:
  /// **'View completion history'**
  String get viewCompletionHistory;

  /// No description provided for @aheadOfSchedule.
  ///
  /// In en, this message translates to:
  /// **'Ahead of schedule'**
  String get aheadOfSchedule;

  /// No description provided for @behindSchedule.
  ///
  /// In en, this message translates to:
  /// **'Behind schedule'**
  String get behindSchedule;

  /// No description provided for @onTrack.
  ///
  /// In en, this message translates to:
  /// **'On track'**
  String get onTrack;

  /// No description provided for @todaysSurah.
  ///
  /// In en, this message translates to:
  /// **'Today\'s surah: {surah}'**
  String todaysSurah(Object surah);

  /// No description provided for @completionHistory.
  ///
  /// In en, this message translates to:
  /// **'{title} - History'**
  String completionHistory(Object title);

  /// No description provided for @noCompletionHistory.
  ///
  /// In en, this message translates to:
  /// **'No completion history yet.'**
  String get noCompletionHistory;

  /// No description provided for @completedInDays.
  ///
  /// In en, this message translates to:
  /// **'Completed in {count} {count, plural, =1{day} other{days}}'**
  String completedInDays(num count);

  /// No description provided for @started.
  ///
  /// In en, this message translates to:
  /// **'Started: {date}'**
  String started(Object date);

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Finished: {date}'**
  String finished(Object date);

  /// No description provided for @onTarget.
  ///
  /// In en, this message translates to:
  /// **'On target!'**
  String get onTarget;

  /// No description provided for @daysAhead.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{day} other{days}} ahead'**
  String daysAhead(num count);

  /// No description provided for @daysOver.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{day} other{days}} over'**
  String daysOver(num count);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarks;

  /// No description provided for @addBookmark.
  ///
  /// In en, this message translates to:
  /// **'Add Bookmark'**
  String get addBookmark;

  /// No description provided for @removeBookmark.
  ///
  /// In en, this message translates to:
  /// **'Remove Bookmark'**
  String get removeBookmark;

  /// No description provided for @bookmarkAdded.
  ///
  /// In en, this message translates to:
  /// **'Bookmark added'**
  String get bookmarkAdded;

  /// No description provided for @bookmarkRemoved.
  ///
  /// In en, this message translates to:
  /// **'Bookmark removed'**
  String get bookmarkRemoved;

  /// No description provided for @noBookmarks.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet. Tap the bookmark icon while reading to save a page.'**
  String get noBookmarks;

  /// No description provided for @bookmarkNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get bookmarkNote;

  /// No description provided for @bookmarkLabel.
  ///
  /// In en, this message translates to:
  /// **'Label (optional)'**
  String get bookmarkLabel;

  /// No description provided for @saveBookmark.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveBookmark;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @editBookmark.
  ///
  /// In en, this message translates to:
  /// **'Edit Bookmark'**
  String get editBookmark;

  /// No description provided for @deleteBookmark.
  ///
  /// In en, this message translates to:
  /// **'Delete Bookmark'**
  String get deleteBookmark;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get page;

  /// No description provided for @readingSessions.
  ///
  /// In en, this message translates to:
  /// **'Reading Sessions'**
  String get readingSessions;

  /// No description provided for @currentSession.
  ///
  /// In en, this message translates to:
  /// **'Current Session'**
  String get currentSession;

  /// No description provided for @totalReadingTime.
  ///
  /// In en, this message translates to:
  /// **'Total Reading Time'**
  String get totalReadingTime;

  /// No description provided for @averageSessionTime.
  ///
  /// In en, this message translates to:
  /// **'Average Session Time'**
  String get averageSessionTime;

  /// No description provided for @longestSession.
  ///
  /// In en, this message translates to:
  /// **'Longest Session'**
  String get longestSession;

  /// No description provided for @statsSessionsToday.
  ///
  /// In en, this message translates to:
  /// **'Sessions today'**
  String get statsSessionsToday;

  /// No description provided for @statsReadingTimeToday.
  ///
  /// In en, this message translates to:
  /// **'Reading time today'**
  String get statsReadingTimeToday;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minutes(Object count);

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'{count}h {minutes}m'**
  String hours(Object count, Object minutes);

  /// No description provided for @tasbihCounter.
  ///
  /// In en, this message translates to:
  /// **'Tasbih Counter'**
  String get tasbihCounter;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @count.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get count;

  /// No description provided for @showTasbih.
  ///
  /// In en, this message translates to:
  /// **'Show Tasbih Counter'**
  String get showTasbih;

  /// No description provided for @tasbihCounterDescription.
  ///
  /// In en, this message translates to:
  /// **'Display tasbih counter in reader'**
  String get tasbihCounterDescription;

  /// No description provided for @tafseer.
  ///
  /// In en, this message translates to:
  /// **'Tafseer'**
  String get tafseer;

  /// No description provided for @tafseerLibrary.
  ///
  /// In en, this message translates to:
  /// **'Tafseer Library'**
  String get tafseerLibrary;

  /// No description provided for @downloadTafseer.
  ///
  /// In en, this message translates to:
  /// **'Download Tafseer'**
  String get downloadTafseer;

  /// No description provided for @deleteTafseer.
  ///
  /// In en, this message translates to:
  /// **'Delete Tafseer'**
  String get deleteTafseer;

  /// No description provided for @tafseerDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Tafseer downloaded'**
  String get tafseerDownloaded;

  /// No description provided for @tafseerDeleted.
  ///
  /// In en, this message translates to:
  /// **'Tafseer deleted'**
  String get tafseerDeleted;

  /// No description provided for @downloadingTafseer.
  ///
  /// In en, this message translates to:
  /// **'Downloading tafseer...'**
  String get downloadingTafseer;

  /// No description provided for @noTafseerAvailable.
  ///
  /// In en, this message translates to:
  /// **'No tafseer available for this page'**
  String get noTafseerAvailable;

  /// No description provided for @noTafseerDownloaded.
  ///
  /// In en, this message translates to:
  /// **'No tafseer downloaded yet. Download from Tafseer Library.'**
  String get noTafseerDownloaded;

  /// No description provided for @selectTafseer.
  ///
  /// In en, this message translates to:
  /// **'Select Tafseer'**
  String get selectTafseer;

  /// No description provided for @availableTafseers.
  ///
  /// In en, this message translates to:
  /// **'Available Tafseers'**
  String get availableTafseers;

  /// No description provided for @downloadedTafseers.
  ///
  /// In en, this message translates to:
  /// **'Downloaded Tafseers'**
  String get downloadedTafseers;

  /// No description provided for @tafseerSize.
  ///
  /// In en, this message translates to:
  /// **'Size: {size}'**
  String tafseerSize(Object size);

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @viewing.
  ///
  /// In en, this message translates to:
  /// **'Viewing'**
  String get viewing;

  /// No description provided for @showTafseer.
  ///
  /// In en, this message translates to:
  /// **'Show Tafseer'**
  String get showTafseer;

  /// No description provided for @hideTafseer.
  ///
  /// In en, this message translates to:
  /// **'Hide Tafseer'**
  String get hideTafseer;

  /// No description provided for @tafseerForPage.
  ///
  /// In en, this message translates to:
  /// **'Tafseer for Page {page}'**
  String tafseerForPage(Object page);

  /// No description provided for @ayah.
  ///
  /// In en, this message translates to:
  /// **'Ayah'**
  String get ayah;

  /// No description provided for @tafseerIbnKathir.
  ///
  /// In en, this message translates to:
  /// **'Tafsir Ibn Kathir'**
  String get tafseerIbnKathir;

  /// No description provided for @tafseerJalalayn.
  ///
  /// In en, this message translates to:
  /// **'Tafsir al-Jalalayn'**
  String get tafseerJalalayn;

  /// No description provided for @tafseerSaadi.
  ///
  /// In en, this message translates to:
  /// **'Tafsir al-Sa\'di'**
  String get tafseerSaadi;

  /// No description provided for @tafseerMuyassar.
  ///
  /// In en, this message translates to:
  /// **'Tafsir al-Muyassar'**
  String get tafseerMuyassar;

  /// No description provided for @englishTranslation.
  ///
  /// In en, this message translates to:
  /// **'English Translation'**
  String get englishTranslation;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;

  /// No description provided for @downloaded.
  ///
  /// In en, this message translates to:
  /// **'Downloaded'**
  String get downloaded;

  /// No description provided for @notDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Not Downloaded'**
  String get notDownloaded;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
