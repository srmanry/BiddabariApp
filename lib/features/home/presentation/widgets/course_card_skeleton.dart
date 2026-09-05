import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_theme.dart';

class CourseCardSkeleton extends StatelessWidget {
  const CourseCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.cardBorder,
      highlightColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 14, width: 200, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(height: 11, width: 120, color: Colors.white),
                  const SizedBox(height: 14),
                  Container(height: 16, width: 90, color: Colors.white),
                  const SizedBox(height: 12),
                  Container(height: 1, color: Colors.white),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(height: 11, width: 60, color: Colors.white),
                      const SizedBox(width: 14),
                      Container(height: 11, width: 60, color: Colors.white),
                      const SizedBox(width: 14),
                      Container(height: 11, width: 60, color: Colors.white),
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
}
