class SearchHistory {
  final String title;
  final String id;

  const SearchHistory({required this.title, required this.id});

  Map<String, dynamic> toMap() {
    return {'title': title, 'id': id};
  }

  factory SearchHistory.fromMap(Map<String, dynamic> map) {
    return SearchHistory(title: map['title'] ?? '', id: map['id'] ?? '');
  }
}
