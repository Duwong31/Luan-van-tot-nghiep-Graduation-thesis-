import 'package:Celes/data/models/api_response.dart';
import 'package:Celes/data/models/voucher_model.dart';
import 'package:Celes/utils/api.dart';

class VoucherRepository {
  /// Get list of available vouchers
  Future<ApiResponse<List<Voucher>>> getVouchers() async {
    try {
      final response = await Api.get(url: Api.vouchersList);

      return ApiResponse.fromJson(
        response,
        (data) {
          if (data is List) {
            return data
                .map((item) => Voucher.fromJson(item as Map<String, dynamic>))
                .toList();
          }
          return <Voucher>[];
        },
      );
    } catch (e) {
      throw Exception('Failed to fetch vouchers: $e');
    }
  }

  /// Get active vouchers only
  Future<ApiResponse<List<Voucher>>> getActiveVouchers() async {
    try {
      final response = await getVouchers();

      if (response.success && response.data != null) {
        final activeVouchers = response.data!
            .where((voucher) => voucher.isValid && !voucher.hasReachedLimit)
            .toList();

        return ApiResponse(
          success: true,
          code: response.code,
          message: response.message,
          data: activeVouchers,
        );
      }

      return response;
    } catch (e) {
      throw Exception('Failed to fetch active vouchers: $e');
    }
  }

  /// Validate voucher code
  Future<ApiResponse<Voucher>> validateVoucher(String code) async {
    try {
      // This would be a separate API call if available
      // For now, we get all vouchers and filter
      final response = await getVouchers();

      if (response.success && response.data != null) {
        final voucher = response.data!.firstWhere(
          (v) => v.code.toUpperCase() == code.toUpperCase(),
          orElse: () => throw Exception('Voucher not found'),
        );

        if (!voucher.isValid) {
          throw Exception('Voucher is not valid or has expired');
        }

        if (voucher.hasReachedLimit) {
          throw Exception('Voucher has reached usage limit');
        }

        return ApiResponse(
          success: true,
          code: 'VOUCHER_VALID',
          message: 'Voucher is valid',
          data: voucher,
        );
      }

      throw Exception('Failed to validate voucher');
    } catch (e) {
      throw Exception('Failed to validate voucher: $e');
    }
  }
}
