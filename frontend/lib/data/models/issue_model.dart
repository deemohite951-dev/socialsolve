import 'user_model.dart';

class IssueModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final String status;
  final String location;
  final String? image;
  final UserModel? author;
  final int upvotesCount;
  final bool isUpvoted;
  final String createdAt;

  IssueModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.location,
    this.image,
    this.author,
    required this.upvotesCount,
    required this.isUpvoted,
    required this.createdAt,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'other',
      status: json['status'] ?? 'reported',
      location: json['location'] ?? '',
      image: json['image'],
      author: json['author'] != null ? UserModel.fromJson(json['author']) : null,
      upvotesCount: json['upvotes_count'] ?? 0,
      isUpvoted: json['is_upvoted'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }
}