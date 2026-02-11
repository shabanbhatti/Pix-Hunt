extension GetFirstLastInitialExtension on String {
  String get initials {
    if (trim().isEmpty) return '';

    final words = trim().split(RegExp(r'\s+'));

    if (words.length == 1) {
      return words.first[0].toUpperCase();
    }

    return (words.first[0] + words.last[0]).toUpperCase();
  }
}

extension FirstTwoNames on String {
  String firstTwoWords() {
    List<String> parts = this.split(' ');

    if (parts.length >= 2) {
      return '${parts[0]} ${parts[1]}';
    } else if (parts.isNotEmpty) {
      return parts[0];
    } else {
      return '';
    }
  }
}
