import 'package:Celes/ui/components/see_all_button.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NewsHomeCard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> news;
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            newsItem['image'] ?? '',
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
                      
                      // Description text
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            newsItem['description'] ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: context.color.textDefaultColor,
                              height: 1.3,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
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

// Extension method để tạo data mẫu
extension NewsHomeCardData on NewsHomeCard {
  static NewsHomeCard movieNews({VoidCallback? onSeeAllTap}) {
    final List<Map<String, dynamic>> movieNews = [
      {
        'title': 'Batman News',
        'description': 'When The Batman 2 Starts Filming Reportedly Revealed',
        'image': 'https://images.unsplash.com/photo-1635805737707-575885ab0820?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      },
      {
        'title': 'MCU Updates',
        'description': '6 Epic Hulk Fights That Could Happen In The MCU',
        'image': 'https://images.unsplash.com/photo-1608889175250-c3b0c1667d3a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      },
      {
        'title': 'Marvel News',
        'description': 'Latest Marvel Studios Updates and Announcements',
        'image': 'https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      },
    ];

    return NewsHomeCard(
      title: 'Movie news',
      news: movieNews,
      onSeeAllTap: onSeeAllTap,
    );
  }
}
