class Auth {
  final String? uid;
  final String? name;
  final String? email;
  final String? createdAtDate;
  final String? imgPath;

  Auth({this.uid, this.name, this.email, this.createdAtDate, this.imgPath});

  Map<String, dynamic> toMap(String fireStoreUid) {
    return {
      'uid': fireStoreUid,
      'name': name,
      'email': email,
      'createdAtDate': createdAtDate,
      'imgUrl': imgPath ?? '',
    };
  }

  factory Auth.fromMap(Map<String, dynamic> map) {
    return Auth(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      createdAtDate: map['createdAtDate'],
      imgPath: map['imgUrl'],
    );
  }

  Auth copyWith({
    String? nameX,
    String? emailX,
    String? uidX,
    String? createdAtX,
  }) {
    return Auth(
      email: emailX ?? this.email,
      createdAtDate: createdAtX ?? this.createdAtDate,
      name: nameX ?? this.name,
      uid: uidX ?? this.uid,
    );
  }
}
