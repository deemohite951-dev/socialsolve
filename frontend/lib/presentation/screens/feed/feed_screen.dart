import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/issue_model.dart';
import '../../../data/models/stats_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/issue_service.dart';
import '../../common_widgets/app_navbar.dart';
import 'widgets/feed_card.dart';
import 'widgets/feed_stats_grid.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final AuthService _authService = AuthService();
  final IssueService _issueService = IssueService();

  UserModel? _currentUser;
  StatsModel? _stats;
  List<IssueModel> _issues = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      final user = await _authService.getSavedUser();
      final stats = await _issueService.fetchStats();
      final issues = await _issueService.fetchIssues();

      setState(() {
        _currentUser = user;
        _stats = stats;
        _issues = issues;
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppNavBar(
        user: _currentUser,
        onRefresh: _loadInitialData,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_stats != null) FeedStatsGrid(stats: _stats!),
                  const SizedBox(height: 32),
                  const Text(
                    'Community Feed',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_issues.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Text(
                          'No issues reported yet.',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _issues.length,
                      itemBuilder: (context, index) => FeedCard(issue: _issues[index]),
                    ),
                ],
              ),
            ),
    );
  }
}