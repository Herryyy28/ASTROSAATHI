import { Injectable, Logger } from '@nestjs/common';

export interface PerformanceMetric {
  endpoint: string;
  durationMs: number;
  statusCode: number;
  timestamp: string;
}

export interface SecurityTelemetryEvent {
  eventType: 'AUTH_FAILURE' | 'PAYMENT_FAILURE' | 'AI_TIMEOUT' | 'UNAUTHORIZED_ACCESS' | 'CRASH_REPORT';
  userId?: string;
  details: Record<string, any>;
  timestamp: string;
}

@Injectable()
export class MonitoringService {
  private readonly logger = new Logger(MonitoringService.name);
  private metricsBuffer: PerformanceMetric[] = [];
  private telemetryEvents: SecurityTelemetryEvent[] = [];

  logApiMetric(endpoint: string, durationMs: number, statusCode: number) {
    const metric: PerformanceMetric = {
      endpoint,
      durationMs,
      statusCode,
      timestamp: new Date().toISOString(),
    };
    this.metricsBuffer.push(metric);
    if (this.metricsBuffer.length > 500) {
      this.metricsBuffer.shift();
    }
    if (durationMs > 1000) {
      this.logger.warn(`⚠️ SLOW API DETECTED: ${endpoint} took ${durationMs}ms`);
    }
  }

  logTelemetryEvent(eventType: SecurityTelemetryEvent['eventType'], details: Record<string, any>, userId?: string) {
    const event: SecurityTelemetryEvent = {
      eventType,
      userId,
      details,
      timestamp: new Date().toISOString(),
    };
    this.telemetryEvents.push(event);
    if (this.telemetryEvents.length > 500) {
      this.telemetryEvents.shift();
    }
    this.logger.warn(`🚨 PRODUCTION MONITORING EVENT [${eventType}]: ${JSON.stringify(details)}`);
  }

  getSystemMetrics() {
    const totalRequests = this.metricsBuffer.length;
    const avgLatencyMs = totalRequests > 0
      ? Math.round(this.metricsBuffer.reduce((acc, m) => acc + m.durationMs, 0) / totalRequests)
      : 0;

    const errorCount = this.metricsBuffer.filter((m) => m.statusCode >= 400).length;

    return {
      success: true,
      totalRequestsTracked: totalRequests,
      averageLatencyMs: avgLatencyMs,
      errorRatePercent: totalRequests > 0 ? Number(((errorCount / totalRequests) * 100).toFixed(2)) : 0,
      recentTelemetryEvents: this.telemetryEvents.slice(-20),
      appVersion: '2.5.0',
    };
  }
}
