// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ApiErrorResponse {
  final String instance;
  final String? detail;
  final String type;
  final String title;

  ApiErrorResponse({
    required this.instance,
    this.detail,
    required this.type,
    required this.title,
  });

  ApiErrorResponse copyWith({
    String? instance,
    String? detail,
    String? type,
    String? title,
  }) {
    return ApiErrorResponse(
      instance: instance ?? this.instance,
      detail: detail ?? this.detail,
      type: type ?? this.type,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'instance': instance,
      'detail': detail,
      'type': type,
      'title': title,
    };
  }

  factory ApiErrorResponse.fromMap(Map<String, dynamic> map) {
    return ApiErrorResponse(
      instance: map['instance'] as String,
      detail: map['detail'] != null ? map['detail'] as String : null,
      type: map['type'] as String,
      title: map['title'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiErrorResponse.fromJson(String source) =>
      ApiErrorResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ApiErrorResponse(instance: $instance, detail: $detail, type: $type, title: $title)';
  }

  @override
  bool operator ==(covariant ApiErrorResponse other) {
    if (identical(this, other)) return true;

    return other.instance == instance &&
        other.detail == detail &&
        other.type == type &&
        other.title == title;
  }

  @override
  int get hashCode {
    return instance.hashCode ^ detail.hashCode ^ type.hashCode ^ title.hashCode;
  }
}
