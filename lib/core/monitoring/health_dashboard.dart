import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'health_service.dart';

/// Exposes the latest health summary reactively.
final healthSummaryProvider = Provider<HealthSummary>((ref) {
  return HealthService.lastSummary;
});

/// Overall health status.
final healthStatusProvider = Provider<HealthStatus>((ref) {
  return HealthService.currentStatus;
});

/// List of failed (critical) dependencies.
final failedDependenciesProvider = Provider<List<HealthCheckResult>>((ref) {
  return HealthService.failedDependencies;
});

/// List of warning (non-critical) dependencies.
final warningDependenciesProvider = Provider<List<HealthCheckResult>>((ref) {
  return HealthService.warningDependencies;
});

/// App uptime in milliseconds.
final uptimeProvider = Provider<int>((ref) {
  return HealthService.uptimeMs;
});

/// Last health check execution duration in milliseconds.
final healthExecutionDurationProvider = Provider<int?>((ref) {
  return HealthService.executionDuration;
});
