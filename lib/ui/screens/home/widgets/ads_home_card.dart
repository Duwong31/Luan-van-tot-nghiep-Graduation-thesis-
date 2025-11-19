import 'package:Celes/ui/components/see_all_button.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AdsHomeCard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> ads;
  final VoidCallback? onSeeAllTap;

  const AdsHomeCard({
    super.key,
    required this.title,
    required this.ads,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    if (ads.isEmpty) return const SizedBox.shrink();

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
        
        // Ads carousel
        SizedBox(
          height: 180,
          child: CarouselSlider.builder(
            itemCount: ads.length,
            options: CarouselOptions(
              height: 180,
              viewportFraction: 0.9, // Show almost full card
              enableInfiniteScroll: false,
              autoPlay: false,
              enlargeCenterPage: false,
              disableCenter: true,
              padEnds: false,
            ),
            itemBuilder: (context, index, realIndex) {
              final ad = ads[index];
              
              return Container(
                margin: EdgeInsets.only(
                  left: index == 0 ? 16 : 8,
                  right: index == ads.length - 1 ? 16 : 8,
                ),
                child: GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        ad['image'] ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.campaign,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
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
extension AdsHomeCardData on AdsHomeCard {
  static AdsHomeCard promoDiscount({VoidCallback? onSeeAllTap}) {
    final List<Map<String, dynamic>> promoAds = [
      {
        'title': 'CGV Movie Vouchers',
        'description': '30% OFF Movie vouchers',
        'image': 'https://tse4.mm.bing.net/th/id/OIP.jpLiFt3G7SsUwjrZyWRV3QHaD0?pid=Api&P=0&h=220https://tse4.mm.bing.net/th/id/OIP.jpLiFt3G7SsUwjrZyWRV3QHaD0?pid=Api&P=0&h=220',
      },
      {
        'title': 'Lotte Cinema Deal',
        'description': '25% OFF Weekend special',
        'image': 'https://tse3.mm.bing.net/th/id/OIP.5vv8Fa8gT-C8GK-sYTm2YwHaEO?pid=Api&P=0&h=220https://tse3.mm.bing.net/th/id/OIP.5vv8Fa8gT-C8GK-sYTm2YwHaEO?pid=Api&P=0&h=220',
      },
      {
        'title': 'Galaxy Cinema Promo',
        'description': '40% OFF Student discount',
        'image': 'https://tse1.mm.bing.net/th/id/OIP.ltLBG9cE4L5zd-Zs9VoqjAHaDt?pid=Api&P=0&h=220',
      },
    ];

    return AdsHomeCard(
      title: 'Promo & Discount',
      ads: promoAds,
      onSeeAllTap: onSeeAllTap,
    );
  }
}