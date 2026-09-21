import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/issue_model.dart';
import '../../../../data/services/issue_service.dart';

class FeedCard extends StatefulWidget {
  final IssueModel issue;

  const FeedCard({super.key, required this.issue});

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  late bool isUpvoted;
  late int upvotesCount;

  @override
  void initState() {
    super.initState();
    isUpvoted = widget.issue.isUpvoted;
    upvotesCount = widget.issue.upvotesCount;
  }

  void _handleUpvote() async {
    setState(() {
      if (isUpvoted) {
        isUpvoted = false;
        upvotesCount--;
      } else {
        isUpvoted = true;
        upvotesCount++;
      }
    });
    try {
      await IssueService().toggleUpvote(widget.issue.id);
    } catch (_) {
      // Revert if API call fails
      setState(() {
        isUpvoted = !isUpvoted;
        upvotesCount += isUpvoted ? 1 : -1;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'resolved':
        return AppColors.accentGreen;
      case 'in_progress':
        return AppColors.accentBlue;
      case 'in_review':
        return AppColors.accentOrange;
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(widget.issue.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.issue.status.toUpperCase().replaceAll('_', ' '),
                  style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                widget.issue.location,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.issue.title,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.issue.description,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reported by ${widget.issue.author?.username ?? "Anonymous"}',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              ElevatedButton.icon(
                onPressed: _handleUpvote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isUpvoted ? AppColors.primary : AppColors.border,
                  foregroundColor: AppColors.textLight,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                icon: const Icon(Icons.thumb_up_alt_outlined, size: 16),
                label: Text('$upvotesCount Upvotes'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}