import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/territory_models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class Shell extends StatelessWidget {
  final String title;
  final Widget child;
  const Shell({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Configurações',
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: child,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/');
          if (index == 1) Navigator.pushReplacementNamed(context, '/alerts');
          if (index == 2)
            Navigator.pushReplacementNamed(context, '/occurrence');
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.grid_view_rounded), label: 'Visão geral'),
          NavigationDestination(
              icon: Icon(Icons.warning_amber_rounded), label: 'Alertas'),
          NavigationDestination(
              icon: Icon(Icons.add_location_alt_outlined), label: 'Registrar'),
        ],
      ),
    );
  }
}

class ConsentScreen extends StatelessWidget {
  const ConsentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    if (state.consented) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) Navigator.pushReplacementNamed(context, '/');
      });
    }
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppTheme.teal,
                  borderRadius: BorderRadius.circular(18),
                ),
                child:
                    const Icon(Icons.insights, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 28),
              Text('Territory Insights SP',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              const Text(
                  'Inteligência territorial para decisões humanas mais conscientes.'),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Antes de começar',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      const Text(
                          'Usaremos preferências locais e registros de ocorrência enviados por você. Não coletamos nome, documento ou localização precisa. Os alertas apoiam a análise e nunca substituem a decisão de um responsável.'),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Icon(Icons.privacy_tip_outlined,
                              color: AppTheme.teal),
                          SizedBox(width: 8),
                          Expanded(
                              child: Text(
                                  'Consentimento explícito e revogável nas configurações.')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => state.setConsent(true),
                icon: const Icon(Icons.check),
                label: const Text('Concordo e quero acompanhar o território'),
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52)),
              ),
              TextButton(
                onPressed: () => showAboutDialog(
                  context: context,
                  applicationName: 'Territory Insights SP',
                  applicationVersion: '1.0.0',
                ),
                child: const Text('Como os dados são tratados?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    if (state.loading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Shell(
      title: 'São Paulo · visão geral',
      child: ListView(
        children: [
          if (state.offline)
            Container(
              padding: const EdgeInsets.all(12),
              color: AppTheme.amber.withOpacity(.25),
              child: const Row(
                children: [
                  Icon(Icons.cloud_off),
                  SizedBox(width: 8),
                  Expanded(
                      child: Text(
                          'Modo offline: mostrando o último conjunto armazenado.')),
                ],
              ),
            ),
          const SizedBox(height: 12),
          Text('Bom dia, Guilherme',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 6),
          const Text(
              'Panorama territorial para orientar prioridades, não decisões automáticas.'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: MetricCard(
                      title: 'Alertas ativos',
                      value: '${state.alerts.length}',
                      delta: 'requerem revisão humana')),
              const SizedBox(width: 12),
              const Expanded(
                  child: MetricCard(
                      title: 'Benefício social',
                      value: '68%',
                      delta: 'cobertura monitorada')),
            ],
          ),
          const SizedBox(height: 20),
          const _QuickLink(
              icon: Icons.thermostat,
              title: 'Dashboard climático',
              subtitle: 'Temperatura e tendência',
              route: '/climate'),
          const _QuickLink(
              icon: Icons.water_drop_outlined,
              title: 'Dashboard hídrico',
              subtitle: 'Consumo de referência',
              route: '/water'),
          const _QuickLink(
              icon: Icons.support_agent,
              title: 'Serviços urbanos',
              subtitle: 'Demandas e ocorrências',
              route: '/services'),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.shield_outlined, color: AppTheme.teal),
              title: const Text('Transparência do modelo'),
              subtitle: const Text(
                  'Toda previsão mostra evidências, limitações e quando não é confiável.'),
              onTap: () => Navigator.pushNamed(context, '/alerts'),
            ),
          ),
          const SourceLine(
              'Última atualização: agora · clima: Open-Meteo · demais séries: sintéticas demonstrativas'),
        ],
      ),
    );
  }
}

class _QuickLink extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  const _QuickLink(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.route});

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor: AppTheme.mint,
              child: Icon(icon, color: AppTheme.teal)),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.pushNamed(context, route),
        ),
      );
}

class DashboardScreen extends StatelessWidget {
  final String title;
  final List<MetricPoint> points;
  final String unit;
  final String source;
  final List<DashboardMetric> metrics;
  const DashboardScreen(
      {super.key,
      required this.title,
      required this.points,
      required this.unit,
      required this.source,
      required this.metrics});

  @override
  Widget build(BuildContext context) {
    final safePoints = points.isEmpty ? const [MetricPoint('—', 0)] : points;
    return Shell(
      title: title,
      child: ListView(
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: metrics
                .map((metric) => SizedBox(
                      width: MediaQuery.sizeOf(context).width > 600
                          ? 180
                          : (MediaQuery.sizeOf(context).width - 50) / 2,
                      child: MetricCard(
                          title: metric.title,
                          value: metric.value,
                          delta: metric.delta,
                          positive: metric.positive),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 18, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Histórico e tendência',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 220,
                    child: LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: (safePoints.length - 1).toDouble(),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true, reservedSize: 38)),
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) => Text(
                              value.toInt() < safePoints.length
                                  ? safePoints[value.toInt()].label
                                  : '',
                              style: const TextStyle(fontSize: 10),
                            ),
                          )),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            color: AppTheme.teal,
                            barWidth: 4,
                            dotData: const FlDotData(show: false),
                            spots: List.generate(
                                safePoints.length,
                                (index) => FlSpot(
                                    index.toDouble(), safePoints[index].value)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Unidade: $unit'),
                  SourceLine(source),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Card(
              child: ListTile(
                  leading: Icon(Icons.filter_alt_outlined),
                  title: Text('Período: 7 dias'),
                  subtitle: Text('Filtro pronto para expansão por bairro.'))),
        ],
      ),
    );
  }
}

class ClimateScreen extends StatelessWidget {
  const ClimateScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return DashboardScreen(
        title: 'Dashboard climático',
        points: state.climate,
        unit: '°C',
        source:
            'API Open-Meteo · coordenadas aproximadas do centro de São Paulo · atualização assíncrona',
        metrics: const [
          DashboardMetric(
              title: 'Máxima',
              value: '28 °C',
              delta: '+12% na janela',
              positive: false),
          DashboardMetric(title: 'Umidade', value: '71%', delta: 'estável'),
          DashboardMetric(
              title: 'Tendência', value: 'alta', delta: 'média móvel'),
        ]);
  }
}

class WaterScreen extends StatelessWidget {
  const WaterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return DashboardScreen(
        title: 'Dashboard hídrico',
        points: state.water,
        unit: 'L/unidade/dia',
        source:
            'Série sintética identificada · referência acadêmica, não medição individual',
        metrics: const [
          DashboardMetric(
              title: 'Hoje',
              value: '158 L',
              delta: '+10% vs. mediana',
              positive: false),
          DashboardMetric(title: 'Mediana', value: '143 L', delta: '7 dias'),
          DashboardMetric(
              title: 'Economia potencial', value: '12%', delta: 'meta social'),
        ]);
  }
}

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return DashboardScreen(
        title: 'Serviços urbanos',
        points: state.services,
        unit: 'ocorrências/dia',
        source:
            'Série sintética demonstrativa · formulário cidadão alimenta a fila local',
        metrics: const [
          DashboardMetric(
              title: 'Demandas',
              value: '68',
              delta: '+8% na semana',
              positive: false),
          DashboardMetric(
              title: 'Resolvidas', value: '42', delta: '62% do total'),
          DashboardMetric(
              title: 'Tempo médio', value: '2,4 d', delta: '-0,3 d'),
        ]);
  }
}

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Shell(
      title: 'Alertas preditivos',
      child: state.alerts.isEmpty
          ? const EmptyState('Nenhum alerta ativo para o período selecionado.')
          : ListView(
              children: [
                const Card(
                    child: Padding(
                        padding: EdgeInsets.all(14),
                        child: Text(
                            'Alertas apoiam a análise; a decisão final é sempre humana.',
                            style: TextStyle(fontWeight: FontWeight.bold)))),
                const SizedBox(height: 12),
                ...state.alerts.map((alert) => Card(
                      child: ListTile(
                        leading: CircleAvatar(
                            backgroundColor: AppTheme.amber.withOpacity(.3),
                            child: const Icon(Icons.warning_amber_rounded,
                                color: Colors.orange)),
                        title: Text(alert.title),
                        subtitle: Text(
                            '${alert.type} · ${alert.severity}\nConfiabilidade: ${alert.reliability}'),
                        isThreeLine: true,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.pushNamed(
                            context, '/alert-detail',
                            arguments: alert),
                      ),
                    )),
              ],
            ),
    );
  }
}

class AlertDetail extends StatelessWidget {
  final PredictiveAlert alert;
  const AlertDetail({super.key, required this.alert});
  @override
  Widget build(BuildContext context) => Shell(
        title: 'Detalhe do alerta',
        child: ListView(children: [
          Text(alert.title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Chip(label: Text('${alert.type} · ${alert.severity}')),
          const SizedBox(height: 16),
          _Info(title: 'Indicador relacionado', text: alert.indicator),
          _Info(title: 'Evidência numérica', text: alert.evidence),
          _Info(title: 'Método', text: alert.method),
          _Info(title: 'Confiabilidade', text: alert.reliability),
          _Info(title: 'Limitações e vieses', text: alert.limitations),
          _Info(
              title: 'Quando não confiar',
              text: alert.whenUnreliable.join(' · ')),
          _Info(title: 'Recomendação', text: alert.recommendation),
          FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.person_search),
              label: const Text('Marcar para revisão humana')),
        ]),
      );
}

class _Info extends StatelessWidget {
  final String title;
  final String text;
  const _Info({required this.title, required this.text});
  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
            padding: const EdgeInsets.all(14),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(text)
            ])),
      );
}

class OccurrenceScreen extends StatefulWidget {
  const OccurrenceScreen({super.key});
  @override
  State<OccurrenceScreen> createState() => _OccurrenceScreenState();
}

class _OccurrenceScreenState extends State<OccurrenceScreen> {
  final form = GlobalKey<FormState>();
  final description = TextEditingController();
  final neighborhood = TextEditingController();
  String category = 'Iluminação';
  bool consent = false;

  @override
  void dispose() {
    description.dispose();
    neighborhood.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Shell(
        title: 'Registrar ocorrência',
        child: Form(
          key: form,
          child: ListView(children: [
            Text('Ajude a qualificar o território',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            const Text(
                'O registro é anonimizado e salvo localmente para uso offline.'),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: category,
              decoration:
                  const InputDecoration(labelText: 'Categoria obrigatória'),
              items: ['Iluminação', 'Resíduos', 'Água', 'Calçada']
                  .map((value) =>
                      DropdownMenuItem(value: value, child: Text(value)))
                  .toList(),
              onChanged: (value) => setState(() => category = value!),
            ),
            const SizedBox(height: 14),
            TextFormField(
                controller: neighborhood,
                decoration:
                    const InputDecoration(labelText: 'Bairro ou referência'),
                validator: (value) => value == null || value.trim().length < 2
                    ? 'Informe uma referência válida.'
                    : null),
            const SizedBox(height: 14),
            TextFormField(
                controller: description,
                maxLines: 4,
                decoration:
                    const InputDecoration(labelText: 'Descrição da ocorrência'),
                validator: (value) => value == null || value.trim().length < 10
                    ? 'Descreva com pelo menos 10 caracteres.'
                    : null),
            const SizedBox(height: 12),
            CheckboxListTile(
                value: consent,
                onChanged: (value) => setState(() => consent = value ?? false),
                title: const Text('Autorizo o uso anonimizado deste registro.'),
                contentPadding: EdgeInsets.zero),
            const SizedBox(height: 12),
            FilledButton(
                onPressed: () => _submit(context),
                child: const Text('Enviar ocorrência')),
          ]),
        ),
      );

  void _submit(BuildContext context) {
    if (!consent) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Confirme o consentimento para continuar.')));
      return;
    }
    if (form.currentState!.validate()) {
      context.read<AppState>().addOccurrence(Occurrence(
          category: category,
          description: description.text,
          neighborhood: neighborhood.text,
          createdAt: DateTime.now()));
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ocorrência registrada com sucesso.')));
      description.clear();
      neighborhood.clear();
    }
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Shell(
        title: 'Configurações',
        child: ListView(children: [
          SwitchListTile(
              title: const Text('Tema de alto contraste'),
              subtitle: const Text('Aumenta a diferenciação visual.'),
              value: state.highContrast,
              onChanged: (_) => state.toggleContrast()),
          ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Privacidade'),
              subtitle: const Text(
                  'Sem nome, documento ou localização precisa; consentimento revogável.'),
              onTap: () => showAboutDialog(
                  context: context, applicationName: 'Privacidade')),
          ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Atualizar dados'),
              onTap: state.initialize),
          const SourceLine(
              'Estado global compartilhado por Provider entre dashboards, alertas e formulário.'),
        ]));
  }
}
