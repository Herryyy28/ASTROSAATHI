import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    const ProviderScope(
      child: AstroSaathiApp(),
    ),
  );
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
      routerConfig: router,
    );
  }
}
