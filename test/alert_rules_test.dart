import 'package:flutter_test/flutter_test.dart';
import 'package:territory_insights_sp/services/territory_service.dart';

void main() {
  test('serviço fornece alertas transparentes e sem confiança inventada', () {
    final alerts = TerritoryService().alerts();
    expect(alerts.length, 2);
    expect(alerts.every((a) => a.reliability == 'Não quantificada'), true);
    expect(alerts.every((a) => a.limitations.isNotEmpty), true);
  });
}
