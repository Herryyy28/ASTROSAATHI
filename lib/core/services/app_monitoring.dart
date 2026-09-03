import 'package:flutter/foundation.dart';

enum MonitoringLevel { info, warning, error, fatal }

class AppMonitoringService {
  static final AppMonitoringService _instance = AppMonitoringService._internal();
  factory AppMonitoringService() => _instance;
  AppMonitoringService._internal();

  static const String appVersion = '2.5.0';
  final List<Map<String, dynamic>> _breadcrumbs = [];
  final List<Map<String, dynamic>> _crashLogs = [];

  void logEvent(String name, {Map<String, dynamic>? parameters}) {
    final log = {
      'event': name,
      'params': parameters ?? {},
      'timestamp': DateTime.now().toIso8601String(),
    };
    _breadcrumbs.add(log);
    if (_breadcrumbs.length > 200) _breadcrumbs.removeAt(0);

    if (kDebugMode) {
      debugPrint('📊 [MONITORING] $name ${parameters ?? ''}');
    }
  }

  void reportException(dynamic error, StackTrace? stackTrace, {String? context}) {
    final report = {
      'context': context ?? 'Unhandled Exception',
      'error': error.toString(),
      'stackTrace': stackTrace?.toString().split('\n').take(5).join('\n') ?? '',
      'appVersion': appVersion,
      'timestamp': DateTime.now().toIso8601String(),
    };
    _crashLogs.add(report);
    if (_crashLogs.length > 100) _crashLogs.removeAt(0);

    debugPrint('🚨 [CRASH REPORT] Context: $context | Error: $error');
  }

  List<Map<String, dynamic>> get breadcrumbs => List.unmodifiable(_breadcrumbs);
  List<Map<String, dynamic>> get crashLogs => List.unmodifiable(_crashLogs);
}
