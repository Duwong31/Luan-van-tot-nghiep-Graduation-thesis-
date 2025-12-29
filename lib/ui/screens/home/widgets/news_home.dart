import 'package:Celes/data/models/news_model.dart';
import 'package:Celes/ui/components/see_all_button.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NewsHomeCard extends StatelessWidget {
  final String title;
  final List<News> news;
  final VoidCallback? onSeeAllTap;

  const NewsHomeCard({
    super.key,
    required this.title,
    required this.news,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    if (news.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: context.color.textDefaultColor,
                ),
              ),
              SeeAllButton(
                onTap: onSeeAllTap,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // News carousel
        SizedBox(
          height: 220,
          child: CarouselSlider.builder(
            itemCount: news.length,
            options: CarouselOptions(
              height: 220,
              viewportFraction: 0.75,
              enableInfiniteScroll: false,
              autoPlay: false,
              enlargeCenterPage: false,
              disableCenter: true,
              padEnds: false,
            ),
            itemBuilder: (context, index, realIndex) {
              final newsItem = news[index];

              return Container(
                margin: EdgeInsets.only(
                  left: index == 0 ? 16 : 8,
                  right: index == news.length - 1 ? 16 : 8,
                ),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to news detail
                    Navigator.pushNamed(context, '/newsDetail',
                        arguments: newsItem);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image container
                      Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            newsItem.thumbnail?.url ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.article,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Title text
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            newsItem.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: context.color.textDefaultColor,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      // Summary text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          newsItem.summary,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color:
                                context.color.textDefaultColor.withValues(alpha: 0.7),
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
