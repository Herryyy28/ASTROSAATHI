import 'package:astrosaathi/core/engine/demo_calendar_engine.dart';
import 'package:astrosaathi/core/providers/profile_provider.dart';
import 'package:astrosaathi/core/theme/app_theme.dart';
import 'package:astrosaathi/features/calendar/presentation/screens/astro_calendar_screen.dart';
import 'package:astrosaathi/features/profile/presentation/screens/edit_profile_screens.dart';
import 'package:astrosaathi/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _profile = BirthProfileData(
  id: 'primary',
  name: 'Aarav Shah',
  relationship: 'Self',
  gender: 'Male',
  dob: '1998-03-18',
  birthTime: '08:42 PM',
  birthPlace: 'Ahmedabad, Gujarat, India',
  latitude: 23.0225,
  longitude: 72.5714,
  timezone: '5.5',
  focusAreas: ['Career', 'Personal Growth'],
  isPrimary: true,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('calendar output is deterministic and recomputes by month and date', () {
    final october = DemoCalendarEngine.monthlyOverview(
      profile: _profile,
      year: 2026,
      month: 10,
    );
    final octoberAgain = DemoCalendarEngine.monthlyOverview(
      profile: _profile,
      year: 2026,
      month: 10,
    );
    final november = DemoCalendarEngine.monthlyOverview(
      profile: _profile,
      year: 2026,
      month: 11,
    );

    expect(october.overallScore, octoberAgain.overallScore);
    expect(october.bestDays, octoberAgain.bestDays);
    expect(
      october.cosmicEvents.map((event) => event.day),
      octoberAgain.cosmicEvents.map((event) => event.day),
    );
    expect(
      '${october.overallScore}|${october.bestDays}',
      isNot('${november.overallScore}|${november.bestDays}'),
    );

    final first = DemoCalendarEngine.dailyDetail(
      profile: _profile,
      date: DateTime(2026, 10, 3),
    );
    final second = DemoCalendarEngine.dailyDetail(
      profile: _profile,
      date: DateTime(2026, 10, 4),
    );
    expect(
      '${first.clarity}|${first.primaryInfluence}',
      isNot('${second.clarity}|${second.primaryInfluence}'),
    );
    expect(DemoCalendarEngine.clampDay(year: 2027, month: 2, day: 31), 28);
  });

  test('profile updates persist all editable local fields', () async {
    final notifier = ProfilesNotifier();
    await notifier.upsertPrimaryProfile(
      name: _profile.name,
      dob: _profile.dob,
      birthTime: _profile.birthTime,
      birthPlace: _profile.birthPlace,
      latitude: _profile.latitude,
      longitude: _profile.longitude,
      timezone: _profile.timezone,
      focusAreas: _profile.focusAreas,
      gender: _profile.gender,
    );
    final updated = notifier.state.single.copyWith(
      name: 'Aarav Mehta',
      gender: 'Prefer not to say',
      birthTimeUnknown: true,
      focusAreas: ['Family', 'Spiritual Growth'],
    );
    await notifier.updateProfile(updated);

    final restored = ProfilesNotifier();
    await restored.loadProfiles();
    expect(restored.state.single.name, 'Aarav Mehta');
    expect(restored.state.single.gender, 'Prefer not to say');
    expect(restored.state.single.birthTimeUnknown, isTrue);
    expect(restored.state.single.focusAreas, ['Family', 'Spiritual Growth']);
  });

  testWidgets('profile rows open dedicated edit screens', (tester) async {
    final notifier = ProfilesNotifier();
    await notifier.upsertPrimaryProfile(
      name: _profile.name,
      dob: _profile.dob,
      birthTime: _profile.birthTime,
      birthPlace: _profile.birthPlace,
      latitude: _profile.latitude,
      longitude: _profile.longitude,
      timezone: _profile.timezone,
      focusAreas: _profile.focusAreas,
      gender: _profile.gender,
    );

    Future<void> pumpProfile() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [profilesListProvider.overrideWith((ref) => notifier)],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    await pumpProfile();
    await tester.tap(find.text('Personal Information'));
    await tester.pumpAndSettle();
    expect(find.byType(EditPersonalInfoScreen), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Birth Details'));
    await tester.pumpAndSettle();
    expect(find.byType(EditBirthDetailsScreen), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Focus Areas'));
    await tester.pumpAndSettle();
    expect(find.byType(EditFocusAreasScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('saving personal information updates profile and local storage', (
    tester,
  ) async {
    final notifier = ProfilesNotifier();
    await notifier.upsertPrimaryProfile(
      name: _profile.name,
      dob: _profile.dob,
      birthTime: _profile.birthTime,
      birthPlace: _profile.birthPlace,
      latitude: _profile.latitude,
      longitude: _profile.longitude,
      timezone: _profile.timezone,
      focusAreas: _profile.focusAreas,
      gender: _profile.gender,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [profilesListProvider.overrideWith((ref) => notifier)],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ProfileScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Personal Information'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'maya patel');
    await tester.tap(find.text('Save Changes'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(notifier.state.single.name, 'Maya Patel');
    expect(find.text('Personal information updated'), findsOneWidget);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('user_name'), 'Maya Patel');
  });

  for (final width in <double>[360, 390, 412, 430]) {
    testWidgets(
      'profile editors and completed calendar fit at ${width.toInt()}px',
      (tester) async {
        tester.view.physicalSize = Size(width, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);

        for (final screen in <Widget>[
          const EditPersonalInfoScreen(),
          const EditBirthDetailsScreen(),
          const EditFocusAreasScreen(),
        ]) {
          await tester.pumpWidget(
            ProviderScope(
              overrides: [activeProfileProvider.overrideWithValue(_profile)],
              child: MaterialApp(theme: AppTheme.lightTheme, home: screen),
            ),
          );
          await tester.pump(const Duration(milliseconds: 250));
          final exception = tester.takeException();
          expect(
            exception,
            isNull,
            reason: '${screen.runtimeType} overflowed at ${width.toInt()}px',
          );
        }

        await tester.pumpWidget(
          ProviderScope(
            overrides: [activeProfileProvider.overrideWithValue(_profile)],
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: const AstroCalendarScreen(),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 400));
        await tester.tap(find.text('Month'));
        await tester.pump(const Duration(milliseconds: 250));
        expect(find.text('Monthly Overview'), findsOneWidget);
        expect(find.text('Demo Cosmic Highlights'), findsOneWidget);
        expect(find.text('Monthly timing unavailable'), findsNothing);

        final currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
        await tester.tap(find.byTooltip('Next month'));
        await tester.pump(const Duration(milliseconds: 250));
        expect(find.text(currentMonth), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
