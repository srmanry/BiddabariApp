import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class DiscountCountdown extends StatefulWidget {
  final DateTime endDate;

  const DiscountCountdown({super.key, required this.endDate});

  @override
  State<DiscountCountdown> createState() => _DiscountCountdownState();
}

class _DiscountCountdownState extends State<DiscountCountdown> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.endDate.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final diff = widget.endDate.difference(DateTime.now());
      setState(() => _remaining = diff.isNegative ? Duration.zero : diff);
      if (diff.isNegative) _timer.cancel();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    if (_remaining <= Duration.zero) {
      return const SizedBox.shrink();
    }
    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;
    final minutes = _remaining.inMinutes % 60;
    final seconds = _remaining.inSeconds % 60;

    final label = days > 0
        ? '${days}d ${_two(hours)}h ${_two(minutes)}m'
        : '${_two(hours)}:${_two(minutes)}:${_two(seconds)}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department_rounded,
              size: 14, color: AppColors.danger),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.danger,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
