import 'package:equatable/equatable.dart';

/// Haber domain modeli
class NewsModel extends Equatable {
  const NewsModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.publishedAt,
    required this.category,
    this.imageUrl,
    this.authorName,
  });

  factory NewsModel.fromFirestore(String id, Map<String, dynamic> data) =>
      NewsModel(
        id: id,
        title: data['title'] as String? ?? '',
        summary: data['summary'] as String? ?? '',
        content: data['content'] as String? ?? '',
        publishedAt: (data['publishedAt'] as dynamic)?.toDate() as DateTime? ??
            DateTime.now(),
        category: data['category'] as String? ?? 'Genel',
        imageUrl: data['imageUrl'] as String?,
        authorName: data['authorName'] as String?,
      );

  factory NewsModel.fromSupabase(Map<String, dynamic> data) => NewsModel(
        id: data['id'] as String,
        title: data['title'] as String? ?? '',
        summary: data['summary'] as String? ?? '',
        content: data['content'] as String? ?? '',
        publishedAt: _dateTimeFromSupabase(data['published_at']),
        category: data['category'] as String? ?? 'Genel',
        imageUrl: data['image_url'] as String?,
        authorName: data['author_name'] as String?,
      );

  final String id;
  final String title;
  final String summary;
  final String content;
  final DateTime publishedAt;
  final String category;
  final String? imageUrl;
  final String? authorName;

  @override
  List<Object?> get props => [id, title, publishedAt];
}

DateTime _dateTimeFromSupabase(Object? value) {
  if (value is DateTime) return value;
  if (value is String) return DateTime.parse(value);
  return DateTime.now();
}
