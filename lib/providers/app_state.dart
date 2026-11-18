import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/territory_models.dart';
import '../services/territory_service.dart';

class AppState extends ChangeNotifier {
  final TerritoryService service;
  AppState(this.service);
  bool loading = true, offline = false, consented = false, highContrast = false;
  String? error;
  String selectedPeriod = '7 dias';
  List<MetricPoint> climate = [], water = [], services = [];
  List<PredictiveAlert> alerts = [];
  List<Occurrence> occurrences = [];
  Future<void> initialize() async {
    final p = await SharedPreferences.getInstance();
    consented = p.getBool('consented') ?? false;
    highContrast = p.getBool('highContrast') ?? false;
    final saved = p.getStringList('occurrences') ?? [];
    occurrences = saved.map((x) {
      final j = jsonDecode(x);
      return Occurrence(
          category: j['category'],
          description: j['description'],
          neighborhood: j['neighborhood'],
          createdAt: DateTime.parse(j['createdAt']));
    }).toList();
    loading = true;
    notifyListeners();
    try {
      climate = await service.fetchClimate();
      offline = climate.isNotEmpty && climate.first.label == '06h';
      water = service.water();
      services = service.services();
      alerts = service.alerts();
      error = null;
    } catch (e) {
      error = 'Não foi possível atualizar os dados.';
    }
    loading = false;
    notifyListeners();
  }

  Future<void> setConsent(bool value) async {
    consented = value;
    final p = await SharedPreferences.getInstance();
    await p.setBool('consented', value);
    notifyListeners();
  }

  Future<void> toggleContrast() async {
    highContrast = !highContrast;
    final p = await SharedPreferences.getInstance();
    await p.setBool('highContrast', highContrast);
    notifyListeners();
  }

  Future<void> addOccurrence(Occurrence o) async {
    occurrences = [...occurrences, o];
    final p = await SharedPreferences.getInstance();
    await p.setStringList(
        'occurrences',
        occurrences
            .map((x) => jsonEncode({
                  'category': x.category,
                  'description': x.description,
                  'neighborhood': x.neighborhood,
                  'createdAt': x.createdAt.toIso8601String()
                }))
            .toList());
    notifyListeners();
  }
}
