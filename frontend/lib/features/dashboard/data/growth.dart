enum GrowthRange {
  year('Year'),
  month('Month'),
  week('Week');

  const GrowthRange(this.label);

  final String label;
}

class GrowthPoint {
  const GrowthPoint({required this.label, required this.value});

  factory GrowthPoint.fromJson(Map<String, dynamic> json) =>
      GrowthPoint(label: json['label'] as String, value: json['value'] as int);

  final String label;
  final int value;
}
