import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../routes/app_routes.dart';
import '../../data/models/course_model.dart';
import 'discount_countdown.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final hasDiscount = course.hasActiveDiscount;
    final currency = NumberFormat.decimalPattern('en_US');

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Get.toNamed('${AppRoutes.courseDetails}/${course.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Hero(
                  tag: 'course-banner-${course.id}',
                  child: CachedNetworkImage(
                    imageUrl: course.bannerUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.surface,
                      child: const Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surface,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 32,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    course.subTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (hasDiscount) ...[
                        Text(
                          '৳${currency.format(course.price)}',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '৳${currency.format(course.discountedPrice)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: AppColors.accent,
                          ),
                        ),
                      ] else
                        Text(
                          '৳${currency.format(course.price)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      const Spacer(),
                      if (hasDiscount && course.discountEndDate != null)
                        DiscountCountdown(endDate: course.discountEndDate!),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(height: 1, color: AppColors.cardBorder),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _InfoChip(
                          icon: Icons.menu_book_rounded,
                          label: '${course.totalClass} Classes'),
                      const SizedBox(width: 14),
                      _InfoChip(
                          icon: Icons.podcasts_rounded,
                          label: '${course.totalLive} Live'),
                      const SizedBox(width: 14),
                      _InfoChip(
                          icon: Icons.assignment_rounded,
                          label: '${course.totalExam} Exams'),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cta,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Get.toNamed(
                          '${AppRoutes.courseDetails}/${course.id}'),
                      child: const Text(
                        'কোর্সটি কিনুন',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
