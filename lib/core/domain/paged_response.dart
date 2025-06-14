class PagedResponse<T> {
  final List<T> content;
  final int pageNumber;
  final int pageSize;
  final int totalElements;
  final int totalPages;
  final bool last;

  PagedResponse({
    required this.content,
    required this.pageNumber,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
    required this.last,
  });

  factory PagedResponse.fromMap(
    Map<String, dynamic> map,
    T Function(Map<String, dynamic>) fromMap,
  ) {
    final List<T> content =
        (map['content'] as List).map((item) => fromMap(item)).toList();

    return PagedResponse<T>(
      content: content,
      pageNumber: map['pageNumber'] as int,
      pageSize: map['pageSize'] as int,
      totalElements: map['totalElements'] as int,
      totalPages: map['totalPages'] as int,
      last: map['last'] as bool,
    );
  }
}
