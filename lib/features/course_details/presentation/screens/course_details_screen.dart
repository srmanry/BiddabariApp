import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../home/data/models/course_model.dart';
import '../../logic/course_details_controller.dart';
import '../widgets/price_countdown_text.dart';

class CourseDetailsScreen extends StatefulWidget {
  const CourseDetailsScreen({super.key});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  int _tabIndex = 0;

  static const _tabs = ['Overview', 'Instructor', 'Routine', 'Review'];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseDetailsController>();
    final course = controller.course;

    if (course == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course Details')),
        body: const Center(child: Text('কোর্সটি খুঁজে পাওয়া যায়নি')),
      );
    }

    final currency = NumberFormat.decimalPattern('en_US');

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            foregroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: _CircleIconButton(
                icon: Icons.arrow_back_rounded,
                onTap: () => Get.back(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'course-banner-${course.id}',
                    child: CachedNetworkImage(
                      imageUrl: course.bannerUrl,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.primaryDark,
                        child: const Icon(Icons.image_not_supported_outlined,
                            size: 40, color: Colors.white70),
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.45),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.15),
                        ],
                        stops: const [0, 0.45, 1],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    course.subTitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (course.hasActiveDiscount) ...[
                        Text(
                          '৳${currency.format(course.discountedPrice)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '৳${currency.format(course.price)}',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.textSecondary,
                            fontSize: 15,
                          ),
                        ),
                      ] else
                        Text(
                          '৳${currency.format(course.price)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                            color: AppColors.textPrimary,
                          ),
                        ),
                    ],
                  ),
                  if (course.hasActiveDiscount && course.discountEndDate != null)
                    PriceCountdownText(endDate: course.discountEndDate!),
                  const SizedBox(height: 20),
                  Container(height: 1, color: AppColors.cardBorder),
                  _StatRow(
                      icon: Icons.schedule_rounded,
                      label: 'Course Duration',
                      value: '${course.durationInMonth} Month'),
                  _StatRow(
                      icon: Icons.videocam_rounded,
                      label: 'Total Lecture',
                      value: course.totalClass),
                  _StatRow(
                      icon: Icons.description_rounded,
                      label: 'Total Exam',
                      value: '${course.totalExam}'),
                  _StatRow(
                      icon: Icons.podcasts_rounded,
                      label: 'Live class',
                      value: '${course.totalLive}'),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cta,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Text(
                        'কোর্সটি কিনুন',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'This Course Includes :',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _IncludeItem(
                      icon: Icons.public_rounded,
                      text: '100% online course'),
                  const _IncludeItem(
                      icon: Icons.devices_rounded,
                      text: 'Access on mobile, tablet and computer'),
                  const _IncludeItem(
                      icon: Icons.ondemand_video_rounded,
                      text: 'Provide exclusive recorded class'),
                  const _IncludeItem(
                      icon: Icons.picture_as_pdf_rounded,
                      text: 'Provide a well-structured lecture sheet in PDF'),
                  const SizedBox(height: 24),
                  _TabBarRow(
                    tabs: _tabs,
                    selectedIndex: _tabIndex,
                    onSelected: (i) => setState(() => _tabIndex = i),
                  ),
                  const SizedBox(height: 20),
                  _TabContent(index: _tabIndex, course: course),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Container(height: 1, color: AppColors.cardBorder),
      ],
    );
  }
}

class _IncludeItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _IncludeItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.accent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBarRow extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _TabBarRow({
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(tabs.length, (i) {
        final selected = i == selectedIndex;
        return GestureDetector(
          onTap: () => onSelected(i),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              tabs[i],
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _TabContent extends StatelessWidget {
  final int index;
  final CourseModel course;

  const _TabContent({required this.index, required this.course});

  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      return Text(
        course.subTitle.isNotEmpty
            ? course.subTitle
            : 'এই কোর্স সম্পর্কে বিস্তারিত তথ্য শীঘ্রই যোগ করা হবে।',
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
          height: 1.6,
        ),
      );
    }
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          'তথ্য শীঘ্রই আসছে',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
