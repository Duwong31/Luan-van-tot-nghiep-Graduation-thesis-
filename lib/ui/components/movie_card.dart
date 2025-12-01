import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:Celes/utils/ui_utils.dart';
import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double? rating;
  final String? ratingCount;
  final String? duration;
  final String? genres;
  final String? releaseDate;
  final double? width;
  final double aspectRatio; // 👈 thêm tỷ lệ poster (mặc định 2:3)
  final VoidCallback? onTap;

  const MovieCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.rating,
    this.ratingCount,
    this.duration,
    this.genres,
    this.releaseDate,
    this.width,
    this.aspectRatio = 2 / 3,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = context.color.textDefaultColor;
    final lightTextColor = context.color.textLightColor;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width, 
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: aspectRatio, // 2:3 
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.movie,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Movie info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.color.territoryColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Rating (if provided)
                  if (rating != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating!.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (ratingCount != null) ...[
                          Text(
                            ' ($ratingCount)',
                            style: TextStyle(
                              fontSize: 12,
                              color: lightTextColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],

                  // Duration
                  if (duration != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: textColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          duration!,
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Genres
                  if (genres != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        UiUtils.getSvg(
                          AppIcons.cinemaNav,
                          width: 14,
                          height: 14,
                          color: textColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            genres!,
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Release date
                  if (releaseDate != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        UiUtils.getSvg(
                          AppIcons.calendar,
                          width: 14,
                          height: 14,
                          color: textColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          releaseDate!,
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
