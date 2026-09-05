import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../logic/home_controller.dart';
import '../widgets/course_card.dart';
import '../widgets/course_card_skeleton.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biddabari'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'কোর্সসমূহ',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(() => AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: controller.isOffline.value
                    ? const _OfflineBanner()
                    : const SizedBox(width: double.infinity),
              )),
          Expanded(
            child: controller.obx(
              (courses) => RefreshIndicator(
                color: AppColors.primary,
                onRefresh: controller.reload,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                  itemCount: courses?.length ?? 0,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) =>
                      CourseCard(course: courses![index]),
                ),
              ),
              onLoading: ListView.separated(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                itemCount: 4,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (context, index) => const CourseCardSkeleton(),
              ),
              onEmpty: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: controller.reload,
                child: ListView(
                  children: const [
                    SizedBox(height: 140),
                    Icon(Icons.search_off_rounded,
                        size: 52, color: AppColors.textSecondary),
                    SizedBox(height: 12),
                    Center(
                      child: Text(
                        'কোনো কোর্স পাওয়া যায়নি',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              onError: (message) => _ErrorView(
                message: message ?? 'একটি সমস্যা হয়েছে',
                onRetry: controller.reload,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFFF4E5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: const Row(
        children: [
          Icon(Icons.wifi_off_rounded, size: 16, color: Color(0xFFB86E00)),
          SizedBox(width: 8),
          Text(
            'অফলাইন — সর্বশেষ সংরক্ষিত কোর্স দেখানো হচ্ছে',
            style: TextStyle(
              color: Color(0xFFB86E00),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.cloud_off_rounded,
                  size: 40, color: AppColors.danger),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('আবার চেষ্টা করুন'),
            ),
          ],
        ),
      ),
    );
  }
}
