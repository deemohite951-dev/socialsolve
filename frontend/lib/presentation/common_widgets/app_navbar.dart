import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/user_model.dart';
import '../../data/services/auth_service.dart';
import '../screens/auth/login_screen.dart';
import '../screens/report/create_issue_screen.dart';

class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  final UserModel? user;
  final VoidCallback? onRefresh;

  const AppNavBar({super.key, this.user, this.onRefresh});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Brand Logo & Title
          Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 38,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.shield, color: AppColors.accentGreen, size: 32),
              ),
              const SizedBox(width: 12),
              const Text(
                'SOCIALSOLVE',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),

          // Middle: Feed & Report Issue Navigation
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  if (onRefresh != null) onRefresh!();
                },
                icon: const Icon(Icons.dashboard_outlined, color: AppColors.accentGreen, size: 20),
                label: const Text('Feed', style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 16),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateIssueScreen()),
                  );
                },
                icon: const Icon(Icons.report_problem_outlined, color: AppColors.textMuted, size: 20),
                label: const Text('Report Issue', style: TextStyle(color: AppColors.textMuted)),
              ),
            ],
          ),

          // Right: + Report Button, User Name & Sign Out
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateIssueScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textLight,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('+ Report', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 20),
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.border,
                child: Text(
                  user != null && user!.username.isNotEmpty
                      ? user!.username[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                user?.username ?? 'Guest',
                style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.logout, color: AppColors.textMuted, size: 22),
                tooltip: 'Sign Out',
                onPressed: () async {
                  await AuthService().logout();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}