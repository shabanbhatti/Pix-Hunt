typedef ImageModel = ({String imgPath, String pixels});
typedef OnPressed = void Function();
typedef BoxModel = ({String title, String imgPath});
typedef OnSubmitted = void Function(String)?;
typedef OnValidator = String? Function(String?)?;
typedef ImageDownloadedMessageModel = ({bool isDownload, String message})?;
typedef LanguageModel = ({String flag, String language, String code});
