import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../dashboard_providers.dart';
import '../domain/dashboard_data.dart';

class DashboardViewModel extends Notifier<AsyncValue<DashboardData>> {
  @override
  AsyncValue<DashboardData> build() {
    ref.listen<AsyncValue<DashboardData>>(dashboardDataProvider, (_, next) {
      if (next.hasValue || next.hasError) {
        state = next;
      }
    });
    return const AsyncValue.loading();
  }

  void refresh() {
    ref.invalidate(dashboardDataProvider);
  }

  void navigateToAddTransaction(BuildContext context) {
    context.push(RouteNames.addTransaction);
  }

  void navigateToCaptureSms(BuildContext context) {
    context.push(RouteNames.smsDiagnostics);
  }

  void navigateToReports(BuildContext context) {
    context.go(RouteNames.reports);
  }

  void navigateToTransactionDetail(BuildContext context, String id) {
    context.push(RouteNames.transactionDetail(id));
  }

  void navigateToHistory(BuildContext context) {
    context.push(RouteNames.history);
  }
}
