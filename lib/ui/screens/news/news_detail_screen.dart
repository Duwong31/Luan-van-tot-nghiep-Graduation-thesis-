import 'package:Celes/data/models/news_model.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class NewsDetailScreen extends StatelessWidget {
  final News news;

  const NewsDetailScreen({
    super.key,
    required this.news,
  });

  static Route route(RouteSettings routeSettings) {
    final news = routeSettings.arguments as News;
    return MaterialPageRoute(
      builder: (_) => NewsDetailScreen(news: news),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.primaryColor,
      body: CustomScrollView(
        slivers: [
          // App Bar with image background
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: context.color.primaryColor,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.color.backgroundColor.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: SvgPicture.asset(
                    AppIcons.arrow_left,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      context.color.textDefaultColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Image
                  Image.network(
                    news.thumbnail?.url ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.article,
                          size: 64,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          context.color.primaryColor.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    news.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: context.color.textDefaultColor,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Author and date
                  Row(
                    children: [
                      // Author
                      if (news.author != null) ...[
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: context.color.territoryColor,
                          child: Text(
                            news.author!.name[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              news.author!.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: context.color.textDefaultColor,
                              ),
                            ),
                            Text(
                              _formatDate(news.createdAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: context.color.descriptionColor,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: context.color.descriptionColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(news.createdAt),
                          style: TextStyle(
                            fontSize: 14,
                            color: context.color.descriptionColor,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.color.forthColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      news.summary,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: context.color.textDefaultColor,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Content (HTML)
                  HtmlWidget(
                    news.content,
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: context.color.textDefaultColor,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          return '${difference.inMinutes} minutes ago';
        }
        return '${difference.inHours} hours ago';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }
}
