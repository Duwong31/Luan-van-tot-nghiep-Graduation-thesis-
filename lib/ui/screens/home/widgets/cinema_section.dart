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
