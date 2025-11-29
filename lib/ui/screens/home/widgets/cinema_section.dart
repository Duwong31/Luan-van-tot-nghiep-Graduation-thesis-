import 'package:Celes/ui/components/see_all_button.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CinemaSection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> cinemas;
  final VoidCallback? onSeeAllTap;

  const CinemaSection({
    super.key,
    required this.title,
    required this.cinemas,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    if (cinemas.isEmpty) return const SizedBox.shrink();

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
        
        // Cinemas carousel
        SizedBox(
          height: 110, 
          child: CarouselSlider.builder(
            itemCount: cinemas.length,
            options: CarouselOptions(
              height: 110,
              viewportFraction: 0.25,
              enableInfiniteScroll: false,
              autoPlay: false,
              enlargeCenterPage: false,
              disableCenter: true,
              padEnds: false,
            ),
            itemBuilder: (context, index, realIndex) {
              final cinema = cinemas[index];
              
              return Container(
                margin: EdgeInsets.only(
                  left: index == 0 ? 16 : 4,
                  right: index == cinemas.length - 1 ? 16 : 4,
                ),
                child: GestureDetector(
                  onTap: () {

                  },
                  child: Column(
                    children: [
                      // Cinema image in circle
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            cinema['image'] ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.local_movies,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Cinema name
                      Text(
                        cinema['name'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: context.color.textDefaultColor,
                        ),
                        textAlign: TextAlign.center,
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
extension CinemaSectionData on CinemaSection {
  static CinemaSection cinemas({VoidCallback? onSeeAllTap}) {
    final List<Map<String, dynamic>> cinemaList = [
      {
        'name': 'Regal',
        'image': 'https://images.unsplash.com/photo-1489599417784-7aeac64de6e3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80',
      },
      {
        'name': 'IMAX',
        'image': 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80',
      },
      {
        'name': '4DX',
        'image': 'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80',
      },
      {
        'name': 'Sweetbox',
        'image': 'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80',
      },
      {
        'name': 'CGV',
        'image': 'https://images.unsplash.com/photo-1596727147705-61a532a659bd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80',
      },
      {
        'name': 'Lotte',
        'image': 'https://images.unsplash.com/photo-1606191026893-c978da95ad5b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80',
      },
      {
        'name': 'Galaxy',
        'image': 'https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80',
      },
      {
        'name': 'BHD Star',
        'image': 'https://images.unsplash.com/photo-1608889175250-c3b0c1667d3a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80',
      },
    ];

    return CinemaSection(
      title: 'Cinemas',
      cinemas: cinemaList,
      onSeeAllTap: onSeeAllTap,
    );
  }
}
