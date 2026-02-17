class Pexer {
  final int? page;
  final String? title;
  final List<Photos>? photosList;

  const Pexer({this.page, this.title, this.photosList});

  factory Pexer.fromJson(Map<String, dynamic> json) {
    return Pexer(
      page: json['pages'] ?? 0,
      title: json['title'] ?? '',
      photosList:
          (json['photos'] as List).map((x) => Photos.fromJson(x)).toList(),
    );
  }

  // ------DB portion---------
  factory Pexer.fromDb(Map<String, dynamic> map) {
    return Pexer(
      page: map[pageCol] ?? 0,
      title: map[titleCol] ?? '',
      photosList: [],
    );
  }
  Map<String, dynamic> toDb() {
    return {pageCol: page, titleCol: title};
  }

  static const String tableName = 'all_photos';
  static const String pageCol = 'page_col';
  static const String titleCol = 'title_col';
  static const String createTable = '''CREATE TABLE $tableName(
      $pageCol INTEGER, 
      $titleCol TEXT,
      PRIMARY KEY ($pageCol, $titleCol)
      )''';
}

class Photos {
  final String? url;
  final String? photographer;
  final String? photographerUrl;
  final String? describtion;
  final String? largeImgUrl;
  final String? originalImgUrl;
  final String? mediumImgUrl;
  final String? smallImgUrl;
  final bool? isBookmarked;
  final String? createdAt;
  final int? id;
  final int? page;
  final String? title;
  const Photos({
    this.describtion,
    this.largeImgUrl,
    this.mediumImgUrl,
    this.originalImgUrl,
    this.isBookmarked,
    this.photographer,
    this.photographerUrl,
    this.smallImgUrl,
    this.url,
    this.createdAt,
    this.id,
    this.page,
    this.title,
  });

  Photos copyWith({
    String? url,
    String? photographer,
    String? photographerUrl,
    String? decribtion,
    String? largeImgUrl,
    String? originalImgUrl,
    String? mediumImgUrl,
    String? smallImageUrl,
    bool? isBookMarkedx,
    int? id,
    String? createdAt,
    int? page,
    String? title,
  }) {
    return Photos(
      describtion: decribtion ?? this.describtion,
      id: id ?? this.id,
      isBookmarked: isBookMarkedx ?? this.isBookmarked,
      largeImgUrl: largeImgUrl ?? this.largeImgUrl,
      mediumImgUrl: mediumImgUrl ?? this.mediumImgUrl,
      originalImgUrl: originalImgUrl ?? this.originalImgUrl,
      page: page ?? this.page,
      photographer: photographer ?? this.photographer,
      photographerUrl: photographerUrl ?? this.photographerUrl,
      smallImgUrl: smallImageUrl ?? this.smallImgUrl,
      title: title ?? this.title,
      url: url ?? this.url,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Photos.fromJson(Map<String, dynamic> json) {
    return Photos(
      describtion: json['describtion'] ?? '',
      largeImgUrl: json['largeImg'] ?? '',
      mediumImgUrl: json['mediumImg'] ?? '',
      originalImgUrl: json['originalImg'] ?? '',
      photographer: json['photographer'] ?? '',
      photographerUrl: json['photographerUrl'] ?? '',
      smallImgUrl: json['smallImg'] ?? '',
      url: json['url'] ?? '',
      id: json['id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      isBookmarked: json['isBookmarked'] ?? false,
      page: json['page'] ?? 0,
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'describtion': describtion,
      'largeImg': largeImgUrl,
      'mediumImg': mediumImgUrl,
      'originalImg': originalImgUrl,
      'photographer': photographer,
      'photographerUrl': photographerUrl,
      'smallImg': smallImgUrl,
      'url': url,
      'id': id,
      'created_at': createdAt,
      'isBookmarked': isBookmarked,
      'page': page,
      'title': title,
    };
  }

  // -------DB portion------------

  static const String tableName = 'photos_table';
  static const String describtionCol = 'describtion_Col';
  static const String urlCol = 'url_Col';
  static const String largeImgCol = 'large_img_Col';
  static const String smallImgCol = 'small_img_Col';
  static const String mediumImgCol = 'medium_img_Col';
  static const String originalImgCol = 'original_img_Col';
  static const String idCol = 'id_Col';
  static const String photographerCol = 'photographer_Col';
  static const String photographerUrlCol = 'photographer_url_Col';
  static const String pageCol = 'page_col';
  static const String titleCol = 'title_col';
  static const String createdAtCol = 'created_at_col';
  static const String isBookmarkedCol = 'isBookmarked_col';

  static const String createTable = '''CREATE TABLE $tableName(
$describtionCol TEXT,
$idCol INTEGER PRIMARY KEY,
$urlCol TEXT,
$mediumImgCol TEXT,
$createdAtCol TEXT,
$largeImgCol TEXT,
$photographerCol TEXT,
$photographerUrlCol TEXT,
$smallImgCol TEXT,
$originalImgCol TEXT,
$isBookmarkedCol INTEGER,
 $pageCol INTEGER,
  $titleCol TEXT,

  FOREIGN KEY ($pageCol, $titleCol)
    REFERENCES ${Pexer.tableName}(${Pexer.pageCol}, ${Pexer.titleCol})
    ON DELETE CASCADE
)''';

  factory Photos.fromDb(Map<String, dynamic> map) {
    return Photos(
      describtion: map[describtionCol] ?? '',
      id: map[idCol] ?? 0,
      largeImgUrl: map[largeImgCol] ?? '',
      mediumImgUrl: map[mediumImgCol] ?? '',
      originalImgUrl: map[originalImgCol] ?? '',
      photographer: map[photographerCol] ?? '',
      photographerUrl: map[photographerUrlCol] ?? '',
      smallImgUrl: map[smallImgCol] ?? '',
      url: map[urlCol] ?? '',
      page: map[pageCol] ?? 0,
      title: map[titleCol] ?? '',
      createdAt: map[createdAtCol] ?? '',
      isBookmarked: map[isBookmarkedCol] == 0 ? false : true,
    );
  }

  Map<String, dynamic> toDb() {
    return {
      describtionCol: describtion,
      idCol: id,
      largeImgCol: largeImgUrl,
      smallImgCol: smallImgUrl,
      mediumImgCol: mediumImgUrl,
      originalImgCol: originalImgUrl,
      photographerCol: photographer,
      photographerUrlCol: photographerUrl,
      urlCol: url,
      createdAtCol: createdAt,
      pageCol: page,
      titleCol: title,
      isBookmarkedCol: (isBookmarked ?? false) ? 1 : 0,
    };
  }
}
