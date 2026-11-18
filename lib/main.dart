import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'models/territory_models.dart';
import 'services/territory_service.dart';
import 'theme/app_theme.dart';
import 'screens/app_screens.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => AppState(TerritoryService())..initialize(),
      child: const TerritoryApp()));
}

class TerritoryApp extends StatelessWidget {
  const TerritoryApp({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return MaterialApp(
        title: 'Territory Insights SP',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.build(highContrast: state.highContrast),
        initialRoute: Uri.base.queryParameters['screen'] ?? '/consent',
        routes: {
          '/consent': (_) => const ConsentScreen(),
          '/': (_) => const HomeScreen(),
          '/climate': (_) => const ClimateScreen(),
          '/water': (_) => const WaterScreen(),
          '/services': (_) => const ServicesScreen(),
          '/alerts': (_) => const AlertsScreen(),
          '/occurrence': (_) => const OccurrenceScreen(),
          '/settings': (_) => const SettingsScreen(),
          '/alert-detail': (_) {
            final argument = ModalRoute.of(_)?.settings.arguments;
            final alerts = _.read<AppState>().alerts;
            final a = argument is PredictiveAlert
                ? argument
                : (alerts.isNotEmpty ? alerts.first : TerritoryService().alerts().first);
            return AlertDetail(alert: a);
          }
        });
  }
}
