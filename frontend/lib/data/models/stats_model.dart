class StatsModel {
  final int total;
  final int inReview;
  final int inProgress;
  final int resolved;

  StatsModel({
    required this.total,
    required this.inReview,
    required this.inProgress,
    required this.resolved,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      total: json['total'] ?? 0,
      inReview: json['in_review'] ?? 0,
      inProgress: json['in_progress'] ?? 0,
      resolved: json['resolved'] ?? 0,
    );
  }
}