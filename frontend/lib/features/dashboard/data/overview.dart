enum OverviewPeriod {
  thisMonth('this_month', 'This Month', 'Vs last month'),
  lastMonth('last_month', 'Last Month', 'Vs previous month'),
  thisYear('this_year', 'This Year', 'Vs last year');

  const OverviewPeriod(this.apiValue, this.label, this.comparisonLabel);

  final String apiValue;
  final String label;
  final String comparisonLabel;
}

class StatComparison {
  const StatComparison({required this.count, required this.previousCount, this.changePercent});

  factory StatComparison.fromJson(Map<String, dynamic> json) => StatComparison(
    count: json['count'] as int,
    previousCount: json['previousCount'] as int,
    changePercent: json['changePercent'] as int?,
  );

  final int count;
  final int previousCount;

  final int? changePercent;
}

class Overview {
  const Overview({
    required this.walletBalance,
    required this.totalShipments,
    required this.exports,
    required this.imports,
  });

  factory Overview.fromJson(Map<String, dynamic> json) => Overview(
    walletBalance: json['walletBalance'] as int,
    totalShipments: StatComparison.fromJson(json['totalShipments'] as Map<String, dynamic>),
    exports: StatComparison.fromJson(json['exports'] as Map<String, dynamic>),
    imports: StatComparison.fromJson(json['imports'] as Map<String, dynamic>),
  );

  final int walletBalance;
  final StatComparison totalShipments;
  final StatComparison exports;
  final StatComparison imports;
}
