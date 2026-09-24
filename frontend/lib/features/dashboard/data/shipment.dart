enum ShipmentStatus {
  inTransit('IN_TRANSIT', 'In-Transit'),
  delayed('DELAYED', 'Delayed'),
  delivered('DELIVERED', 'Delivered'),
  pending('PENDING', 'Pending');

  const ShipmentStatus(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static ShipmentStatus fromApi(String value) =>
      values.firstWhere((status) => status.apiValue == value, orElse: () => pending);
}

class Shipment {
  const Shipment({
    required this.trackingId,
    required this.senderName,
    required this.receiverName,
    required this.pickupCity,
    required this.pickupCountry,
    required this.deliveryCity,
    required this.deliveryCountry,
    required this.amount,
    required this.status,
    required this.isExport,
    required this.isPaid,
    required this.processingHours,
    required this.createdAt,
  });

  factory Shipment.fromJson(Map<String, dynamic> json) => Shipment(
    trackingId: json['trackingId'] as String,
    senderName: json['senderName'] as String,
    receiverName: json['receiverName'] as String,
    pickupCity: json['pickupCity'] as String,
    pickupCountry: json['pickupCountry'] as String,
    deliveryCity: json['deliveryCity'] as String,
    deliveryCountry: json['deliveryCountry'] as String,
    amount: json['amount'] as int,
    status: ShipmentStatus.fromApi(json['status'] as String),
    isExport: json['direction'] == 'EXPORT',
    isPaid: json['isPaid'] as bool,
    processingHours: json['processingHours'] as int,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  final String trackingId;
  final String senderName;
  final String receiverName;
  final String pickupCity;
  final String pickupCountry;
  final String deliveryCity;
  final String deliveryCountry;

  /// In kobo.
  final int amount;
  final ShipmentStatus status;
  final bool isExport;
  final bool isPaid;
  final int processingHours;
  final DateTime createdAt;
}

class ShipmentPage {
  const ShipmentPage({required this.items, required this.page, required this.totalPages});

  factory ShipmentPage.fromJson(Map<String, dynamic> json) => ShipmentPage(
    items: (json['data'] as List)
        .map((item) => Shipment.fromJson(item as Map<String, dynamic>))
        .toList(),
    page: json['page'] as int,
    totalPages: json['totalPages'] as int,
  );

  final List<Shipment> items;
  final int page;
  final int totalPages;
}
