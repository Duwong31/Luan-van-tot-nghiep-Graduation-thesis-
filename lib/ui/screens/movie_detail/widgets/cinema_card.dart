import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CinemaCard extends StatelessWidget {
  final String name;
  final String distance;
  final String address;
  final String logoAsset;
  final bool isSelected;
  final VoidCallback onTap;

  const CinemaCard({
    super.key,
    required this.name,
    required this.distance,
    required this.address,
    required this.logoAsset,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor   = isSelected ? const Color(0xFF1A0502) : const Color(0xFF181818);
    final borderCol = isSelected ? context.color.territoryColor : Colors.transparent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderCol, width: 1.2),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: context.color.textDefaultColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$distance  |  $address',
                      style: TextStyle(
                        color: context.color.textDefaultColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Logo
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: SvgPicture.asset(
                  logoAsset,
                  height: 16,
                  width: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
