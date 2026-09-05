import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class PriceCountdownText extends StatefulWidget {
  final DateTime endDate;

  const PriceCountdownText({super.key, required this.endDate});

  @override
  State<PriceCountdownText> createState() => _PriceCountdownTextState();
}

class _PriceCountdownTextState extends State<PriceCountdownText> {
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

  @override
  Widget build(BuildContext context) {
    if (_remaining <= Duration.zero) return const SizedBox.shrink();

    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;
    final minutes = _remaining.inMinutes % 60;

    final parts = <String>[
      if (days > 0) '$days day${days > 1 ? 's' : ''}',
      '$hours hour${hours != 1 ? 's' : ''}',
      '$minutes minute${minutes != 1 ? 's' : ''}',
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          const Icon(Icons.access_time_filled_rounded,
              size: 14, color: AppColors.danger),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              '${parts.join(', ')} left at this price!',
              style: const TextStyle(
                color: AppColors.danger,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
