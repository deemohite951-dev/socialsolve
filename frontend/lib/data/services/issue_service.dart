import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/issue_model.dart';
import '../models/stats_model.dart';

class IssueService {
  final ApiClient _client = ApiClient();

  Future<StatsModel> fetchStats() async {
    final response = await _client.dio.get(ApiConstants.issueStats);
    return StatsModel.fromJson(response.data);
  }

  Future<List<IssueModel>> fetchIssues({String? status}) async {
    final response = await _client.dio.get(
      ApiConstants.issues,
      queryParameters: status != null ? {'status': status} : null,
    );
    return (response.data as List).map((e) => IssueModel.fromJson(e)).toList();
  }

  Future<void> createIssue(FormData formData) async {
    await _client.dio.post(ApiConstants.issues, data: formData);
  }

  Future<void> toggleUpvote(int issueId) async {
    await _client.dio.post('${ApiConstants.issues}$issueId/upvote/');
  }
}