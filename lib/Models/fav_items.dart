class FavItemModalClass {
  final String? id;
  final String originalPhotoUrl;
  final String mediumPhotoUrl;
  final String largePhotoUrl;
  final String smallPhotoUrl;
  final String title;
  final String photographer;
  final String? pixels;
  

  FavItemModalClass({
    this.id,
    this.pixels,
    required this.photographer,
    required this.title,
    required this.originalPhotoUrl,
    required this.mediumPhotoUrl,
    required this.largePhotoUrl,
    required this.smallPhotoUrl,
  });

  factory FavItemModalClass.fromMap(Map<String, dynamic> map, {String? id}) {
    return FavItemModalClass(
      id: id,
      pixels: map['pixels']??'',
      photographer: map['photographer'],
      title: map['title'],
      originalPhotoUrl: map['originalPhotoUrl'] ?? '',
      mediumPhotoUrl: map['mediumPhotoUrl'] ?? '',
      largePhotoUrl: map['largePhotoUrl'] ?? '',
      smallPhotoUrl: map['smallPhotoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'originalPhotoUrl': originalPhotoUrl,
      'mediumPhotoUrl': mediumPhotoUrl,
      'largePhotoUrl': largePhotoUrl,
      'smallPhotoUrl': smallPhotoUrl,
      'title': title,
      'photographer':photographer,
      'id': id,
      'pixels': pixels
    };
  }
}
