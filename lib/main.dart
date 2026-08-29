import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/locale_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Prevent unhandled error crashes in production
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
  };
  WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
    debugPrint('Platform Error: $error\n$stack');
    return true;
  };

  // Allow runtime font fetching
  GoogleFonts.config.allowRuntimeFetching = true;

  // Render main app immediately so UI opens instantly without waiting for ad SDK
  runApp(
    const ProviderScope(
      child: AstroSaathiApp(),
    ),
  );

  // Initialize Mobile Ads asynchronously after UI renders
  MobileAds.instance.initialize().catchError((e) {
    debugPrint('MobileAds init error: $e');
    return const InitializationStatus({});
  });
}

class AstroSaathiApp extends ConsumerWidget {
  const AstroSaathiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final language = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'AstroSaathi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      locale: Locale(language.code),
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('gu'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        final clampedTextScaler = mediaQueryData.textScaler.clamp(
          minScaleFactor: 0.85,
          maxScaleFactor: 1.15,
        );
        return MediaQuery(
          data: mediaQueryData.copyWith(textScaler: clampedTextScaler),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
