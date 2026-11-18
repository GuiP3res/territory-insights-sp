import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/territory_models.dart';

class TerritoryService {
  static const _lat = -23.5505, _lon = -46.6333;
  Future<List<MetricPoint>> fetchClimate() async {
    final uri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$_lat&longitude=$_lon&hourly=temperature_2m,relative_humidity_2m&past_days=7&forecast_days=1&timezone=America%2FSao_Paulo');
    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200)
        throw Exception('API ${response.statusCode}');
      final data = jsonDecode(response.body);
      final values = (data['hourly']['temperature_2m'] as List).cast<num>();
      final times = (data['hourly']['time'] as List).cast<String>();
      final step = values.length > 12 ? values.length - 12 : 0;
      return List.generate(
          values.length - step,
          (i) => MetricPoint(
              times[i + step].substring(11, 16), values[i + step].toDouble()));
    } catch (_) {
      return const [
        MetricPoint('06h', 18),
        MetricPoint('09h', 21),
        MetricPoint('12h', 26),
        MetricPoint('15h', 28),
        MetricPoint('18h', 24),
        MetricPoint('21h', 20)
      ];
    }
  }

  List<MetricPoint> water() => const [
        MetricPoint('Seg', 142),
        MetricPoint('Ter', 148),
        MetricPoint('Qua', 151),
        MetricPoint('Qui', 149),
        MetricPoint('Sex', 157),
        MetricPoint('Sáb', 161),
        MetricPoint('Dom', 158)
      ];
  List<MetricPoint> services() => const [
        MetricPoint('01', 42),
        MetricPoint('05', 51),
        MetricPoint('10', 47),
        MetricPoint('15', 63),
        MetricPoint('20', 58),
        MetricPoint('25', 71),
        MetricPoint('30', 68)
      ];
  List<PredictiveAlert> alerts() => const [
        PredictiveAlert(
            id: 'heat',
            title: 'Possível estresse térmico',
            type: 'Clima',
            severity: 'Atenção',
            indicator: 'Temperatura máxima',
            evidence:
                '28 °C no pico e tendência de alta de 12% na janela observada.',
            method: 'Regra de limiar + média móvel simples de 6 pontos.',
            reliability: 'Não quantificada',
            limitations:
                'Regra não estima probabilidade; não incorpora vento, sombra ou vulnerabilidade individual.',
            recommendation:
                'Validar com a Defesa Civil e avaliar comunicação preventiva, sem automatizar decisões.',
            whenUnreliable: [
              'Poucos pontos históricos',
              'Falha na API meteorológica',
              'Microclimas não representados'
            ]),
        PredictiveAlert(
            id: 'water',
            title: 'Consumo hídrico acima da referência',
            type: 'Recursos hídricos',
            severity: 'Monitorar',
            indicator: 'Consumo diário estimado',
            evidence:
                '161 L/unidade no sábado, 13% acima da mediana semanal de 143 L.',
            method: 'Desvio relativo à mediana móvel semanal.',
            reliability: 'Não quantificada',
            limitations: 'Série sintética para demonstração; não representa medição individual.',
            recommendation: 'Investigar a causa com equipe responsável antes de qualquer ação.',
            whenUnreliable: [
              'Série curta',
              'Mudança sazonal',
              'Dados sintéticos'
            ]),
      ];
}
