class MetricPoint {
  final String label;
  final double value;
  const MetricPoint(this.label, this.value);
}

class DashboardMetric {
  final String title;
  final String value;
  final String delta;
  final String source;
  final String updatedAt;
  final bool positive;

  const DashboardMetric({
    required this.title,
    required this.value,
    required this.delta,
    this.source = '',
    this.updatedAt = '',
    this.positive = true,
  });
}

class PredictiveAlert {
  final String id, title, type, severity, indicator, evidence, method;
  final String reliability, limitations, recommendation;
  final List<String> whenUnreliable;

  const PredictiveAlert({
    required this.id,
    required this.title,
    required this.type,
    required this.severity,
    required this.indicator,
    required this.evidence,
    required this.method,
    required this.reliability,
    required this.limitations,
    required this.recommendation,
    required this.whenUnreliable,
  });
}

class Occurrence {
  final String category, description, neighborhood;
  final DateTime createdAt;
  const Occurrence({
    required this.category,
    required this.description,
    required this.neighborhood,
    required this.createdAt,
  });
}
