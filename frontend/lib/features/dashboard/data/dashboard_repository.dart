import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_provider.dart';
import 'growth.dart';
import 'overview.dart';
import 'shipment.dart';

final dashboardRepositoryProvider = Provider((ref) => DashboardRepository(ref.read(dioProvider)));

class DashboardRepository {
  DashboardRepository(this._dio);

  final Dio _dio;

  Future<Overview> getOverview(OverviewPeriod period) => _request(
    () => _dio.get('/dashboard/overview', queryParameters: {'period': period.apiValue}),
    Overview.fromJson,
  );

  Future<List<GrowthPoint>> getGrowth(GrowthRange range) => _request(
    () => _dio.get('/dashboard/growth', queryParameters: {'range': range.name}),
    (json) => (json['points'] as List)
        .map((point) => GrowthPoint.fromJson(point as Map<String, dynamic>))
        .toList(),
  );

  Future<ShipmentPage> getShipments({required int page, required int limit}) => _request(
    () => _dio.get('/shipments', queryParameters: {'page': page, 'limit': limit}),
    ShipmentPage.fromJson,
  );

  Future<Shipment> getShipment(String trackingId) => _request(
    () => _dio.get('/shipments/${Uri.encodeComponent(trackingId)}'),
    (json) => Shipment.fromJson(json['shipment'] as Map<String, dynamic>),
  );

  /// Returns the new wallet balance in kobo.
  Future<int> fundWallet(int amountKobo) => _request(
    () => _dio.post('/wallet/fund', data: {'amount': amountKobo}),
    (json) => json['walletBalance'] as int,
  );

  Future<({Shipment shipment, int walletBalance})> payForShipment(String trackingId) => _request(
    () => _dio.post('/shipments/${Uri.encodeComponent(trackingId)}/pay'),
    (json) => (
      shipment: Shipment.fromJson(json['shipment'] as Map<String, dynamic>),
      walletBalance: json['walletBalance'] as int,
    ),
  );

  Future<T> _request<T>(
    Future<Response<dynamic>> Function() send,
    T Function(Map<String, dynamic> json) parse,
  ) async {
    try {
      final response = await send();
      return parse(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
