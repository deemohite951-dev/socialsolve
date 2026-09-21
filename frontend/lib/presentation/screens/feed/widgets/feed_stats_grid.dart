import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/stats_model.dart';

class FeedStatsGrid extends StatelessWidget {
  final StatsModel stats;

  const FeedStatsGrid({super.key, required this.stats});

  Widget _buildCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$count',
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildCard(
          title: 'Total Issues',
          count: stats.total,
          icon: Icons.assignment_outlined,
          color: AppColors.accentPurple,
        ),
        const SizedBox(width: 16),
        _buildCard(
          title: 'In Review',
          count: stats.inReview,
          icon: Icons.pending_actions_outlined,
          color: AppColors.accentOrange,
        ),
        const SizedBox(width: 16),
        _buildCard(
          title: 'In Progress',
          count: stats.inProgress,
          icon: Icons.build_circle_outlined,
          color: AppColors.accentBlue,
        ),
        const SizedBox(width: 16),
        _buildCard(
          title: 'Resolved',
          count: stats.resolved,
          icon: Icons.check_circle_outline,
          color: AppColors.accentGreen,
        ),
      ],
    );
  }
}