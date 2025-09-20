class DownloadsItem {
  final String id;
 
  final String imgUrl;
  final String title;
  final String photographer;
  final String pixels;
  final String date;
  

  DownloadsItem({
    required this.id,
    required this.pixels,
    required this.photographer,
    required this.title,
    required this.imgUrl,
    required this.date
  });

  factory DownloadsItem.fromMap(Map<String, dynamic> map, {String? id}) {
    return DownloadsItem(
      id: map['id'],
      pixels: map['pixels']??'',
      photographer: map['photographer'],
      title: map['title'],
      imgUrl: map['imgUrl'] ?? '',
      date: map['date']??''
    );
  }

  Map<String, dynamic> toMap() {
    return {
     'date': date,
      'imgUrl': imgUrl,
      'title': title,
      'photographer':photographer,
      'id': id,
      'pixels': pixels
    };
  }
}
