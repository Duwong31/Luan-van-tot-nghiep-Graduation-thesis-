import 'package:Celes/data/cubits/voucher/voucher_cubit.dart';
import 'package:Celes/data/models/voucher_model.dart';
import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VoucherBottomSheet extends StatefulWidget {
  final Function(Voucher) onVoucherSelected;
  final String? currentVoucherCode;

  const VoucherBottomSheet({
    Key? key,
    required this.onVoucherSelected,
    this.currentVoucherCode,
  }) : super(key: key);

  @override
  State<VoucherBottomSheet> createState() => _VoucherBottomSheetState();
}

class _VoucherBottomSheetState extends State<VoucherBottomSheet> {
  @override
  void initState() {
    super.initState();
    // Fetch active vouchers when bottom sheet opens
    context.read<VoucherCubit>().fetchActiveVouchers();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.color.secondaryColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Voucher', // TODO: Add to localization
                  style: TextStyle(
                    color: context.color.textDefaultColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: context.color.textDefaultColor,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Voucher List
          Flexible(
            child: BlocBuilder<VoucherCubit, VoucherState>(
              builder: (context, state) {
                if (state is VoucherLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (state is VoucherError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: context.color.textDefaultColor
                                .withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.errorMessage,
                            style: TextStyle(
                              color: context.color.textDefaultColor
                                  .withValues(alpha: 0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<VoucherCubit>()
                                  .fetchActiveVouchers();
                            },
                            child: Text(Tr.of(context)!.retry),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is VoucherLoaded) {
                  final vouchers = state.activeVouchers;

                  if (vouchers.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.discount_outlined,
                              size: 64,
                              color: context.color.textDefaultColor
                                  .withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No vouchers available', // TODO: Add to localization
                              style: TextStyle(
                                color: context.color.textDefaultColor
                                    .withValues(alpha: 0.7),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: vouchers.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final voucher = vouchers[index];
                      final isSelected =
                          widget.currentVoucherCode == voucher.code;

                      return _VoucherCard(
                        voucher: voucher,
                        isSelected: isSelected,
                        onTap: () {
                          widget.onVoucherSelected(voucher);
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _VoucherCard extends StatelessWidget {
  final Voucher voucher;
  final bool isSelected;
  final VoidCallback onTap;

  const _VoucherCard({
    required this.voucher,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? context.color.territoryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Discount badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: context.color.territoryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                voucher.discountDisplay,
                style: TextStyle(
                  color: context.color.territoryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Voucher info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    voucher.name,
                    style: TextStyle(
                      color: context.color.textDefaultColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Code: ${voucher.code}',
                    style: TextStyle(
                      color:
                          context.color.textDefaultColor.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: context.color.textDefaultColor
                            .withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        voucher.validPeriod,
                        style: TextStyle(
                          color: context.color.textDefaultColor
                              .withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Selection indicator
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: context.color.territoryColor,
                size: 24,
              )
            else
              Icon(
                Icons.circle_outlined,
                color: context.color.textDefaultColor.withValues(alpha: 0.3),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
