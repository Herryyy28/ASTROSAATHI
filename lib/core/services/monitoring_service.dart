import 'package:flutter/foundation.dart';

enum MetricCategory {
  auth,
  payment,
  api,
  ai,
  performance,
  crash,
}

class PerformanceMetric {
  final String metricName;
  final int durationMs;
  final String timestamp;

  PerformanceMetric({
    required this.metricName,
    required this.durationMs,
    required this.timestamp,
  });
}

class MonitoringService {
  static final List<String> _errorLogs = [];
  static final List<PerformanceMetric> _performanceLogs = [];

  /// Log sanitized crash or exception without exposing user tokens/secrets
  static void logError(
    Object error, {
    StackTrace? stackTrace,
    MetricCategory category = MetricCategory.api,
    String? contextMessage,
  }) {
    final timestamp = DateTime.now().toIso8601String();
    final sanitizedError = _sanitizeMessage(error.toString());
    final logMessage = '[$timestamp] [${category.name.toUpperCase()}] ${contextMessage ?? ''}: $sanitizedError';

    _errorLogs.add(logMessage);
    if (_errorLogs.length > 100) {
      _errorLogs.removeAt(0);
    }

    if (kDebugMode) {
      debugPrint('📊 MONITORING: $logMessage');
      if (stackTrace != null) {
        debugPrint('STACKTRACE: ${stackTrace.toString().split('\n').take(3).join('\n')}');
      }
    }
  }

  /// Measure feature load performance
  static void recordPerformance(String featureName, int durationMs) {
    final metric = PerformanceMetric(
      metricName: featureName,
      durationMs: durationMs,
      timestamp: DateTime.now().toIso8601String(),
    );
    _performanceLogs.add(metric);
    if (_performanceLogs.length > 50) {
      _performanceLogs.removeAt(0);
    }

    if (kDebugMode) {
      debugPrint('⚡ PERFORMANCE: ${metric.metricName} loaded in ${metric.durationMs}ms');
    }
  }

  /// Sanitize logs to strip authorization headers, JWT tokens, CVVs, or OTPs
  static String _sanitizeMessage(String raw) {
    return raw
        .replaceAll(RegExp(r'Bearer\s+[A-Za-z0-9\-\._~\+\/]+=*'), 'Bearer [REDACTED]')
        .replaceAll(RegExp(r'key_[A-Za-z0-9_]+'), 'key_[REDACTED]')
        .replaceAll(RegExp(r'rzp_[A-Za-z0-9_]+'), 'rzp_[REDACTED]')
        .replaceAll(RegExp(r'\b\d{4}[- ]?\d{4}[- ]?\d{4}[- ]?\d{4}\b'), '[CARD REDACTED]')
        .replaceAll(RegExp(r'\b\d{6}\b'), '[OTP REDACTED]');
  }

  static List<String> getRecentErrorLogs() => List.unmodifiable(_errorLogs);
  static List<PerformanceMetric> getPerformanceMetrics() => List.unmodifiable(_performanceLogs);
}
