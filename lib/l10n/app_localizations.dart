import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_language.dart';
import '../core/providers/locale_provider.dart';
import 'translations/en_translations.dart';
import 'translations/hi_translations.dart';
import 'translations/gu_translations.dart';

class AppLocalizations {
  final AppLanguage language;

  AppLocalizations(this.language);

  static AppLocalizations of(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(localeProvider);
    return AppLocalizations(lang);
  }

  static AppLocalizations fromLanguage(AppLanguage language) {
    return AppLocalizations(language);
  }

  String translate(String key) {
    Map<String, String> translationMap;
    switch (language) {
      case AppLanguage.hindi:
        translationMap = hiTranslations;
        break;
      case AppLanguage.gujarati:
        translationMap = guTranslations;
        break;
      case AppLanguage.english:
      default:
        translationMap = enTranslations;
        break;
    }

    return translationMap[key] ?? enTranslations[key] ?? key;
  }

  // Common & Core
  String get appTitle => translate('app_title');
  String get active => translate('active');
  String get loading => translate('loading');
  String get error => translate('error');
  String get retry => translate('retry');
  String get save => translate('save');
  String get cancel => translate('cancel');
  String get continueText => translate('continue');
  String get back => translate('back');
  String get next => translate('next');
  String get ok => translate('ok');
  String get close => translate('close');
  String get done => translate('done');
  String get confirm => translate('confirm');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get share => translate('share');
  String get viewDetails => translate('view_details');
  String get whyThis => translate('why_this');
  String get noDataAvailable => translate('no_data_available');
  String get somethingWentWrong => translate('something_went_wrong');
  String get pleaseWait => translate('please_wait');
  String get networkError => translate('network_error');
  String get sessionExpired => translate('session_expired');
  String get locationUnavailable => translate('location_unavailable');
  String get aiUnavailable => translate('ai_unavailable');
  String get selectLanguage => translate('select_language');
  String get chooseLanguage => translate('choose_language');
  String get chooseLanguageSub => translate('choose_language_sub');

  // Nav
  String get navGamePlan => translate('nav_game_plan');
  String get navHoroscope => translate('nav_horoscope');
  String get navPanchang => translate('nav_panchang');
  String get navMatching => translate('nav_matching');
  String get navRemedies => translate('nav_remedies');
  String get navAstroBaba => translate('nav_astro_baba');
  String get navMyKundlis => translate('nav_my_kundlis');
  String get navSettings => translate('nav_settings');

  // Home
  String get goodMorning => translate('good_morning');
  String get goodAfternoon => translate('good_afternoon');
  String get goodEvening => translate('good_evening');
  String get cosmicGamePlan => translate('cosmic_game_plan');
  String get cosmicCalendarTitle => translate('cosmic_calendar_title');
  String get cosmicCalendarSub => translate('cosmic_calendar_sub');
  String get energyScore => translate('energy_score');
  String get todaysFocus => translate('todays_focus');
  String get doTitle => translate('do_title');
  String get beCarefulTitle => translate('be_careful_title');
  String get avoidTitle => translate('avoid_title');
  String get bestWindow => translate('best_window');
  String get categories => translate('categories');
  String get currentDasha => translate('current_dasha');
  String get currentTransit => translate('current_transit');
  String get todaysInsight => translate('todays_insight');
  String get askAstroBabaPrompt => translate('ask_astro_baba_prompt');
  String get askAstroBabaBtn => translate('ask_astro_baba_btn');
  String get quickActions => translate('quick_actions');

  // Kundli
  String get kundliTitle => translate('kundli_title');
  String get birthChart => translate('birth_chart');
  String get planetaryPositions => translate('planetary_positions');
  String get houses => translate('houses');
  String get ascendantLagna => translate('ascendant_lagna');
  String get signs => translate('signs');
  String get planetDetails => translate('planet_details');
  String get houseDetails => translate('house_details');
  String get dasha => translate('dasha');
  String get mahadasha => translate('mahadasha');
  String get antardasha => translate('antardasha');
  String get currentPeriod => translate('current_period');
  String get upcomingPeriod => translate('upcoming_period');
  String get transit => translate('transit');
  String get explanation => translate('explanation');
  String get createKundli => translate('create_kundli');

  // Panchang & Muhurat
  String get panchangTitle => translate('panchang_title');
  String get todaysPanchang => translate('todays_panchang');
  String get changeDate => translate('change_date');
  String get changeLocation => translate('change_location');
  String get tithi => translate('tithi');
  String get vara => translate('vara');
  String get nakshatra => translate('nakshatra');
  String get yoga => translate('yoga');
  String get karana => translate('karana');
  String get sunrise => translate('sunrise');
  String get sunset => translate('sunset');
  String get moonrise => translate('moonrise');
  String get moonset => translate('moonset');
  String get rahuKaal => translate('rahu_kaal');
  String get abhijitMuhurat => translate('abhijit_muhurat');
  String get muhurat => translate('muhurat');
  String get recommended => translate('recommended');
  String get whyThisTime => translate('why_this_time');

  // Matching
  String get matchingTitle => translate('matching_title');
  String get gunaScore => translate('guna_score');
  String get mangalDosh => translate('mangal_dosh');
  String get strengths => translate('strengths');
  String get concerns => translate('concerns');
  String get overallCompatibility => translate('overall_compatibility');
  String get checkCompatibility => translate('check_compatibility');

  // Remedies & Japa
  String get remediesTitle => translate('remedies_title');
  String get remediesSub => translate('remedies_sub');
  String get recommendedRemedy => translate('recommended_remedy');
  String get whyThisRemedy => translate('why_this_remedy');
  String get gemstoneRecommendation => translate('gemstone_recommendation');
  String get wearingInstructions => translate('wearing_instructions');
  String get mantra => translate('mantra');
  String get beejMantra => translate('beej_mantra');
  String get authenticUpay => translate('authentic_upay');
  String get instructions => translate('instructions');
  String get japaCounter => translate('japa_counter');
  String get chantCount => translate('chant_count');

  // Astro Baba
  String get astroBabaGreeting => translate('astro_baba_greeting');
  String get askBabaHint => translate('ask_baba_hint');
  String get babaConnected => translate('baba_connected');

  // Settings & Profile
  String get profileSettings => translate('profile_settings');
  String get myProfile => translate('my_profile');
  String get myFamily => translate('my_family');
  String get history => translate('history');
  String get savedInsights => translate('saved_insights');
  String get languageSetting => translate('language_setting');
  String get appearance => translate('appearance');
  String get darkMode => translate('dark_mode');
  String get lightMode => translate('light_mode');
  String get trustCenter => translate('trust_center');
  String get privacy => translate('privacy');
  String get security => translate('security');
  String get help => translate('help');
  String get about => translate('about');
  String get logout => translate('logout');
  String get deleteAccount => translate('delete_account');
  String get saveChanges => translate('save_changes');
  String get notifications => translate('notifications');
  String get notificationDailyReady => translate('notification_daily_ready');
  String get generatePdfReport => translate('generate_pdf_report');

  // Onboarding
  String get welcomeToAstrosaathi => translate('welcome_to_astrosaathi');
  String get onboardingSub1 => translate('onboarding_sub1');
  String get onboardingSub2 => translate('onboarding_sub2');
  String get getStarted => translate('get_started');

  // ── New 5-Tab Navigation ─────────────────────────
  String get navHome => translate('nav_home');
  String get navKundli => translate('nav_kundli');
  String get navExplore => translate('nav_explore');
  String get navAstroAi => translate('nav_astro_ai');
  String get navProfile => translate('nav_profile');

  // ── Explore Hub ──────────────────────────────────
  String get exploreTitle => translate('explore_title');
  String get explorePanchang => translate('explore_panchang');
  String get exploreMuhurat => translate('explore_muhurat');
  String get exploreHoroscope => translate('explore_horoscope');
  String get exploreDosha => translate('explore_dosha');
  String get exploreRemedies => translate('explore_remedies');
  String get exploreCompatibility => translate('explore_compatibility');
  String get exploreNumerology => translate('explore_numerology');
  String get exploreTransits => translate('explore_transits');

  // ── Progressive Disclosure ───────────────────────
  String get whatThisMeans => translate('what_this_means');
  String get viewTechnicalDetails => translate('view_technical_details');
  String get basedOnKundli => translate('based_on_kundli');
  String get whySeeingThis => translate('why_seeing_this');

  // ── Kundli Screen Tabs ───────────────────────────
  String get tabOverview => translate('tab_overview');
  String get tabPlanets => translate('tab_planets');
  String get tabHouses => translate('tab_houses');
  String get tabDasha => translate('tab_dasha');
  String get tabYogas => translate('tab_yogas');
  String get tabRemedies => translate('tab_remedies');
  String get strongInfluence => translate('strong_influence');
  String get moderateInfluence => translate('moderate_influence');
  String get weakInfluence => translate('weak_influence');

  // ── Profile Screen ───────────────────────────────
  String get primaryProfile => translate('primary_profile');
  String get familyKundlis => translate('family_kundlis');
  String get addFamilyMember => translate('add_family_member');
  String get dataPrivacy => translate('data_privacy');
  String get accountManagement => translate('account_management');
}
