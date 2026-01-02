import 'package:Celes/data/models/news_model.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final News news;
  final VoidCallback? onTap;

  const NewsCard({
    super.key,
    required this.news,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: context.color.forthColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  news.thumbnail?.url ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.article,
                        size: 48,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    news.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.color.textDefaultColor,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Summary
                  Text(
                    news.summary,
                    style: TextStyle(
                      fontSize: 14,
                      color: context.color.descriptionColor,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // Author and date
                  Row(
                    children: [
                      // Author
                      if (news.author != null) ...[
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: context.color.descriptionColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          news.author!.name,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.color.descriptionColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],

                      // Date
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: context.color.descriptionColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(news.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: context.color.descriptionColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
